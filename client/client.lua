local QBCore = exports['qb-core']:GetCoreObject()

local resourceName = GetCurrentResourceName()

local zoneName = nil
local inZone = false

local MenuItemId = nil

local PlayerData = {}
local PlayerJob = {}
local PlayerGang = {}

local ManagementItemIDs = {
    Gang = nil,
    Boss = nil
}

local reloadSkinTimer = GetGameTimer()

local TargetPeds = {
    Store = {},
    ClothingRoom = {},
    PlayerOutfitRoom = {}
}

local function getGender()
    local gender
    if Config.GenderBasedOnPed then
        local model = exports[resourceName]:getPedModel(PlayerPedId())
        if model == "mp_f_freemode_01" then
            gender = "female"
        end
    else
        if PlayerData.charinfo.gender == 1 then
            gender = "female"
        end
    end
    return gender or "male"
end

local function RemoveTargetPeds(peds)
    for i = 1, #peds, 1 do
        DeletePed(peds[i])
    end
end

local function RemoveTargets()
    if Config.EnablePedsForShops then
        RemoveTargetPeds(TargetPeds.Store)
    else
        for k, v in pairs(Config.Stores) do
            exports['qb-target']:RemoveZone(v.shopType .. k)
        end
    end

    if Config.EnablePedsForClothingRooms then
        RemoveTargetPeds(TargetPeds.ClothingRoom)
    else
        for k, v in pairs(Config.ClothingRooms) do
            exports['qb-target']:RemoveZone('clothing_' .. (v.job or v.gang) .. k)
        end
    end

    if Config.EnablePedsForPlayerOutfitRooms then
        RemoveTargetPeds(TargetPeds.PlayerOutfitRoom)
    else
        for k in pairs(Config.PlayerOutfitRooms) do
            exports['qb-target']:RemoveZone('playeroutfitroom_' .. k)
        end
    end
end

local function LoadPlayerUniform()
    QBCore.Functions.TriggerCallback("fivem-appearance:server:getUniform", function(uniformData)
        if not uniformData then
            return
        end
        if Config.BossManagedOutfits then
            QBCore.Functions.TriggerCallback("fivem-appearance:server:getManagementOutfits", function(result)
                local uniform = nil
                for i = 1, #result, 1 do
                    if result[i].name == uniformData.name then
                        uniform = {
                            type = uniformData.type,
                            name = result[i].name,
                            model = result[i].model,
                            components = result[i].components,
                            props = result[i].props,
                            disableSave = true,
                        }
                        break
                    end
                end

                if not uniform then
                    TriggerServerEvent("fivem-appearance:server:syncUniform", nil) -- Uniform doesn't exist anymore
                    return
                end
    
                TriggerEvent("fivem-appearance:client:changeOutfit", uniform)
            end, uniformData.type, getGender())
        else
            local outfits = Config.Outfits[uniformData.jobName][uniformData.gender]
            local uniform = nil
            for i = 1, #outfits, 1 do
                if outfits[i].name == uniformData.label then
                    uniform = outfits[i]
                    break
                end
            end

            if not uniform then
                TriggerServerEvent("fivem-appearance:server:syncUniform", nil) -- Uniform doesn't exist anymore
                return
            end

            uniform.jobName = uniformData.jobName
            uniform.gender = uniformData.gender

            TriggerEvent("qb-clothing:client:loadOutfit", uniform)
        end
    end)
end

local function ResetRechargeMultipliers()
    local player = PlayerId()
    SetPlayerHealthRechargeMultiplier(player, 0.0)
    SetPlayerHealthRechargeLimit(player, 0.0)
end

local function RemoveManagementMenuItems()
    if ManagementItemIDs.Boss then
        exports["qb-management"]:RemoveBossMenuItem(ManagementItemIDs.Boss)
    end
    if ManagementItemIDs.Gang then
        exports["qb-management"]:RemoveGangMenuItem(ManagementItemIDs.Gang)
    end
end

local function AddManagementMenuItems()
    local eventName = "fivem-appearance:client:OutfitManagementMenu"
    local menuItem = {
        header = "Outfit Management",
        icon = "fa-solid fa-shirt",
        params = {
            event = eventName,
            args = {
                backEvent = eventName
            }
        }
    }
    menuItem.txt = "Manage outfits for Job"
    menuItem.params.args.type = "Job"
    ManagementItemIDs.Boss = exports["qb-management"]:AddBossMenuItem(menuItem)

    menuItem.txt = "Manage outfits for Gang"
    menuItem.params.args.type = "Gang"
    ManagementItemIDs.Gang = exports["qb-management"]:AddGangMenuItem(menuItem)
end

local function RemoveRadialMenuOption()
    if MenuItemId then
        exports['qb-radialmenu']:RemoveOption(MenuItemId)
        MenuItemId = nil
    end
end

