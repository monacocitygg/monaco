-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("tattoos",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSHARES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkShares()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		
		if vRP.GetFine(source) then
			if vRP.GetFine(source) > 0 then
				TriggerClientEvent("Notify",source,"vermelho","Multas pendentes encontradas.",3000)
				return false
			end
		end	

		if exports["hud"]:Reposed(Passport) or exports["hud"]:Wanted(Passport,source) then
			return false
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateTattoo(status)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Tatuagens", dvalue = json.encode(status) })
	end
end