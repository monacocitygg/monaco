-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vGARAGES = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("pdm",Creative)
vCLIENT = Tunnel.getInterface("pdm")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local function HasGarageSpace(Passport)
	local Capacity = 3
	if vRP.HasGroup(Passport,"Painite") then
		Capacity = 4
	elseif vRP.HasGroup(Passport,"Serendibite") then
		Capacity = 4
	end
	local Owned = 0
	local All = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })
	for _,v in pairs(All) do
		if v["work"] == "false" then
			Owned = Owned + 1
		end
	end
	return Owned < Capacity
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Verify()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		-- if vRP.GetFine(Passport) > 0 then
		-- 	TriggerClientEvent("Notify",source,"amarelo","Você possui multas pendentes.",10000)
		-- 	return false
		-- end

		if exports["hud"]:Wanted(Passport,source) and exports["hud"]:Reposed(Passport) then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Buy(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] then
			Active[Passport] = true

			if VehicleGems(Name) > 0 then
				if VehicleMode(Name) == "Rental" then
					local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
					if vehicle[1] then
						TriggerClientEvent("Notify",source,"amarelo","Já possui um <b>"..VehicleName(Name).."</b>.",3000)
						Active[Passport] = nil
						return
					end

					local VehiclePrice = VehicleGems(Name)
					local Text = "Alugar o veículo <b>"..VehicleName(Name).."</b> por <b>"..VehiclePrice.."</b> gemas?"

					if vRP.ConsultItem(Passport,"rentalveh",1) then
						Text = "Alugar o veículo <b>"..VehicleName(Name).."</b> usando o vale?"
					end

					if vRP.Request(source,Text,"Y","U") then
						if not HasGarageSpace(Passport) then
							TriggerClientEvent("Notify",source,"amarelo","Limite de vagas da garagem atingido.",5000)
							Active[Passport] = nil
							return
						end
						if vRP.TakeItem(Passport,"rentalveh",1,true) or vRP.PaymentGems(Passport,VehiclePrice) then
							local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
							if vehicle[1] then
								if vehicle[1]["rental"] <= os.time() then
									vRP.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
									TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.",5000)
								else
									vRP.Query("vehicles/rentalVehiclesDays",{ Passport = Passport, vehicle = Name })
									TriggerClientEvent("Notify",source,"verde","Adicionado <b>30 Dias</b> de aluguel no veículo <b>"..VehicleName(Name).."</b>.",5000)
								end
							else
								vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "false" })
								TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
						end
					end
				else
					local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
					if vehicle[1] then
						TriggerClientEvent("Notify",source,"amarelo","Já possui um <b>"..VehicleName(Name).."</b>.",3000)
						Active[Passport] = nil
						return
					else
						local VehiclePrice = VehicleGems(Name)
						if vRP.Request(source,"Comprar <b>"..VehicleName(Name).."</b> por <b>"..parseFormat(VehiclePrice).."</b> diamantes?","Y","U") then
							if not HasGarageSpace(Passport) then
								TriggerClientEvent("Notify",source,"amarelo","Limite de vagas da garagem atingido.",5000)
								Active[Passport] = nil
								return
							end
							if vRP.PaymentGems(Passport,VehiclePrice) then
								vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "false" })
								TriggerClientEvent("Notify",source,"verde","Compra concluída.",5000)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>Diamantes</b> insuficientes.",5000)
							end
						end
					end
				end
				Active[Passport] = nil
			else
				local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				if vehicle[1] then
					TriggerClientEvent("Notify",source,"amarelo","Já possui um <b>"..VehicleName(Name).."</b>.",3000)
					Active[Passport] = nil
					return
				else
					if VehicleMode(Name) == "work" then
						local Price = VehiclePrice(Name)
						if vRP.HasGroup(Passport,"Painite") then
							Price = math.floor(Price * 0.85)
						elseif vRP.HasGroup(Passport,"Serendibite") then
							Price = math.floor(Price * 0.95)
						end
						if vRP.PaymentFull(Passport,Price) then
							vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "true" })
							TriggerClientEvent("Notify",source,"verde","Compra concluída.",5000)
						else
							TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
						end
					else
						local VehiclePrice = VehiclePrice(Name)
						if vRP.HasGroup(Passport,"Painite") then
							VehiclePrice = math.floor(VehiclePrice * 0.85)
						elseif vRP.HasGroup(Passport,"Serendibite") then
							VehiclePrice = math.floor(VehiclePrice * 0.95)
						end
						if vRP.Request(source,"Comprar <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(VehiclePrice).."</b> dólares?","Y","U") then
							if not HasGarageSpace(Passport) then
								TriggerClientEvent("Notify",source,"amarelo","Limite de vagas da garagem atingido.",5000)
								Active[Passport] = nil
								return
							end
							if vRP.PaymentFull(Passport,VehiclePrice) then
								vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "false" })
								TriggerClientEvent("Notify",source,"verde","Compra concluída.",5000)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
							end
						end
					end
				end
	
				Active[Passport] = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckDrive()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] then
			Active[Passport] = true

			if not exports["hud"]:Wanted(Passport) then
				if vRP.Request(source,"Iniciar o teste por <b>$100</b> dólares?","Y","U") then
					if vRP.PaymentFull(Passport,100) then
						TriggerEvent("vRP:BucketServer",source,"Enter",Passport)
						Active[Passport] = nil

						return true
					else
						TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
					end
				end
			end

			Active[Passport] = nil
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RemoveDrive()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("vRP:BucketServer",source,"Exit")
		TriggerClientEvent("Notify",source,"azul","Eai, gostou do veículo que estava testando?",5000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)
