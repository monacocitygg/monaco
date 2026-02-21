fx_version "bodacious"
game "gta5"
lua54 "yes"

shared_scripts {
    '@vrp/lib/utils.lua',
	'config.lua'
}

client_scripts {
	"@vrp/config/Item.lua",
	"@vrp/config/Native.lua",
	"client-side/client.lua"
}

server_scripts {
	"@vrp/config/Item.lua",
	"server-side/server.lua"
}

escrow_ignore {
	'config.lua'
}

ui_page "web-side/index.html"

files{
    "web-side/**",
    "web-side/**/**",
}                