local function InitAppearance()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    PlayerGang = PlayerData.gang

    TriggerEvent("updateJob", PlayerJob.name)
    TriggerEvent("updateGang", PlayerGang.name)

    QBCore.Functions.TriggerCallback('fivem-appearance:server:getAppearance', function(appearance)
        if not appearance then
            return
        end
        exports[resourceName]:setPlayerAppearance(appearance)
        if Config.PersistUniforms then
            LoadPlayerUniform()
        end
        ResetRechargeMultipliers()

        if Config.Debug then -- This will detect if the player model is set as "player_zero" aka michael. Will then set the character as a freemode ped based on gender.
            Wait(5000)
            if GetEntityModel(PlayerPedId()) == `player_zero` then
                print('Player detected as "player_zero", Starting CreateFirstCharacter event')
                TriggerEvent('qb-clothes:client:CreateFirstCharacter')
            end
        end
    end)
    ResetBlips(PlayerJob.name, PlayerGang.name)
    if Config.BossManagedOutfits then
        AddManagementMenuItems()
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        InitAppearance()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if Config.UseTarget and GetResourceState("qb-target") == "started" then
            RemoveTargets()
        end
        if Config.UseRadialMenu and GetResourceState("qb-radialmenu") == "started" then
            RemoveRadialMenuOption()
        end
        if Config.BossManagedOutfits and GetResourceState("qb-management") == "started" then
            RemoveManagementMenuItems()
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    PlayerJob = JobInfo
    TriggerEvent("updateJob", PlayerJob.name)
    ResetBlips(PlayerJob.name, PlayerGang.name)
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerData.gang = GangInfo
    PlayerGang = GangInfo
    TriggerEvent("updateGang", PlayerGang.name)
    ResetBlips(PlayerJob.name, PlayerGang.name)
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    PlayerJob.onduty = duty
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    InitAppearance()
end)

local function getComponentConfig()
    return {
        masks = not Config.DisableComponents.Masks,
        upperBody = not Config.DisableComponents.UpperBody,
        lowerBody = not Config.DisableComponents.LowerBody,
        bags = not Config.DisableComponents.Bags,
        shoes = not Config.DisableComponents.Shoes,
        scarfAndChains = not Config.DisableComponents.ScarfAndChains,
        bodyArmor = not Config.DisableComponents.BodyArmor,
        shirts = not Config.DisableComponents.Shirts,
        decals = not Config.DisableComponents.Decals,
        jackets = not Config.DisableComponents.Jackets
    }
end

local function getPropConfig()
    return {
        hats = not Config.DisableProps.Hats,
        glasses = not Config.DisableProps.Glasses,
        ear = not Config.DisableProps.Ear,
        watches = not Config.DisableProps.Watches,
        bracelets = not Config.DisableProps.Bracelets
    }
end

function getDefaultConfig()
    return {
        ped = false,
        headBlend = false,
        faceFeatures = false,
        headOverlays = false,
        components = false,
        componentConfig = getComponentConfig(),
        props = false,
        propConfig = getPropConfig(),
        tattoos = false,
        enableExit = true,
    }
end

local function getNewCharacterConfig()
    local config = getDefaultConfig()
    config.enableExit   = false

    config.ped          = Config.NewCharacterSections.Ped
    config.headBlend    = Config.NewCharacterSections.HeadBlend
    config.faceFeatures = Config.NewCharacterSections.FaceFeatures
    config.headOverlays = Config.NewCharacterSections.HeadOverlays
    config.components   = Config.NewCharacterSections.Components
    config.props        = Config.NewCharacterSections.Props
    config.tattoos      = Config.NewCharacterSections.Tattoos

    return config
end

RegisterNetEvent('qb-clothes:client:CreateFirstCharacter', function()
    QBCore.Functions.GetPlayerData(function(pd)
        local gender = "Male"
        local skin = 'mp_m_freemode_01'
        if pd.charinfo.gender == 1 then
            skin = "mp_f_freemode_01"
            gender = "Female"
        end
        exports[resourceName]:setPlayerModel(skin)
        -- Fix for tattoo's appearing when creating a new character
        local ped = PlayerPedId()
        exports[resourceName]:setPedTattoos(ped, {})
        exports[resourceName]:setPedComponents(ped, Config.InitialPlayerClothes[gender].Components)
        exports[resourceName]:setPedProps(ped, Config.InitialPlayerClothes[gender].Props)
        exports[resourceName]:setPedHair(ped, Config.InitialPlayerClothes[gender].Hair)
        ClearPedDecorations(ped)
        local config = getNewCharacterConfig()
        exports[resourceName]:startPlayerCustomization(function(appearance)
            if (appearance) then
                TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
                ResetRechargeMultipliers()
            end
        end, config)
    end)
end)

function OpenShop(config, isPedMenu, shopType)
    QBCore.Functions.TriggerCallback("fivem-appearance:server:hasMoney", function(hasMoney, money)
        if not hasMoney and not isPedMenu then
            QBCore.Functions.Notify("Not enough cash. Need $" .. money, "error")
            return
        end

        exports[resourceName]:startPlayerCustomization(function(appearance)
            if appearance then
                if not isPedMenu then
                    TriggerServerEvent("fivem-appearance:server:chargeCustomer", shopType)
                end
                TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
            else
                QBCore.Functions.Notify("Cancelled Customization")
            end
        end, config)
    end, shopType)
