if not Framework.Ox() then return end

local Ox = require '@ox_core.lib.init'
local player = Ox.GetPlayer()

local function getPlayerGroup(type)
    local name, grade = player.getGroupByType(type)

    return {
        name = name,
        grade = {
            level = grade or 0
        },
        onduty = true
    }
end

RegisterNetEvent("ox:setActiveCharacter", function(character)
    Framework.UpdatePlayerData()

    if character.isNew then
        return InitializeCharacter(Framework.GetGender(true))
    end

    InitAppearance()
end)

RegisterNetEvent("ox:setGroup", function()
    Framework.UpdatePlayerData()
    ResetBlips()
end)

function Framework.GetPlayerGender()
    return player.get('gender') == 'female' and 'Female' or 'Male'
end

function Framework.UpdatePlayerData()
    client.job = getPlayerGroup('job')
    client.gang = getPlayerGroup('gang')
    client.citizenid = player.charId
end

AddEventHandler("ox:playerLoaded", function()
    Framework.UpdatePlayerData()
    ResetBlips()
end)

function Framework.HasTracker() return false end

function Framework.CheckPlayerMeta()
    return LocalPlayer.state.isDead or IsPedCuffed(cache.ped)
end

function Framework.IsPlayerAllowed(charId)
    return charId == player.charId
end

function Framework.GetRankInputValues(type)
    local playerGroup = client[type]
    local group = playerGroup and playerGroup.name and Ox.GetGroup(playerGroup.name)
    local rankValues = {}

    if group and group.grades then
        for grade, label in pairs(group.grades) do
            rankValues[#rankValues + 1] = {
                label = label,
                value = tonumber(grade)
            }
        end
    end

    return rankValues
end

function Framework.GetJobGrade()
    return client.job.grade.level - 1
end

function Framework.GetGangGrade()
    return client.gang.grade.level - 1
end

function Framework.CachePed() end

function Framework.RestorePlayerArmour() end

Framework.UpdatePlayerData()
