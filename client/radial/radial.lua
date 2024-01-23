Radial = {}

Radial.MenuID = "open_clothing_menu"

local radialOptionAdded = false

function Radial.IsOX()
    local resName = "ox_lib"
    if GetResourceState(resName) ~= "missing" and Config.UseOxRadial then
        Radial.ResourceName = resName
        return true
    end
    return false
end

function Radial.IsQB()
    local resName = "qb-radialmenu"
    if GetResourceState(resName) ~= "missing" then
        Radial.ResourceName = resName
        return true
    end
    return false
end

function Radial.IsQBX()
    local resName = "qbx_radialmenu"
    if GetResourceState(resName) ~= "missing" then
        Radial.ResourceName = resName
        return true
    end
    return false
end

function Radial.AddOption(currentZone)
    if not Config.UseRadialMenu then return end

    if not currentZone then
        Radial.Remove()
        return
    end
    local event, title
    local zoneEvents = {
        clothingRoom = {"illenium-appearance:client:OpenClothingRoom", _L("menu.title")},
        playerOutfitRoom = {"illenium-appearance:client:OpenPlayerOutfitRoom", _L("menu.outfitsTitle")},
        clothing = {"illenium-appearance:client:openClothingShopMenu", _L("menu.clothingShopTitle")},
        barber = {"illenium-appearance:client:OpenBarberShop", _L("menu.barberShopTitle")},
        tattoo = {"illenium-appearance:client:OpenTattooShop", _L("menu.tattooShopTitle")},
        surgeon = {"illenium-appearance:client:OpenSurgeonShop", _L("menu.surgeonShopTitle")},
    }
    if zoneEvents[currentZone.name] then
        event, title = table.unpack(zoneEvents[currentZone.name])
    end

    Radial.Add(title, event)
    radialOptionAdded = true
end

function Radial.RemoveOption()
    if radialOptionAdded then
        Radial.Remove()
        radialOptionAdded = false
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if Config.UseOxRadial and GetResourceState("ox_lib") == "started" or GetResourceState("qb-radialmenu") == "started" then
            Radial.RemoveOption()
        end
    end
end)