end

local function OpenClothingShop(isPedMenu)
    local config = getDefaultConfig()
    config.components = true
    config.props = true

    if isPedMenu then
        config.ped = true
        config.headBlend = true
        config.faceFeatures = true
        config.headOverlays = true
        config.tattoos = true
    end
    OpenShop(config, isPedMenu, 'clothing')
end

local function OpenBarberShop()
    local config = getDefaultConfig()
    config.headOverlays = true
    OpenShop(config, false, 'barber')
end

local function OpenTattooShop()
    local config = getDefaultConfig()
    config.tattoos = true
    OpenShop(config, false, 'tattoo')
end

local function OpenSurgeonShop()
    local config = getDefaultConfig()
    config.headBlend = true
    config.faceFeatures = true
    OpenShop(config, false, 'surgeon')
end

RegisterNetEvent('fivem-appearance:client:openClothingShop', OpenClothingShop)

RegisterNetEvent('fivem-appearance:client:saveOutfit', function()
    local keyboard = exports['qb-input']:ShowInput({
        header = "Name your outfit",
        submitText = "Save Outfit",
        inputs = {{
            text = "Outfit Name",
            name = "input",
            type = "text",
            isRequired = true
        }}
    })

    if keyboard ~= nil then
        Wait(500)
        QBCore.Functions.TriggerCallback("fivem-appearance:server:getOutfits", function(outfits)
            local outfitExists = false
            for i = 1, #outfits, 1 do
                if outfits[i].outfitname == keyboard.input then
                    outfitExists = true
                    break
                end
            end

            if outfitExists then
                QBCore.Functions.Notify("Outfit with this name already exists.", "error")
                return
            end

            local playerPed = PlayerPedId()
            local pedModel = exports[resourceName]:getPedModel(playerPed)
            local pedComponents = exports[resourceName]:getPedComponents(playerPed)
            local pedProps = exports[resourceName]:getPedProps(playerPed)

            TriggerServerEvent('fivem-appearance:server:saveOutfit', keyboard.input, pedModel, pedComponents, pedProps)
        end)
    end
end)

RegisterNetEvent("fivem-appearance:client:OutfitManagementMenu", function(args)
    local bossMenuEvent = "qb-bossmenu:client:OpenMenu"
    if args.type == "Gang" then
        bossMenuEvent = "qb-gangmenu:client:OpenMenu"
    end
    local menuItems = {
        {
            header = "👔 | Manage " .. args.type .. " Outfits",
            isMenuHeader = true
        },
        {
            header = "Change Outfit",
            txt = "Pick from any of your currently saved "  .. args.type .. " outfits",
            params = {
                event = "fivem-appearance:client:ChangeManagementOutfitMenu",
                args = {
                    backEvent = args.backEvent,
                    type = args.type,
                }
            }
        },
        {
            header = "Save current Outfit",
            txt = "Save your current outfit as " .. args.type .. " outfit",
            params = {
                event = "fivem-appearance:client:SaveManagementOutfit",
                args = args.type
            }
        },
        {
            header = "Delete Outfit",
            txt = "Delete a saved " .. args.type .. " outfit",
            params = {
                event = "fivem-appearance:client:DeleteManagementOutfitMenu",
                args = {
                    backEvent = args.backEvent,
                    type = args.type,
                }
            }
        },
        {
            header = "Return",
            icon = "fa-solid fa-angle-left",
            params = {
                event = bossMenuEvent,
            }
        }
    }

    exports["qb-menu"]:openMenu(menuItems)

end)

local function getRankInputValues(rankList)
    local rankValues = {}
    for k, v in pairs(rankList) do
        rankValues[#rankValues + 1] = {
            text = v.name,
            value = k
        }
    end
    return rankValues
end

RegisterNetEvent("fivem-appearance:client:SaveManagementOutfit", function(mType)
    local playerPed = PlayerPedId()
    local outfitData = {
        Type = mType,
        Model = exports[resourceName]:getPedModel(playerPed),
        Components = exports[resourceName]:getPedComponents(playerPed),
        Props = exports[resourceName]:getPedProps(playerPed)
    }

    local rankValues
    
    if mType == "Job" then
        outfitData.JobName = PlayerJob.name
        rankValues = getRankInputValues(QBCore.Shared.Jobs[PlayerJob.name].grades)
        
    else
        outfitData.JobName = PlayerGang.name
        rankValues = getRankInputValues(QBCore.Shared.Gangs[PlayerGang.name].grades)
    end

    local saveDialog = exports['qb-input']:ShowInput({
        header = "Management Outfit Details",
        submitText = "Save Outfit",
        inputs = {
            {
                text = "Outfit Name",
                name = "outfitName",
                type = "text",
                isRequired = true
            },
            {
                text = "Gender",
                name = "gender",
                type = "radio",
                options = {
                    {
                        text = "Male", value = "male"
                    },
                    {
                        text = "Female", value = "female"
                    }
                },
                default = "male"
            },
            {
                text = "Minimum Rank",
                name = "minRank",
                type = "select",
                options = rankValues,
                default = '0'
            }
        }
    })

    if not saveDialog then
        return
    end

    outfitData.Name = saveDialog["outfitName"]
    outfitData.Gender = saveDialog["gender"]
    outfitData.MinRank = tonumber(saveDialog["minRank"])

    TriggerServerEvent("fivem-appearance:server:saveManagementOutfit", outfitData)

end)

