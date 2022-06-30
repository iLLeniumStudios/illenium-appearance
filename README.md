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
- Job / Gang locked Stores
- Tattoo's Support
- Hair Textures
- Polyzone Support
- Ped Menu command (/pedmenu) (Configurable)
- Reload Skin command (/reloadskin)
- Improved code quality
- Plastic Surgeons
- qb-target Support
- Skin migration support (qb-clothing / old fivem-appearance)
- Player specific outfit locations (Restricted via CitizenID)
- Makeup Secondary Color
- QBCore Theme
- Component & Props Blacklist support
- Limit Components & Props to certain Jobs / Gangs
- Limit Components & Props to ACEs (Allows you to have VIP clothing on your Server)
- Persist Job / Gang Clothes on reconnects / logout
- Themes Support

## New Preview (with Tattoos)

https://streamable.com/qev2h7

## Setup

- Delete / stop `qb-clothing` from youre resources folder
- Delete / stop any tattoo shop resources e.g., `qb-tattooshop` from your resources folder
- Put `setr fivem-appearance:locale "en"` in your server.cfg
- Put `ensure fivem-appearance` in your server.cfg
- If you want to use ACE permissions for clothing items then do the following:
  - Add `add_ace resource.fivem-appearance command.list_aces allow` to server.cfg
  - Set `Config.EnableACEPermissions` to `true` in `shared/config.lua`
- Delete the table `player_outfits` from your database
- Apply the SQL file located [here](sql/player_outfits.sql) to your database to have the new `player_outfits` table created 
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


## Blacklisting Clothes and / or Limiting them to Jobs / Gangs / ACEs

You can now blacklist different clothes by adding them in a specific format to `blacklist.json`. The default file contains all the component names that you can choose to blacklist. For example if you want to blacklist following items:

```
Jackets: 10, 12, 13, 18 (All Textures)
Jackets: 11 (Texture: 1, 2, 3)
Masks: 10, 11, 12, 13 (All Textures)
Masks: 14 (Texture: 5, 7, 10, 12, 13)
Jackets: 25, 30, 35 (Accessible only to "police" job)
Hats: 41, 42, 45 (Accessible only to "ballas" gang)
Scarfs & Chains: 5, 6, 7 (Accessible only to "vip" ACE)
```

Here is how the JSON file would look like, for such configuration:

```json
{
  "male": {
    "components": {
      "masks": [
        {
          "drawables": [10, 11, 12, 13]
        },
        {
          "drawables": [14],
          "textures": [5, 7, 10, 11, 12, 13]
        }
      ],
      "upperBody": [],
      "lowerBody": [],
      "bags": [],
      "shoes": [],
      "scarfAndChains": [
        {
          "drawables": [5, 6, 7],
          "aces": ["vip"]
        }
      ],
      "shirts": [],
      "bodyArmor": [],
      "decals": [],
      "jackets": [
        {
          "drawables":  [11],
          "textures": [1, 2, 3]
        },
        {
          "drawables": [10, 12, 13, 18]
        },
        {
          "drawables": [25, 30, 35],
          "jobs": ["police"]
        }
      ]
    },
    "props": {
      "hats": [
        {
          "drawables": [41, 42, 45],
          "gangs": ["ballas"]
        }
      ],
      "glasses": [],
      "ear": [],
      "watches": [],
      "bracelets": []
    }
  },
  "female": {
    "components": {
      "masks": [],
      "upperBody": [],
      "lowerBody": [],
      "bags": [],
      "shoes": [],
      "scarfAndChains": [],
      "shirts": [],
      "bodyArmor": [],
      "decals": [],
      "jackets": []
    },
    "props": {
      "hats": [],
      "glasses": [],
      "ear": [],
      "watches": [],
      "bracelets": []
    }
  }
}
```

You can separately blacklist male and female clothes. Just put them under the right section in the json and you should be good to go.

## Theme configuration

fivem-appearance comes with 2 themes, `default` and `qb-core` and `qb-core` is set as the default one.

### Switch between themes

Change `currentTheme` to the theme `id`. You can choose between `qb-core` and `default`.

### Creating custom themes

- Copy an existing theme based on which you want to create a new one
- Change the `id` to something unique
- Change the parameters of the theme accordingly

### Theme parameters

You can customize every theme using the parameters defined in `theme.json`. Following table explains a little bit about what each parameter can do

| Parameter                  | Description                                                   |
|----------------------------|---------------------------------------------------------------|
| id                         | Unique ID for the theme                                       |
| borderRadius               | How round do you want the corners of the elements to be       |
| fontColor                  | Main color of the text                                        |
| fontColorHover             | Color of the text on hover                                    |
| fontColorSelected          | Color of the text when it is selected                         |
| fontFamily                 | Font of the text                                              |
| primaryBackground          | Main background color for the elements                        |
| primaryBackgroundSelected  | Main background color for the elements when they are selected |
| secondaryBackground        | Secondary background color                                    |
| scaleOnHover               | Increase the size of the elements on hover                    |
| sectionFontWeight          | Font weight for the section headings text                     |
| smoothBackgroundTransition | Enable to fade in to the background color during hover        |

*Note:* After creating the custom theme, make sure to change `currentTheme` to the `id` of the new theme. You can ofcourse modify the existing themes as well if you want, but it is recommended to create your own so that you can switch between the defaults and the custom one whenever needed.

## Credits
- Original Script: https://github.com/pedr0fontoura/fivem-appearance
- Tattoo's Support: https://github.com/franfdezmorales/fivem-appearance
- Last Maintained Fork for QB: https://github.com/mirrox1337/aj-fivem-appearance
