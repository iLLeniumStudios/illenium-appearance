function CheckDuty()
    return not Config.OnDutyOnlyClothingRooms or (Config.OnDutyOnlyClothingRooms and client.job.onduty)
end

function IsPlayerAllowedForOutfitRoom(outfitRoom)
    local isAllowed = false
    local count = #outfitRoom.citizenIDs
    for i = 1, count, 1 do
        if Framework.IsPlayerAllowed(outfitRoom.citizenIDs[i]) then
            isAllowed = true
            break
        end
    end
    return isAllowed or not outfitRoom.citizenIDs or count == 0
end

function GetPlayerJobOutfits(job)
    local outfits = {}
    local gender = Framework.GetGender()
    local gradeLevel = job and Framework.GetJobGrade() or Framework.GetGangGrade()
    local jobName = job and client.job.name or client.gang.name

    if Config.BossManagedOutfits then
        local mType = job and "Job" or "Gang"
        local result = lib.callback.await("illenium-appearance:server:getManagementOutfits", false, mType, gender)
        for i = 1, #result, 1 do
            outfits[#outfits + 1] = {
                type = mType,
                model = result[i].model,
                components = result[i].components,
                props = result[i].props,
                disableSave = true,
                name = result[i].name
            }
        end
    elseif Config.Outfits[jobName] and Config.Outfits[jobName][gender] then
        for i = 1, #Config.Outfits[jobName][gender], 1 do
            for _, v in pairs(Config.Outfits[jobName][gender][i].grades) do
                if v == gradeLevel then
                    outfits[#outfits + 1] = Config.Outfits[jobName][gender][i]
                    outfits[#outfits].gender = gender
                    outfits[#outfits].jobName = jobName
                end
            end
        end
    end

    return outfits
end

function OpenOutfitRoom(outfitRoom)
    local isAllowed = IsPlayerAllowedForOutfitRoom(outfitRoom)
    if isAllowed then
        OpenMenu(nil, "outfit")
    end
end

function OpenBarberShop()
    local config = GetDefaultConfig()
    config.headOverlays = true
    OpenShop(config, false, "barber")
end

function OpenTattooShop()
    local config = GetDefaultConfig()
    config.tattoos = true
    OpenShop(config, false, "tattoo")
end

function OpenSurgeonShop()
    local config = GetDefaultConfig()
    config.headBlend = true
    config.faceFeatures = true
    OpenShop(config, false, "surgeon")
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if Config.BossManagedOutfits then
            Management.RemoveItems()
        end
    end
end)
