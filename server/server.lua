local QBCore = exports['qb-core']:GetCoreObject()

local outfitCache = {}
local uniformCache = {}

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
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?', {citizenid})
    for i = 1, #result, 1 do
        outfitCache[citizenid][#outfitCache[citizenid] + 1] = {
            id = result[i].id,
            outfitname = result[i].outfitname,
            model = result[i].model,
            components = json.decode(result[i].components),
            props = json.decode(result[i].props)
        }
    end
end

-- Callback(s)

QBCore.Functions.CreateCallback('fivem-appearance:server:getAppearance', function(source, cb, model)
    local Player = QBCore.Functions.GetPlayer(source)
    local query = 'SELECT skin FROM playerskins WHERE citizenid = ?'
    if model ~= nil then
        query = query .. ' AND model = ?'
        modelActive = model
    else
        query = query .. ' AND active = ?'
        modelActive = 1
    end
    MySQL.query(query, {Player.PlayerData.citizenid, modelActive}, function(result)
        if result ~= nil then
            cb(json.decode(result[1].skin))
        else
            cb(nil)
        end
    end)
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
    local Player = QBCore.Functions.GetPlayer(source)
    if outfitCache[Player.PlayerData.citizenid] == nil then
        getOutfitsForPlayer(Player.PlayerData.citizenid)
    end
    cb(outfitCache[Player.PlayerData.citizenid])
end)

QBCore.Functions.CreateCallback("fivem-appearance:server:getManagementOutfits", function(source, cb, mType, gender)
    local Player = QBCore.Functions.GetPlayer(source)
    local jobName = Player.PlayerData.job.name
    local grade = Player.PlayerData.job.grade.level
    if mType == "Gang" then
        jobName = Player.PlayerData.gang.name
        grade = Player.PlayerData.gang.grade.level
    end
    
    grade = tonumber(grade)

    local query = "SELECT * FROM management_outfits WHERE type = ? AND job_name = ?"
    local queryArgs = {mType, jobName}

    if gender then
        query = query .. " AND gender = ?"
        queryArgs[#queryArgs + 1] = gender
    end

    local managementOutfits = {}
    local result = MySQL.Sync.fetchAll(query, queryArgs)
    for i = 1, #result, 1 do
        if grade >= result[i].minrank then
            managementOutfits[#managementOutfits + 1] = {
                id = result[i].id,
                name = result[i].name,
                model = result[i].model,
                gender = result[i].gender,
                components = json.decode(result[i].components),
                props = json.decode(result[i].props)
            }
        end
    end
    cb(managementOutfits)
end)

QBCore.Functions.CreateCallback("fivem-appearance:server:getUniform", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    cb(uniformCache[Player.PlayerData.citizenid])
end)

RegisterServerEvent("fivem-appearance:server:saveAppearance", function(appearance)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if appearance ~= nil then
        MySQL.update.await("UPDATE playerskins SET active = 0 WHERE citizenid = ?", {Player.PlayerData.citizenid}) -- Make all the skins inactive
        MySQL.Async.execute('DELETE FROM playerskins WHERE citizenid = ? AND model = ?',
            {Player.PlayerData.citizenid, appearance.model}, function()
                MySQL.Async.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)',
                    {Player.PlayerData.citizenid, appearance.model, json.encode(appearance), 1})
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

RegisterNetEvent('fivem-appearance:server:saveOutfit', function(name, model, components, props)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if outfitCache[Player.PlayerData.citizenid] == nil then
        getOutfitsForPlayer(Player.PlayerData.citizenid)
    end
    if model and components and props then
        MySQL.Async.insert(
            'INSERT INTO player_outfits (citizenid, outfitname, model, components, props) VALUES (?, ?, ?, ?, ?)',
            {Player.PlayerData.citizenid, name, model, json.encode(components), json.encode(props)}, function(id)
                outfitCache[Player.PlayerData.citizenid][#outfitCache[Player.PlayerData.citizenid] + 1] = {
                    id = id,
                    outfitname = name,
                    model = model,
                    components = components,
                    props = props
                }
                TriggerClientEvent('QBCore:Notify', src, 'Outfit ' .. name .. ' has been saved', 'success')
            end)
    end
end)

RegisterNetEvent("fivem-appearance:server:saveManagementOutfit", function(outfitData)
    local src = source

    MySQL.Async.insert("INSERT INTO management_outfits (job_name, type, minrank, name, gender, model, props, components) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        {
            outfitData.JobName,
            outfitData.Type,
            outfitData.MinRank,
            outfitData.Name,
            outfitData.Gender,
            outfitData.Model,
            json.encode(outfitData.Props),
            json.encode(outfitData.Components)
        },
        function()
            TriggerClientEvent('QBCore:Notify', src, 'Outfit ' .. outfitData.Name .. ' has been saved', 'success')
        end)
end)

RegisterNetEvent("fivem-appearance:server:deleteManagementOutfit", function(id)
    MySQL.query("DELETE FROM management_outfits WHERE id = ?", {id})
end)

RegisterNetEvent("fivem-appearance:server:syncUniform", function(uniform)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    uniformCache[Player.PlayerData.citizenid] = uniform
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
    QBCore.Commands.Add('pedmenu', 'Open Ped Menu', {{
        name = 'id',
        help = '[Optional] ID of player (Gives you the ped menu if not provided)'
    }}, false, function(source, args)
        local src = source
        local playerId = tonumber(args[1])
        if playerId then
            local Player = QBCore.Functions.GetPlayer(playerId)
            if Player then
                src = playerId
            else
                TriggerClientEvent('QBCore:Notify', src, "Player not online", 'error')
                return
            end
        end

        TriggerClientEvent("fivem-appearance:client:openClothingShopMenu", src, true)
    end, Config.PedMenuGroup)
end

QBCore.Commands.Add('reloadskin', 'Reloads your character', {}, false, function(source, _)
    TriggerClientEvent("fivem-appearance:client:reloadSkin", source)
end)

QBCore.Commands.Add('clearstuckprops', 'Removes all the props attached to the entity', {}, false, function(source, _)
    TriggerClientEvent("fivem-appearance:client:ClearStuckProps", source)
end)