RegisterNetEvent("fivem-appearance:client:DeleteManagementOutfitMenu", function(args)
    QBCore.Functions.TriggerCallback('fivem-appearance:server:getManagementOutfits', function(result)
        local outfitMenu = {}
        for i = 1, #result, 1 do
            outfitMenu[#outfitMenu + 1] = {
                header = 'Delete "' .. result[i].name .. '"',
                txt = "Model: " .. result[i].model .. " - Gender: " .. result[i].gender,
                params = {
                    event = 'fivem-appearance:client:DeleteManagementOutfit',
                    args = result[i].id
                }
            }
        end
        outfitMenu[#outfitMenu + 1] = {
            header = "Return",
            icon = "fa-solid fa-angle-left",
            params = {
                event = "fivem-appearance:client:OutfitManagementMenu",
                args = {
                    backEvent = args.backEvent,
                    type = args.type,
                }
            }
        }
        exports['qb-menu']:openMenu(outfitMenu)
    end, args.type)
end)

RegisterNetEvent("fivem-appearance:client:ChangeManagementOutfitMenu", function(args)
    QBCore.Functions.TriggerCallback('fivem-appearance:server:getManagementOutfits', function(result)
        local outfitMenu = {}
        for i = 1, #result, 1 do
            outfitMenu[#outfitMenu + 1] = {
                header = result[i].name,
                txt = result[i].model,
                params = {
                    event = 'fivem-appearance:client:changeOutfit',
                    args = {
                        type = args.type,
                        name = result[i].name,
                        model = result[i].model,
                        components = result[i].components,
                        props = result[i].props,
                        disableSave = true,
                    }
                }
            }
        end
        outfitMenu[#outfitMenu + 1] = {
            header = "Return",
            icon = "fa-solid fa-angle-left",
            params = {
                event = "fivem-appearance:client:OutfitManagementMenu",
                args = {
                    backEvent = args.backEvent,
                    type = args.type,
                }
            }
        }
        exports['qb-menu']:openMenu(outfitMenu)
    end, args.type, getGender())
end)

function OpenMenu(isPedMenu, backEvent, menuType, menuData)
    local menuItems = {}
    local outfitMenuItems = {{
        header = "Change Outfit",
        txt = "Pick from any of your currently saved outfits",
        params = {
            event = "fivem-appearance:client:changeOutfitMenu",
            args = {
                isPedMenu = isPedMenu,
                backEvent = backEvent
            }
        }
    }, {
        header = "Save New Outfit",
        txt = "Save a new outfit you can use later on",
        params = {
            event = "fivem-appearance:client:saveOutfit"
        }
    }, {
        header = "Delete Outfit",
        txt = "Yeah... We didnt like that one either",
        params = {
            event = "fivem-appearance:client:deleteOutfitMenu",
            args = {
                isPedMenu = isPedMenu,
                backEvent = backEvent
            }
        }
    }}
    if menuType == "default" then
        local header = "Buy Clothing - $" .. Config.ClothingCost
        if isPedMenu then
            header = "Change Clothing"
        end
        menuItems[#menuItems + 1] = {
            header = "Clothing Store Options",
            icon = "fas fa-shirt",
            isMenuHeader = true -- Set to true to make a nonclickable title
        }
        menuItems[#menuItems + 1] = {
            header = header,
            txt = "Pick from a wide range of items to wear",
            params = {
                event = "fivem-appearance:client:openClothingShop",
                args = isPedMenu
            }
        }
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "outfit" then
        menuItems[#menuItems + 1] = {
            header = "👔 | Outfit Options",
            isMenuHeader = true -- Set to true to make a nonclickable title
        }
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "job-outfit" then
        menuItems[#menuItems + 1] = {
            header = "👔 | Outfit Options",
            isMenuHeader = true -- Set to true to make a nonclickable title
        }
        menuItems[#menuItems + 1] = {
            header = "Civilian Outfit",
            txt = "Put on your clothes",
            params = {
                event = "fivem-appearance:client:reloadSkin"
            }
        }
        menuItems[#menuItems + 1] = {
            header = "Work Clothes",
            txt = "Pick from any of your work outfits",
            params = {
                event = "fivem-appearance:client:openJobOutfitsListMenu",
                args = {
                    backEvent = backEvent,
                    menuData = menuData
                }
            }
        }
    end
    exports['qb-menu']:openMenu(menuItems)
