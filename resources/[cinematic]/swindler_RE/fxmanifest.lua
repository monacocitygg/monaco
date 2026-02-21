shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'cerulean'
name 'swindler_rockstareditor'
description 'Rockstar Editor script, feito por swindler#1337.'
author 'swindler#1337'
game 'gta5'

client_scripts {
    '@menuv/menuv.lua',
    'config.lua',
    'cl_swindlerRE.lua'
}

server_scripts {
    'config.lua',
    'sv_swindlerRE.lua'
}

dependencies {
    'menuv'
}              