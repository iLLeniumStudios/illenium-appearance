local client = client

local currentZone = nil

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
        if Zones.Store[i]["remove"] then
            Zones.Store[i]:remove()
        end
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
        Management.AddItems()
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
        if Config.UseRadialMenu then
            if Config.UseOxRadial and GetResourceState('ox_lib') == "started" then
                Radial.RemoveOption()
            elseif GetResourceState("qb-radialmenu") == "started" then
                Radial.RemoveOption()
            end
        end
        if Config.BossManagedOutfits then
            Management.RemoveItems()
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

function SetInitialClothes(initial)
    client.setPlayerModel(initial.Model)
    -- Fix for tattoo's appearing when creating a new character
    local ped = cache.ped
    client.setPedTattoos(ped, {})
    client.setPedComponents(ped, initial.Components)
    client.setPedProps(ped, initial.Props)
    client.setPedHair(ped, initial.Hair, {})
    ClearPedDecorations(ped)
end

function InitializeCharacter(gender, onSubmit, onCancel)
    SetInitialClothes(Config.InitialPlayerClothes[gender])
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
                    title = _L("cancelled.title"),
                    description = _L("cancelled.description"),
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
    local response = lib.inputDialog(_L("outfits.import.title"), {
        {
            type = "input",
            label = _L("outfits.import.name.label"),
            placeholder = _L("outfits.import.name.placeholder"),
            default = _L("outfits.import.name.default"),
            required = true
        },
        {
            type = "input",
            label = _L("outfits.import.code.label"),
            placeholder = "XXXXXXXXXXXX",
            required = true
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
                    title = _L("outfits.import.success.title"),
                    description = _L("outfits.import.success.description"),
                    type = "success",
                    position = Config.NotifyOptions.position
                })
            else
                lib.notify({
                    title = _L("outfits.import.failure.title"),
                    description = _L("outfits.import.failure.description"),
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
                title = _L("outfits.generate.failure.title"),
                description = _L("outfits.generate.failure.description"),
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end
        lib.setClipboard(code)
        lib.inputDialog(_L("outfits.generate.success.title"), {
            {
                type = "input",
                label = _L("outfits.generate.success.description"),
                default = code,
                disabled = true
            }
        })
    end, id)
end)

RegisterNetEvent("illenium-appearance:client:saveOutfit", function()
    local response = lib.inputDialog(_L("outfits.save.title"), {
        {
            type = "input",
            label = _L("outfits.save.name.label"),
            placeholder = _L("outfits.save.name.placeholder"),
            required = true
        }
    })

    if not response then
        return
    end

    local outfitName = response[1]
    if outfitName then
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
                    title = _L("outfits.save.failure.title"),
                    description = _L("outfits.save.failure.description"),
                    type = "error",
                    position = Config.NotifyOptions.position
                })
                return
            end

            local pedModel = client.getPedModel(cache.ped)
            local pedComponents = client.getPedComponents(cache.ped)
            local pedProps = client.getPedProps(cache.ped)

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
                title = _L("outfits.update.failure.title"),
                description = _L("outfits.update.failure.description"),
                type = "error",
                position = Config.NotifyOptions.position
            })
            return
        end

        local pedModel = client.getPedModel(cache.ped)
        local pedComponents = client.getPedComponents(cache.ped)
        local pedProps = client.getPedProps(cache.ped)

        TriggerServerEvent("illenium-appearance:server:updateOutfit", outfitID, pedModel, pedComponents, pedProps)
    end)
end)

local function RegisterChangeOutfitMenu(id, parent, outfits, mType)
    local changeOutfitMenu = {
        id = id,
        title = _L("outfits.change.title"),
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
        title = _L("outfits.update.title"),
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
        title = _L("outfits.generate.title"),
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
        title = _L("outfits.delete.title"),
        menu = parent,
        options = {}
    }

    table.sort(outfits, function(a, b)
        return a.name < b.name
    end)

    for i = 1, #outfits, 1 do
        deleteOutfitMenu.options[#deleteOutfitMenu.options + 1] = {
            title = string.format(_L("outfits.delete.item.title"), outfits[i].name),
            description = string.format(_L("outfits.delete.item.description"), outfits[i].model, (outfits[i].gender and (" - Gender: " .. outfits[i].gender) or "")),
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
        title = string.format(_L("outfits.manage.title"), args.type),
        options = {
            {
                title = _L("outfits.change.title"),
                description = string.format(_L("outfits.change.description"), args.type),
                menu = changeManagementOutfitMenuID,
            },
            {
                title = _L("outfits.save.menuTitle"),
                description = string.format(_L("outfits.save.menuDescription"), args.type),
                event = "illenium-appearance:client:SaveManagementOutfit",
                args = args.type
            },
            {
                title = _L("outfits.delete.title"),
                description = string.format(_L("outfits.delete.description"), args.type),
                menu = deleteManagementOutfitMenuID,
            },
            {
                title = _L("menu.returnTitle"),
                icon = "fa-solid fa-angle-left",
                event = bossMenuEvent
            }
        }
    }

    lib.registerContext(managementMenu)
    lib.showContext(managementMenuID)