end

RegisterNetEvent("fivem-appearance:client:openJobOutfitsListMenu", function(data)
    local menu = {{
        header = '< Go Back',
        params = {
            event = data.backEvent,
            args = data.menuData
        }
    }}
    local event = "qb-clothing:client:loadOutfit"
    if Config.BossManagedOutfits then
        event = "fivem-appearance:client:changeOutfit"
    end
    if data.menuData then
        for _, v in pairs(data.menuData) do
            menu[#menu + 1] = {
                header = v.name,
                params = {
                    event = event,
                    args = v
                }
            }
        end
    end
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent("fivem-appearance:client:openClothingShopMenu", function(isPedMenu)
    if type(isPedMenu) == "table" then
        isPedMenu = false
    end
    OpenMenu(isPedMenu, "fivem-appearance:client:openClothingShopMenu", "default")
end)

RegisterNetEvent("fivem-appearance:client:OpenBarberShop", function()
    OpenBarberShop()
end)

RegisterNetEvent("fivem-appearance:client:OpenTattooShop", function()
    OpenTattooShop()
end)

RegisterNetEvent("fivem-appearance:client:OpenSurgeonShop", function()
    OpenSurgeonShop()
end)

RegisterNetEvent("fivem-appearance:client:changeOutfitMenu", function(data)
    QBCore.Functions.TriggerCallback('fivem-appearance:server:getOutfits', function(result)
        local outfitMenu = {{
            header = '< Go Back',
            params = {
                event = data.backEvent,
                args = data.isPedMenu
            }
        }}
        for i = 1, #result, 1 do
            outfitMenu[#outfitMenu + 1] = {
                header = result[i].outfitname,
                txt = result[i].model,
                params = {
                    event = 'fivem-appearance:client:changeOutfit',
                    args = {
                        name = result[i].outfitname,
                        model = result[i].model,
                        components = result[i].components,
                        props = result[i].props
                    }
                }
            }
        end
        exports['qb-menu']:openMenu(outfitMenu)
    end)
end)

RegisterNetEvent("fivem-appearance:client:changeOutfit", function(data)
    local playerPed = PlayerPedId()
    local pedModel = exports[resourceName]:getPedModel(playerPed)
    local failed = false
    local appearanceDB = nil
    if pedModel ~= data.model then
        QBCore.Functions.TriggerCallback("fivem-appearance:server:getAppearance", function(appearance)
            if appearance then
                exports[resourceName]:setPlayerAppearance(appearance)
                appearanceDB = appearance
                ResetRechargeMultipliers()
            else
                QBCore.Functions.Notify(
                    "Something went wrong. The outfit that you're trying to change to, does not have a base appearance.",
                    "error")
                failed = true
            end
        end, data.model)
    else
        appearanceDB = exports[resourceName]:getPedAppearance(playerPed)
    end
    if not failed then
        while not appearanceDB do
            Wait(100)
        end
        playerPed = PlayerPedId()
        exports[resourceName]:setPedComponents(playerPed, data.components)
        exports[resourceName]:setPedProps(playerPed, data.props)
        exports[resourceName]:setPedHair(playerPed, appearanceDB.hair)

        if data.disableSave then
            TriggerServerEvent("fivem-appearance:server:syncUniform", {
                type = data.type,
                name = data.name
            }) -- Is a uniform
        else
            local appearance = exports[resourceName]:getPedAppearance(playerPed)
            TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
        end
    end
end)

RegisterNetEvent("fivem-appearance:client:deleteOutfitMenu", function(data)
    QBCore.Functions.TriggerCallback('fivem-appearance:server:getOutfits', function(result)
        local outfitMenu = {{
            header = '< Go Back',
            params = {
                event = data.backEvent,
                args = data.isPedMenu
            }
        }}
        for i = 1, #result, 1 do
            outfitMenu[#outfitMenu + 1] = {
                header = 'Delete "' .. result[i].outfitname .. '"',
                txt = 'You will never be able to get this back!',
                params = {
                    event = 'fivem-appearance:client:deleteOutfit',
                    args = result[i].id
                }
            }
        end
        exports['qb-menu']:openMenu(outfitMenu)
    end)
end)

RegisterNetEvent("fivem-appearance:client:DeleteManagementOutfit", function(id)
    TriggerServerEvent("fivem-appearance:server:deleteManagementOutfit", id)
    QBCore.Functions.Notify('Outfit Deleted', 'error')
end)

RegisterNetEvent('fivem-appearance:client:deleteOutfit', function(id)
    TriggerServerEvent('fivem-appearance:server:deleteOutfit', id)
    QBCore.Functions.Notify('Outfit Deleted', 'error')
end)

RegisterNetEvent('fivem-appearance:client:openJobOutfitsMenu', function(outfitsToShow)
    OpenMenu(nil, "fivem-appearance:client:openJobOutfitsMenu", "job-outfit", outfitsToShow)
end)

local function InCooldown()
    return (GetGameTimer() - reloadSkinTimer) < Config.ReloadSkinCooldown
end

local function CheckPlayerMeta()
    return PlayerData.metadata["isdead"] or PlayerData.metadata["inlaststand"] or PlayerData.metadata["ishandcuffed"]
end

RegisterNetEvent('fivem-appearance:client:reloadSkin', function()
    if InCooldown() or CheckPlayerMeta() then
        QBCore.Functions.Notify("You cannot use reloadskin right now", "error")
        return
    end

    reloadSkinTimer = GetGameTimer()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    local maxhealth = GetEntityMaxHealth(playerPed)
    local armour = GetPedArmour(playerPed)

    QBCore.Functions.TriggerCallback('fivem-appearance:server:getAppearance', function(appearance)
        if not appearance then
            return
        end
        exports[resourceName]:setPlayerAppearance(appearance)
        if Config.PersistUniforms then
            TriggerServerEvent("fivem-appearance:server:syncUniform", nil)
        end
        playerPed = PlayerPedId()
        SetPedMaxHealth(playerPed, maxhealth)
        Wait(1000) -- Safety Delay
        SetEntityHealth(playerPed, health)
        SetPedArmour(playerPed, armour)
        ResetRechargeMultipliers()
    end)
end)

RegisterNetEvent("qb-radialmenu:client:onRadialmenuOpen", function()
    if not inZone or not zoneName then
        RemoveRadialMenuOption()
        return
    end
    local event, title
    if string.find(zoneName, "ClothingRooms_") then
        event = "fivem-appearance:client:OpenClothingRoom"
        title = "Clothing Room"
    elseif string.find(zoneName, "PlayerOutfitRooms_") then
        event = "fivem-appearance:client:OpenPlayerOutfitRoom"
        title = "Player Outfits"
    elseif zoneName == "clothing" then
        event = "fivem-appearance:client:openClothingShopMenu"
        title = "Clothing Shop"
    elseif zoneName == "barber" then
        event = "fivem-appearance:client:OpenBarberShop"
        title = "Barber Shop"
    elseif zoneName == "tattoo" then
        event = "fivem-appearance:client:OpenTattooShop"
        title = "Tattoo Shop"
    elseif zoneName == "surgeon" then
        event = "fivem-appearance:client:OpenSurgeonShop"
        title = "Surgeon Shop"
    end

    MenuItemId = exports["qb-radialmenu"]:AddOption({
        id = "open_clothing_menu",
        title = title,
        icon = "shirt",
        type = "client",
        event = event,
        shouldClose = true
    }, MenuItemId)
end)

local function isPlayerAllowedForOutfitRoom(outfitRoom)
    local isAllowed = false
    for i = 1, #outfitRoom.citizenIDs, 1 do
        if outfitRoom.citizenIDs[i] == PlayerData.citizenid then
            isAllowed = true
            break
        end
    end
    return isAllowed
end

local function OpenOutfitRoom(outfitRoom)
    local isAllowed = isPlayerAllowedForOutfitRoom(outfitRoom)
    if isAllowed then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    end
end

local function getPlayerJobOutfits(clothingRoom)
    local outfits = {}
    local gender = getGender()
    local fetched = false
    local gradeLevel = clothingRoom.job and PlayerJob.grade.level or PlayerGang.grade.level
    local jobName = clothingRoom.job and PlayerJob.name or PlayerGang.name

    if Config.BossManagedOutfits then
        local mType = clothingRoom.job and "Job" or "Gang"
        QBCore.Functions.TriggerCallback('fivem-appearance:server:getManagementOutfits', function(result)
            for i = 1, #result, 1 do
                outfits[#outfits + 1] = {
                    type = mType,
                    model = result[i].model,
                    components = result[i].components,
                    props = result[i].props,
                    disableSave = true,
                    name = result[i].name
                }
            end
            fetched = true
        end, mType, gender)
        while not fetched do
            Wait(10)
        end
    else
        for i = 1, #Config.Outfits[jobName][gender], 1 do
            for _, v in pairs(Config.Outfits[jobName][gender][i].grades) do
                if v == gradeLevel then
                    outfits[#outfits + 1] = Config.Outfits[jobName][gender][i]
                    outfits[#outfits].gender = gender
                    outfits[#outfits].jobName = jobName
                end
            end
        end
    end

    return outfits
end

RegisterNetEvent("fivem-appearance:client:OpenClothingRoom", function()
    local clothingRoom = Config.ClothingRooms[tonumber(string.sub(zoneName, 15))]
    local outfits = getPlayerJobOutfits(clothingRoom)
    TriggerEvent('fivem-appearance:client:openJobOutfitsMenu', outfits)
end)

RegisterNetEvent("fivem-appearance:client:OpenPlayerOutfitRoom", function()
    local outfitRoom = Config.PlayerOutfitRooms[tonumber(string.sub(zoneName, 19))]
    OpenOutfitRoom(outfitRoom)
end)

local function CheckDuty()
    return not Config.OnDutyOnlyClothingRooms or (Config.OnDutyOnlyClothingRooms and PlayerJob.onduty)
end

local function SetupStoreZones()
    local zones = {}
    for k, v in pairs(Config.Stores) do
        if Config.UseRadialMenu then
            zones[#zones + 1] = PolyZone:Create(v.zone.shape, {
                name = 'Stores_' .. v.shopType .. '_' .. k,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ,
            })
        else
            zones[#zones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
                name = 'Stores_' .. v.shopType .. '_' .. k,
                minZ = v.coords.z - 1.5,
                maxZ = v.coords.z + 1.5,
                heading = v.coords.w
            })
        end
    end

    local storeCombo = ComboZone:Create(zones, {
        name = "storeCombo",
        debugPoly = Config.Debug
    })
    storeCombo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            local matches = {zone.name:match("([^_]+)_([^_]+)_([^_]+)")}
            zoneName = matches[2]
            local currentStore = Config.Stores[tonumber(matches[3])]
            local jobName = (currentStore.job and PlayerJob.name) or (currentStore.gang and PlayerGang.name)
            if jobName == (currentStore.job or currentStore.gang) then
                inZone = true
                local prefix = Config.UseRadialMenu and '' or '[E] '
                if zoneName == 'clothing' then
                    exports['qb-core']:DrawText(prefix .. 'Clothing Store')
                elseif zoneName == 'barber' then
                    exports['qb-core']:DrawText(prefix .. 'Barber')
                elseif zoneName == 'tattoo' then
                    exports['qb-core']:DrawText(prefix .. 'Tattoo Shop')
                elseif zoneName == 'surgeon' then
                    exports['qb-core']:DrawText(prefix .. 'Plastic Surgeon')
                end
            end
        else
            inZone = false
            exports['qb-core']:HideText()
        end
    end)
end

local function SetupClothingRoomZones()
    local roomZones = {}
    for k, v in pairs(Config.ClothingRooms) do
        if Config.UseRadialMenu then
            roomZones[#roomZones + 1] = PolyZone:Create(v.zone.shape, {
                name = 'ClothingRooms_' .. k,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ,
            })
        else
            roomZones[#roomZones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
                name = 'ClothingRooms_' .. k,
                minZ = v.coords.z - 1.5,
                maxZ = v.coords.z + 1,
                heading = v.coords.w
            })
        end
    end

    local clothingRoomsCombo = ComboZone:Create(roomZones, {
        name = "clothingRoomsCombo",
        debugPoly = Config.Debug
    })
    clothingRoomsCombo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            zoneName = zone.name
            local clothingRoom = Config.ClothingRooms[tonumber(string.sub(zone.name, 15))]
            local jobName = clothingRoom.job and PlayerJob.name or PlayerGang.name
            if jobName == (clothingRoom.job or clothingRoom.gang) then
                if CheckDuty() then
                    inZone = true
                    local prefix = Config.UseRadialMenu and '' or '[E] '
                    exports['qb-core']:DrawText(prefix .. 'Clothing Room')
                end
            end
        else
            inZone = false
            exports['qb-core']:HideText()
        end
    end)
