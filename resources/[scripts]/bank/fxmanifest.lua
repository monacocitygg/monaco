server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'

fx_version "bodacious"
game "gta5"
lua54 "yes"
version "1.5.0"
ui_page "web-side/index.html"
client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/*"
}
server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}
files {
	"web-side/*",
	"web-side/**/*"
}                                                                                                                              