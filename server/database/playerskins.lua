Database.PlayerSkins = {}

function Database.PlayerSkins.UpdateActiveField(citizenID, active)
    MySQL.update.await("UPDATE playerskins SET active = ? WHERE citizenid = ?", {active, citizenID}) -- Make all the skins inactive / active
end

function Database.PlayerSkins.DeleteByModel(citizenID, model)
    MySQL.query.await("DELETE FROM playerskins WHERE citizenid = ? AND model = ?", {citizenID, model})
end

function Database.PlayerSkins.Add(citizenID, model, appearance, active)
    MySQL.insert.await("INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)", {citizenID, model, appearance, active})
end

function Database.PlayerSkins.GetByCitizenID(citizenID, model)
    local query = "SELECT skin FROM playerskins WHERE citizenid = ?"
    local queryArgs = {citizenID}
    if model ~= nil then
        query = query .. " AND model = ?"
        queryArgs[#queryArgs + 1] = model
    else
        query = query .. " AND active = ?"
        queryArgs[#queryArgs + 1] = 1
    end
    return MySQL.scalar.await(query, queryArgs)
end

function Database.PlayerSkins.DeleteByCitizenID(citizenID)
    MySQL.query.await("DELETE FROM playerskins WHERE citizenid = ?", { citizenID })
end

function Database.PlayerSkins.GetAll()
    return MySQL.query.await("SELECT * FROM playerskins")
end
