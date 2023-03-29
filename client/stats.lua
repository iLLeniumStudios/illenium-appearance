local stats = nil

local function ResetRechargeMultipliers()
    SetPlayerHealthRechargeMultiplier(cache.playerId, 0.0)
    SetPlayerHealthRechargeLimit(cache.playerId, 0.0)
end

function BackupPlayerStats()
    stats = {
        health = GetEntityHealth(PlayerPedId()),
        armour = GetPedArmour(PlayerPedId())
    }
end

function RestorePlayerStats()
    if stats then
        SetEntityMaxHealth(PlayerPedId(), 200)
        Wait(1000) -- Safety Delay
        SetEntityHealth(PlayerPedId(), stats.health)
        SetPedArmour(PlayerPedId(), stats.armour)
        ResetRechargeMultipliers()
        stats = nil
        return
    end

    -- If no stats are backed up, restore from the framework
    Framework.RestorePlayerArmour()
end
