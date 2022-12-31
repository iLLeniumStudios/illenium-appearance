local QBCore = exports["qb-core"]:GetCoreObject()
local continue = false

local function MigrateFivemAppearance(source)
    local allPlayers = MySQL.Sync.fetchAll("SELECT * FROM players")
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
        MySQL.Async.insert("INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)", {
            playerSkins[i].citizenID,
            json.decode(playerSkins[i].skin).model,
            playerSkins[i].skin,
            1
        })
    end
    lib.notify(source, {
        title = "Success",
        description = "Migration finished. " .. tostring(#playerSkins) .. " skins migrated",
        type = "success",
        position = Config.NotifyOptions.position
    })
end

local function MigrateQBClothing(source)
    local allPlayerSkins = MySQL.Sync.fetchAll("SELECT * FROM playerskins")
    local migrated = 0
    for i=1, #allPlayerSkins, 1 do
        if not tonumber(allPlayerSkins[i].model) then
            lib.notify(source, {
                title = "Information",
                description = "Skipped skin",
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
        title = "Success",
        description = "Migration finished. " .. migrated .. " skins migrated",
        type = "success",
        position = Config.NotifyOptions.position
    })
end

RegisterNetEvent("illenium-appearance:server:migrate-qb-clothing-skin", function(citizenid, appearance)
    local src = source
    MySQL.Async.execute("DELETE FROM playerskins WHERE citizenid = ?", { citizenid }, function()
        MySQL.Async.insert("INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)", {
            citizenid,
            appearance.model,
            json.encode(appearance),
            1
        })
        continue = true
        lib.notify(src, {
            id = "illenium_appearance_skin_migrated",
            title = "Success",
            description = "Migrated skin",
            type = "success",
            position = Config.NotifyOptions.position
        })
    end)
end)

QBCore.Commands.Add("migrateskins", "Migrate skins to illenium-appearance", {{name="type", help="fivem-appearance / qb-clothing"}}, false, function(source, args)
    local type = tostring(args[1])
    if type == "fivem-appearance" then
        MigrateFivemAppearance(source)
    elseif type == "qb-clothing" then
        CreateThread(function()
            MigrateQBClothing(source)
        end)
    else
        lib.notify(source, {
            title = "Error",
            description = "Invalid type",
            type = "error",
            position = Config.NotifyOptions.position
        })
    end
end, "god")
