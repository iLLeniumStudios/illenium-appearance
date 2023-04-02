local RegisterNetEvent = RegisterNetEvent
local SetPedComponentVariation = SetPedComponentVariation
local SetPedPropIndex = SetPedPropIndex
local ClearPedProp = ClearPedProp
local TriggerServerEvent = TriggerServerEvent

local function typeof(var)
    local _type = type(var)

    if _type ~= "table" and _type ~= "userdata" then
        return _type
    end

    local _meta = getmetatable(var)
    return (_meta ~= nil and _meta._NAME) or _type
end

function LoadJobOutfit(oData)
    local ped = cache.ped
    local data = oData.outfitData

    data = typeof(data) == "table" and data or json.decode(data)

    local components = {
        pants = 4, arms = 3, ["t-shirt"] = 8, vest = 9, torso2 = 11, shoes = 6,
        bag = 5, decals = 10, accessory = 7, mask = 1
    }

    for name, component in pairs(components) do
        if data[name] then
            SetPedComponentVariation(ped, component, data[name].item, data[name].texture, 0)
        end
    end

    if Framework.HasTracker() then
        SetPedComponentVariation(ped, 7, 13, 0, 0)
    elseif not data.accessory then
        SetPedComponentVariation(ped, 7, -1, 0, 2)
    end

    local props = { hat = 0, glass = 1, ear = 2 }

    for name, prop in pairs(props) do
        if data[name] and data[name].item ~= -1 and data[name].item ~= 0 then
            SetPedPropIndex(ped, prop, data[name].item, data[name].texture, true)
        else
            ClearPedProp(ped, prop)
        end
    end

    local length = 0
    for _ in pairs(data) do
        length = length + 1
    end

    if Config.PersistUniforms and length > 1 then
        TriggerServerEvent("illenium-appearance:server:syncUniform", {
            jobName = oData.jobName,
            gender = oData.gender,
            label = oData.name
        })
    end
end

RegisterNetEvent("illenium-appearance:client:loadJobOutfit", LoadJobOutfit)

RegisterNetEvent("illenium-appearance:client:openOutfitMenu", function()
    OpenMenu(nil, "outfit")
end)