end

local function SetupPlayerOutfitRoomZones()
    local roomZones = {}
    for k, v in pairs(Config.PlayerOutfitRooms) do
        if Config.UseRadialMenu then
            roomZones[#roomZones + 1] = PolyZone:Create(v.zone.shape, {
                name = 'PlayerOutfitRooms_' .. k,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ,
            })
        else
            roomZones[#roomZones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
                name = 'PlayerOutfitRooms_' .. k,
                minZ = v.coords.z - 1.5,
                maxZ = v.coords.z + 1
            })
        end
    end

    local playerOutfitRoomsCombo = ComboZone:Create(roomZones, {
        name = "playerOutfitRoomsCombo",
        debugPoly = Config.Debug
    })
    playerOutfitRoomsCombo:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            zoneName = zone.name
            local outfitRoom = Config.PlayerOutfitRooms[tonumber(string.sub(zone.name, 19))]
            local isAllowed = isPlayerAllowedForOutfitRoom(outfitRoom)
            if isAllowed then
                inZone = true
                local prefix = Config.UseRadialMenu and '' or '[E] '
                exports['qb-core']:DrawText(prefix .. 'Outfits')
            end
        else
            inZone = false
            exports['qb-core']:HideText()
        end
    end)
end

local function SetupZones()
    SetupStoreZones()
    SetupClothingRoomZones()
    SetupPlayerOutfitRoomZones()
