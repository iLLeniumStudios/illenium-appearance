local QBCore = exports['qb-core']:GetCoreObject()

local zoneName = nil
local inZone = false

local allMyOutfits = {}
local PlayerData = {}
local PlayerJob = {}
local PlayerGang = {}

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
        PlayerGang = PlayerData.gang
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    PlayerGang = PlayerData.gang

    QBCore.Functions.TriggerCallback('fivem-appearance:server:getAppearance', function(appearance)
        if not appearance then
            return
        end
        exports['fivem-appearance']:setPlayerAppearance(appearance)

        if Config.Debug then -- This will detect if the player model is set as "player_zero" aka michael. Will then set the character as a freemode ped based on gender.
            Wait(5000)
            if GetEntityModel(PlayerPedId()) == `player_zero` then
                print('Player detected as "player_zero", Starting CreateFirstCharacter event')
                TriggerEvent('qb-clothes:client:CreateFirstCharacter')
            end
        end

    end)
end)

local function getConfigForPermission(hasPedPerms)
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        tattoos = true
    }

    if Config.EnablePedMenu then
        config.ped = hasPedPerms
    end

    return config
end

RegisterNetEvent('qb-clothes:client:CreateFirstCharacter', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        local skin = 'mp_m_freemode_01'
        if PlayerData.charinfo.gender == 1 then
            skin = "mp_f_freemode_01"
        end
        exports['fivem-appearance']:setPlayerModel(skin)
        QBCore.Functions.TriggerCallback("QBCore:HasPermission", function(permission)
            local config = getConfigForPermission(permission)
            exports['fivem-appearance']:startPlayerCustomization(function(appearance)
                if (appearance) then
                    TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
                end
            end, config)
        end, Config.PedMenuGroup)
    end)
end)

function OpenShop(config, isPedMenu)
    QBCore.Functions.TriggerCallback("fivem-appearance:server:hasMoney", function(hasMoney)
        if not hasMoney and not isPedMenu then
            QBCore.Functions.Notify("Not enough cash. Need $" .. Config.Money, "error")
            return
        end

        exports['fivem-appearance']:startPlayerCustomization(function(appearance)
            if appearance then
                if not isPedMenu then
                    TriggerServerEvent("fivem-appearance:server:chargeCustomer")
                end
                TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
            else
                QBCore.Functions.Notify("Cancelled Customization")
            end
        end, config)
    end)
end

local function OpenClothingShop(isPedMenu)
    local config = {
        ped = false,
        headBlend = false,
        faceFeatures = false,
        headOverlays = false,
        components = true,
        props = true,
        tattoos = false
    }
    if isPedMenu then
        config = {
            ped = true,
            headBlend = true,
            faceFeatures = true,
            headOverlays = true,
            components = true,
            props = true,
            tattoos = true
        }
    end
    OpenShop(config, isPedMenu)
end

local function OpenBarberShop()
    OpenShop({
        ped = false,
        headBlend = false,
        faceFeatures = false,
        headOverlays = true,
        components = false,
        props = false,
        tattoos = false
    })
end

local function OpenTattooShop()
    OpenShop({
        ped = false,
        headBlend = false,
        faceFeatures = false,
        headOverlays = false,
        components = false,
        props = false,
        tattoos = true
    })
end

local function OpenSurgeonShop()
    OpenShop({
        ped = false,
        headBlend = true,
        faceFeatures = true,
        headOverlays = false,
        components = false,
        props = false,
        tattoos = false
    })
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
        local appearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())
        TriggerServerEvent('fivem-appearance:server:saveOutfit', keyboard.input, appearance)
    end
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
        local header = "Buy Clothing - $" .. Config.Money
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
    if data.menuData then
        for k, v in pairs(data.menuData) do
            menu[#menu + 1] = {
                header = v.outfitLabel,
                params = {
                    event = 'qb-clothing:client:loadOutfit',
                    args = v
                }
            }
        end
    end
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent("fivem-appearance:client:openClothingShopMenu", function(isPedMenu)
    OpenMenu(isPedMenu, "fivem-appearance:client:openClothingShopMenu", "default")
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
                params = {
                    event = 'fivem-appearance:client:changeOutfit',
                    args = result[i].skin
                }
            }
        end
        exports['qb-menu']:openMenu(outfitMenu)
    end)
