fx_version 'cerulean'
game 'gta5'

author 'Trae AI'
description 'Advanced Anti-Cheat System'
version '1.0.0'

shared_script 'config.lua'

-- MySQL Driver Support (oxmysql or mysql-async)
server_script '@oxmysql/lib/MySQL.lua'

-- vRP Support
server_script '@vrp/lib/utils.lua'

client_scripts {
    'client/main.lua',
    'client/debug.lua'
}

server_scripts {
    'server/stats.lua',
    'server/main.lua'
}
