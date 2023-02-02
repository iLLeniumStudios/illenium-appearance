local client = client

local currentZone = nil
local MenuItemId = nil

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

local Zones = {
    Store = {},
    ClothingRoom = {},
    PlayerOutfitRoom = {}
}

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
            Target.RemoveZone(v.type .. k)
        end
    end

    if Config.EnablePedsForClothingRooms then
        RemoveTargetPeds(TargetPeds.ClothingRoom)
    else
        for k, v in pairs(Config.ClothingRooms) do
            Target.RemoveZone("clothing_" .. (v.job or v.gang) .. k)
        end
    end

    if Config.EnablePedsForPlayerOutfitRooms then
        RemoveTargetPeds(TargetPeds.PlayerOutfitRoom)
    else
        for k in pairs(Config.PlayerOutfitRooms) do
            Target.RemoveZone("playeroutfitroom_" .. k)
        end
    end
end

local function RemoveZones()
    for i = 1, #Zones.Store do
        Zones.Store[i]:remove()
    end
    for i = 1, #Zones.ClothingRoom do
        Zones.ClothingRoom[i]:remove()
    end
    for i = 1, #Zones.PlayerOutfitRoom do
        Zones.PlayerOutfitRoom[i]:remove()
    end
end

local function LoadPlayerUniform()
    lib.callback("illenium-appearance:server:getUniform", false, function(uniformData)
        if not uniformData then
            return
        end
        if Config.BossManagedOutfits then
            local result = lib.callback.await("illenium-appearance:server:getManagementOutfits", false, uniformData.type, Framework.GetGender())
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
                TriggerServerEvent("illenium-appearance:server:syncUniform", nil) -- Uniform doesn't exist anymore
                return
            end

            TriggerEvent("illenium-appearance:client:changeOutfit", uniform)
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
                TriggerServerEvent("illenium-appearance:server:syncUniform", nil) -- Uniform doesn't exist anymore
                return
            end

            uniform.jobName = uniformData.jobName
            uniform.gender = uniformData.gender

            TriggerEvent("illenium-appearance:client:loadJobOutfit", uniform)
        end
    end)
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
    local eventName = "illenium-appearance:client:OutfitManagementMenu"
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

function InitAppearance()
    Framework.UpdatePlayerData()
    lib.callback("illenium-appearance:server:getAppearance", false, function(appearance)
        if not appearance then
            return
        end

        client.setPlayerAppearance(appearance)
        if Config.PersistUniforms then
            LoadPlayerUniform()
        end
    end)
    ResetBlips()
    if Config.BossManagedOutfits then
        AddManagementMenuItems()
    end
    RestorePlayerStats()
end

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        InitAppearance()
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if Config.UseTarget and Target.IsTargetStarted() then
            RemoveTargets()
        else
            RemoveZones()
        end
        if Config.UseRadialMenu and GetResourceState("qb-radialmenu") == "started" then
            RemoveRadialMenuOption()
        end
        if Config.BossManagedOutfits and GetResourceState("qb-management") == "started" then
            RemoveManagementMenuItems()
        end
    end
end)



local function getNewCharacterConfig()
    local config = GetDefaultConfig()
    config.enableExit   = false

    config.ped          = Config.NewCharacterSections.Ped
    config.headBlend    = Config.NewCharacterSections.HeadBlend
    config.faceFeatures = Config.NewCharacterSections.FaceFeatures
    config.headOverlays = Config.NewCharacterSections.HeadOverlays
    config.components   = Config.NewCharacterSections.Components
    config.props        = Config.NewCharacterSections.Props
    config.tattoos      = not Config.RCoreTattoosCompatibility and Config.NewCharacterSections.Tattoos

    return config
end

