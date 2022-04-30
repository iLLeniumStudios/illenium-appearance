local QBCore = exports['qb-core']:GetCoreObject()

-- Callback(s)

QBCore.Functions.CreateCallback('fivem-appearance:server:getAppearance', function(source, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	local result = MySQL.Sync.fetchAll('SELECT skin FROM playerskins WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, 1})
    if result[1] ~= nil then
        cb(json.decode(result[1].skin))
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('QBCore:HasPermission', function(source, cb, perm)
    cb(QBCore.Functions.HasPermission(source, perm))
end)

QBCore.Functions.CreateCallback('fivem-appearance:server:hasMoney', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.money.cash >= Config.Money then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('fivem-appearance:server:getOutfits', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local myOutfits = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', { Player.PlayerData.citizenid })
    for i=1, #result, 1 do
		myOutfits[#myOutfits+1] = {id = result[i].id, outfitname = result[i].outfitname, model = result[i].model, skin = json.decode(result[i].skin), outfitId = result[i].outfitId}
	end
    cb(myOutfits)
end)

RegisterServerEvent("fivem-appearance:server:saveAppearance", function(appearance)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if appearance ~= nil then
        MySQL.Async.execute('DELETE FROM playerskins WHERE citizenid = ?', { Player.PlayerData.citizenid }, function()
            MySQL.Async.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
                Player.PlayerData.citizenid,
                appearance.model,
                json.encode(appearance),
                1
            })
        end)
    end
end)

RegisterServerEvent("fivem-appearance:server:chargeCustomer", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Config.Money) then
        TriggerClientEvent("QBCore:Notify", src, "Gave $" .. Config.Money .. " for character customization!", "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "You didn't have enough money! Tried to exploit the system!", "error")
    end
end)

RegisterNetEvent('fivem-appearance:server:saveOutfit', function(name, appearance)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    if appearance ~= nil then
        local outfitId = "outfit-" .. math.random(1, 10) .. "-" .. math.random(1111, 9999)
        MySQL.Async.insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            name,
            appearance.model,
            json.encode(appearance),
            outfitId,    
        }, function()
            TriggerClientEvent('QBCore:Notify', src, 'Outfit ' .. name .. ' has been saved', 'success')
        end)
    end
end)

RegisterNetEvent('fivem-appearance:server:deleteOutfit', function(id)
    MySQL.query('DELETE FROM player_outfits WHERE id = ?', {id})
end)

if Config.EnablePedMenu then
    QBCore.Commands.Add('pedmenu', 'Open Ped Menu', {}, false, function(source, args)
        TriggerClientEvent("fivem-appearance:client:openClothingShopMenu", source, true)
    end, Config.PedMenuGroup)
end

QBCore.Commands.Add('reloadskin', 'Reloads your character', {}, false, function(source, args)
    TriggerClientEvent("fivem-appearance:client:reloadSkin", source)
end)
