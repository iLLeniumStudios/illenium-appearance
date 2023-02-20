if not Framework.ESX() then return end

local client = client
local firstSpawn = false

AddEventHandler("esx_skin:resetFirstSpawn", function()
    firstSpawn = true
end)

AddEventHandler("esx_skin:playerRegistered", function()
    if(firstSpawn) then
        InitializeCharacter(Framework.GetGender(true))
    end
end)

RegisterNetEvent("skinchanger:loadSkin2", function(ped, skin)
    if not skin.model then skin.model = "mp_m_freemode_01" end
    client.setPedAppearance(ped, skin)
    Framework.CachePed()
end)

RegisterNetEvent("skinchanger:getSkin", function(cb)
    while not Framework.PlayerData do
        Wait(1000)
    end
    lib.callback("illenium-appearance:server:getAppearance", false, function(appearance)
        cb(appearance)
        Framework.CachePed()
    end)
end)

RegisterNetEvent("skinchanger:loadSkin", function(skin, cb)
    -- add validation invisible when failed registration (maybe server restarted when apply skin)
    if skin.model then
        client.setPlayerAppearance(skin)
    else
        local data = Config.InitialPlayerClothes[Framework.GetGender(true)]
        if Framework.GetGender(true) == "Male" then
            data.model = 'mp_m_freemode_01'
        else
            data.model = 'mp_f_freemode_01'
        end
        client.setPlayerAppearance(data)
    end
    Framework.CachePed()
	if cb ~= nil then
		cb()
	end
end)

RegisterNetEvent("skinchanger:loadClothes", function(_, clothes)
    local playerPed = PlayerPedId()
    local components = Framework.ConvertComponents(clothes, client.getPedComponents(playerPed))
    local props = Framework.ConvertProps(clothes, client.getPedProps(playerPed))

    client.setPedComponents(playerPed, components)
    client.setPedProps(playerPed, props)
end)

RegisterNetEvent("esx_skin:openSaveableMenu", function(onSubmit, onCancel)
    InitializeCharacter(Framework.GetGender(true), onSubmit, onCancel)
end)
