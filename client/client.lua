local QBCore = exports["qb-core"]:GetCoreObject()

local client = client

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
        local model = client.getPedModel(PlayerPedId())
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
            exports["qb-target"]:RemoveZone(v.shopType .. k)
        end
    end

    if Config.EnablePedsForClothingRooms then
        RemoveTargetPeds(TargetPeds.ClothingRoom)
    else
        for k, v in pairs(Config.ClothingRooms) do
            exports["qb-target"]:RemoveZone("clothing_" .. (v.job or v.gang) .. k)
        end
    end

    if Config.EnablePedsForPlayerOutfitRooms then
        RemoveTargetPeds(TargetPeds.PlayerOutfitRoom)
    else
        for k in pairs(Config.PlayerOutfitRooms) do
            exports["qb-target"]:RemoveZone("playeroutfitroom_" .. k)
        end
    end
end

local function LoadPlayerUniform()
    lib.callback("fivem-appearance:server:getUniform", false, function(uniformData)
        if not uniformData then
            return
        end
        if Config.BossManagedOutfits then
            local result = lib.callback.await("fivem-appearance:server:getManagementOutfits", false, uniformData.type, getGender())
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
        exports["qb-radialmenu"]:RemoveOption(MenuItemId)
        MenuItemId = nil
    end
end

local function InitAppearance()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    PlayerGang = PlayerData.gang

    TriggerEvent("updateJob", PlayerJob.name)
    TriggerEvent("updateGang", PlayerGang.name)

    lib.callback("fivem-appearance:server:getAppearance", false, function(appearance)
        if not appearance then
            return
        end
        client.setPlayerAppearance(appearance)
        if Config.PersistUniforms then
            LoadPlayerUniform()
        end
        ResetRechargeMultipliers()

        if Config.Debug then -- This will detect if the player model is set as "player_zero" aka michael. Will then set the character as a freemode ped based on gender.
            Wait(5000)
            if GetEntityModel(PlayerPedId()) == `player_zero` then
                print('Player detected as "player_zero", Starting CreateFirstCharacter event')
                TriggerEvent("qb-clothes:client:CreateFirstCharacter")
            end
        end
    end)
    ResetBlips(PlayerJob.name, PlayerGang.name)
    if Config.BossManagedOutfits then
        AddManagementMenuItems()
    end
end

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        InitAppearance()
    end
end)

AddEventHandler("onResourceStop", function(resource)
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

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(JobInfo)
    PlayerData.job = JobInfo
    PlayerJob = JobInfo
    TriggerEvent("updateJob", PlayerJob.name)
    ResetBlips(PlayerJob.name, PlayerGang.name)
end)

RegisterNetEvent("QBCore:Client:OnGangUpdate", function(GangInfo)
    PlayerData.gang = GangInfo
    PlayerGang = GangInfo
    TriggerEvent("updateGang", PlayerGang.name)
    ResetBlips(PlayerJob.name, PlayerGang.name)
end)

