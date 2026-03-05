server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version "bodacious"
game "gta5"
lua54 "yes"

client_scripts {
    '@vrp/lib/Utils.lua',
    "client-side/*.lua"
}

server_scripts {
    '@vrp/lib/Utils.lua',
    "server-side/*.lua"
}
