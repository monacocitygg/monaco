-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("skinshop",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Check()
    local source = source
    local Passport = vRP.Passport(source)

    -- Bloqueia jogadores com o grupo "Castigo"
    if vRP.HasPermission(Passport, "Castigo", 1) then
        TriggerClientEvent("Notify", source, "vermelho", "Você está em castigo e não pode acessar o Skinshop.", 5000)
        return false
    end

	if vRP.GetHealth(source) <= 101 then
		TriggerClientEvent("Notify", source, "amarelo", "Você nao pode usar a Loja de Roupa Desmaiado(a).", 10000)
		return false
	end

    if Passport and not exports["hud"]:Reposed(Passport) and not exports["hud"]:Wanted(Passport) then
        return true
    end

    return false
end

RegisterCommand('mascara', function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    local vida = vRP.GetHealth(source)

    if vRP.GetHealth(source) <= 100 then
        TriggerClientEvent('Notify', source, 'vermelho', 'Você não pode fazer isso em coma.', 7500)
        return
    end

    if not Player(source)["state"]["Handcuff"] then
        if Passport then
            if vRP.HasGroup(Passport, "PremiumPrata") or 
               vRP.HasGroup(Passport, "PremiumOuro") or 
               vRP.HasGroup(Passport, "PremiumPlatina") or 
               vRP.HasGroup(Passport, "PremiumDiamante") or 
               vRP.HasGroup(Passport, "PremiumBlack") then
                TriggerClientEvent("setmascara", source, args[1], args[2])
            else
                local consultItem = vRP.InventoryItemAmount(Passport, "mask")
                if consultItem and consultItem[1] >= 1 then
                    TriggerClientEvent("setmascara", source, args[1], args[2])
                else
                    TriggerClientEvent('Notify', source, 'vermelho', 'Você não possui o item roupas no seu inventário.', 7500)
                end
            end
        end
    end
end)


function Creative.Update2(Skinshop)
    local source = source
    local Passport = vRP.Passport(source)
    local Clothings = Skinshop

    if Passport then
        vRP.Query("playerdata/SetData", { Passport = Passport, dkey = "Clothings", dvalue = json.encode(Clothings)})
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Clothes)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Clothings", dvalue = json.encode(Clothes) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:Remove")
AddEventHandler("skinshop:Remove",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if vRP.HasService(Passport,"Police") then
				TriggerClientEvent("skinshop:set"..Mode,ClosestPed)
			end
		end
	end
end)