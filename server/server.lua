local QBCore = exports["qb-core"]:GetCoreObject()

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
    local result = MySQL.Sync.fetchAll("SELECT * FROM player_outfits WHERE citizenid = ?", {citizenid})
    for i = 1, #result, 1 do
        outfitCache[citizenid][#outfitCache[citizenid] + 1] = {
            id = result[i].id,
            name = result[i].outfitname,
            model = result[i].model,
            components = json.decode(result[i].components),
            props = json.decode(result[i].props)
        }
    end
end

-- Callback(s)

lib.callback.register("illenium-appearance:server:getAppearance", function(source, model)
    local Player = QBCore.Functions.GetPlayer(source)
    local query = "SELECT skin FROM playerskins WHERE citizenid = ?"
    local queryArgs = {Player.PlayerData.citizenid}
    if model ~= nil then
        query = query .. " AND model = ?"
        queryArgs[#queryArgs + 1] = model
    else
        query = query .. " AND active = ?"
        queryArgs[#queryArgs + 1] = 1
    end
    local result = MySQL.Sync.fetchAll(query, queryArgs)
    if result[1] ~= nil then
        return json.decode(result[1].skin)
    end
end)

lib.callback.register("illenium-appearance:server:hasMoney", function(source, shopType)
    local Player = QBCore.Functions.GetPlayer(source)
    local money = getMoneyForShop(shopType)
    if Player.PlayerData.money.cash >= money then
        return true, money
    else
        return false, money
    end
end)

lib.callback.register("illenium-appearance:server:getOutfits", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if outfitCache[Player.PlayerData.citizenid] == nil then
        getOutfitsForPlayer(Player.PlayerData.citizenid)
    end
    return outfitCache[Player.PlayerData.citizenid]
end)

lib.callback.register("illenium-appearance:server:getManagementOutfits", function(source, mType, gender)
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
    return managementOutfits
end)

lib.callback.register("illenium-appearance:server:getUniform", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return uniformCache[Player.PlayerData.citizenid]
end)

RegisterServerEvent("illenium-appearance:server:saveAppearance", function(appearance)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if appearance ~= nil then
        MySQL.update.await("UPDATE playerskins SET active = 0 WHERE citizenid = ?", {Player.PlayerData.citizenid}) -- Make all the skins inactive
        MySQL.Async.execute("DELETE FROM playerskins WHERE citizenid = ? AND model = ?",
            {Player.PlayerData.citizenid, appearance.model}, function()
                MySQL.Async.insert("INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)",
                    {Player.PlayerData.citizenid, appearance.model, json.encode(appearance), 1})
            end)
    end
end)

RegisterServerEvent("illenium-appearance:server:chargeCustomer", function(shopType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local money = getMoneyForShop(shopType)
    if Player.Functions.RemoveMoney("cash", money) then
        lib.notify(src, {
            title = "Success",
            description = "Gave $" .. money .. " to " .. shopType .. "!",
            type = "success",
            position = Config.NotifyOptions.position
        })
    else
        lib.notify(src, {
            title = "Exploit!",
            description = "You didn't have enough money! Tried to exploit the system!",
            type = "error",
            position = Config.NotifyOptions.position
        })
    end
end)

RegisterNetEvent("illenium-appearance:server:saveOutfit", function(name, model, components, props)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if outfitCache[Player.PlayerData.citizenid] == nil then
        getOutfitsForPlayer(Player.PlayerData.citizenid)
    end
    if model and components and props then
        MySQL.Async.insert(
            "INSERT INTO player_outfits (citizenid, outfitname, model, components, props) VALUES (?, ?, ?, ?, ?)",
            {Player.PlayerData.citizenid, name, model, json.encode(components), json.encode(props)}, function(id)
                outfitCache[Player.PlayerData.citizenid][#outfitCache[Player.PlayerData.citizenid] + 1] = {
                    id = id,
                    name = name,
                    model = model,
                    components = components,
                    props = props
                }
                lib.notify(src, {
                    title = "Success",
                    description = "Outfit " .. name .. " has been saved",
                    type = "success",
                    position = Config.NotifyOptions.position
                })
            end)
    end
end)

RegisterNetEvent("illenium-appearance:server:saveManagementOutfit", function(outfitData)
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
            lib.notify(src, {
                title = "Success",
                description = "Outfit " .. outfitData.Name .. " has been saved",
                type = "success",
                position = Config.NotifyOptions.position
            })
        end)
end)

RegisterNetEvent("illenium-appearance:server:deleteManagementOutfit", function(id)
    MySQL.query("DELETE FROM management_outfits WHERE id = ?", {id})
end)

RegisterNetEvent("illenium-appearance:server:syncUniform", function(uniform)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    uniformCache[Player.PlayerData.citizenid] = uniform
end)

RegisterNetEvent("illenium-appearance:server:deleteOutfit", function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query("DELETE FROM player_outfits WHERE id = ?", {id})

    for k, v in ipairs(outfitCache[Player.PlayerData.citizenid]) do
        if v.id == id then
            table.remove(outfitCache[Player.PlayerData.citizenid], k)
            break
        end
    end
end)

RegisterNetEvent("illenium-appearance:server:resetOutfitCache", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        outfitCache[Player.PlayerData.citizenid] = nil
    end
end)

if Config.EnablePedMenu then
    lib.addCommand(Config.PedMenuGroup, "pedmenu", function(source, args)
        local target = source
        if args.playerID then
            local Player = QBCore.Functions.GetPlayer(args.playerID)
            if Player then
                target = args.playerID
            else
                lib.notify(source, {
                    title = "Error",
                    description = "Player not online",
                    type = "error",
                    position = Config.NotifyOptions.position
                })
                return
            end
        end
        TriggerClientEvent("illenium-appearance:client:openClothingShopMenu", target, true)
    end, {"playerID:?number"}, "Open / Give Clothing Menu")
end

lib.addCommand(false, "reloadskin", function(source)
    TriggerClientEvent("illenium-appearance:client:reloadSkin", source)
end, nil, "Reloads your character")

lib.addCommand(false, "clearstuckprops", function(source)
    TriggerClientEvent("illenium-appearance:client:ClearStuckProps", source)
end, nil, "Removes all the props attached to the entity")

lib.versionCheck('iLLeniumStudios/illenium-appearance')
