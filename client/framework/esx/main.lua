if not Framework.ESX() then return end

local ESX = exports["es_extended"]:getSharedObject()
Framework.PlayerData = ESX.GetPlayerData()

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    Framework.PlayerData = xPlayer
    client.job = Framework.PlayerData.job
    client.gang = Framework.PlayerData.gang
    client.citizenid = Framework.PlayerData.identifier
    InitAppearance()
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    Framework.PlayerData = nil
end)

RegisterNetEvent("esx:setJob", function(job)
	Framework.PlayerData.job = job
    client.job = Framework.PlayerData.job
    client.gang = Framework.PlayerData.job
end)

function Framework.GetPlayerGender()
    Framework.PlayerData = ESX.GetPlayerData()
    if Framework.PlayerData.sex == "f" then
        return "Female"
    end
    return "Male"
end

function Framework.UpdatePlayerData()
    local data = ESX.GetPlayerData()
    if data.job then
        Framework.PlayerData = data
        client.job = Framework.PlayerData.job
        client.gang = Framework.PlayerData.job
    end
    client.citizenid = Framework.PlayerData.identifier
end

function Framework.HasTracker()
    return false
end

function Framework.CheckPlayerMeta()
    Framework.PlayerData = ESX.GetPlayerData()
    return Framework.PlayerData.dead or IsPedCuffed(Framework.PlayerData.ped)
end

function Framework.IsPlayerAllowed(citizenid)
    return citizenid == Framework.PlayerData.identifier
end

-- Not implemented entirely
function Framework.GetRankInputValues(type)
    local jobGrades = lib.callback.await("illenium-appearance:server:esx:getGradesForJob", false, client[type].name)
    return jobGrades
end

function Framework.GetJobGrade()
    return client.job.grade
end

function Framework.GetGangGrade()
    return client.gang.grade
end

function Framework.CachePed()
    ESX.SetPlayerData("ped", PlayerPedId())
end

function Framework.RestorePlayerArmour()
    return nil
end
