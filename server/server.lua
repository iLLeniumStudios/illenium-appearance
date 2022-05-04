local QBCore = exports['qb-core']:GetCoreObject()

local outfitCache = {}

local function getMoneyForShop(shopType)
    local money = 0
    if shopType == "clothing" then
        money = Config.ClothingCost
    elseif shopType == "barber" then
        money = Config.BarberCost
    elseif shopType == "tattoo" then
        money = Config.TattooCost
    elseif shopType == "surgeon" then
        money = Config.SurgeonCost
    end

    return money
end

local function getOutfitsForPlayer(citizenid)
    outfitCache[citizenid] = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', { citizenid })
    for i=1, #result, 1 do
        outfitCache[citizenid][#outfitCache[citizenid]+1] = {id = result[i].id, outfitname = result[i].outfitname, model = result[i].model, skin = json.decode(result[i].skin), outfitId = result[i].outfitId}
	end
end

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

QBCore.Functions.CreateCallback('fivem-appearance:server:hasMoney', function(source, cb, shopType)
    local Player = QBCore.Functions.GetPlayer(source)
    local money = getMoneyForShop(shopType)
    if Player.PlayerData.money.cash >= money then
        cb(true, money)
    else
        cb(false, money)
    end
end)

QBCore.Functions.CreateCallback('fivem-appearance:server:getOutfits', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if outfitCache[Player.PlayerData.citizenid] == nil then
        getOutfitsForPlayer(Player.PlayerData.citizenid)
    end
    cb(outfitCache[Player.PlayerData.citizenid])
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

RegisterServerEvent("fivem-appearance:server:chargeCustomer", function(shopType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local money = getMoneyForShop(shopType)
    if Player.Functions.RemoveMoney('cash', money) then
        TriggerClientEvent("QBCore:Notify", src, "Gave $" .. money .. " to " .. shopType .. "!", "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "You didn't have enough money! Tried to exploit the system!", "error")
    end
end)

RegisterNetEvent('fivem-appearance:server:saveOutfit', function(name, appearance)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    if outfitCache[Player.PlayerData.citizenid] == nil then
        getOutfitsForPlayer(Player.PlayerData.citizenid)
    end
    if appearance ~= nil then
        local outfitId = "outfit-" .. math.random(1, 10) .. "-" .. math.random(1111, 9999)
        MySQL.Async.insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.citizenid,
            name,
            appearance.model,
            json.encode(appearance),
            outfitId,
        }, function(id)
            outfitCache[Player.PlayerData.citizenid][#outfitCache[Player.PlayerData.citizenid]+1] = {id = id, outfitname = name, model = appearance.model, skin = appearance, outfitId = outfitId}
            TriggerClientEvent('QBCore:Notify', src, 'Outfit ' .. name .. ' has been saved', 'success')
        end)
    end
end)

RegisterNetEvent('fivem-appearance:server:deleteOutfit', function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_outfits WHERE id = ?', {id})
    
    for k, v in ipairs(outfitCache[Player.PlayerData.citizenid]) do
        if v.id == id then
            table.remove(outfitCache[Player.PlayerData.citizenid], k)
            break
        end
    end
end)

RegisterNetEvent("fivem-appearance:server:resetOutfitCache", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        outfitCache[Player.PlayerData.citizenid] = nil
    end
end)

if Config.EnablePedMenu then
    QBCore.Commands.Add('pedmenu', 'Open Ped Menu', {}, false, function(source, _)
        TriggerClientEvent("fivem-appearance:client:openClothingShopMenu", source, true)
    end, Config.PedMenuGroup)
end

QBCore.Commands.Add('reloadskin', 'Reloads your character', {}, false, function(source, _)
    TriggerClientEvent("fivem-appearance:client:reloadSkin", source)
end)
