# fivem-appearance

[![Lint](https://github.com/iLLeniumStudios/fivem-appearance/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/iLLeniumStudios/fivem-appearance/actions/workflows/lint.yml)

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

- Delete / stop `qb-clothing` from youre resources folder
- Delete / stop any tattoo shop resources e.g., `qb-tattooshop` from your resources folder
- Put `setr fivem-appearance:locale "en"` in your server.cfg
- Put `ensure fivem-appearance` in your server.cfg
- If you want to configure qb-multicharacter, follow the corresponding guide for your version [here](docs/multicharacter-setup.md)
- Restart your server
- Follow the respective guide below based on your older version of clothing resource (qb-clothing / fivem-appearance)

### qb-clothing

Migration demo: https://streamable.com/ydxoqb

- Connect to your server
- Open up any of your saved character
- Run the following command:

```lua
/migrateskins qb-clothing
```

- Wait until all the skins are migrated to the new format
- Quit the game
- Restart the server

### fivem-appearance (aj, mirrox1337 etc)

- Delete `player_outfits` table from the database
- Create the `player_outfits` table using the SQL [here](https://github.com/qbcore-framework/qb-clothing/blob/main/qb-clothing.sql#L12-L22)
- Connect to your server
- Open up any of your saved character
- Run the following command:

```lua
/migrateskins fivem-appearance
```

- Wait until all the skins are migrated to the new format
- Restart the server

## Credits
- Original Script: https://github.com/pedr0fontoura/fivem-appearance
- Tattoo's Support: https://github.com/franfdezmorales/fivem-appearance
- Last Maintained Fork for QB: https://github.com/mirrox1337/aj-fivem-appearance
