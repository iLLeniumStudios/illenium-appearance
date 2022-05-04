fx_version "cerulean"
game { "gta5" }

author 'snakewiz'
description 'A flexible player customization script for FiveM.'
repository 'https://github.com/pedr0fontoura/fivem-appearance'
version '1.2.2'

client_scripts {
  'game/build/client.js',
  'client/blips.lua',
  'client/client.lua',
  'client/backward-events.lua',
  '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
  'migrate/client/client.lua'
}

server_scripts {
  'server/server.lua',
  '@oxmysql/lib/MySQL.lua',
  'migrate/server/server.lua',
}

shared_scripts {
  'shared/config.lua'
}

files {
  'web/build/index.html',
  'web/build/static/js/*.js',
  'locales/*.json',
  'peds.json',
  'tattoos.json',
}

ui_page 'web/build/index.html'

provide 'qb-clothing'

dependencies {
  'qb-core',
}
