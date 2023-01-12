Target = {}

function Target.IsOX()
    return GetResourceState("ox-target") ~= "missing"
end

function Target.IsQB()
    return GetResourceState("qb-target") ~= "missing"
end
