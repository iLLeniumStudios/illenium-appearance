lib.callback.register("illenium-appearance:server:GetPlayerAces", function()
    local src = source
    local allowedAces = {}
    for i = 1, #Config.Aces do
        if IsPlayerAceAllowed(src, Config.Aces[i]) then
            allowedAces[#allowedAces+1] = k
        end
    end
    return allowedAces
end)
