fx_version "cerulean"
game "gta5"

author 'snakewiz & iLLeniumStudios'
description 'A flexible player customization script for FiveM qb-core servers.'
repository 'https://github.com/iLLeniumStudios/fivem-appearance'
version 'main'

lua54 'yes'

client_scripts {
  'game/constants.lua',
  'game/util.lua',
  'game/customisation.lua',
  'game/nui.lua',
  'client/blips.lua',
  'client/props.lua',
  'client/client.lua',
  'client/backward-events.lua',
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/ComboZone.lua',
  'migrate/client/client.lua'
}

server_scripts {
  'server/server.lua',
  'server/permissions.lua',
  '@oxmysql/lib/MySQL.lua',
  'migrate/server/server.lua',
}

shared_scripts {
  'shared/json.lua',
  'shared/config.lua'
}

files {
  'web/dist/index.html',
  'web/dist/assets/*.js',
  'locales/*.json',
  'peds.json',
  'tattoos.json',
  'blacklist.json',
  'theme.json'
}

ui_page 'web/dist/index.html'

dependencies {
  'qb-core',
}
