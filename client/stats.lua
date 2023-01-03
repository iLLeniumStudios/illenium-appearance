local stats = {}

local function ResetRechargeMultipliers()
    local player = PlayerId()
    SetPlayerHealthRechargeMultiplier(player, 0.0)
    SetPlayerHealthRechargeLimit(player, 0.0)
end

function BackupPlayerStats()
    local playerPed = PlayerPedId()
    stats.health = GetEntityHealth(playerPed)
    stats.armour = GetPedArmour(playerPed)
end

function RestorePlayerStats()
    local playerPed = PlayerPedId()
    SetEntityMaxHealth(playerPed, 200)
    Wait(1000) -- Safety Delay
    SetEntityHealth(playerPed, stats.health)
    SetPedArmour(playerPed, stats.armour)
    ResetRechargeMultipliers()
end
