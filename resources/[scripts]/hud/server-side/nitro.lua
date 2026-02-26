-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local NitroData = {}
local PurgeData = {}
local nitroColor = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS (server-side access from other resources)
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GetNitro",function(Plate) return NitroData[Plate] or 0 end)
exports("SetNitro",function(Plate,Fuel) NitroData[Plate] = Fuel end)
exports("RemoveNitro",function(Plate) NitroData[Plate] = nil end)
exports("GetPurge",function(Plate) return PurgeData[Plate] or 0 end)
exports("SetPurge",function(Plate,Fuel) PurgeData[Plate] = Fuel end)
exports("RemovePurge",function(Plate) PurgeData[Plate] = nil end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNEL (client access via vSERVER.GetNitroFuel)
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.GetNitroFuel(Plate)
	return NitroData[Plate] or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.UpdateNitro(Plate,Fuel)
	if NitroData[Plate] then
		NitroData[Plate] = Fuel
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPURGE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hypex.UpdatePurge(Plate,Fuel)
	if PurgeData[Plate] then
		PurgeData[Plate] = Fuel
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