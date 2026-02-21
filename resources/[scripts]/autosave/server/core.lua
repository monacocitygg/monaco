-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTOSAVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(3600000)
		TriggerEvent("SaveServer",true)
		print("\27[32m[AUTOSAVE]\27[37m Todo o servidor foi salvo.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("autosave",function(source,args,rawCommand)
	if source == 0 then
		TriggerEvent("SaveServer",false)
		print("\27[32m[AUTOSAVE]\27[37m Save manual executado com sucesso.")
	else
		local Passport = vRP.Passport(source)
		if vRP.HasGroup(Passport,"Admin") then
			TriggerEvent("SaveServer",false)
			TriggerClientEvent("Notify",source,"verde","Save manual executado.",5000)
		end
	end
end)
