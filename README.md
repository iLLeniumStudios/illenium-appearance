# fivem-appearance

A replacement for qb-clothing and other clothing resources for qb-core

<img src="https://i.imgur.com/ltLSMmh.png" alt="fivem-appearance with Tattoos" />

Discord: https://discord.gg/ZVJEkjUTkx

## Dependencies

- [PolyZone](https://github.com/mkafrin/PolyZone)
- [qb-core](https://github.com/qbcore-framework/qb-core) (Latest)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)
- [qb-input](https://github.com/qbcore-framework/qb-input)
- [qb-target](https://github.com/BerkieBb/qb-target) (Optional)

## Features

- Everything from standalone fivem-appearance
- Player outfits
- Rank based Clothing Rooms for Jobs / Gangs
- Tattoo's Support
- Hair Textures
- Polyzone Support
- Ped Menu command (/pedmenu) (Configurable)
- Reload Skin command (/reloadskin)
- Improved code quality
- No additional SQL needed. Uses the default `qb-clothing` schema
- Plastic Surgeons
- qb-target Support
- Skin migration support (qb-clothing / old fivem-appearance)
- Player specific outfit locations (Restricted via CitizenID)
- Makeup Secondary Color
- QBCore Theme

## New Preview (with Tattoos)

https://streamable.com/qev2h7

## Setup

- Delete / stop `qb-clothing`
- Delete / stop any tattoo shop resources e.g., `qb-tattooshop`
- Put `setr fivem-appearance:locale "en"` in your server.cfg
- Put `ensure fivem-appearance` in your server.cfg
- Follow the code below to replace the events

**NOTE:** ~~This might NOT pick up existing outfits / skins. It is recommended to use this on a new server.~~ You can now use the migration guide below to migrate the skins from other skin resources

## Migrating skins from other clothing resources

Migration demo: https://streamable.com/ydxoqb

### qb-clothing

- Run the following command while in-game

```lua
/migrateskins qb-clothing
```

- Wait until all the skins are migrated to the new format
- Restart the server

### fivem-appearance (aj, mirrox1337 etc)

- Run the following command while in-game

```lua
/migrateskins fivem-appearance
```

- Wait until all the skins are migrated to the new format
- Restart the server


## qb-multicharacter support

- Replace the `qb-multicharacter:server:getSkin` callback on Line: 151 of qb-multicharacter/server/main.lua with:

```lua
QBCore.Functions.CreateCallback("qb-multicharacter:server:getSkin", function(source, cb, cid)
    local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        cb(json.decode(result[1].skin))
    else
        cb(nil)
    end
end)
```

- Replace the `RegisterNUICallback('cDataPed', function(data)'` callback on Line: 109 of qb-multicharacter/client/main.lua with:

```lua
RegisterNUICallback('cDataPed', function(data)
    local cData = data.cData
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
                        Wait(10)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                end)
            end
        end, cData.citizenid)
    else
        Citizen.CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
        end)
    end
end)
```

## Credits
- Original Script: https://github.com/pedr0fontoura/fivem-appearance
- Tattoo's Support: https://github.com/franfdezmorales/fivem-appearance
- Last Maintained Fork for QB: https://github.com/mirrox1337/aj-fivem-appearance
