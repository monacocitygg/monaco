-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("engine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local isPrice = 0
local lastFuel = 0
local LastPump = 0
local pumpGunInHand = false
local pumpGunInCar = false
local currentPumpRope = nil
local PumpCoords = vec3(0.0,0.0,0.0)
local PumpConfig = {}
local currentPumpEntity = nil
local currentPropWheelCoords = vec3(0.0,0.0,0.0)
local fuelVeh = {}
local isFuel = false
local showNui = false
local lastVehicleInFuel = nil
local lastVehicleIsPlane = nil
local gameTimer = GetGameTimer()
local lastGameTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(eventName,args)
	if eventName == "CEventNetworkPlayerEnteredVehicle" then
		if args[1] == PlayerId() then
			local Plate = GetVehicleNumberPlateText(args[2])
			if GetEntityModel(args[2]) == `rcbandito` then
				fuelVeh[Plate] = 100.0
			else
				fuelVeh[Plate] = vSERVER.vehicleFuel(Plate)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCLASS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehClass = {
	[0] = 1.0,
	[1] = 1.0,
	[2] = 1.0,
	[3] = 1.0,
	[4] = 1.0,
	[5] = 1.0,
	[6] = 1.0,
	[7] = 1.0,
	[8] = 1.0,
	[9] = 1.0,
	[10] = 1.0,
	[11] = 1.0,
	[12] = 1.0,
	[13] = 0.0,
	[14] = 0.0,
	[15] = 1.5,
	[16] = 1.0,
	[17] = 1.0,
	[18] = 1.0,
	[19] = 1.0,
	[20] = 1.0,
	[21] = 0.0,
	[22] = 1.0
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
local vehFuel = {
	[1.0] = 0.50,
	[0.9] = 0.45,
	[0.8] = 0.40,
	[0.7] = 0.35,
	[0.6] = 0.30,
	[0.5] = 0.25,
	[0.4] = 0.20,
	[0.3] = 0.15,
	[0.2] = 0.10,
	[0.1] = 0.05,
	[0.0] = 0.00
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUELLOCS
-----------------------------------------------------------------------------------------------------------------------------------------
local fuelLocs = {
	["1"] = { -2096.24,-320.21,13.16,	15.0	,0.065,true,false },
	["2"] = { 178.36,6604.46,31.86,		10.0	,0.065,true,false },
	["3"] = { 265.05,-1262.65,29.3,		15.0	,0.085,false,false },
	["4"] = { 819.14,-1028.65,26.41,	15.0	,0.085,false,false },
	["5"] = { 1208.61,-1402.43,35.23,	15.0	,0.065,false,false },
	["6"] = { 1181.48,-330.26,69.32,	10.0	,0.075,false,false },
	["7"] = { 621.01,268.68,103.09,		15.0	,0.075,false,false },
	["8"] = { 2581.09,361.79,108.47,	17.0	,0.055,false,false },
	["9"] = { 175.08,-1562.12,29.27,	15.0	,0.075,false,false },
	["10"] = { -319.76,-1471.63,30.55,	17.0	,0.075,false,false },
	["11"] = { 1784.51,3330.1,41.27,	8.0		,0.085,false,false },
	["12"] = { 49.42,2778.8,58.05,		15.0	,0.055,false,false },
	["13"] = { 264.09,2606.56,44.99,	15.0	,0.065,false,false },
	["14"] = { 1039.38,2671.28,39.56,	15.0	,0.065,false,false },
	["15"] = { 1207.4,2659.93,37.9,		10.0	,0.065,false,false },
	["16"] = { 2539.19,2594.47,37.95,	9.0		,0.055,false,false },
	["17"] = { 2679.95,3264.18,55.25,	10.0	,0.065,false,false },
	["18"] = { 2005.03,3774.43,32.41,	15.0	,0.075,false,false },
	["19"] = { 1687.07,4929.53,42.08,	15.0	,0.055,false,false },
	["20"] = { 1701.53,6415.99,32.77,	10.0	,0.065,false,false },
	["21"] = { -94.46,6419.59,31.48,	15.0	,0.085,false,false },
	["22"] = { -2555.17,2334.23,33.08,	16.0	,0.065,false,false },
	["23"] = { -1800.09,803.54,138.72,	16.0	,0.065,false,false },
	["24"] = { -1437.0,-276.8,46.21,	15.0	,0.075,false,false },
	["25"] = { -724.56,-935.97,19.22,	17.0	,0.075,false,false },
	["26"] = { -525.26,-1211.19,18.19,	15.0	,0.075,false,false },
	["27"] = { -70.96,-1762.21,29.54,	15.0	,0.085,false,false },
	["28"] = { -1112.4,-2884.08,13.93,	30.0	,0.095,false,false },
	["29"] = { -2505.68,4079.25,38.79,	8.0		,0.075,false,false },
	["30"] = { 2505.42,4079.81,38.79,	8.0		,0.075,false,false },
	["31"] = { -705.32,-1465.06,5.04,	25.0	,0.095,false,false },
	["32"] = { 303.52,-1448.71,45.52,	25.0	,0.095,false,false },
	["33"] = { 317.31,-1460.28,45.52,	25.0	,0.095,false,false },
}

local gasPumpModels = {
	{ GetHashKey("prop_gas_pump_1d"), 0.0,0.0,2.3 },
	{ GetHashKey("prop_gas_pump_1a"), 0.0,0.0,2.3 },
	{ GetHashKey("prop_gas_pump_1b"), 0.0,0.0,2.3 },
	{ GetHashKey("prop_gas_pump_1c"), 0.0,0.0,2.3 },
	{ 0x1CF9D53D, 0.0,0.0,2.3 },
	{ GetHashKey("prop_vintage_pump"), 0.0,0.0,1.8 },
	{ GetHashKey("prop_gas_pump_old2"), 0.0,0.0,1.6 },
	{ GetHashKey("prop_gas_pump_old3"), 0.0,0.0,1.6 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ELETRIC
-----------------------------------------------------------------------------------------------------------------------------------------
local Eletric = {
	[1392481335] = false,
	[-1529242755] = false,
	[-1848994066] = false,
	[-1622444098] = false,
	[1031562256] = false,
	[-1130810103] = false,
	[-1132721664] = false,
	[544021352] = false,
	[1147287684] = false,
	[1491375716] = false,
	[1560980623] = false,
	[989294410] = false,
	[-1894894188] = false,
	[-1558566249] = false,
	[1673934297] = false,
	[-1027629791] = false,
	[662793086] = false
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FLOOR
-----------------------------------------------------------------------------------------------------------------------------------------
function floor(num)
	local mult = 10 ^ 1
	return math.floor(num * mult + 0.5) / mult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSUMEFUEL
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsUsing(ped)
			local speed = GetEntitySpeed(vehicle) * 2.236936
			if GetVehicleFuelLevel(vehicle) >= 1 then
				if speed >= 1 then
					local Plate = GetVehicleNumberPlateText(vehicle)

					if fuelVeh[Plate] ~= nil then
						local vehClasses = GetVehicleClass(vehicle)

						fuelVeh[Plate] = (fuelVeh[Plate] - (vehFuel[floor(GetVehicleCurrentRpm(vehicle))] or 1.0) * (vehClass[vehClasses] or 1.0) / 10)
						SetVehicleFuelLevel(vehicle,fuelVeh[Plate])
					end

					if GetPedInVehicleSeat(vehicle,-1) == ped then
						TriggerServerEvent("engine:tryFuel",Plate,fuelVeh[Plate])
					end
				end
			else
				SetVehicleEngineOn(vehicle,false,true,true)
				timeDistance = 1
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREDREFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
local vehiclesBlacklist = {
	[`kwid`] = true,
	[`betazoe`] = true
}

Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local vehicle = GetPlayersLastVehicle()
				local vehModel = GetEntityModel(vehicle)
				if GetSelectedPedWeapon(ped) == 883325847 then
					if DoesEntityExist(vehicle) and not vehiclesBlacklist[vehModel] then
						local coords = GetEntityCoords(ped)
						local coordsVeh = GetEntityCoords(vehicle)
						local vehFuel = GetVehicleFuelLevel(vehicle)
						local Plate = GetVehicleNumberPlateText(vehicle)
						local distance = #(coords - vector3(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"]))
						if distance <= 3.5 then
							timeDistance = 1

							if not isFuel then
								if GetAmmoInPedWeapon(ped,883325847) - 0.02 * 100 <= 1 then
									text3D(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"] + 1,"~b~GALÃO VAZIO")
								elseif vehFuel < 100.0 then
									text3D(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"] + 1,"~g~E~w~   ABASTECER")
								end
							else
								if GetAmmoInPedWeapon(ped,883325847) - 0.02 * 100 > 1 then
									SetPedAmmo(ped,883325847,math.floor(GetAmmoInPedWeapon(ped,883325847) - 0.02 * 100))

									SetVehicleFuelLevel(vehicle,vehFuel + 0.025)
									text3D(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"] + 1,"~g~E~w~   CANCELAR")
									text3D(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"] + 0.85,"TANQUE: ~y~"..parseInt(floor(vehFuel)).."%   ~w~GALÃO: ~y~"..parseInt(GetAmmoInPedWeapon(ped,883325847) / 4500 * 100).."%")

									if not IsEntityPlayingAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3) then
										TaskPlayAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3.0,3.0,-1,50,0,0,0,0)
									end

									if vehFuel >= 100.0 or GetAmmoInPedWeapon(ped,883325847) - 0.02 * 100 <= 1 or GetEntityHealth(ped) <= 101 then
										TriggerServerEvent("engine:tryFuel",Plate,vehFuel)
										StopAnimTask(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
										RemoveAnimDict("timetable@gardener@filling_can")
										isFuel = false
										lastVehicleInFuel = nil
										lastVehicleIsPlane = nil
									end
								end
							end

							if IsControlJustPressed(1,38) and GetGameTimer() >= gameTimer then
								gameTimer = GetGameTimer() + 3000

								if isFuel then
									TriggerServerEvent("engine:tryFuel",Plate,vehFuel)
									StopAnimTask(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
									RemoveAnimDict("timetable@gardener@filling_can")
									isFuel = false
									lastVehicleInFuel = nil
									lastVehicleIsPlane = nil
								else
									if GetAmmoInPedWeapon(ped,883325847) - 0.02 * 100 >= 0 and vehFuel <= 100.0 then
										TaskTurnPedToFaceEntity(ped,vehicle,5000)
										loadAnim("timetable@gardener@filling_can")
										TaskPlayAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3.0,3.0,-1,50,0,0,0,0)
										isFuel = true
										lastVehicleInFuel = vehicle
										lastVehicleIsPlane = IsThisModelAPlane(vehModel) or IsThisModelAHeli(vehModel)
									end
								end
							end
						end

						if isFuel and distance > 3.5 then
							TriggerServerEvent("engine:tryFuel",Plate,vehFuel)
							StopAnimTask(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
							RemoveAnimDict("timetable@gardener@filling_can")
							isFuel = false
							lastVehicleInFuel = nil
							lastVehicleIsPlane = nil
						end
					end
				else
					local coords = GetEntityCoords(ped)

					for k,v in pairs(fuelLocs) do
						local distance = #(coords - vector3(v[1],v[2],v[3]))
						if distance <= v[4] and ((v[7] and Eletric[vehModel]) or (not v[7] and not Eletric[vehModel])) then
							timeDistance = 1
							local vehicle = GetPlayersLastVehicle()
							if DoesEntityExist(vehicle) and not vehiclesBlacklist[vehModel]  then
								local coordsVeh = GetEntityCoords(vehicle)
								local vehFuel = GetVehicleFuelLevel(vehicle)
								local Plate = GetVehicleNumberPlateText(vehicle)
								local distanceToVeh = #(coords - vector3(coordsVeh["x"],coordsVeh["y"],coordsVeh["z"]))

								if not pumpGunInHand then
									for _,p in ipairs(gasPumpModels) do
										LastPump = GetClosestObjectOfType(coords.x,coords.y,coords.z,2.5,p[1],false,false,false)
										if LastPump and DoesEntityExist(LastPump) then
											PumpCoords = GetEntityCoords(LastPump)
											PumpConfig = p
											break
										end
									end
								end
								local distanceToPump = #(coords - PumpCoords)

								if distanceToPump > 5.0 and pumpGunInHand then
									pumpGunInHand = false
									pumpGunInCar = false
									DetachEntity(currentPumpEntity, false, false)
									TriggerServerEvent("engine:remPumpEntity",ObjToNet(currentPumpEntity))
									DeleteEntity(currentPumpEntity)
									RopeUnloadTextures()
									DeleteRope(currentPumpRope)
									LastPump = nil
								end

								if not pumpGunInHand and distanceToPump < 2.0 and vehFuel < 100.0 then
									while not RopeAreTexturesLoaded() do
										RopeLoadTextures()
										Citizen.Wait(1)
									end

									text3D(PumpCoords.x,PumpCoords.y,PumpCoords.z + 1,"~g~E~w~   ABASTECER")

									if IsControlJustPressed(1,38) and GetGameTimer() >= gameTimer then
										pumpGunInHand = true
										pumpGunInCar = false
										gameTimer = GetGameTimer() + 3000
										vRP.removeObjects()
										LoadModel(`prop_cs_fuel_nozle`)
										currentPumpEntity = CreateObjectNoOffset(`prop_cs_fuel_nozle`, coords.x,coords.y,coords.z, true, true, false)
										local pumpNetId = ObjToNet(currentPumpEntity)
										SetEntityCollision(currentPumpEntity, false, false)
										AttachEntityToEntity(currentPumpEntity,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),60309), 0.055, 0.05, 0.0, -50.0, -90.0, -50.0,true,true,false,true,0,true)
										local RopePumpOffset = GetOffsetFromEntityInWorldCoords(currentPumpEntity, 0.0, -0.02, -0.175)
										local RopeLength = 3.5
										currentPumpRope = AddRope(PumpCoords.x+PumpConfig[2],PumpCoords.y+PumpConfig[3],PumpCoords.z+PumpConfig[4], 0.0, 0.0, 0.0, RopeLength, 4, RopeLength, 1.0, 0.0, false, false, false, 2.0, 0)
										AttachEntitiesToRope(currentPumpRope, LastPump, currentPumpEntity, PumpCoords.x+PumpConfig[2],PumpCoords.y+PumpConfig[3],PumpCoords.z+PumpConfig[4], RopePumpOffset.x, RopePumpOffset.y, RopePumpOffset.z, RopeLength, false, false, nil, nil)
										StartRopeWinding(currentPumpRope)
										ActivatePhysics(currentPumpRope)
									end
								end

								if pumpGunInHand and distanceToVeh <= 3.5 then
									if not isFuel then
										text3D(PumpCoords.x,PumpCoords.y,PumpCoords.z + 1,"~g~BACKSPACE~w~   Cancelar")
										if IsControlJustPressed(1,177) then
											pumpGunInHand = false
											pumpGunInCar = false
											DetachEntity(currentPumpEntity, false, false)
											TriggerServerEvent("engine:remPumpEntity",ObjToNet(currentPumpEntity))
											DeleteEntity(currentPumpEntity)
											RopeUnloadTextures()
											DeleteRope(currentPumpRope)
											LastPump = nil
										end
										
										if pumpGunInCar and vehFuel < 100.0 then
											text3D(currentPropWheelCoords["x"],currentPropWheelCoords["y"],currentPropWheelCoords["z"] + 1,"~g~E~w~   ABASTECER")
										end
									else
										if not showNui then
											local Title = "Posto de Gasolina"
											local Legends = "Abastecimento de combustível"
											local Background = "url(background.png) rgba(15,15,15,.75)"
											
											SendNUIMessage({ action = "showFuel", tank = vehFuel })
										--	SendNUIMessage({ show = true, background = Background, title = Title, legends = Legends })
											showNui = true
										end
										
										isPrice = isPrice + v[5]
										SetVehicleFuelLevel(vehicle,vehFuel + 0.025)
										--SendNUIMessage({ tank = parseInt(floor(vehFuel)), price = parseInt(isPrice), lts = v[5] * 4 })
										SendNUIMessage({ action = "setFuel", tank = parseInt(floor(vehFuel)), price = parseInt(isPrice), lts = v[5] * 4 })
										text3D(currentPropWheelCoords["x"],currentPropWheelCoords["y"],currentPropWheelCoords["z"] + 1,"~g~E~w~   FINALIZAR")

										if not IsEntityPlayingAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3) then
											TaskPlayAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3.0,3.0,-1,50,0,0,0,0)
										end

										local explodePump = false
										if lastGameTimer < GetGameTimer() and GetIsVehicleEngineRunning(vehicle) then
											lastGameTimer = GetGameTimer() + 1000
											local Chance = math.random(100)
											if Chance < 39 then
												explodePump = true
												AddExplosion(coords.x,coords.y,coords.z, 34, 1.0, 1.0, true, true, false)
											end
										end

										if vehFuel >= 100.0 or GetEntityHealth(ped) <= 101 or explodePump then
											local Kmv = 0
											if v[6] then
												Kmv = isPrice * 0.25
											end

											if vSERVER.paymentFuel(isPrice,Plate,vehFuel,Kmv,Network) then
												TriggerServerEvent("engine:tryFuel",Plate,vehFuel)
												fuelVeh[Plate] = vehFuel
											else
												TriggerServerEvent("engine:tryFuel",Plate,lastFuel)
												fuelVeh[Plate] = lastFuel
											end

											StopAnimTask(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
											RemoveAnimDict("timetable@gardener@filling_can")
											SendNUIMessage({ action = "hideFuel" })
											showNui = false
											isFuel = false
											lastVehicleInFuel = nil
											lastVehicleIsPlane = nil
											isPrice = 0

											pumpGunInHand = false
											pumpGunInCar = false
											DetachEntity(currentPumpEntity, false, false)
											TriggerServerEvent("engine:remPumpEntity",ObjToNet(currentPumpEntity))
											DeleteEntity(currentPumpEntity)
											RopeUnloadTextures()
        									DeleteRope(currentPumpRope)
											LastPump = nil
										end
									end

									if IsControlJustPressed(1,38) and GetGameTimer() >= gameTimer and pumpGunInHand and pumpGunInCar then
										gameTimer = GetGameTimer() + 3000

										if isFuel then
											local Kmv = 0
											if v[6] then
												Kmv = isPrice * 0.25
											end

											if vSERVER.paymentFuel(isPrice,Plate,vehFuel,Kmv,Network) then
												TriggerServerEvent("engine:tryFuel",Plate,vehFuel)
												fuelVeh[Plate] = vehFuel
											else
												TriggerServerEvent("engine:tryFuel",Plate,lastFuel)
												fuelVeh[Plate] = lastFuel
											end

											StopAnimTask(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
											RemoveAnimDict("timetable@gardener@filling_can")
											SendNUIMessage({ action = "hideFuel" })
											showNui = false
											isFuel = false
											lastVehicleInFuel = nil
											lastVehicleIsPlane = nil
											isPrice = 0

											pumpGunInHand = false
											pumpGunInCar = false
											DetachEntity(currentPumpEntity, false, false)
											TriggerServerEvent("engine:remPumpEntity",ObjToNet(currentPumpEntity))
											DeleteEntity(currentPumpEntity)
											RopeUnloadTextures()
        									DeleteRope(currentPumpRope)
											LastPump = nil
										else
											local distanceToPumpWheel = #(coords - currentPropWheelCoords)
											if vehFuel < 100.0 and distanceToPumpWheel < 2.5 then
												lastFuel = vehFuel
												TaskTurnPedToFaceEntity(ped,vehicle,5000)
												loadAnim("timetable@gardener@filling_can")
												TaskPlayAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3.0,3.0,-1,50,0,0,0,0)
												isFuel = true
												lastVehicleInFuel = vehicle
												lastVehicleIsPlane = IsThisModelAPlane(vehModel) or IsThisModelAHeli(vehModel)
											end
										end
									end


									if pumpGunInHand and not pumpGunInCar then
										currentPropWheelCoords = GetWorldPositionOfEntityBone(vehicle,GetEntityBoneIndexByName(vehicle,"wheel_lr"))
										local distanceToPumpWheel = #(coords - currentPropWheelCoords)
										text3D(currentPropWheelCoords.x,currentPropWheelCoords.y,currentPropWheelCoords.z + 0.7,"~g~E~w~   ENCAIXAR")

										if IsControlJustPressed(1,38) and GetGameTimer() >= gameTimer and distanceToPumpWheel < 2.5+(lastVehicleIsPlane and 20.0 or 0.0)  then
											gameTimer = GetGameTimer() + 3000
											
											DetachEntity(currentPumpEntity, false, false)
											lastVehicleInFuel = vehicle
											lastVehicleIsPlane = IsThisModelAPlane(vehModel) or IsThisModelAHeli(vehModel)

											local isABike = IsThisModelABike(vehModel)
											local positionOffset = GetOffsetFromEntityGivenWorldCoords(vehicle, currentPropWheelCoords.x, currentPropWheelCoords.y, currentPropWheelCoords.z+0.7)
											AttachEntityToEntity(currentPumpEntity, vehicle, -1, positionOffset.x-(isABike and 0.25 or 0.1), positionOffset.y+(isABike and 0.9 or 0.0), positionOffset.z+(isABike and 0.1 or 0.0), isABike and -90.0 or -50.0, 0.0, -90.0, true, true, false, false, 0, true)
	
											pumpGunInCar = true
										end
									end

								end

								if isFuel and distanceToVeh > 3.5 then
									
									if vSERVER.paymentFuel(isPrice,Plate,vehFuel) then
										TriggerServerEvent("engine:tryFuel",Plate,vehFuel)
										fuelVeh[Plate] = vehFuel
									else
										TriggerServerEvent("engine:tryFuel",Plate,lastFuel)
										fuelVeh[Plate] = lastFuel
									end

									StopAnimTask(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
									RemoveAnimDict("timetable@gardener@filling_can")
									SendNUIMessage({ action = "hideFuel" })
									showNui = false
									isFuel = false
									isPrice = 0
									
									SetTimeout(3000,function()
										local lasTcoords = GetEntityCoords(lastVehicleInFuel)
										local distanceToPump = #(lasTcoords - PumpCoords)
										local explodePump = false
										if distanceToPump > 7.0+(lastVehicleIsPlane and 20.0 or 0.0) and pumpGunInCar then
											explodePump = true
											AddExplosion(lasTcoords.x,lasTcoords.y,lasTcoords.z, 34, 1.0, 1.0, true, true, false)
										end
										lastVehicleInFuel = nil
										lastVehicleIsPlane = nil
										pumpGunInHand = false
										pumpGunInCar = false
										DetachEntity(currentPumpEntity, false, false)
										TriggerServerEvent("engine:remPumpEntity",ObjToNet(currentPumpEntity))
										DeleteEntity(currentPumpEntity)
										RopeUnloadTextures()
										DeleteRope(currentPumpRope)
										LastPump = nil
										StopAnimTask(PlayerPedId(),"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
										RemoveAnimDict("timetable@gardener@filling_can")
									end)
								end

								if pumpGunInCar and pumpGunInHand and lastVehicleInFuel then
									local coords = GetEntityCoords(lastVehicleInFuel)
									local distanceToPump = #(coords - PumpCoords)
									if distanceToPump > 7.0+(lastVehicleIsPlane and 20.0 or 0.0) then
										AddExplosion(coords.x,coords.y,coords.z, 34, 1.0, 1.0, true, true, false)
										pumpGunInHand = false
										pumpGunInCar = false
										DetachEntity(currentPumpEntity, false, false)
										TriggerServerEvent("engine:remPumpEntity",ObjToNet(currentPumpEntity))
										DeleteEntity(currentPumpEntity)
										RopeUnloadTextures()
										DeleteRope(currentPumpRope)
										LastPump = nil
										lastVehicleInFuel = nil
										lastVehicleIsPlane = nil
									end
								end
							end
						end
						
					end
				end

				if isFuel then
					DisableControlAction(1,18,true)
					DisableControlAction(1,22,true)
					DisableControlAction(1,23,true)
					DisableControlAction(1,24,true)
					DisableControlAction(1,29,true)
					DisableControlAction(1,30,true)
					DisableControlAction(1,31,true)
					DisableControlAction(1,140,true)
					DisableControlAction(1,142,true)
					DisableControlAction(1,143,true)
					DisableControlAction(1,257,true)
					DisableControlAction(1,263,true)
				end
			else
				if not pumpGunInHand and DoesRopeExist(currentPumpRope) then
					DeleteRope(currentPumpRope)
					RopeUnloadTextures()
				end

				if pumpGunInCar and pumpGunInHand and lastVehicleInFuel then
					local coords = GetEntityCoords(lastVehicleInFuel)
					local distanceToPump = #(coords - PumpCoords)
					if distanceToPump > 7.0+(lastVehicleIsPlane and 20.0 or 0.0) then
						AddExplosion(coords.x,coords.y,coords.z, 34, 1.0, 1.0, true, true, false)
						pumpGunInHand = false
						pumpGunInCar = false
						DetachEntity(currentPumpEntity, false, false)
						TriggerServerEvent("engine:remPumpEntity",ObjToNet(currentPumpEntity))
						DeleteEntity(currentPumpEntity)
						RopeUnloadTextures()
						DeleteRope(currentPumpRope)
						LastPump = nil
						lastVehicleInFuel = nil
						lastVehicleIsPlane = nil
						StopAnimTask(PlayerPedId(),"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0)
						RemoveAnimDict("timetable@gardener@filling_can")
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:syncFuel")
AddEventHandler("engine:syncFuel",function(Plate,Result,Network)
	fuelVeh[Plate] = Result

	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleFuelLevel(Vehicle,fuelVeh[Plate] + 0.0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function text3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = (string.len(text) + 4) / 170 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function loadAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadModel(modelHash)
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            RequestModel(modelHash)
            Citizen.Wait(100)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPOINTINFRONTOFPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPointInfrontOfPosition(position, forward, distance)
	return vec3(position.x + forward.x * distance, position.y + forward.y * distance, position.z + forward.z * distance)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VTUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:vehTuning")
AddEventHandler("engine:vehTuning",function()
	local Vehicle = vRP.ClosestVehicle(5)
	if Vehicle then
		local motor = GetVehicleMod(Vehicle,11)
		local freio = GetVehicleMod(Vehicle,12)
		local transmissao = GetVehicleMod(Vehicle,13)
		local suspensao = GetVehicleMod(Vehicle,15)
		local blindagem = GetVehicleMod(Vehicle,16)
		local body = GetVehicleBodyHealth(Vehicle)
		local engine = GetVehicleEngineHealth(Vehicle)
		local fuel = GetVehicleFuelLevel(Vehicle)
		local plate = GetVehicleNumberPlateText(Vehicle)

		if motor == -1 then
			motor = "Desativado"
		elseif motor == 0 then
			motor = "Nível 1 / "..GetVehicleMod(Vehicle,11)
		elseif motor == 1 then
			motor = "Nível 2 / "..GetVehicleMod(Vehicle,11)
		elseif motor == 2 then
			motor = "Nível 3 / "..GetVehicleMod(Vehicle,11)
		elseif motor == 3 then
			motor = "Nível 4 / "..GetVehicleMod(Vehicle,11)
		elseif motor == 4 then
			motor = "Nível 5 / "..GetVehicleMod(Vehicle,11)
		end

		if freio == -1 then
			freio = "Desativado"
		elseif freio == 0 then
			freio = "Nível 1 / "..GetVehicleMod(Vehicle,12)
		elseif freio == 1 then
			freio = "Nível 2 / "..GetVehicleMod(Vehicle,12)
		elseif freio == 2 then
			freio = "Nível 3 / "..GetVehicleMod(Vehicle,12)
		end

		if transmissao == -1 then
			transmissao = "Desativado"
		elseif transmissao == 0 then
			transmissao = "Nível 1 / "..GetVehicleMod(Vehicle,13)
		elseif transmissao == 1 then
			transmissao = "Nível 2 / "..GetVehicleMod(Vehicle,13)
		elseif transmissao == 2 then
			transmissao = "Nível 3 / "..GetVehicleMod(Vehicle,13)
		elseif transmissao == 3 then
			transmissao = "Nível 4 / "..GetVehicleMod(Vehicle,13)
		end

		if suspensao == -1 then
			suspensao = "Desativado"
		elseif suspensao == 0 then
			suspensao = "Nível 1 / "..GetVehicleMod(Vehicle,15)
		elseif suspensao == 1 then
			suspensao = "Nível 2 / "..GetVehicleMod(Vehicle,15)
		elseif suspensao == 2 then
			suspensao = "Nível 3 / "..GetVehicleMod(Vehicle,15)
		elseif suspensao == 3 then
			suspensao = "Nível 4 / "..GetVehicleMod(Vehicle,15)
		elseif suspensao == 4 then
			suspensao = "Nível 5 / "..GetVehicleMod(Vehicle,15)
		end

		if blindagem == -1 then
			blindagem = "Desativado"
		elseif blindagem == 0 then
			blindagem = "Nível 1 / "..GetVehicleMod(Vehicle,16)
		elseif blindagem == 1 then
			blindagem = "Nível 2 / "..GetVehicleMod(Vehicle,16)
		elseif blindagem == 2 then
			blindagem = "Nível 3 / "..GetVehicleMod(Vehicle,16)
		elseif blindagem == 3 then
			blindagem = "Nível 4 / "..GetVehicleMod(Vehicle,16)
		elseif blindagem == 4 then
			blindagem = "Nível 5 / "..GetVehicleMod(Vehicle,16)
		end

		TriggerEvent("Notify","amarelo","<b>Motor:</b> "..motor.."<br><b>Freio:</b> "..freio.."<br><b>Transmissão:</b> "..transmissao.."<br><b>Suspensão:</b> "..suspensao.."<br><b>Blindagem:</b> "..blindagem.."<br><b>Lataria:</b> "..parseInt(body / 10).."%<br><b>Nitro:</b> "..parseInt((GlobalState["Nitro"][plate] or 0) / 10).."%<br><b>Motor:</b> "..parseInt(engine / 10).."%<br><b>Gasolina:</b> "..parseInt(fuel).."%",10000)
	end
end)