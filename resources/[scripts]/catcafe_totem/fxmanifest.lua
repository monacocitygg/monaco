fx_version 'cerulean'
game 'gta5'

author 'Trae AI'
description 'Catcafe Totem'
version '1.0.0'

client_scripts {
    '@vrp/lib/utils.lua',
    'config.lua',
    'client-side/core.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'config.lua',
    'server-side/core.lua'
}

ui_page 'web-side/index.html'

files {
    'web-side/index.html',
    'web-side/style.css',
    'web-side/script.js',
    'web-side/images/*'
}
