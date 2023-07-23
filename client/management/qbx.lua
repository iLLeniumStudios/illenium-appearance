if not Config.BossManagedOutfits then return end

if not Management.IsQBX() then return end

function Management.AddItems()
    local menuItem = {
        title = _L("outfitManagement.title"),
        icon = "fa-solid fa-shirt",
        event = "illenium-appearance:client:OutfitManagementMenu",
        args = {}
    }
    menuItem.description = _L("outfitManagement.jobText")
    menuItem.args.type = "Job"
    Management.ItemIDs.Boss = exports[Management.ResourceName]:AddBossMenuItem(menuItem)

    menuItem.description = _L("outfitManagement.gangText")
    menuItem.args.type = "Gang"
    Management.ItemIDs.Gang = exports[Management.ResourceName]:AddGangMenuItem(menuItem)
end