end)

RegisterNetEvent("illenium-appearance:client:SaveManagementOutfit", function(mType)
    local outfitData = {
        Type = mType,
        Model = client.getPedModel(cache.ped),
        Components = client.getPedComponents(cache.ped),
        Props = client.getPedProps(cache.ped)
    }

    local rankValues

    if mType == "Job" then
        outfitData.JobName = client.job.name
        rankValues = Framework.GetRankInputValues("job")

    else
        outfitData.JobName = client.gang.name
        rankValues = Framework.GetRankInputValues("gang")
    end

    local dialogResponse = lib.inputDialog(_L("outfits.save.managementTitle"), {
            {
                label = _L("outfits.save.name.label"),
                type = "input",
                required = true
            },
            {
                label = _L("outfits.save.gender.label"),
                type = "select",
                options = {
                    {
                        label = _L("outfits.save.gender.male"), value = "male"
                    },
                    {
                        label = _L("outfits.save.gender.female"), value = "female"
                    }
                },
                default = "male",
            },
            {
                label = _L("outfits.save.rank.label"),
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
        title = _L("jobOutfits.title"),
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
            title = _L("outfits.change.title"),
            description = _L("outfits.change.pDescription"),
            menu = changeOutfitMenuID
        },
        {
            title = _L("outfits.update.title"),
            description = _L("outfits.update.description"),
            menu = updateOutfitMenuID
        },
        {
            title = _L("outfits.save.menuTitle"),
            description = _L("outfits.save.description"),
            event = "illenium-appearance:client:saveOutfit"
        },
        {
            title = _L("outfits.generate.title"),
            description = _L("outfits.generate.description"),
            menu = generateOutfitCodeMenuID
        },
        {
            title = _L("outfits.delete.title"),
            description = _L("outfits.delete.mDescription"),
            menu = deleteOutfitMenuID
        },
        {
            title = _L("outfits.import.menuTitle"),
            description = _L("outfits.import.description"),
            event = "illenium-appearance:client:importOutfitCode"
        }
    }
    if menuType == "default" then
        local header = string.format(_L("clothing.title"), Config.ClothingCost)
        if isPedMenu then
            header = _L("clothing.titleNoPrice")
        end
        mainMenu.title = _L("clothing.options.title")
        menuItems[#menuItems + 1] = {
            title = header,
            description = _L("clothing.options.description"),
            event = "illenium-appearance:client:openClothingShop",
            args = isPedMenu
        }
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "outfit" then
        mainMenu.title = _L("clothing.outfits.title")
        for i = 0, #outfitMenuItems, 1 do
            menuItems[#menuItems + 1] = outfitMenuItems[i]
        end
    elseif menuType == "job-outfit" then
        mainMenu.title = _L("clothing.outfits.title")
        menuItems[#menuItems + 1] = {
            title = _L("clothing.outfits.civilian.title"),
            description = _L("clothing.outfits.civilian.description"),
            event = "illenium-appearance:client:reloadSkin"
        }

        local workOutfitsMenuID = "illenium_appearance_work_outfits_menu"
        RegisterWorkOutfitsListMenu(workOutfitsMenuID, mainMenuID, menuData)

        menuItems[#menuItems + 1] = {
            title = _L("jobOutfits.title"),
            description = _L("jobOutfits.description"),
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
    local pedModel = client.getPedModel(cache.ped)
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
                    title = _L("outfits.change.failure.title"),
                    description = _L("outfits.change.failure.description"),
                    type = "error",
                    position = Config.NotifyOptions.position
                })
            end
            p:resolve(appearance)
        end, data.model)
        appearanceDB = Citizen.Await(p)
    else
        appearanceDB = client.getPedAppearance(cache.ped)
    end
    if appearanceDB then
        client.setPedComponents(cache.ped, data.components)
        client.setPedProps(cache.ped, data.props)
        client.setPedHair(cache.ped, appearanceDB.hair, appearanceDB.tattoos)

        if data.disableSave then
            TriggerServerEvent("illenium-appearance:server:syncUniform", {
                type = data.type,
                name = data.name
            }) -- Is a uniform
        else
            local appearance = client.getPedAppearance(cache.ped)
            TriggerServerEvent("illenium-appearance:server:saveAppearance", appearance)
        end
        Framework.CachePed()
    end
end)

