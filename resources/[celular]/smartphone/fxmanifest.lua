server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'adamant'
game 'gta5'

server_scripts {
  'server.js'
}

client_scripts {
  "@vrp/lib/Utils.lua",
  'client.lua'
}

ui_page 'index.html'

files {
  'index.html',
  'index.js',
  'style.css',
  'assets/**/*'
}