end)

RegisterNetEvent("fivem-appearance:client:changeOutfit", function(appearance)
    exports['fivem-appearance']:setPlayerAppearance(appearance)
    TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
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

RegisterNetEvent('fivem-appearance:client:deleteOutfit', function(id)
    TriggerServerEvent('fivem-appearance:server:deleteOutfit', id)
    QBCore.Functions.Notify('Outfit Deleted', 'error')
end)

RegisterNetEvent('fivem-appearance:client:openJobOutfitsMenu', function(outfitsToShow)
    OpenMenu(isPedMenu, "fivem-appearance:client:openJobOutfitsMenu", "job-outfit", outfitsToShow)
end)

RegisterNetEvent('fivem-appearance:client:reloadSkin', function()
    local playerPed = PlayerPedId()
    local maxhealth = GetEntityMaxHealth(playerPed)
    local health = GetEntityHealth(playerPed)
    QBCore.Functions.TriggerCallback('fivem-appearance:server:getAppearance', function(appearance)
        if not appearance then
            return
        end
        exports['fivem-appearance']:setPlayerAppearance(appearance)

        for k, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(PlayerPedId(), v) then
                SetEntityAsMissionEntity(v, true, true)
                DeleteObject(v)
                DeleteEntity(v)
            end
            SetPedMaxHealth(PlayerId(), maxhealth)
            Citizen.Wait(1000) -- Safety Delay
            SetEntityHealth(PlayerPedId(), health)
        end
    end)
end)

function getPlayerJobOutfits(clothingRoom)
    local outfits = {}
    local gender = "male"
    if PlayerData.charinfo.gender == 1 then
        gender = "female"
    end
    local gradeLevel = clothingRoom.isGang and PlayerData.gang.grade.level or PlayerData.job.grade.level

    for i = 0, #Config.Outfits[PlayerJob.name][gender], 1 do
        for k,v in pairs(Config.Outfits[PlayerJob.name][gender][i].grades) do
            if v == gradeLevel then
                outfits[#outfits+1] = Config.Outfits[PlayerJob.name][gender][i]
            end
        end
    end

    return outfits
end

function SetupZones()
    local zones = {}
    for k, v in pairs(Config.Stores) do
        zones[#zones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
            name = v.shopType,
            minZ = v.coords.z - 1.5,
            maxZ = v.coords.z + 1,
            debugPoly = false
        })
    end

    local clothingCombo = ComboZone:Create(zones, {
        name = "clothingCombo",
        debugPoly = false
    })
    clothingCombo:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inZone = true
            zoneName = zone.name
            if zoneName == 'clothing' then
                exports['qb-core']:DrawText('[E] Clothing Store')
            elseif zoneName == 'barber' then
                exports['qb-core']:DrawText('[E] Barber')
            elseif zoneName == 'tattoo' then
                exports['qb-core']:DrawText('[E] Tattoo Shop')
            elseif zoneName == 'surgeon' then
                exports['qb-core']:DrawText('[E] Plastic Surgeon')
            end
        else
            inZone = false
            exports['qb-core']:HideText()
        end
    end)

    local roomZones = {}
    for k, v in pairs(Config.ClothingRooms) do
        roomZones[#roomZones + 1] = BoxZone:Create(v.coords, v.length, v.width, {
            name = 'ClothingRooms_' .. k,
            minZ = v.coords.z - 1.5,
            maxZ = v.coords.z + 1,
            debugPoly = false
        })
    end

    local clothingRoomsCombo = ComboZone:Create(roomZones, {
        name = "clothingRoomsCombo",
        debugPoly = false
    })
    clothingRoomsCombo:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            zoneName = zone.name
            if (PlayerData.job.name == Config.ClothingRooms[tonumber(string.sub(zone.name, 15))].requiredJob) then
                inZone = true
                exports['qb-core']:DrawText('[E] Clothing Room')
            end
        else
            inZone = false
            exports['qb-core']:HideText()
        end
    end)
