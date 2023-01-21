local stats = nil

local function ResetRechargeMultipliers()
    local player = PlayerId()
    SetPlayerHealthRechargeMultiplier(player, 0.0)
    SetPlayerHealthRechargeLimit(player, 0.0)
end

function BackupPlayerStats()
    local playerPed = PlayerPedId()
    stats = {
        health = GetEntityHealth(playerPed),
        armour = GetPedArmour(playerPed)
    }
end

function RestorePlayerStats()
    if stats then
        local playerPed = PlayerPedId()
        SetEntityMaxHealth(playerPed, 200)
        Wait(1000) -- Safety Delay
        SetEntityHealth(playerPed, stats.health)
        SetPedArmour(playerPed, stats.armour)
        ResetRechargeMultipliers()
        stats = nil
        return
    end

    -- If no stats are backed up, restore from the framework
    Framework.RestorePlayerArmour()
end
