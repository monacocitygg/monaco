server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
shared_script "@ThnAC/native.lua"
shared_script "@ThnAC/natives.lua"
fx_version 'cerulean'
game 'gta5'

author 'Exit'
description 'Sistema de Mundo SS com Interface para FiveM'
version '1.0.0'

-- Define a página NUI que será carregada
ui_page 'html/index.html'

-- Arquivos necessários para a interface
files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/discord-icon.svg',
    'html/discord-btn.svg',
}

-- Scripts do cliente e servidor
client_scripts {
    'client.lua'
}

server_scripts {
    "@vrp/lib/Utils.lua", 
    'server.lua'
}