end

local function EnsurePedModel(pedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
    end
end

local function CreatePedAtCoords(pedModel, coords, scenario)
    pedModel = type(pedModel) == "string" and joaat(pedModel) or pedModel
    EnsurePedModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, false, false)
    TaskStartScenarioInPlace(ped, scenario, true)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

local function SetupStoreTargets()
    for k, v in pairs(Config.Stores) do
        local targetConfig = Config.TargetConfig[v.shopType]
        local action

        if v.shopType == 'barber' then
            action = OpenBarberShop
        elseif v.shopType == 'clothing' then
            action = function()
                TriggerEvent("fivem-appearance:client:openClothingShopMenu")
            end
        elseif v.shopType == 'tattoo' then
            action = OpenTattooShop
        elseif v.shopType == 'surgeon' then
            action = OpenSurgeonShop
        end

        local parameters = {
            options = {{
                type = "client",
                action = action,
                icon = targetConfig.icon,
                label = targetConfig.label
            }},
            distance = targetConfig.distance
        }

        if Config.EnablePedsForShops then
            TargetPeds.Store[k] = CreatePedAtCoords(targetConfig.model, v.coords, targetConfig.scenario)
            exports['qb-target']:AddTargetEntity(TargetPeds.Store[k], parameters)
        else
            exports['qb-target']:AddBoxZone(v.shopType .. k, v.coords, v.length, v.width, {
                name = v.shopType .. k,
                debugPoly = Config.Debug,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 1,
                heading = v.coords.w
            }, parameters)
        end
    end
