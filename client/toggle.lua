local ComponentMap = {
    Mask = 1,
    UpperBody = 3,
    LowerBody = 4,
    Bags = 5,
    Shoes = 6,
    ScarfAndChains = 7,
    Shirt = 8,
    BodyArmor = 9,
    Decals = 10,
    Jackets = 11,
}

local PropMap = {
    Hat = 0,
    Glasses = 1,
    Ear = 2,
    Watch = 6,
    Bracelet = 7
}

local CurrentComponents = {}
local CurrentProps = {}

for k, v in pairs(Config.ToggleVariations.Components) do
    RegisterNetEvent("fivem-appearance:client:components:toggle:" .. k, function()
        local playerPed = PlayerPedId()
        local component = ComponentMap[k]
        local gender = Gender == 1 and "Female" or "Male"
        if not CurrentComponents[component]then
            CurrentComponents[component] = {}
            CurrentComponents[component].drawable = GetPedDrawableVariation(playerPed, component)
            CurrentComponents[component].texture = GetPedTextureVariation(playerPed, component)
            SetPedComponentVariation(playerPed, component, v[gender].Drawable, v[gender].Texture, 0)
        else
            SetPedComponentVariation(playerPed, component, CurrentComponents[component].drawable, CurrentComponents[component].texture, 0)
            CurrentComponents[component] = nil
        end
    end)
end

for k, v in pairs(Config.ToggleVariations.Props) do
    RegisterNetEvent("fivem-appearance:client:props:toggle:" .. k, function()
        local playerPed = PlayerPedId()
        local prop = PropMap[k]
        local gender = Gender == 1 and "Female" or "Male"
        if not CurrentProps[prop]then
            CurrentProps[prop] = {}
            CurrentProps[prop].drawable = GetPedPropIndex(playerPed, prop)
            CurrentProps[prop].texture = GetPedPropTextureIndex(playerPed, prop)
            SetPedPropIndex(playerPed, prop, v[gender].Drawable, v[gender].Texture, false)
        else
            SetPedPropIndex(playerPed, prop, CurrentProps[prop].drawable, CurrentProps[prop].texture, false)
            CurrentProps[prop] = nil
        end
    end)
end

