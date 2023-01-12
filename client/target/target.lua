Target = {}

function Target.IsOX()
    return GetResourceState("ox_target") ~= "missing"
end

function Target.IsQB()
    return GetResourceState("qb-target") ~= "missing"
end
