Management = {}

Management.ItemIDs = {
    Gang = nil,
    Boss = nil
}

function Management.IsQB()
    local resName = "qb-management"
    if GetResourceState(resName) ~= "missing" then
        Management.ResourceName = resName
        return true
    end
    return false
end

function Management.IsQBX()
    local resName = "qbx-management"
    if GetResourceState(resName) ~= "missing" then
        Management.ResourceName = resName
        return true
    end
    return false
end

function Management.RemoveItems()
    if GetResourceState(Management.ResourceName) ~= "started" then return end

    if Management.ItemIDs.Boss then
        exports[Management.ResourceName]:RemoveBossMenuItem(Management.ItemIDs.Boss)
    end
    if Management.ItemIDs.Gang then
        exports[Management.ResourceName]:RemoveGangMenuItem(Management.ItemIDs.Gang)
    end
end
