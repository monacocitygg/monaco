server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'adamant'
game 'gta5'

shared_scripts {
    "shared-side/*.lua"
}

client_scripts {
    "@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
    'client-side/*.lua'
}

server_scripts {
    "@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
    'server-side/*.lua'
}