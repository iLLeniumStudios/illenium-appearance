if not Framework.ESX() then return end

local ESX = exports["es_extended"]:getSharedObject()

function Framework.GetPlayerID(src)
    local Player = ESX.GetPlayerFromId(src)
    if Player then
        return Player.identifier
    end
end

function Framework.HasMoney(src, type, money)
    if type == "cash" then
        type = "money"
    end
    local Player = ESX.GetPlayerFromId(src)
    return Player.getAccount(type).money >= money
end

function Framework.RemoveMoney(src, type, money)
    if type == "cash" then
        type = "money"
    end
    local Player = ESX.GetPlayerFromId(src)
    if Player.getAccount(type).money >= money then
        Player.removeAccountMoney(type, money)
        return true
    end
    return false
end

function Framework.GetJob(src)
    local Player = ESX.GetPlayerFromId(src)
    return Player.getJob()
end

function Framework.GetGang(src)
    local Player = ESX.GetPlayerFromId(src)
    return Player.getJob()
end

function Framework.SaveAppearance(appearance, citizenID)
    MySQL.update("UPDATE users SET skin = ? WHERE identifier = ?", {json.encode(appearance), citizenID})
end

function Framework.GetAppearance(citizenID)
    local user = MySQL.Sync.fetchAll("SELECT skin FROM users WHERE identifier = ?", {citizenID})[1]
    if user then
        return json.decode(user.skin)
    end
    return nil
end
