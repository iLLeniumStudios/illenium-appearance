if not Config.BossManagedOutfits then return end

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
    local resName = "qbx_management"
    if GetResourceState(resName) ~= "missing" then
        Management.ResourceName = resName
        return true
    end
    return false
end
