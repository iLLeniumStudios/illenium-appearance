if not Target.IsQB() then return end

function Target.RemoveZone(zone)
    exports["qb-target"]:RemoveZone(zone)
end

function Target.AddTargetEntity(entity, parameters)
    exports["qb-target"]:AddTargetEntity(entity, parameters)
end

function Target.AddBoxZone(name, coords, size, parameters)
    exports["qb-target"]:AddBoxZone(name, coords, size.x, size.y, {
        name = name,
        debugPoly = Config.Debug,
        minZ = coords.z - 1,
        maxZ = coords.z + 1,
        heading = coords.w
    }, parameters)
end

function Target.IsTargetStarted()
    return GetResourceState("qb-target") == "started"
end
