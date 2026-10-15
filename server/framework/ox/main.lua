if not Framework.Ox() then return end

local Ox = require '@ox_core.lib.init'

function Framework.GetPlayerID(playerId)
    local player = Ox.GetPlayer(playerId)
    return player and player.charId
end

function Framework.HasMoney(playerId, item, amount)
    return exports.ox_inventory:GetItemCount(playerId, item) >= amount
end

function Framework.RemoveMoney(playerId, type, amount)
    return exports.ox_inventory:RemoveItem(playerId, type, amount)
end

local function getPlayerGroup(playerId, type)
    local player = Ox.GetPlayer(playerId)
    if not player then return nil end

    local name, grade = player.getGroupByType(type)
    if not name then return nil end

    return {
        name = name,
        grade = {
            level = grade or 0
        }
    }
end

function Framework.GetJob(playerId)
    return getPlayerGroup(playerId, 'job')
end

function Framework.GetGang(playerId)
    return getPlayerGroup(playerId, 'gang')
end

function Framework.SaveAppearance(appearance, charId)
    Database.PlayerSkins.UpdateActiveField(charId, 0)
    Database.PlayerSkins.DeleteByModel(charId, appearance.model)
    Database.PlayerSkins.Add(charId, appearance.model, json.encode(appearance), 1)
end

function Framework.GetAppearance(charId, model)
    local result = Database.PlayerSkins.GetByCitizenID(charId, model)
    if result then
        return json.decode(result)
    end
end
