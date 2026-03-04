-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
DEVICE = Tunnel.getInterface("device")
REQUEST = Tunnel.getInterface("request")
SURVIVAL = Tunnel.getInterface("survival")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GG
-----------------------------------------------------------------------------------------------------------------------------------------
local RespawnGroups = {
    ["Police"] = vec3(-900.23,-2030.92,9.4),
    ["Core"] = vec3(-900.23,-2030.92,9.4),
    ["Gtm"] = vec3(-900.23,-2030.92,9.4),
    ["Graer"] = vec3(-900.23,-2030.92,9.4),
    ["Speed"] = vec3(-900.23,-2030.92,9.4)
}

RegisterCommand("gg",function(source)
	if GetPlayerRoutingBucket(source) < 900000 then
		local Passport = vRP.Passport(source)
		if Passport and SURVIVAL.CheckDeath(source) then
            local InventoryLog = vRP.GetInventoryLog(Passport)

            if vRP.UserPremium(Passport) then
                if ClearInventoryPremium then
                    vRP.ClearInventory(Passport, InventoryLog)
                end
            elseif CleanDeathInventory then
                vRP.ClearInventory(Passport, InventoryLog)
            end

			local Datatable = vRP.Datatable(Passport)
			if Datatable and Datatable["Weight"] then
				Datatable["Weight"] = BackpackWeightDefault
			end

			vRP.UpgradeThirst(Passport,100)
			vRP.UpgradeHunger(Passport,100)
			vRP.DowngradeStress(Passport,100)

            if InventoryLog == "" then
                InventoryLog = "Nenhum item no inventário."
            end

            local webhookMessage = "**Source:** " .. source ..
                "\n**Passaporte:** " .. Passport ..
                "\n**IP:** " .. GetPlayerEndpoint(source) ..
                "\n**Itens Removidos:**\n" .. InventoryLog

			TriggerEvent("Discord","Airport", webhookMessage, 3092790)

			local PlayerGroup = nil
			for Permission, Coords in pairs(RespawnGroups) do
                local hasGroup = vRP.HasGroup(Passport, Permission)
                print("DEBUG GG: Checking group", Permission, "for Passport", Passport, "Result:", hasGroup)
				if hasGroup then
					PlayerGroup = Permission
					break
				end
			end

            print("DEBUG GG: PlayerGroup selected:", PlayerGroup)
            if PlayerGroup then
                print("DEBUG GG: Respawning at custom coords:", RespawnGroups[PlayerGroup])
				SURVIVAL.Respawn(source, RespawnGroups[PlayerGroup])
			else
                print("DEBUG GG: Respawning at default coords")
				SURVIVAL.Respawn(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SMARTPHONE:SERVICE_REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("smartphone:service_request",function(Data)
	local Service = vRP.NumPermission(Data["service"]["permission"])
	local Passport = vRP.Passport(Data["source"])
	local Identity = vRP.Identity(Passport)
	local Answered = false

	for Passport,Sources in pairs(Service) do
		async(function()
			TriggerClientEvent("NotifyPush",Sources,{ code = 20, phone = Identity["phone"], title = "Chamado de "..Data["name"], text = Data["content"], x = Data["location"][1], y = Data["location"][2], z = Data["location"][3], time = "Recebido às "..os.date("%H:%M"), blipColor = 2 })

			if vRP.Request(Sources,"Aceitar o chamado de <b>"..Data["name"].."?","Sim","Não") then
				if not Answered then
					Answered = true
					TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_RESPONSE",{})
					TriggerClientEvent("smartphone:pusher",Sources,"GPS",{ location = Data["location"] })
				else
					TriggerClientEvent("Notify",Sources,"negado","Chamado atendido.",5000)
				end
			end
		end)
	end

	SetTimeout(30000,function()
		if not Answered then
			TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_REJECT",{})
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Request(source,Message,Accept,Reject)
	return REQUEST.Function(source,Message,Accept or "Sim",Reject or "Não")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Revive(source,Health,Arena)
	return SURVIVAL.Revive(source,Health,Arena)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP.DEVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Device(source,Seconds)
    return DEVICE.Device(source,Seconds)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetMapName(ServerName)
	SetGameType(ServerName)
	SetRoutingBucketEntityLockdownMode(0,"relaxed")
end)