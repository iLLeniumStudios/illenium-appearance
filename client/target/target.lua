Target = {}

function Target.IsOX()
    return GetResourceState("qb-target") ~= "missing"
end

function Target.IsQB()
    return GetResourceState("ox_target") ~= "missing"
end
