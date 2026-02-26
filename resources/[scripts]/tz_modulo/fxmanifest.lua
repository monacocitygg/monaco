





fx_version 'adamant'
game 'gta5'
author '@tz'
description 'Scripts desenvolvidos por tz. Discord:'
shared_scripts {
    '/main/shared/*','/scripts/**/shared/*.lua',
    -- "@vrp/lib/vehicles.lua","@vrp/lib/itemlist.lua", -- creative v5
     "@vrp/config/Vehicle.lua","@vrp/config/Item.lua", -- creative network
}
server_scripts { 
    '/main/server/*','/scripts/**/server.lua','/scripts/**/server/*' 
}
client_scripts {
    '/main/client/*','/scripts/**/client.lua','/scripts/**/client/*'
}
