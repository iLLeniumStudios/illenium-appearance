local configAces = {}

for i = 1, #Config.Peds.pedConfig do
    local pedConfigEntry = Config.Peds.pedConfig[i]
    if pedConfigEntry.aces then
        for k = 1, #pedConfigEntry.aces do
            configAces[pedConfigEntry.aces[k]] = true
        end
    end
end

lib.callback.register("illenium-appearance:server:GetPlayerAces", function()
    local src = source
    local allowedAces = {}

    for k in pairs(configAces) do
        if IsPlayerAceAllowed(src, k) then
            allowedAces[#allowedAces+1] = k
        end
    end

    return allowedAces
end)
