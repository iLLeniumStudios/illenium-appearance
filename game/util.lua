local hashesComputed = false
local PED_TATTOOS = {}
local pedModelsByHash = {}

local function tofloat(num)
    return num + 0.0
end

local function isPedFreemodeModel(ped)
    local model = GetEntityModel(ped)
    return model == `mp_m_freemode_01` or model == `mp_f_freemode_01`
end

local function computePedModelsByHash()
    for i = 1, #Config.Peds.pedConfig do
        local peds = Config.Peds.pedConfig[i].peds
        for j = 1, #peds do
            pedModelsByHash[joaat(peds[j])] = peds[j]
        end
    end
end

---@param ped number entity id
---@return string
--- Get the model name from an entity's model hash
local function getPedModel(ped)
    if not hashesComputed then
        computePedModelsByHash()
        hashesComputed = true
    end
    return pedModelsByHash[GetEntityModel(ped)]
end

---@param ped number entity id
---@return table<number, table<string, number>>
local function getPedComponents(ped)
    local size = #constants.PED_COMPONENTS_IDS
    local components = table.create(size, 0)

    for i = 1, size do
        local componentId = constants.PED_COMPONENTS_IDS[i]
        components[i] = {
            component_id = componentId,
            drawable = GetPedDrawableVariation(ped, componentId),
            texture = GetPedTextureVariation(ped, componentId),
        }
    end

    return components
end

---@param ped number entity id
---@return table<number, table<string, number>>
local function getPedProps(ped)
    local size = #constants.PED_PROPS_IDS
    local props = table.create(size, 0)

    for i = 1, size do
        local propId = constants.PED_PROPS_IDS[i]
        props[i] = {
            prop_id = propId,
            drawable = GetPedPropIndex(ped, propId),
            texture = GetPedPropTextureIndex(ped, propId),
        }
    end
    return props
end

local function round(number, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", number))
end

---@param ped number entity id
---@return table <number, number>
---```
---{ shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix }
---```
local function getPedHeadBlend(ped)
    -- GET_PED_HEAD_BLEND_DATA
    local shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix = Citizen.InvokeNative(0x2746BD9D88C5C5D0, ped, Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0))

    shapeMix = tonumber(string.sub(shapeMix, 0, 4))
    if shapeMix > 1 then shapeMix = 1 end

    skinMix = tonumber(string.sub(skinMix, 0, 4))
    if skinMix > 1 then skinMix = 1 end

    if not thirdMix then
        thirdMix = 0
    end
    thirdMix = tonumber(string.sub(thirdMix, 0, 4))
    if thirdMix > 1 then thirdMix = 1 end


    return {
        shapeFirst = shapeFirst,
        shapeSecond = shapeSecond,
        shapeThird = shapeThird,
        skinFirst = skinFirst,
        skinSecond = skinSecond,
        skinThird = skinThird,
        shapeMix = shapeMix,
        skinMix = skinMix,
        thirdMix = thirdMix
    }
end

---@param ped number entity id
---@return table<number, table<string, number>>
local function getPedFaceFeatures(ped)
    local size = #constants.FACE_FEATURES
    local faceFeatures = table.create(0, size)

    for i = 1, size do
        local feature = constants.FACE_FEATURES[i]
        faceFeatures[feature] = round(GetPedFaceFeature(ped, i-1), 1)
    end

    return faceFeatures
end

---@param ped number entity id
---@return table<number, table<string, number>>
local function getPedHeadOverlays(ped)
    local size = #constants.HEAD_OVERLAYS
    local headOverlays = table.create(0, size)

    for i = 1, size do
        local overlay = constants.HEAD_OVERLAYS[i]
        local _, value, _, firstColor, secondColor, opacity = GetPedHeadOverlayData(ped, i-1)

        if value ~= 255 then
            opacity = round(opacity, 1)
        else
            value = 0
            opacity = 0
        end

        headOverlays[overlay] = {style = value, opacity = opacity, color = firstColor, secondColor = secondColor}
    end

    return headOverlays
end

---@param ped number entity id
---@return table<string, number>
local function getPedHair(ped)
    return {
        style = GetPedDrawableVariation(ped, 2),
        color = GetPedHairColor(ped),
        highlight = GetPedHairHighlightColor(ped),
        texture = GetPedTextureVariation(ped, 2)
    }
end

local function getPedDecorationType()
    local playerPed = PlayerPedId()
    local pedModel = GetEntityModel(playerPed)
    local decorationType

    if pedModel == `mp_m_freemode_01` then
        decorationType = "male"
    elseif pedModel == `mp_f_freemode_01` then
        decorationType = "female"
    else
        decorationType = IsPedMale(playerPed) and "male" or "female"
    end

    return decorationType
