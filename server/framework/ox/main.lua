if not Framework.Ox() then return end

local Ox = require '@ox_core.lib.init'

function Framework.GetPlayerID(playerId)
    return Ox.GetPlayer(playerId).charId
end

function Framework.HasMoney(playerId, item, amount)
    return exports.ox_inventory:GetItemCount(playerId, item) >= amount
end

function Framework.RemoveMoney(playerId, type, amount)
    return exports.ox_inventory:RemoveItem(playerId, type, amount)
end

function Framework.GetJob()
    return ---@todo
end

function Framework.GetGang()
    return ---@todo
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
