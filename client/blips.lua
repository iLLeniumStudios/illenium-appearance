CreateThread(function()
    for k, _ in pairs (Config.Stores) do
        local blipConfig = Config.Blips[Config.Stores[k].shopType]
        if (blipConfig.Show and Config.Stores[k].showBlip == nil) or Config.Stores[k].showBlip then
            local blip = AddBlipForCoord(Config.Stores[k].coords)
            SetBlipSprite(blip, blipConfig.Sprite)
            SetBlipColour(blip, blipConfig.Color)
            SetBlipScale(blip, blipConfig.Scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipConfig.Name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)
