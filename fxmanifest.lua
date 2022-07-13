fx_version "cerulean"
game "gta5"

author 'snakewiz'
description 'A flexible player customization script for FiveM.'
repository 'https://github.com/pedr0fontoura/fivem-appearance'
version 'main'
lua54 'yes'

client_scripts {
  'game/dist/index.js',
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

provide 'qb-clothing'

dependencies {
  'qb-core',
}
