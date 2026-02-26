-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Bahamas = {}
Tunnel.bindInterface("target",Bahamas)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPLATE (reads from garages export)
-----------------------------------------------------------------------------------------------------------------------------------------
function Bahamas.CheckPlate(Plate)
	return exports["garages"]:CheckPlate(Plate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Bahamas.CheckIn()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetHealth(source) <= 100 then
			if vRP.PaymentFull(Passport,1950) then
				vRP.UpgradeHunger(Passport,20)
				vRP.UpgradeThirst(Passport,20)
				TriggerEvent("Reposed",source,Passport,900)

				return true
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		else
			if vRP.Request(source,"Prosseguir o tratamento por <b>$1750</b> dólares?","Y","U") then
				if vRP.PaymentFull(Passport,1750) then
					vRP.UpgradeHunger(Passport,20)
					vRP.UpgradeThirst(Passport,20)
					TriggerEvent("Reposed",source,Passport,900)

					return true
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CALLWORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Calls = {}
RegisterServerEvent("target:CallWorks")
AddEventHandler("target:CallWorks",function(Perm)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Calls[Perm] then
			Calls[Perm] = os.time()
		end

		if os.time() >= Calls[Perm] then
			if Perm == "Paramedic" then
				TriggerClientEvent("Notify",-1,"amarelo","<b>Pillbox Medical:</b> Estamos em busca de doadores de sangue, seja solidário e ajude o próximo, procure um de nossos profissionais.",15000)
			else
				TriggerClientEvent("Notify",-1,"amarelo","<b>"..Perm..":</b> Estamos em busca de trabalhadores, compareça ao estabelecimento, procure um de nossos funcionários e consulte nosso serviço de entregas.",15000)
			end

			Calls[Perm] = os.time() + 600
		else
			local Cooldown = parseInt(Calls[Perm] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Cooldown.."</b> segundos.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CHARGEPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:ChargePlayer")
AddEventHandler("target:ChargePlayer",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.Passport(Entity[1])
		if OtherPassport then
			local Keyboard = vKEYBOARD.keySingle(source,"Valor:")
			if Keyboard then
				local Amount = parseInt(Keyboard[1])
				if Amount > 0 then
					if vRP.Request(Entity[1],"Você aceita pagar <b>$"..Amount.."</b> dólares para <b>"..vRP.Identity(Passport)["name"].."</b>?","Y","U") then
						if vRP.PaymentFull(OtherPassport,Amount) then
							vRP.GiveBank(Passport,Amount)
							TriggerClientEvent("Notify",source,"verde","Recebimento concluído.",5000)
							TriggerClientEvent("Notify",Entity[1],"verde","Pagamento concluído.",5000)
						else
							TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
						end
					end
				end
			end
		end
	end
end)
