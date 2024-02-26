if not Framework.Ox() then return end

local Ox = require '@ox_core.lib.init'
local player = Ox.GetPlayer()

RegisterNetEvent("ox:setActiveCharacter", function(character)
    if character.isNew then
        return InitializeCharacter(Framework.GetGender(true))
    end

    InitAppearance()
end)

---@todo groups
-- RegisterNetEvent("ox:setGroup", function(group, grade)
-- end)

function Framework.GetPlayerGender()
    return player.get('gender') == 'female' and 'Female' or 'Male'
end

function Framework.UpdatePlayerData() end

function Framework.HasTracker() return false end

function Framework.CheckPlayerMeta()
    return LocalPlayer.state.isDead or IsPedCuffed(cache.ped)
end

function Framework.IsPlayerAllowed(charId)
    return charId == player.charId
end

function Framework.GetRankInputValues() end

function Framework.GetJobGrade() end

function Framework.GetGangGrade() end

function Framework.CachePed() end

function Framework.RestorePlayerArmour() end
