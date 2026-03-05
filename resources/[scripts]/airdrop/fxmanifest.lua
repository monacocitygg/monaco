server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'



fx_version "cerulean"
game "gta5"

shared_scripts {
	'config/*'
}

client_scripts {
	"@vrp/lib/utils.lua",
	"client/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server/*"
}                                                                                                                                                                                                                                                                                                                                                                            