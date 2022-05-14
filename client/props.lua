if Config.AlwaysKeepProps then
    local lastped = nil

    CreateThread(function()
        SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
        while true do
            if PlayerPedId() ~= lastped then
                lastped = PlayerPedId()
                SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
            end
            Wait(1000)
        end
    end)
end