end

local function SetupClothingRoomTargets()
    for k, v in pairs(Config.ClothingRooms) do
        local targetConfig = Config.TargetConfig["clothingroom"]
        local action = function()
            local outfits = getPlayerJobOutfits(v)
            TriggerEvent('fivem-appearance:client:openJobOutfitsMenu', outfits)
        end

        local parameters = {
            options = {{
                type = "client",
                action = action,
                icon = targetConfig.icon,
                label = targetConfig.label,
                canInteract = CheckDuty,
                job = v.job,
                gang = v.gang
            }},
            distance = targetConfig.distance
        }

        if Config.EnablePedsForClothingRooms then
            TargetPeds.ClothingRoom[k] = CreatePedAtCoords(targetConfig.model, v.coords, targetConfig.scenario)
            exports['qb-target']:AddTargetEntity(TargetPeds.ClothingRoom[k], parameters)
        else
            local key = 'clothing_' .. (v.job or v.gang) .. k
            exports['qb-target']:AddBoxZone(key, v.coords, v.length, v.width, {
                name = key,
                debugPoly = Config.Debug,
                minZ = v.coords.z - 2,
                maxZ = v.coords.z + 2,
                heading = v.coords.w
            }, parameters)
        end
    end
end

local function SetupPlayerOutfitRoomTargets()
    for k, v in pairs(Config.PlayerOutfitRooms) do
        local targetConfig = Config.TargetConfig["playeroutfitroom"]

        local parameters = {
            options = {{
                type = "client",
                action = function()
                    OpenOutfitRoom(v)
                end,
                icon = targetConfig.icon,
                label = targetConfig.label,
                canInteract = function()
                    return isPlayerAllowedForOutfitRoom(v)
                end
            }},
            distance = targetConfig.distance
        }

        if Config.EnablePedsForPlayerOutfitRooms then
            TargetPeds.PlayerOutfitRoom[k] = CreatePedAtCoords(targetConfig.model, v.coords, targetConfig.scenario)
            exports['qb-target']:AddTargetEntity(TargetPeds.ClothingRoom[k], parameters)
        else
            exports['qb-target']:AddBoxZone('playeroutfitroom_' .. k, v.coords, v.length, v.width, {
                name = 'playeroutfitroom_' .. k,
                debugPoly = Config.Debug,
                minZ = v.coords.z - 2,
                maxZ = v.coords.z + 2,
                heading = v.coords.w
            }, parameters)
        end
    end
end

local function SetupTargets()
    SetupStoreTargets()
    SetupClothingRoomTargets()
    SetupPlayerOutfitRoomTargets()
end

local function ZonesLoop()
    Wait(1000)
    while true do
        local sleep = 1000
        if inZone then
            sleep = 5
            if IsControlJustReleased(0, 38) then
                if string.find(zoneName, 'ClothingRooms_') then
                    local clothingRoom = Config.ClothingRooms[tonumber(string.sub(zoneName, 15))]
                    local outfits = getPlayerJobOutfits(clothingRoom)
                    TriggerEvent('fivem-appearance:client:openJobOutfitsMenu', outfits)
                elseif string.find(zoneName, 'PlayerOutfitRooms_') then
                    local outfitRoom = Config.PlayerOutfitRooms[tonumber(string.sub(zoneName, 19))]
                    OpenOutfitRoom(outfitRoom)
                elseif zoneName == 'clothing' then
                    TriggerEvent("fivem-appearance:client:openClothingShopMenu")
                elseif zoneName == 'barber' then
                    OpenBarberShop()
                elseif zoneName == 'tattoo' then
                    OpenTattooShop()
                elseif zoneName == 'surgeon' then
                    OpenSurgeonShop()
                end
            end
        end
        Wait(sleep)
    end
end

CreateThread(function()
    if Config.UseTarget then
        SetupTargets()
    else
        SetupZones()
        if not Config.UseRadialMenu then
            ZonesLoop()
        end
    end
end)
