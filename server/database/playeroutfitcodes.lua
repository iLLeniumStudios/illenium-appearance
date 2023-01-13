Database.PlayerOutfitCodes = {}

function Database.PlayerOutfitCodes.GetByCode(code)
    return MySQL.single.await("SELECT * FROM player_outfit_codes WHERE code = ?", {code})
end

function Database.PlayerOutfitCodes.GetByOutfitID(outfitID)
    return MySQL.single.await("SELECT * FROM player_outfit_codes WHERE outfitID = ?", {outfitID})
end

function Database.PlayerOutfitCodes.Add(outfitID, code)
    return MySQL.insert.await("INSERT INTO player_outfit_codes (outfitid, code) VALUES (?, ?)", {outfitID, code})
end

function Database.PlayerOutfitCodes.DeleteByOutfitID(id)
    MySQL.query.await("DELETE FROM player_outfit_codes WHERE outfitid = ?", {id})
end
