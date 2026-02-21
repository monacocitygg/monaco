fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/config.lua",
	"client-side/core.lua"
}

server_scripts {
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
	"server-side/config.lua",
	"server-side/core.lua"
}

files {
	"web-side/index.html",
	"web-side/crafting.css",
	"web-side/script.js",
	"web-side/assets/*"
}