RegisterNetEvent("illenium-appearance:client:DeleteManagementOutfit", function(id)
    TriggerServerEvent("illenium-appearance:server:deleteManagementOutfit", id)
    lib.notify({
        title = _L("outfits.delete.management.success.title"),
        description = _L("outfits.delete.management.success.description"),
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

RegisterNetEvent("illenium-appearance:client:deleteOutfit", function(id)
    TriggerServerEvent("illenium-appearance:server:deleteOutfit", id)
    lib.notify({
        title = _L("outfits.delete.success.title"),
        description = _L("outfits.delete.success.failure"),
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
    if InCooldown() or Framework.CheckPlayerMeta() or cache.vehicle or IsPedFalling(cache.ped) then
        lib.notify({
            title = _L("commands.reloadskin.failure.title"),
            description = _L("commands.reloadskin.failure.description"),
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
            title = _L("commands.clearstuckprops.failure.title"),
            description = _L("commands.clearstuckprops.failure.description"),
            type = "error",
            position = Config.NotifyOptions.position
        })
        return
    end

    reloadSkinTimer = GetGameTimer()

    for _, v in pairs(GetGamePool("CObject")) do
      if IsEntityAttachedToEntity(cache.ped, v) then
        SetEntityAsMissionEntity(v, true, true)
        DeleteObject(v)
        DeleteEntity(v)
      end
    end
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
        OpenMenu(nil, "outfit")
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
            lib.showTextUI(prefix .. string.format(_L("textUI.clothing"), Config.ClothingCost), Config.TextUIOptions)
        elseif currentZone.name == "barber" then
            lib.showTextUI(prefix .. string.format(_L("textUI.barber"), Config.BarberCost), Config.TextUIOptions)
        elseif currentZone.name == "tattoo" then
            lib.showTextUI(prefix .. string.format(_L("textUI.tattoo"), Config.TattooCost), Config.TextUIOptions)
        elseif currentZone.name == "surgeon" then
            lib.showTextUI(prefix .. string.format(_L("textUI.surgeon"), Config.SurgeonCost), Config.TextUIOptions)
        end
        Radial.AddOption(currentZone)
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
            lib.showTextUI(prefix .. _L("textUI.clothingRoom"), Config.TextUIOptions)
            Radial.AddOption(currentZone)
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
        lib.showTextUI(prefix .. _L("textUI.playerOutfitRoom"), Config.TextUIOptions)
        Radial.AddOption(currentZone)
    end
end

local function onZoneExit()
    currentZone = nil
    Radial.RemoveOption()
    lib.hideTextUI()
end

local function SetupZone(store, onEnter, onExit)
    if Config.RCoreTattoosCompatibility and store.type == "tattoo" then
        return {}
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
    elseif v.usePoly then
        Target.AddPolyZone(v.type .. k, v.points, parameters)
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

        local key = "clothing_" .. (v.job or v.gang) .. k
        if Config.EnablePedsForClothingRooms then
            TargetPeds.ClothingRoom[k] = CreatePedAtCoords(v.targetModel or targetConfig.model, v.coords, v.targetScenario or targetConfig.scenario)
            Target.AddTargetEntity(TargetPeds.ClothingRoom[k], parameters)
        elseif v.usePoly then
            Target.AddPolyZone(key, v.points, parameters)
        else
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
            Target.AddTargetEntity(TargetPeds.PlayerOutfitRoom[k], parameters)
        elseif v.usePoly then
            Target.AddPolyZone("playeroutfitroom_" .. k, v.points, parameters)
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