function InitializeCharacter(gender, onSubmit, onCancel)
    local skin = "mp_m_freemode_01"
    if gender == "Female" then
        skin = "mp_f_freemode_01"
    end
    client.setPlayerModel(skin)
    -- Fix for tattoo's appearing when creating a new character
    local ped = PlayerPedId()
    client.setPedTattoos(ped, {})
    client.setPedComponents(ped, Config.InitialPlayerClothes[gender].Components)
    client.setPedProps(ped, Config.InitialPlayerClothes[gender].Props)
    client.setPedHair(ped, Config.InitialPlayerClothes[gender].Hair, {})
    ClearPedDecorations(ped)
    local config = getNewCharacterConfig()
    TriggerServerEvent("illenium-appearance:server:ChangeRoutingBucket")
    client.startPlayerCustomization(function(appearance)
        if (appearance) then
            TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
            if onSubmit then
                onSubmit()
            end
        elseif onCancel then
            onCancel()
        end
        Framework.CachePed()
        TriggerServerEvent("illenium-appearance:server:ResetRoutingBucket")
    end, config)
end

function OpenShop(config, isPedMenu, shopType)
    lib.callback("illenium-appearance:server:hasMoney", false, function(hasMoney, money)
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
                    TriggerServerEvent("illenium-appearance:server:chargeCustomer", shopType)
                end
                TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
            else
                lib.notify({
                    title = "Cancelled Customization",
                    description = "Customization not saved",
                    type = "inform",
                    position = Config.NotifyOptions.position
                })
            end
            Framework.CachePed()
        end, config)
    end, shopType)
end

local function OpenClothingShop(isPedMenu)
    local config = GetDefaultConfig()
    config.components = true
    config.props = true

    if isPedMenu then
        config.ped = true
        config.headBlend = true
        config.faceFeatures = true
        config.headOverlays = true
        config.tattoos = not Config.RCoreTattoosCompatibility and true
    end
    OpenShop(config, isPedMenu, "clothing")
end

local function OpenBarberShop()
    local config = GetDefaultConfig()
    config.headOverlays = true
    OpenShop(config, false, "barber")
end

local function OpenTattooShop()
    local config = GetDefaultConfig()
    config.tattoos = true
    OpenShop(config, false, "tattoo")
end

local function OpenSurgeonShop()
    local config = GetDefaultConfig()
    config.headBlend = true
    config.faceFeatures = true
    OpenShop(config, false, "surgeon")
end

RegisterNetEvent("illenium-appearance:client:openClothingShop", OpenClothingShop)

RegisterNetEvent("illenium-appearance:client:importOutfitCode", function()
    local response = lib.inputDialog("Enter outfit code", {
        {
            type = "input",
            label = "Name the Outfit",
            placeholder = "A nice outfit",
            default = "Imported Outfit"
        },
        {
            type = "input",
            label = "Outfit Code",
            placeholder = "XXXXXXXXXXXX"
        }
    })

    if not response then
        return
    end

    local outfitName = response[1]
    local outfitCode = response[2]
    if outfitCode ~= nil then
        Wait(500)
        lib.callback("illenium-appearance:server:importOutfitCode", false, function(success)
            if success then
                lib.notify({
                    title = "Outfit Imported",
                    description = "You can now change to the outfit using the outfit menu",
                    type = "success",
                    position = Config.NotifyOptions.position
                })
            else
                lib.notify({
                    title = "Import Failure",
                    description = "Invalid outfit code",
                    type = "error",
                    position = Config.NotifyOptions.position
                })
            end
        end, outfitName, outfitCode)
    end
end)

