Database.PlayerOutfits = {}

function Database.PlayerOutfits.GetAllByCitizenID(citizenid)
    return MySQL.query.await("SELECT * FROM player_outfits WHERE citizenid = ?", {citizenid})
end

function Database.PlayerOutfits.GetByID(id)
    return MySQL.single.await("SELECT * FROM player_outfits WHERE id = ?", {id})
end

function Database.PlayerOutfits.Add(citizenID, outfitName, model, components, props)
   return MySQL.insert.await("INSERT INTO player_outfits (citizenid, outfitname, model, components, props) VALUES (?, ?, ?, ?, ?)", {
        citizenID,
        outfitName,
        model,
        components,
        props
    })
end

function Database.PlayerOutfits.DeleteByID(id)
    MySQL.query.await("DELETE FROM player_outfits WHERE id = ?", {id})
end
