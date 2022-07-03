# qb-multicharacter

- Replace the `qb-multicharacter:server:getSkin` callback on Line: 181 of qb-multicharacter/server/main.lua with:

```lua
QBCore.Functions.CreateCallback("qb-multicharacter:server:getSkin", function(_, cb, cid)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        cb(json.decode(result[1].skin))
    else
        cb(nil)
    end
end)
```

- Replace the `RegisterNUICallback('cDataPed', function(nData, cb)` callback on Line: 127 of qb-multicharacter/client/main.lua with:

```lua
RegisterNUICallback('cDataPed', function(nData, cb)
    local cData = nData.cData  
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(skinData)
            if skinData then
                local model = skinData.model
                CreateThread(function()
                    RequestModel(GetHashKey(model))
                    while not HasModelLoaded(GetHashKey(model)) do
                        Wait(10)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)

                    local RandomAnims = {
                        "WORLD_HUMAN_HANG_OUT_STREET", 
                        "WORLD HUMAN STAND IMPATIENT", 
                        "WORLD_HUMAN_STAND_MOBILE", 
                        "WORLD_HUMAN_SMOKING_POT", 
                        "WORLD_HUMAN_LEANING", 
                        "WORLD_HUMAN_DRUG DEALER_HARD", 
                        "WORLD_HUMAN_SUPERHERO", 
                        "WORLD_HUMAN_TOURIST_MAP", 
                        "WORLD_HUMAN YOGA", 
                        "WORLD_HUMAN_BINOCULARS", 
                        "WORLD HUMAN BUM WASH", 
                        "WORLD_HUMAN_CONST_DRILL", 
                        "WORLD_HUMAN_MOBILE_FILM_SHOCKING", 
                        "WORLD HUMAN MUSCLE FLEX", 
                        "WORLD_HUMAN_MUSICIAN", 
                        "WORLD_HUMAN_PAPARAZZI", 
                        "WORLD_HUMAN_PARTYING",
                    }
                    local PlayAnim = RandomAnims[math.random(#RandomAnims)] 
                    SetPedCanPlayAmbientAnims(charPed, true) 
                    TaskStartScenarioInPlace(charPed, PlayAnim, 0, true)

                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    exports['fivem-appearance']:setPedAppearance(charPed, skinData)
                end)
            else
                CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
            cb("ok")
        end, cData.citizenid)
    else
        CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
        cb("ok")
    end
end)
```
