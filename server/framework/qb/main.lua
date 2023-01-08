if not Framework.QBCore() then return end

local QBCore = exports["qb-core"]:GetCoreObject()

function Framework.GetPlayerID(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        return Player.PlayerData.citizenid
    end
end

function Framework.HasMoney(src, type, money)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.PlayerData.money[type] >= money
end

function Framework.RemoveMoney(src, type, money)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.Functions.RemoveMoney(type, money)
end

function Framework.GetJob(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.PlayerData.job
end

function Framework.GetGang(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.PlayerData.gang
end

function Framework.SaveAppearance(appearance, citizenID)
    MySQL.update.await("UPDATE playerskins SET active = 0 WHERE citizenid = ?", {citizenID}) -- Make all the skins inactive
    MySQL.Async.execute("DELETE FROM playerskins WHERE citizenid = ? AND model = ?",
        {citizenID, appearance.model}, function()
            MySQL.Async.insert("INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)",
                {citizenID, appearance.model, json.encode(appearance), 1})
        end)
end

function Framework.GetAppearance(citizenID, model)
    local query = "SELECT skin FROM playerskins WHERE citizenid = ?"
    local queryArgs = {citizenID}
    if model ~= nil then
        query = query .. " AND model = ?"
        queryArgs[#queryArgs + 1] = model
    else
        query = query .. " AND active = ?"
        queryArgs[#queryArgs + 1] = 1
    end
    local result = MySQL.Sync.fetchAll(query, queryArgs)
    if result[1] ~= nil then
        return json.decode(result[1].skin)
    end
end
