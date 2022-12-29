local Blips = {}
local job
local gang

local function ShowBlip(blipConfig, blip)
    if blip.job and blip.job ~= job then
        return false
    elseif blip.gang and blip.gang ~= gang then
        return false
    end

    return (blipConfig.Show and blip.showBlip == nil) or blip.showBlip
end

local function CreateBlip(blipConfig, coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipConfig.Sprite)
    SetBlipColour(blip, blipConfig.Color)
    SetBlipScale(blip, blipConfig.Scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipConfig.Name)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function SetupBlips()
    for k, _ in pairs (Config.Stores) do
        local blipConfig = Config.Blips[Config.Stores[k].shopType]
        if ShowBlip(blipConfig, Config.Stores[k]) then
            local blip = CreateBlip(blipConfig, Config.Stores[k].coords)
            Blips[#Blips + 1] = blip
        end
    end
end

function ResetBlips(job, gang)
    if Config.ShowNearestShopOnly then
        return
    end

    for i = 1, #Blips do
        RemoveBlip(Blips[i])
    end
    Blips = {}
    job = job
    gang = gang
    SetupBlips()
end

local function ShowNearestShopBlip()
    for k in pairs(Config.Blips) do
        Blips[k] = 0
    end
    while true do
        local coords = GetEntityCoords(PlayerPedId())
        for shopType, blipConfig in pairs(Config.Blips) do
            local closest = 1000000
            local closestCoords

            for _, shop in pairs(Config.Stores) do
                if shop.shopType == shopType and ShowBlip(blipConfig, shop, job, gang) then
                    local dist = #(coords - vector3(shop.coords.xyz))
                    if dist < closest then
                        closest = dist
                        closestCoords = shop.coords
                    end
                end
            end
            if DoesBlipExist(Blips[shopType]) then
                RemoveBlip(Blips[shopType])
            end

            if closestCoords then
                Blips[shopType] = CreateBlip(blipConfig, closestCoords)
            end
        end
        Wait(Config.NearestShopBlipUpdateDelay)
    end
end

if Config.ShowNearestShopOnly then
    CreateThread(ShowNearestShopBlip)
end
