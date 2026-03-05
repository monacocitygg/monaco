server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version "bodacious"
game "gta5"

ui_page "html/index.html"

shared_scripts {
    "config.lua",
}

client_scripts {
	"@vrp/lib/Utils.lua",
	"client/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Item.lua",
	"server/*"
}

files {
	"html/*",
	"html/**/*",
}

dependencies {
    'vrp'
}