fx_version "cerulean"
game "gta5"
lua54 'yes'


author 'MateHUN [mhScripts]'
description 'Template used mCore'
version '1.0.0'




server_scripts {
     "shared/**.*",
    "server/functions.lua",
    "server/main.lua",
}

client_scripts {
     '@mate-grid/init.lua',
     "shared/**.*",
     "client/init.lua",
     "client/functions.lua",
     "client/garden/*.lua",
     "client/tools/ToolHandler.lua",
     "client/tools/ToolRegistry.lua",
     "client/seeds/SeedHandler.lua",
     "client/seeds/SeedRegistry.lua",

     "client/nui.lua",
     "client/main.lua",
}

server_script "@oxmysql/lib/MySQL.lua"
shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'

dependency {
    'mCore',
    'oxmysql',
    'ox_lib',
    "mate-grid"
}


escrow_ignore {
    'shared/config.lua',
    '**/*.editable.lua'
}


files {
  "html/index.html",
  "html/assets/*.js",
  "html/assets/*.css",
  "shared/config.lua",
  "client/tools/*.lua",
  "client/seeds/*.lua"
}


ui_page "html/index.html"
--ui_page "http://localhost:5173"
