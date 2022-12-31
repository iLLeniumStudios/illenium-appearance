fx_version "cerulean"
game "gta5"

author "snakewiz & iLLeniumStudios"
description "A flexible player customization script for FiveM qb-core servers."
repository "https://github.com/iLLeniumStudios/illenium-appearance"
version "main"

lua54 "yes"

client_scripts {
  "game/constants.lua",
  "game/util.lua",
  "game/customization.lua",
  "game/nui.lua",
  "client/defaults.lua",
  "client/blips.lua",
  "client/props.lua",
  "client/client.lua",
  "client/backward-events.lua",
  "@PolyZone/client.lua",
  "@PolyZone/BoxZone.lua",
  "@PolyZone/ComboZone.lua",
  "migrate/client/client.lua"
}

server_scripts {
  "server/server.lua",
  "server/permissions.lua",
  "@oxmysql/lib/MySQL.lua",
  "migrate/server/server.lua"
}

shared_scripts {
  "shared/config.lua",
  "shared/blacklist.lua",
  "shared/peds.lua",
  "shared/tattoos.lua",
  "shared/theme.lua",
  "locales/en.lua",
  "locales/ar.lua",
  "locales/bg.lua",
  "locales/de.lua",
  "locales/es-ES.lua",
  "locales/fr.lua",
  "locales/pt-BR.lua",
  "locales/ro-RO.lua",
  "@ox_lib/init.lua"
}

files {
  "web/dist/index.html",
  "web/dist/assets/*.js"
}

ui_page "web/dist/index.html"

dependencies {
  "qb-core",
}
