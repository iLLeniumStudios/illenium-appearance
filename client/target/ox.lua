if not Config.UseTarget then return end

if not Target.IsOX() then return end

local ZoneIDMap = {}

local function convert(options)
    local distance = options.distance
    options = options.options
    for _, v in pairs(options) do
        v.onSelect = v.action
        v.distance = v.distance or distance
        v.name = v.name or v.label
        v.groups = v.job or v.gang
        v.type = nil
        v.action = nil

        v.job = nil
        v.gang = nil
        v.qtarget = true
    end

    return options
end

function Target.RemoveZone(zone)
    exports["ox_target"]:removeZone(ZoneIDMap[zone])
end

function Target.AddTargetEntity(entity, parameters)
    exports["ox_target"]:addLocalEntity(entity, convert(parameters))
end

function Target.AddBoxZone(name, coords, size, parameters)
    local rotation = parameters.rotation
    ZoneIDMap[name] = exports["ox_target"]:addBoxZone({
        coords = coords,
        size = size,
        rotation = rotation,
        debug = Config.Debug,
        options = convert(parameters)
    })
end

function Target.AddPolyZone(name, points, parameters)
    ZoneIDMap[name] = exports["ox_target"]:addPolyZone({
        points = points,
        debug = Config.Debug,
        options = convert(parameters)
    })
end

function Target.IsTargetStarted()
    return GetResourceState("ox_target") == "started"
end
