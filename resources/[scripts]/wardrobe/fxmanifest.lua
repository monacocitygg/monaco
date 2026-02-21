fx_version "bodacious"
game "gta5"

client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/core.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/core.lua"
}

ui_page "web-side/index.html"

files {
	"web-side/index.html",
	"web-side/style.css",
	"web-side/script.js"
}