end

function SetupTargets()
    for k, v in pairs(Config.Stores) do
        local opts = {}
        if v.shopType == 'barber' then
            opts = {
                action = function(entity)
                    OpenBarberShop()
                end,
                icon = "fas fa-scissors",
                label = "Barber",
            }
        elseif v.shopType == 'clothing' then
            opts = {
                action = function(entity)
                    TriggerEvent("fivem-appearance:client:openClothingShopMenu")
                end,
                icon = "fas fa-tshirt",
                label = "Clothing Store",
            }
        elseif v.shopType == 'tattoo' then
            opts = {
                action = function(entity)
                    OpenTattooShop()
                end,
                icon = "fas fa-pen",
                label = "Tattoos",
            }
        elseif v.shopType == 'surgeon' then
            opts = {
                action = function(entity)
                    OpenSurgeonShop()
                end,
                icon = "fas fa-scalpel",
                label = "Plastic Surgeon"
            }
        end
        exports['qb-target']:AddBoxZone(v.shopType .. k, v.coords, v.length, v.width, {
            name = v.shopType .. k,
            debugPoly = false,
            minZ = v.coords.z-1,
            maxZ = v.coords.z+1,
        }, {
            options = {
                {
                    type = "client",
                    action = opts.action,
                    icon = opts.icon,
                    label = opts.label,
                },
            },
            distance = 3
        })
    end

    for k, v in pairs(Config.ClothingRooms) do
        local action = nil
        action = function(entity)
            local outfits = getPlayerJobOutfits(v)
            TriggerEvent('fivem-appearance:client:openJobOutfitsMenu', outfits)
        end

        exports['qb-target']:AddBoxZone('clothing_' .. v.requiredJob .. k, v.coords, v.length, v.width, {
            name = 'clothing_' .. v.requiredJob .. k,
            debugPoly = false,
            minZ = v.coords.z - 2,
            maxZ = v.coords.z + 2,
        }, {
            options = {
                {
                    type = "client",
                    action = action,
                    icon = "fas fa-sign-in-alt",
                    label = "Clothing",
                    job = v.requiredJob
                },
            },
            distance = 3
        })
    end
end

function ZonesLoop()
    Wait(1000)
    while true do
        local sleep = 1000
        if inZone then
            sleep = 5
            if string.find(zoneName, 'ClothingRooms_') then
                if IsControlJustReleased(0, 38) then
                    local clothingRoom = Config.ClothingRooms[tonumber(string.sub(zoneName, 15))]
                    local outfits = getPlayerJobOutfits(clothingRoom)
                    TriggerEvent('fivem-appearance:client:openJobOutfitsMenu', outfits)
                end
            elseif zoneName == 'clothing' then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("fivem-appearance:client:openClothingShopMenu")
                end
            elseif zoneName == 'barber' then
                if IsControlJustReleased(0, 38) then
                    OpenBarberShop()
                end
            elseif zoneName == 'tattoo' then
                if IsControlJustReleased(0, 38) then
                    OpenTattooShop()
                end
            elseif zoneName == 'surgeon' then
                if IsControlJustReleased(0, 38) then
                    OpenSurgeonShop()
                end
            end
        else
            sleep = 1000
        end
        Wait(sleep)
    end
end

CreateThread(function()
    if Config.UseTarget then
        SetupTargets()
    else
        SetupZones()
        ZonesLoop()
    end
end)
