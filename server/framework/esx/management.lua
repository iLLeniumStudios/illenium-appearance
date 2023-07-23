if Config.BossManagedOutfits then
    lib.addCommand("bossmanagedoutfits", { help = _L("commands.bossmanagedoutfits.title"), }, function(source)
        TriggerClientEvent("illenium-appearance:client:OutfitManagementMenu", source, {
            type = "Job"
        })
    end)
end