RegisterNetEvent("QBCore:Client:SetDuty", function(duty)
    PlayerJob.onduty = duty
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
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

RegisterNetEvent("qb-clothes:client:CreateFirstCharacter", function()
    QBCore.Functions.GetPlayerData(function(pd)
        local gender = "Male"
        local skin = "mp_m_freemode_01"
        if pd.charinfo.gender == 1 then
            skin = "mp_f_freemode_01"
            gender = "Female"
        end
        client.setPlayerModel(skin)
        -- Fix for tattoo's appearing when creating a new character
        local ped = PlayerPedId()
        client.setPedTattoos(ped, {})
        client.setPedComponents(ped, Config.InitialPlayerClothes[gender].Components)
        client.setPedProps(ped, Config.InitialPlayerClothes[gender].Props)
        client.setPedHair(ped, Config.InitialPlayerClothes[gender].Hair)
        ClearPedDecorations(ped)
        local config = getNewCharacterConfig()
        client.startPlayerCustomization(function(appearance)
            if (appearance) then
                TriggerServerEvent("fivem-appearance:server:saveAppearance", appearance)
                ResetRechargeMultipliers()
            end
        end, config)
    end)
end)

function OpenShop(config, isPedMenu, shopType)
    lib.callback("fivem-appearance:server:hasMoney", false, function(hasMoney, money)
        if not hasMoney and not isPedMenu then
            lib.notify({
                title = "Cannot Enter Shop",
                description = "Not enough cash. Need $" .. money,
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end

        client.startPlayerCustomization(function(appearance)
            if appearance then
                if not isPedMenu then
                    TriggerServerEvent("fivem-appearance:server:chargeCustomer", shopType)
                end
                TriggerServerEvent("fivem-appearance:server:saveAppearance", appearance)
            else
                lib.notify({
                    title = "Cancelled Customization",
                    description = "Customization not saved",
                    type = "inform",
                    position = Config.NotifyOptions.position
                })
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
    OpenShop(config, isPedMenu, "clothing")
end

local function OpenBarberShop()
    local config = getDefaultConfig()
    config.headOverlays = true
    OpenShop(config, false, "barber")
end

local function OpenTattooShop()
    local config = getDefaultConfig()
    config.tattoos = true
    OpenShop(config, false, "tattoo")
end

local function OpenSurgeonShop()
    local config = getDefaultConfig()
    config.headBlend = true
    config.faceFeatures = true
    OpenShop(config, false, "surgeon")
end

RegisterNetEvent("fivem-appearance:client:openClothingShop", OpenClothingShop)

RegisterNetEvent("fivem-appearance:client:saveOutfit", function()
    local response = lib.inputDialog("Name your outfit", {
        {
            type = "input",
            label = "Outfit Name",
            placeholder = "Very cool outfit"
        }
    })

    if not response then
        return
    end

    local outfitName = response[1]
    if outfitName ~= nil then
        Wait(500)
        lib.callback("fivem-appearance:server:getOutfits", false, function(outfits)
            local outfitExists = false
            for i = 1, #outfits, 1 do
                if outfits[i].name == outfitName then
                    outfitExists = true
                    break
                end
            end

            if outfitExists then
                lib.notify({
                    title = "Save Failed",
                    description = "Outfit with this name already exists",
                    type = "error",
                    position = Config.NotifyOptions.position
                })
                return
            end

            local playerPed = PlayerPedId()
            local pedModel = client.getPedModel(playerPed)
            local pedComponents = client.getPedComponents(playerPed)
            local pedProps = client.getPedProps(playerPed)

            TriggerServerEvent("fivem-appearance:server:saveOutfit", outfitName, pedModel, pedComponents, pedProps)
        end)
    end
end)

local function RegisterChangeOutfitMenu(id, parent, outfits, mType)
    local changeOutfitMenu = {
        id = id,
        title = "Change Outfit",
        menu = parent,
        options = {}
    }
    for i = 1, #outfits, 1 do
        changeOutfitMenu.options[#changeOutfitMenu.options + 1] = {
            title = outfits[i].name,
            description = outfits[i].model,
            event = "fivem-appearance:client:changeOutfit",
            args = {
                type = mType,
                name = outfits[i].name,
                model = outfits[i].model,
                components = outfits[i].components,
                props = outfits[i].props,
                disableSave = mType and true or false
            }
        }
    end

    lib.registerContext(changeOutfitMenu)
end

local function RegisterDeleteOutfitMenu(id, parent, outfits, deleteEvent)
    local deleteOutfitMenu = {
        id = id,
        title = "Delete Outfit",
        menu = parent,
        options = {}
    }
    for i = 1, #outfits, 1 do
        deleteOutfitMenu.options[#deleteOutfitMenu.options + 1] = {
            title = 'Delete "' .. outfits[i].name .. '"',
            description = "Model: " .. outfits[i].model .. (outfits[i].gender and (" - Gender: " .. outfits[i].gender) or ""),
            event = deleteEvent,
            args = outfits[i].id
        }
    end

    lib.registerContext(deleteOutfitMenu)
end

RegisterNetEvent("fivem-appearance:client:OutfitManagementMenu", function(args)
    local bossMenuEvent = "qb-bossmenu:client:OpenMenu"
    if args.type == "Gang" then
        bossMenuEvent = "qb-gangmenu:client:OpenMenu"
    end

    local outfits = lib.callback.await("fivem-appearance:server:getManagementOutfits", false, args.type, getGender())
    local managementMenuID = "illenium_appearance_outfit_management_menu"
    local changeManagementOutfitMenuID = "illenium_appearance_change_management_outfit_menu"
    local deleteManagementOutfitMenuID = "illenium_appearance_delete_management_outfit_menu"

    RegisterChangeOutfitMenu(changeManagementOutfitMenuID, managementMenuID, outfits, args.type)
    RegisterDeleteOutfitMenu(deleteManagementOutfitMenuID, managementMenuID, outfits, "fivem-appearance:client:DeleteManagementOutfit")
    local managementMenu = {
        id = managementMenuID,
        title = "👔 | Manage " .. args.type .. " Outfits",
        options = {
            {
                title = "Change Outfit",
                description = "Pick from any of your currently saved "  .. args.type .. " outfits",
                menu = changeManagementOutfitMenuID,
            },
            {
                title = "Save current Outfit",
                description = "Save your current outfit as " .. args.type .. " outfit",
                event = "fivem-appearance:client:SaveManagementOutfit",
                args = args.type
            },
            {
                title = "Delete Outfit",
                description = "Delete a saved " .. args.type .. " outfit",
                menu = deleteManagementOutfitMenuID,
            },
            {
                title = "Return",
                icon = "fa-solid fa-angle-left",
                event = bossMenuEvent
            }
        }
    }

    lib.registerContext(managementMenu)
    lib.showContext(managementMenuID)
end)

local function getRankInputValues(rankList)
    local rankValues = {}
    for k, v in pairs(rankList) do
        rankValues[#rankValues + 1] = {
            label = v.name,
            value = k
        }
    end
    return rankValues
end

RegisterNetEvent("fivem-appearance:client:SaveManagementOutfit", function(mType)
    local playerPed = PlayerPedId()
    local outfitData = {
        Type = mType,
        Model = client.getPedModel(playerPed),
        Components = client.getPedComponents(playerPed),
        Props = client.getPedProps(playerPed)
    }

    local rankValues
    
    if mType == "Job" then
        outfitData.JobName = PlayerJob.name
        rankValues = getRankInputValues(QBCore.Shared.Jobs[PlayerJob.name].grades)
        
    else
        outfitData.JobName = PlayerGang.name
        rankValues = getRankInputValues(QBCore.Shared.Gangs[PlayerGang.name].grades)
    end

    local dialogResponse = lib.inputDialog("Management Outfit Details", {
            {
                label = "Outfit Name",
                type = "input",
            },
            {
                label = "Gender",
                type = "select",
                options = {
                    {
                        label = "Male", value = "male"
                    },
                    {
                        label = "Female", value = "female"
                    }
                },
                default = "male"
            },
            {
                label = "Minimum Rank",
                type = "select",
                options = rankValues,
                default = "0"
            }
        })

    if not dialogResponse then
        return
    end


    outfitData.Name = dialogResponse[1]
    outfitData.Gender = dialogResponse[2]
    outfitData.MinRank = tonumber(dialogResponse[3])

    TriggerServerEvent("fivem-appearance:server:saveManagementOutfit", outfitData)

end)

local function RegisterWorkOutfitsListMenu(id, parent, menuData)
    local menu = {
        id = id,
        menu = parent,
        title = "Work Outfits",
        options = {}
    }
    local event = "qb-clothing:client:loadOutfit"
    if Config.BossManagedOutfits then
        event = "fivem-appearance:client:changeOutfit"
    end
    if menuData then
        for _, v in pairs(menuData) do
            menu.options[#menu.options + 1] = {
                title = v.name,
                event = event,
                args = v
            }
        end
    end
    lib.registerContext(menu)
end

function OpenMenu(isPedMenu, menuType, menuData)
    local mainMenuID = "illenium_appearance_main_menu"
    local mainMenu = {
        id = mainMenuID
    }
    local menuItems = {}

    local outfits = lib.callback.await("fivem-appearance:server:getOutfits", false)
    local changeOutfitMenuID = "illenium_appearance_change_outfit_menu"
    local deleteOutfitMenuID = "illenium_appearance_delete_outfit_menu"

    RegisterChangeOutfitMenu(changeOutfitMenuID, mainMenuID, outfits)
    RegisterDeleteOutfitMenu(deleteOutfitMenuID, mainMenuID, outfits, "fivem-appearance:client:deleteOutfit")
    local outfitMenuItems = {
        {
            title = "Change Outfit",
            description = "Pick from any of your currently saved outfits",
            menu = changeOutfitMenuID
        },
        {
            title = "Save New Outfit",
            description = "Save a new outfit you can use later on",
            event = "fivem-appearance:client:saveOutfit"
        },
        {
            title = "Delete Outfit",
            description = "Delete any of your saved outfits",
            menu = deleteOutfitMenuID
        }
    }
    if menuType == "default" then
        local header = "Buy Clothing - $" .. Config.ClothingCost
        if isPedMenu then
            header = "Change Clothing"
        end
        mainMenu.title = "👔 | Clothing Store Options"
        menuItems[#menuItems + 1] = {
            title = header,
            description = "Pick from a wide range of items to wear",
            event = "fivem-appearance:client:openClothingShop",
            args = isPedMenu
        }
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "outfit" then
        mainMenu.title = "👔 | Outfit Options"
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "job-outfit" then
        mainMenu.title = "👔 | Outfit Options"
        menuItems[#menuItems + 1] = {
            title = "Civilian Outfit",
            description = "Put on your clothes",
            event = "fivem-appearance:client:reloadSkin"
        }

        local workOutfitsMenuID = "illenium_appearance_work_outfits_menu"
        RegisterWorkOutfitsListMenu(workOutfitsMenuID, mainMenuID, menuData)

        menuItems[#menuItems + 1] = {
            title = "Work Outfits",
            description = "Pick from any of your work outfits",
            menu = workOutfitsMenuID
        }
    end
    mainMenu.options = menuItems

    lib.registerContext(mainMenu)
    lib.showContext(mainMenuID)
end

RegisterNetEvent("fivem-appearance:client:openClothingShopMenu", function(isPedMenu)
    if type(isPedMenu) == "table" then
        isPedMenu = false
    end
    OpenMenu(isPedMenu, "default")
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

RegisterNetEvent("fivem-appearance:client:changeOutfit", function(data)
    local playerPed = PlayerPedId()
    local pedModel = client.getPedModel(playerPed)
    local appearanceDB
    if pedModel ~= data.model then
        local p = promise.new()
        lib.callback("fivem-appearance:server:getAppearance", false, function(appearance)
            if appearance then
                client.setPlayerAppearance(appearance)
                ResetRechargeMultipliers()
            else
                lib.notify({
                    title = "Something went wrong",
                    description = "The outfit that you're trying to change to, does not have a base appearance",
                    type = "error",
                    position = Config.NotifyOptions.position
                })
            end
            p:resolve(appearance)
        end, data.model)
        appearanceDB = Citizen.Await(p)
    else
        appearanceDB = client.getPedAppearance(playerPed)
    end
    if appearanceDB then
        playerPed = PlayerPedId()
        client.setPedComponents(playerPed, data.components)
        client.setPedProps(playerPed, data.props)
        client.setPedHair(playerPed, appearanceDB.hair)

        if data.disableSave then
            TriggerServerEvent("fivem-appearance:server:syncUniform", {
                type = data.type,
                name = data.name
            }) -- Is a uniform
        else
            local appearance = client.getPedAppearance(playerPed)
            TriggerServerEvent("fivem-appearance:server:saveAppearance", appearance)
        end
    end
end)

RegisterNetEvent("fivem-appearance:client:DeleteManagementOutfit", function(id)
    TriggerServerEvent("fivem-appearance:server:deleteManagementOutfit", id)
    lib.notify({
        title = "Success",
        description = "Outfit Deleted",
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

RegisterNetEvent("fivem-appearance:client:deleteOutfit", function(id)
    TriggerServerEvent("fivem-appearance:server:deleteOutfit", id)
    lib.notify({
        title = "Success",
        description = "Outfit Deleted",
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

RegisterNetEvent("fivem-appearance:client:openJobOutfitsMenu", function(outfitsToShow)
    OpenMenu(nil, "job-outfit", outfitsToShow)
end)

local function InCooldown()
    return (GetGameTimer() - reloadSkinTimer) < Config.ReloadSkinCooldown
end

local function CheckPlayerMeta()
    return PlayerData.metadata["isdead"] or PlayerData.metadata["inlaststand"] or PlayerData.metadata["ishandcuffed"]
end

RegisterNetEvent("fivem-appearance:client:reloadSkin", function()
    local playerPed = PlayerPedId()

    if InCooldown() or CheckPlayerMeta() or IsPedInAnyVehicle(playerPed, true) or IsPedFalling(playerPed) then
        lib.notify({
            title = "Error",
            description = "You cannot use reloadskin right now",
            type = "error",
            position = Config.NotifyOptions.position
        })
        return
    end

    reloadSkinTimer = GetGameTimer()

    local health = GetEntityHealth(playerPed)
    local maxhealth = GetEntityMaxHealth(playerPed)
    local armour = GetPedArmour(playerPed)

    lib.callback("fivem-appearance:server:getAppearance", false, function(appearance)
        if not appearance then
            return
        end
        client.setPlayerAppearance(appearance)
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

RegisterNetEvent("fivem-appearance:client:ClearStuckProps", function()
    if InCooldown() or CheckPlayerMeta() then
        lib.notify({
            title = "Error",
            description = "You cannot use clearstuckprops right now",
            type = "error",
            position = Config.NotifyOptions.position
        })
        return
    end

    reloadSkinTimer = GetGameTimer()
    local playerPed = PlayerPedId()

    for _, v in pairs(GetGamePool("CObject")) do
      if IsEntityAttachedToEntity(playerPed, v) then
        SetEntityAsMissionEntity(v, true, true)
        DeleteObject(v)
        DeleteEntity(v)
      end
    end
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
    local count = #outfitRoom.citizenIDs
    for i = 1, count, 1 do
        if outfitRoom.citizenIDs[i] == PlayerData.citizenid then
            isAllowed = true
            break
        end
    end
    return isAllowed or not outfitRoom.citizenIDs or count == 0
end

local function OpenOutfitRoom(outfitRoom)
    local isAllowed = isPlayerAllowedForOutfitRoom(outfitRoom)
    if isAllowed then
        TriggerEvent("qb-clothing:client:openOutfitMenu")
    end
end

local function getPlayerJobOutfits(clothingRoom)
    local outfits = {}
    local gender = getGender()
    local gradeLevel = clothingRoom.job and PlayerJob.grade.level or PlayerGang.grade.level
    local jobName = clothingRoom.job and PlayerJob.name or PlayerGang.name

    if Config.BossManagedOutfits then
        local mType = clothingRoom.job and "Job" or "Gang"
        local result = lib.callback.await("fivem-appearance:server:getManagementOutfits", false, mType, gender)
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
    TriggerEvent("fivem-appearance:client:openJobOutfitsMenu", outfits)
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
                name = "Stores_" .. v.shopType .. "_" .. k,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ,
            })
        else
            zones[#zones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
                name = "Stores_" .. v.shopType .. "_" .. k,
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
                local prefix = Config.UseRadialMenu and "" or "[E] "
                if zoneName == "clothing" then
                    lib.showTextUI(prefix .. "Clothing Store - Price: $" .. Config.ClothingCost, Config.TextUIOptions)
                elseif zoneName == "barber" then
                    lib.showTextUI(prefix .. "Barber - Price: $" .. Config.BarberCost, Config.TextUIOptions)
                elseif zoneName == "tattoo" then
                    lib.showTextUI(prefix .. "Tattoo Shop - Price: $" .. Config.TattooCost, Config.TextUIOptions)
                elseif zoneName == "surgeon" then
                    lib.showTextUI(prefix .. "Plastic Surgeon - Price: $" .. Config.SurgeonCost, Config.TextUIOptions)
                end
            end
        else
            inZone = false
            lib.hideTextUI()
        end
    end)
end

local function SetupClothingRoomZones()
    local roomZones = {}
    for k, v in pairs(Config.ClothingRooms) do
        if Config.UseRadialMenu then
            roomZones[#roomZones + 1] = PolyZone:Create(v.zone.shape, {
                name = "ClothingRooms_" .. k,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ,
            })
        else
            roomZones[#roomZones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
                name = "ClothingRooms_" .. k,
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
                if CheckDuty() or clothingRoom.gang then
                    inZone = true
                    local prefix = Config.UseRadialMenu and "" or "[E] "
                    lib.showTextUI(prefix .. "Clothing Room", Config.TextUIOptions)
                end
            end
        else
            inZone = false
            lib.hideTextUI()
        end
    end)
end

local function SetupPlayerOutfitRoomZones()
    local roomZones = {}
    for k, v in pairs(Config.PlayerOutfitRooms) do
        if Config.UseRadialMenu then
            roomZones[#roomZones + 1] = PolyZone:Create(v.zone.shape, {
                name = "PlayerOutfitRooms_" .. k,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ,
            })
        else
            roomZones[#roomZones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
                name = "PlayerOutfitRooms_" .. k,
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
                local prefix = Config.UseRadialMenu and "" or "[E] "
                lib.showTextUI(prefix .. "Outfits", Config.TextUIOptions)
            end
        else
            inZone = false
            lib.hideTextUI()
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

        if v.shopType == "barber" then
            action = OpenBarberShop
        elseif v.shopType == "clothing" then
            action = function()
                TriggerEvent("fivem-appearance:client:openClothingShopMenu")
            end
        elseif v.shopType == "tattoo" then
            action = OpenTattooShop
        elseif v.shopType == "surgeon" then
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
            TargetPeds.Store[k] = CreatePedAtCoords(v.targetModel or targetConfig.model, v.coords, v.targetScenario or targetConfig.scenario)
            exports["qb-target"]:AddTargetEntity(TargetPeds.Store[k], parameters)
        else
            exports["qb-target"]:AddBoxZone(v.shopType .. k, v.coords, v.length, v.width, {
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
            TriggerEvent("fivem-appearance:client:openJobOutfitsMenu", outfits)
        end

        local parameters = {
            options = {{
                type = "client",
                action = action,
                icon = targetConfig.icon,
                label = targetConfig.label,
                canInteract = v.job and CheckDuty or nil,
                job = v.job,
                gang = v.gang
            }},
            distance = targetConfig.distance
        }

        if Config.EnablePedsForClothingRooms then
            TargetPeds.ClothingRoom[k] = CreatePedAtCoords(v.targetModel or targetConfig.model, v.coords, v.targetScenario or targetConfig.scenario)
            exports["qb-target"]:AddTargetEntity(TargetPeds.ClothingRoom[k], parameters)
        else
            local key = "clothing_" .. (v.job or v.gang) .. k
            exports["qb-target"]:AddBoxZone(key, v.coords, v.length, v.width, {
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
            TargetPeds.PlayerOutfitRoom[k] = CreatePedAtCoords(v.targetModel or targetConfig.model, v.coords, v.targetScenario or targetConfig.scenario)
            exports["qb-target"]:AddTargetEntity(TargetPeds.ClothingRoom[k], parameters)
        else
            exports["qb-target"]:AddBoxZone("playeroutfitroom_" .. k, v.coords, v.length, v.width, {
                name = "playeroutfitroom_" .. k,
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
                if string.find(zoneName, "ClothingRooms_") then
                    local clothingRoom = Config.ClothingRooms[tonumber(string.sub(zoneName, 15))]
                    local outfits = getPlayerJobOutfits(clothingRoom)
                    TriggerEvent("fivem-appearance:client:openJobOutfitsMenu", outfits)
                elseif string.find(zoneName, "PlayerOutfitRooms_") then
                    local outfitRoom = Config.PlayerOutfitRooms[tonumber(string.sub(zoneName, 19))]
                    OpenOutfitRoom(outfitRoom)
                elseif zoneName == "clothing" then
                    TriggerEvent("fivem-appearance:client:openClothingShopMenu")
                elseif zoneName == "barber" then
                    OpenBarberShop()
                elseif zoneName == "tattoo" then
                    OpenTattooShop()
                elseif zoneName == "surgeon" then
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
