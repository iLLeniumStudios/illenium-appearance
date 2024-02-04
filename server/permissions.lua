lib.callback.register("illenium-appearance:server:GetPlayerAces", function()
    local src = source
    local allowedAces = {}
    for i = 1, #Config.Aces do
        local ace = Config.Aces[i]
        if IsPlayerAceAllowed(src, ace) then
            allowedAces[#allowedAces+1] = ace
        end
    end
    return allowedAces
end)