RegisterNetEvent("illenium-appearance:client:generateOutfitCode", function(id)
    lib.callback("illenium-appearance:server:generateOutfitCode", false, function(code)
        if not code then
            lib.notify({
                title = "Something went wrong",
                description = "Code generation failed for the outfit",
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end
        lib.setClipboard(code)
        lib.inputDialog("Outfit Code Generated", {
            {
                type = "input",
                label = "Here is your outfit code",
                default = code,
                disabled = true
            }
        })
    end, id)
end)

RegisterNetEvent("illenium-appearance:client:saveOutfit", function()
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
        lib.callback("illenium-appearance:server:getOutfits", false, function(outfits)
            local outfitExists = false
            for i = 1, #outfits, 1 do
                if outfits[i].name:lower() == outfitName:lower() then
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

            TriggerServerEvent("illenium-appearance:server:saveOutfit", outfitName, pedModel, pedComponents, pedProps)
        end)
    end
end)

RegisterNetEvent('illenium-appearance:client:updateOutfit', function(outfitID)
    if not outfitID then return end
    
    lib.callback("illenium-appearance:server:getOutfits", false, function(outfits)
        local outfitExists = false
        for i = 1, #outfits, 1 do
            if outfits[i].id == outfitID then
                outfitExists = true
                break
            end
        end

        if not outfitExists then
            lib.notify({
                title = "Update Failed",
                description = "That outfit does not exist",
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end

        local playerPed = PlayerPedId()
        local pedModel = client.getPedModel(playerPed)
        local pedComponents = client.getPedComponents(playerPed)
        local pedProps = client.getPedProps(playerPed)

        TriggerServerEvent("illenium-appearance:server:updateOutfit", outfitID, pedModel, pedComponents, pedProps)
    end)
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
            event = "illenium-appearance:client:changeOutfit",
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

    table.sort(changeOutfitMenu.options, function(a, b)
        return a.title < b.title
    end)
    
    lib.registerContext(changeOutfitMenu)
end

local function RegisterUpdateOutfitMenu(id, parent, outfits)
    local updateOutfitMenu = {
        id = id,
        title = "Change Outfit",
        menu = parent,
        options = {}
    }
    for i = 1, #outfits, 1 do
        updateOutfitMenu.options[#updateOutfitMenu.options + 1] = {
            title = outfits[i].name,
            description = outfits[i].model,
            event = "illenium-appearance:client:updateOutfit",
            args = outfits[i].id
        }
    end

    table.sort(updateOutfitMenu.options, function(a, b)
        return a.title < b.title
    end)
    
    lib.registerContext(updateOutfitMenu)
end

local function RegisterGenerateOutfitCodeMenu(id, parent, outfits)
    local generateOutfitCodeMenu = {
        id = id,
        title = "Generate Outfit Code",
        menu = parent,
        options = {}
    }
    for i = 1, #outfits, 1 do
        generateOutfitCodeMenu.options[#generateOutfitCodeMenu.options + 1] = {
            title = outfits[i].name,
            description = outfits[i].model,
            event = "illenium-appearance:client:generateOutfitCode",
            args = outfits[i].id
        }
    end

    lib.registerContext(generateOutfitCodeMenu)
end

local function RegisterDeleteOutfitMenu(id, parent, outfits, deleteEvent)
    local deleteOutfitMenu = {
        id = id,
        title = "Delete Outfit",
        menu = parent,
        options = {}
    }

    table.sort(outfits, function(a, b)
        return a.name < b.name
    end)

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

RegisterNetEvent("illenium-appearance:client:OutfitManagementMenu", function(args)
    local bossMenuEvent = "qb-bossmenu:client:OpenMenu"
    if args.type == "Gang" then
        bossMenuEvent = "qb-gangmenu:client:OpenMenu"
    end

    local outfits = lib.callback.await("illenium-appearance:server:getManagementOutfits", false, args.type, Framework.GetGender())
    local managementMenuID = "illenium_appearance_outfit_management_menu"
    local changeManagementOutfitMenuID = "illenium_appearance_change_management_outfit_menu"
    local deleteManagementOutfitMenuID = "illenium_appearance_delete_management_outfit_menu"

    RegisterChangeOutfitMenu(changeManagementOutfitMenuID, managementMenuID, outfits, args.type)
    RegisterDeleteOutfitMenu(deleteManagementOutfitMenuID, managementMenuID, outfits, "illenium-appearance:client:DeleteManagementOutfit")
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
                event = "illenium-appearance:client:SaveManagementOutfit",
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

RegisterNetEvent("illenium-appearance:client:SaveManagementOutfit", function(mType)
    local playerPed = PlayerPedId()
    local outfitData = {
        Type = mType,
        Model = client.getPedModel(playerPed),
        Components = client.getPedComponents(playerPed),
        Props = client.getPedProps(playerPed)
    }

    local rankValues

    if mType == "Job" then
        outfitData.JobName = client.job.name
        rankValues = Framework.GetRankInputValues("job")

    else
        outfitData.JobName = client.gang.name
        rankValues = Framework.GetRankInputValues("gang")
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

    TriggerServerEvent("illenium-appearance:server:saveManagementOutfit", outfitData)

end)

local function RegisterWorkOutfitsListMenu(id, parent, menuData)
    local menu = {
        id = id,
        menu = parent,
        title = "Work Outfits",
        options = {}
    }
    local event = "illenium-appearance:client:loadJobOutfit"
    if Config.BossManagedOutfits then
        event = "illenium-appearance:client:changeOutfit"
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

    local outfits = lib.callback.await("illenium-appearance:server:getOutfits", false)
    local changeOutfitMenuID = "illenium_appearance_change_outfit_menu"
    local updateOutfitMenuID = "illenium_appearance_update_outfit_menu"
    local deleteOutfitMenuID = "illenium_appearance_delete_outfit_menu"
    local generateOutfitCodeMenuID = "illenium_appearance_generate_outfit_code_menu"

    RegisterChangeOutfitMenu(changeOutfitMenuID, mainMenuID, outfits)
    RegisterUpdateOutfitMenu(updateOutfitMenuID, mainMenuID, outfits)
    RegisterDeleteOutfitMenu(deleteOutfitMenuID, mainMenuID, outfits, "illenium-appearance:client:deleteOutfit")
    RegisterGenerateOutfitCodeMenu(generateOutfitCodeMenuID, mainMenuID, outfits)
    local outfitMenuItems = {
        {
            title = "Change Outfit",
            description = "Pick from any of your currently saved outfits",
            menu = changeOutfitMenuID
        },
        {
            title = "Update Outfit",
            description = "Save your current clothing to an existing outfit",
            menu = updateOutfitMenuID
        },
        {
            title = "Save New Outfit",
            description = "Save a new outfit you can use later on",
            event = "illenium-appearance:client:saveOutfit"
        },
        {
            title = "Generate Outfit Code",
            description = "Generate an outfit code for sharing",
            menu = generateOutfitCodeMenuID
        },
        {
            title = "Delete Outfit",
            description = "Delete any of your saved outfits",
            menu = deleteOutfitMenuID
        },
        {
            title = "Import Outfit",
            description = "Import an outfit from a sharing code",
            event = "illenium-appearance:client:importOutfitCode"
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
            event = "illenium-appearance:client:openClothingShop",
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
            event = "illenium-appearance:client:reloadSkin"
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

RegisterNetEvent("illenium-appearance:client:openClothingShopMenu", function(isPedMenu)
    if type(isPedMenu) == "table" then
        isPedMenu = false
    end
    OpenMenu(isPedMenu, "default")
end)

RegisterNetEvent("illenium-appearance:client:OpenBarberShop", function()
    OpenBarberShop()
end)

RegisterNetEvent("illenium-appearance:client:OpenTattooShop", function()
    OpenTattooShop()
end)

RegisterNetEvent("illenium-appearance:client:OpenSurgeonShop", function()
    OpenSurgeonShop()
end)

RegisterNetEvent("illenium-appearance:client:changeOutfit", function(data)
    local playerPed = PlayerPedId()
    local pedModel = client.getPedModel(playerPed)
    local appearanceDB
    if pedModel ~= data.model then
        local p = promise.new()
        lib.callback("illenium-appearance:server:getAppearance", false, function(appearance)
            BackupPlayerStats()
            if appearance then
                client.setPlayerAppearance(appearance)
                RestorePlayerStats()
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
        client.setPedHair(playerPed, appearanceDB.hair, appearanceDB.tattoos)

        if data.disableSave then
            TriggerServerEvent("illenium-appearance:server:syncUniform", {
                type = data.type,
                name = data.name
            }) -- Is a uniform
        else
            local appearance = client.getPedAppearance(playerPed)
            TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
        end
        Framework.CachePed()
    end
end)

RegisterNetEvent("illenium-appearance:client:DeleteManagementOutfit", function(id)
    TriggerServerEvent("illenium-appearance:server:deleteManagementOutfit", id)
    lib.notify({
        title = "Success",
        description = "Outfit Deleted",
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

RegisterNetEvent("illenium-appearance:client:deleteOutfit", function(id)
    TriggerServerEvent("illenium-appearance:server:deleteOutfit", id)
    lib.notify({
        title = "Success",
        description = "Outfit Deleted",
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

RegisterNetEvent("illenium-appearance:client:openJobOutfitsMenu", function(outfitsToShow)
    OpenMenu(nil, "job-outfit", outfitsToShow)
end)

local function InCooldown()
    return (GetGameTimer() - reloadSkinTimer) < Config.ReloadSkinCooldown
end

RegisterNetEvent("illenium-appearance:client:reloadSkin", function()
    local playerPed = PlayerPedId()

    if InCooldown() or Framework.CheckPlayerMeta() or IsPedInAnyVehicle(playerPed, true) or IsPedFalling(playerPed) then
        lib.notify({
            title = "Error",
            description = "You cannot use reloadskin right now",
            type = "error",
            position = Config.NotifyOptions.position
        })
        return
    end

    reloadSkinTimer = GetGameTimer()
    BackupPlayerStats()

    lib.callback("illenium-appearance:server:getAppearance", false, function(appearance)
        if not appearance then
            return
        end
        client.setPlayerAppearance(appearance)
        if Config.PersistUniforms then
            TriggerServerEvent("illenium-appearance:server:syncUniform", nil)
        end
        RestorePlayerStats()
    end)
end)

RegisterNetEvent("illenium-appearance:client:ClearStuckProps", function()
    if InCooldown() or Framework.CheckPlayerMeta() then
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
    if not currentZone then
        RemoveRadialMenuOption()
        return
    end
    local event, title
    if currentZone.name == "clothingRoom" then
        event = "illenium-appearance:client:OpenClothingRoom"
        title = "Clothing Room"
    elseif currentZone.name == "playerOutfitRoom" then
        event = "illenium-appearance:client:OpenPlayerOutfitRoom"
        title = "Player Outfits"
    elseif currentZone.name == "clothing" then
        event = "illenium-appearance:client:openClothingShopMenu"
        title = "Clothing Shop"
    elseif currentZone.name == "barber" then
        event = "illenium-appearance:client:OpenBarberShop"
        title = "Barber Shop"
    elseif currentZone.name == "tattoo" then
        event = "illenium-appearance:client:OpenTattooShop"
        title = "Tattoo Shop"
    elseif currentZone.name == "surgeon" then
        event = "illenium-appearance:client:OpenSurgeonShop"
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
        if Framework.IsPlayerAllowed(outfitRoom.citizenIDs[i]) then
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
    local gender = Framework.GetGender()
    local gradeLevel = clothingRoom.job and Framework.GetJobGrade() or Framework.GetGangGrade()
    local jobName = clothingRoom.job and client.job.name or client.gang.name

    if Config.BossManagedOutfits then
        local mType = clothingRoom.job and "Job" or "Gang"
        local result = lib.callback.await("illenium-appearance:server:getManagementOutfits", false, mType, gender)
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

RegisterNetEvent("illenium-appearance:client:OpenClothingRoom", function()
    local clothingRoom = Config.ClothingRooms[currentZone.index]
    local outfits = getPlayerJobOutfits(clothingRoom)
    TriggerEvent("illenium-appearance:client:openJobOutfitsMenu", outfits)
end)

RegisterNetEvent("illenium-appearance:client:OpenPlayerOutfitRoom", function()
    local outfitRoom = Config.PlayerOutfitRooms[currentZone.index]
    OpenOutfitRoom(outfitRoom)
end)

local function CheckDuty()
    return not Config.OnDutyOnlyClothingRooms or (Config.OnDutyOnlyClothingRooms and client.job.onduty)
end

local function lookupZoneIndexFromID(zones, id)
    for i = 1, #zones do
        if zones[i].id == id then
            return i
        end
    end
end

local function onStoreEnter(data)
    local index = lookupZoneIndexFromID(Zones.Store, data.id)
    local store = Config.Stores[index]

    local jobName = (store.job and client.job.name) or (store.gang and client.gang.name)
    if jobName == (store.job or store.gang) then
        currentZone = {
            name = store.type,
            index = index
        }
        local prefix = Config.UseRadialMenu and "" or "[E] "
        if currentZone.name == "clothing" then
            lib.showTextUI(prefix .. "Clothing Store - Price: $" .. Config.ClothingCost, Config.TextUIOptions)
        elseif currentZone.name == "barber" then
            lib.showTextUI(prefix .. "Barber - Price: $" .. Config.BarberCost, Config.TextUIOptions)
        elseif currentZone.name == "tattoo" then
            lib.showTextUI(prefix .. "Tattoo Shop - Price: $" .. Config.TattooCost, Config.TextUIOptions)
        elseif currentZone.name == "surgeon" then
            lib.showTextUI(prefix .. "Plastic Surgeon - Price: $" .. Config.SurgeonCost, Config.TextUIOptions)
        end
    end
end

local function onClothingRoomEnter(data)
    local index = lookupZoneIndexFromID(Zones.ClothingRoom, data.id)
    local clothingRoom = Config.ClothingRooms[index]

    local jobName = clothingRoom.job and client.job.name or client.gang.name
    if jobName == (clothingRoom.job or clothingRoom.gang) then
        if CheckDuty() or clothingRoom.gang then
            currentZone = {
                name = "clothingRoom",
                index = index
            }
            local prefix = Config.UseRadialMenu and "" or "[E] "
            lib.showTextUI(prefix .. "Clothing Room", Config.TextUIOptions)
        end
    end
end

local function onPlayerOutfitRoomEnter(data)
    local index = lookupZoneIndexFromID(Zones.PlayerOutfitRoom, data.id)
    local playerOutfitRoom = Config.PlayerOutfitRooms[index]

    local isAllowed = isPlayerAllowedForOutfitRoom(playerOutfitRoom)
    if isAllowed then
        currentZone = {
            name = "playerOutfitRoom",
            index = index
        }
        local prefix = Config.UseRadialMenu and "" or "[E] "
        lib.showTextUI(prefix .. "Outfits", Config.TextUIOptions)
    end
end

local function onZoneExit()
    currentZone = nil
    lib.hideTextUI()
end

local function SetupZone(store, onEnter, onExit)
    if Config.RCoreTattoosCompatibility and store.type == "tattoo" then
        return
    end

    if Config.UseRadialMenu or store.usePoly then
        return lib.zones.poly({
            points = store.points,
            debug = Config.Debug,
            onEnter = onEnter,
            onExit = onExit
        })
    end

    return lib.zones.box({
        coords = store.coords,
        size = store.size,
        rotation = store.rotation,
        debug = Config.Debug,
        onEnter = onEnter,
        onExit = onExit
    })
end

local function SetupStoreZones()
    for _, v in pairs(Config.Stores) do
        Zones.Store[#Zones.Store + 1] = SetupZone(v, onStoreEnter, onZoneExit)
    end
end

local function SetupClothingRoomZones()
    for _, v in pairs(Config.ClothingRooms) do
        Zones.ClothingRoom[#Zones.ClothingRoom + 1] = SetupZone(v, onClothingRoomEnter, onZoneExit)
    end
end

local function SetupPlayerOutfitRoomZones()
    for _, v in pairs(Config.PlayerOutfitRooms) do
        Zones.PlayerOutfitRoom[#Zones.PlayerOutfitRoom + 1] = SetupZone(v, onPlayerOutfitRoomEnter, onZoneExit)
    end
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

local function SetupStoreTarget(targetConfig, action, k, v)
    local parameters = {
        options = {{
            type = "client",
            action = action,
            icon = targetConfig.icon,
            label = targetConfig.label
        }},
        distance = targetConfig.distance,
        rotation = v.rotation
    }

    if Config.EnablePedsForShops then
        TargetPeds.Store[k] = CreatePedAtCoords(v.targetModel or targetConfig.model, v.coords, v.targetScenario or targetConfig.scenario)
        Target.AddTargetEntity(TargetPeds.Store[k], parameters)
    else
        Target.AddBoxZone(v.type .. k, v.coords, v.size, parameters)
    end
end

local function SetupStoreTargets()
    for k, v in pairs(Config.Stores) do
        local targetConfig = Config.TargetConfig[v.type]
        local action

        if v.type == "barber" then
            action = OpenBarberShop
        elseif v.type == "clothing" then
            action = function()
                TriggerEvent("illenium-appearance:client:openClothingShopMenu")
            end
        elseif v.type == "tattoo" then
            action = OpenTattooShop
        elseif v.type == "surgeon" then
            action = OpenSurgeonShop
        end

        if not (Config.RCoreTattoosCompatibility and v.type == "tattoo") then
            SetupStoreTarget(targetConfig, action, k, v)
        end
    end
end

local function SetupClothingRoomTargets()
    for k, v in pairs(Config.ClothingRooms) do
        local targetConfig = Config.TargetConfig["clothingroom"]
        local action = function()
            local outfits = getPlayerJobOutfits(v)
            TriggerEvent("illenium-appearance:client:openJobOutfitsMenu", outfits)
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
            distance = targetConfig.distance,
            rotation = v.rotation
        }

        if Config.EnablePedsForClothingRooms then
            TargetPeds.ClothingRoom[k] = CreatePedAtCoords(v.targetModel or targetConfig.model, v.coords, v.targetScenario or targetConfig.scenario)
            Target.AddTargetEntity(TargetPeds.ClothingRoom[k], parameters)
        else
            local key = "clothing_" .. (v.job or v.gang) .. k
            Target.AddBoxZone(key, v.coords, v.size, parameters)
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
            distance = targetConfig.distance,
            rotation = v.rotation
        }

        if Config.EnablePedsForPlayerOutfitRooms then
            TargetPeds.PlayerOutfitRoom[k] = CreatePedAtCoords(v.targetModel or targetConfig.model, v.coords, v.targetScenario or targetConfig.scenario)
            Target.AddTargetEntity(TargetPeds.ClothingRoom[k], parameters)
        else
            Target.AddBoxZone("playeroutfitroom_" .. k, v.coords, v.size, parameters)
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
        if currentZone then
            sleep = 5
            if IsControlJustReleased(0, 38) then
                if currentZone.name == "clothingRoom" then
                    local clothingRoom = Config.ClothingRooms[currentZone.index]
                    local outfits = getPlayerJobOutfits(clothingRoom)
                    TriggerEvent("illenium-appearance:client:openJobOutfitsMenu", outfits)
                elseif currentZone.name == "playerOutfitRoom" then
                    local outfitRoom = Config.PlayerOutfitRooms[currentZone.index]
                    OpenOutfitRoom(outfitRoom)
                elseif currentZone.name == "clothing" then
                    TriggerEvent("illenium-appearance:client:openClothingShopMenu")
                elseif currentZone.name == "barber" then
                    OpenBarberShop()
                elseif currentZone.name == "tattoo" then
                    OpenTattooShop()
                elseif currentZone.name == "surgeon" then
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
