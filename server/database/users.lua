Database.Users = {}

function Database.Users.UpdateSkinForUser(citizenID, skin)
    return MySQL.update.await("UPDATE users SET skin = ? WHERE identifier = ?", {skin, citizenID})
end

function Database.Users.GetSkinByCitizenID(citizenID)
    return MySQL.single.await("SELECT skin FROM users WHERE identifier = ?", {citizenID})
end

function Database.Users.GetAll()
    return MySQL.query.await("SELECT * FROM users")
end
