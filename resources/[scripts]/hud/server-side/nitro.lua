-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Nitro"] = {}
GlobalState["Purge"] = {}
local nitroColor = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.UpdateNitro(Plate,Fuel)
	if GlobalState["Nitro"][Plate] then
		local Nitro = GlobalState["Nitro"]
		Nitro[Plate] = Fuel
		GlobalState:set("Nitro",Nitro,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPURGE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.UpdatePurge(Plate,Fuel)
	if GlobalState["Purge"][Plate] then
		local Purge = GlobalState["Purge"]
		Purge[Plate] = Fuel
		GlobalState:set("Purge",Purge,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITROCOLOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("hud:nitroColor")
AddEventHandler("hud:nitroColor",function()
	if nitroColor == true then
		nitroColor = false
	else
		nitroColor = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.ActiveNitro(Net,Status)
	local source = source
	local Players = vRPC.ClosestPeds(source,50)
	for _,v in pairs(Players) do
		async(function()
			TriggerClientEvent("hud:Nitro",v[2],Net,Status,nitroColor)
		end)
	end
	TriggerClientEvent("hud:Nitro",source,Net,Status,nitroColor)
end