if not Config.BossManagedOutfits then return end

if Framework.ESX() then return end

function Management.RemoveItems()
    if GetResourceState(Management.ResourceName) ~= "started" then return end

    if Management.ItemIDs.Boss then
        exports[Management.ResourceName]:RemoveBossMenuItem(Management.ItemIDs.Boss)
    end
    if Management.ItemIDs.Gang then
        exports[Management.ResourceName]:RemoveGangMenuItem(Management.ItemIDs.Gang)
    end
end

function Management.AddBackMenuItem(managementMenu, args)
    local bossMenuEvent = "qb-bossmenu:client:OpenMenu"
    if args.type == "Gang" then
        bossMenuEvent = "qb-gangmenu:client:OpenMenu"
    end

    managementMenu.options[#managementMenu.options+1] = {
        title = _L("menu.returnTitle"),
        icon = "fa-solid fa-angle-left",
        event = bossMenuEvent
    }
end