end

local function getPedAppearance(ped)
    local eyeColor = GetPedEyeColor(ped)

    return {
        model = getPedModel(ped) or "mp_m_freemode_01",
        headBlend = getPedHeadBlend(ped),
        faceFeatures = getPedFaceFeatures(ped),
        headOverlays = getPedHeadOverlays(ped),
        components = getPedComponents(ped),
        props = getPedProps(ped),
        hair = getPedHair(ped),
        tattoos = client.getPedTattoos(),
        eyeColor = eyeColor < #constants.EYE_COLORS and eyeColor or 0
    }
end

local function setPlayerModel(model)
    local playerPed = PlayerId()

    if type(model) == "string" then model = joaat(model) end

    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        SetPlayerModel(playerPed, model)
        SetModelAsNoLongerNeeded(model)
        playerPed = PlayerPedId()

        if isPedFreemodeModel(playerPed) then
            SetPedDefaultComponentVariation(playerPed)
            SetPedHeadBlendData(playerPed, 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
        end

        PED_TATTOOS = {}
        return playerPed
    end

    return playerPed
end

local function setPedHeadBlend(ped, headBlend)
    if headBlend and isPedFreemodeModel(ped) then
        SetPedHeadBlendData(ped, headBlend.shapeFirst, headBlend.shapeSecond, headBlend.shapeThird, headBlend.skinFirst, headBlend.skinSecond, headBlend.skinThird, tofloat(headBlend.shapeMix or 0), tofloat(headBlend.skinMix or 0), tofloat(headBlend.thirdMix or 0), false)
    end
end

local function setPedFaceFeatures(ped, faceFeatures)
    if faceFeatures then
        for k, v in pairs(constants.FACE_FEATURES) do
            SetPedFaceFeature(ped, k-1, tofloat(faceFeatures[v]))
        end
    end
end

local function setPedHeadOverlays(ped, headOverlays)
    if headOverlays then
        for k, v in pairs(constants.HEAD_OVERLAYS) do
            local headOverlay = headOverlays[v]
            SetPedHeadOverlay(ped, k-1, headOverlay.style, tofloat(headOverlay.opacity))

            if headOverlay.color then
                local colorType = 1
                if v == "blush" or v == "lipstick" or v == "makeUp" then
                    colorType = 2
                end

                SetPedHeadOverlayColor(ped, k-1, colorType, headOverlay.color, headOverlay.secondColor)
            end
        end
    end
end

local function applyAutomaticFade(ped, style)
    local gender = getPedDecorationType()
    local hairDecoration = constants.HAIR_DECORATIONS[gender][style]

    if(hairDecoration) then
        AddPedDecorationFromHashes(ped, hairDecoration[1], hairDecoration[2])
    end
end

local function setTattoos(ped, tattoos, style)
    local isMale = client.getPedDecorationType() == "male"
    ClearPedDecorations(ped)
    if Config.AutomaticFade then
        tattoos["ZONE_HAIR"] = {}
        PED_TATTOOS["ZONE_HAIR"] = {}
        applyAutomaticFade(ped, style or GetPedDrawableVariation(ped, 2))
    end
    for k in pairs(tattoos) do
        for i = 1, #tattoos[k] do
            local tattoo = tattoos[k][i]
            local tattooGender = isMale and tattoo.hashMale or tattoo.hashFemale
            for _ = 1, (tattoo.opacity or 0.1) * 10 do
                AddPedDecorationFromHashes(ped, joaat(tattoo.collection), joaat(tattooGender))
            end
        end
    end
    if Config.RCoreTattoosCompatibility then
        TriggerEvent("rcore_tattoos:applyOwnedTattoos")
    end
end

local function setPedHair(ped, hair, tattoos)
    if hair then
        SetPedComponentVariation(ped, 2, hair.style, hair.texture, 0)
        SetPedHairColor(ped, hair.color, hair.highlight)
        if isPedFreemodeModel(ped) then
            setTattoos(ped, tattoos or PED_TATTOOS, hair.style)
        end
    end
end

local function setPedEyeColor(ped, eyeColor)
    if eyeColor then
        SetPedEyeColor(ped, eyeColor)
    end
end

local function setPedComponent(ped, component)
    if component then
        if isPedFreemodeModel(ped) and (component.component_id == 0 or component.component_id == 2) then
            return
        end

        SetPedComponentVariation(ped, component.component_id, component.drawable, component.texture, 0)
    end
end

local function setPedComponents(ped, components)
    if components then
        for _, v in pairs(components) do
            setPedComponent(ped, v)
        end
    end
end

local function setPedProp(ped, prop)
    if prop then
        if prop.drawable == -1 then
            ClearPedProp(ped, prop.prop_id)
        else
            SetPedPropIndex(ped, prop.prop_id, prop.drawable, prop.texture, false)
        end
    end
end

local function setPedProps(ped, props)
    if props then
        for _, v in pairs(props) do
            setPedProp(ped, v)
        end
    end
end

local function setPedTattoos(ped, tattoos)
    PED_TATTOOS = tattoos
    setTattoos(ped, tattoos)
end

local function getPedTattoos()
    return PED_TATTOOS
end

local function addPedTattoo(ped, tattoos)
    setTattoos(ped, tattoos)
end

local function removePedTattoo(ped, tattoos)
    setTattoos(ped, tattoos)
end

local function setPreviewTattoo(ped, tattoos, tattoo)
    local isMale = client.getPedDecorationType() == "male"
    local tattooGender = isMale and tattoo.hashMale or tattoo.hashFemale

    ClearPedDecorations(ped)
    for _ = 1, (tattoo.opacity or 0.1) * 10 do
        AddPedDecorationFromHashes(ped, joaat(tattoo.collection), tattooGender)
    end
    for k in pairs(tattoos) do
        for i = 1, #tattoos[k] do
            local aTattoo = tattoos[k][i]
            if aTattoo.name ~= tattoo.name then
                local aTattooGender = isMale and aTattoo.hashMale or aTattoo.hashFemale
                for _ = 1, (aTattoo.opacity or 0.1) * 10 do
                    AddPedDecorationFromHashes(ped, joaat(aTattoo.collection), joaat(aTattooGender))
                end
            end
        end
    end
    if Config.AutomaticFade then
        applyAutomaticFade(ped, GetPedDrawableVariation(ped, 2))
    end
end

local function setPedAppearance(ped, appearance)
    if appearance then
        setPedComponents(ped, appearance.components)
        setPedProps(ped, appearance.props)

        if appearance.headBlend and isPedFreemodeModel(ped) then setPedHeadBlend(ped, appearance.headBlend) end
        if appearance.faceFeatures then setPedFaceFeatures(ped, appearance.faceFeatures) end
        if appearance.headOverlays then setPedHeadOverlays(ped, appearance.headOverlays) end
        if appearance.hair then setPedHair(ped, appearance.hair, appearance.tattoos) end
        if appearance.eyeColor then setPedEyeColor(ped, appearance.eyeColor) end
        if appearance.tattoos then setPedTattoos(ped, appearance.tattoos) end
    end
end

local function setPlayerAppearance(appearance)
    if appearance then
        setPlayerModel(appearance.model)
        setPedAppearance(PlayerPedId(), appearance)
    end
end

exports("getPedModel", getPedModel)
exports("getPedComponents", getPedComponents)
exports("getPedProps", getPedProps)
exports("getPedHeadBlend", getPedHeadBlend)
exports("getPedFaceFeatures", getPedFaceFeatures)
exports("getPedHeadOverlays", getPedHeadOverlays)
exports("getPedHair", getPedHair)
exports("getPedAppearance", getPedAppearance)

exports("setPlayerModel", setPlayerModel)
exports("setPedHeadBlend", setPedHeadBlend)
exports("setPedFaceFeatures", setPedFaceFeatures)
exports("setPedHeadOverlays", setPedHeadOverlays)
exports("setPedHair", setPedHair)
exports("setPedEyeColor", setPedEyeColor)
exports("setPedComponent", setPedComponent)
exports("setPedComponents", setPedComponents)
exports("setPedProp", setPedProp)
exports("setPedProps", setPedProps)
exports("setPlayerAppearance", setPlayerAppearance)
exports("setPedAppearance", setPedAppearance)
exports("setPedTattoos", setPedTattoos)

client = {
    getPedAppearance = getPedAppearance,
    setPlayerModel = setPlayerModel,
    setPedHeadBlend = setPedHeadBlend,
    setPedFaceFeatures = setPedFaceFeatures,
    setPedHair = setPedHair,
    setPedHeadOverlays = setPedHeadOverlays,
    setPedEyeColor = setPedEyeColor,
    setPedComponent = setPedComponent,
    setPedProp = setPedProp,
    setPlayerAppearance = setPlayerAppearance,
    getPedDecorationType = getPedDecorationType,
    isPedFreemodeModel = isPedFreemodeModel,
    setPreviewTattoo = setPreviewTattoo,
    setPedTattoos = setPedTattoos,
    getPedTattoos = getPedTattoos,
    addPedTattoo = addPedTattoo,
    removePedTattoo = removePedTattoo,
    getPedModel = getPedModel,
    setPedComponents = setPedComponents,
    setPedProps = setPedProps,
    getPedComponents = getPedComponents,
    getPedProps = getPedProps
}
