local resetTimer = GetGameTimer()
local allAces = {}

lib.callback.register("illenium-appearance:server:GetPlayerAces", function()
    local src = source
    local allowedAces = {}
    for k in pairs(allAces) do
        if IsPlayerAceAllowed(src, k) then
            allowedAces[#allowedAces + 1] = k
        end
    end
    return allowedAces
end)

local function findAceFromSecurityMessage(message)
    local words = {}
    for word in message:gmatch("%S+") do words[#words + 1] = word end
    return words[3]
end

RegisterConsoleListener(function(channel, message)
    if channel ~= "security" then
        return
    end

    local ace = findAceFromSecurityMessage(message)
    if ace and ((GetGameTimer() - resetTimer) > Config.ACEResetCooldown) then
        allAces = {}
    end

    if ace then
        allAces[ace] = true
        resetTimer = GetGameTimer()
    end
end)

if Config.EnableACEPermissions then
    CreateThread(function()
        while true do
            ExecuteCommand("list_aces")
            Wait(Config.ACEListCooldown)
        end
    end)
end
