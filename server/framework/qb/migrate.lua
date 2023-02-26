if not Framework.QBCore() then return end

local continue = false

local function MigrateFivemAppearance(source)
    local allPlayers = Database.Players.GetAll()
    local playerSkins = {}
    for i=1, #allPlayers, 1 do
        if allPlayers[i].skin then
            playerSkins[#playerSkins+1] = {
                citizenID = allPlayers[i].citizenid,
                skin = allPlayers[i].skin
            }
        end
    end

    for i=1, #playerSkins, 1 do
        Database.PlayerSkins.Add(playerSkins[i].citizenID, json.decode(playerSkins[i].skin).model, playerSkins[i].skin, 1)
    end
    lib.notify(source, {
        title = _L("migrate.success.title"),
        description = string.format(_L("migrate.success.description"), tostring(#playerSkins)),
        type = "success",
        position = Config.NotifyOptions.position
    })
end

local function MigrateQBClothing(source)
    local allPlayerSkins = Database.PlayerSkins.GetAll()
    local migrated = 0
    for i=1, #allPlayerSkins, 1 do
        if not tonumber(allPlayerSkins[i].model) then
            lib.notify(source, {
                title = _L("migrate.skip.title"),
                description = _L("migrate.skip.description"),
                type = "inform",
                position = Config.NotifyOptions.position
            })
        else
            TriggerClientEvent("illenium-appearance:client:migration:load-qb-clothing-skin", source, allPlayerSkins[i])
            while not continue do
                Wait(10)
            end
            continue = false
            migrated = migrated + 1
        end
    end
    TriggerClientEvent("illenium-appearance:client:reloadSkin", source)

    lib.notify(source, {
        title = _L("migrate.success.title"),
        description = string.format(_L("migrate.success.description"), tostring(migrated)),
        type = "success",
        position = Config.NotifyOptions.position
    })
end

RegisterNetEvent("illenium-appearance:server:migrate-qb-clothing-skin", function(citizenid, appearance)
    local src = source
    Database.PlayerSkins.DeleteByCitizenID(citizenid)
    Database.PlayerSkins.Add(citizenid, appearance.model, json.encode(appearance), 1)
    continue = true
    lib.notify(src, {
        id = "illenium_appearance_skin_migrated",
        title = _L("migrate.success.title"),
        description = _L("migrate.success.descriptionSingle"),
        type = "success",
        position = Config.NotifyOptions.position
    })
end)

lib.addCommand("migrateskins", {
    help = "Migrate skins",
    params = {
        {
            name = "resourceName",
            type = "string",
        },
    },
    restricted = "group.god"
}, function(source, args)
    local resourceName = args.resourceName
    if resourceName == "fivem-appearance" then
        MigrateFivemAppearance(source)
    elseif resourceName == "qb-clothing" then
        CreateThread(function()
            MigrateQBClothing(source)
        end)
    else
        lib.notify(source, {
            title = _L("migrate.typeError.title"),
            description = _L("migrate.typeError.description"),
            type = "error",
            position = Config.NotifyOptions.position
        })
    end
end)
