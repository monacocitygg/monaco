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
Night = Tunnel.getInterface("Night_MedicoOFF")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local callActive = false
local ambulanceVehicle = nil
local ambulanceNPC = nil
local canCallAmbulance = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERCOMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Command, function(source, args, raw)
    if not Night.CheckPermission() then
        functions.NotifyNoPermission()
        return
    end
	if GetEntityHealth(PlayerPedId()) >= 101 then return end
    if Night.CheckIn() then
        SpawnVehicle(GetEntityCoords(PlayerPedId()))
        functions.NotifyAmbulanceComing()
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function SpawnVehicle(x, y, z)
	canCallAmbulance = false
	local vehhash = GetHashKey(Config.VehicleModel)
	local loc = GetEntityCoords(PlayerPedId())

	RequestModel(vehhash)
	while not HasModelLoaded(vehhash) do
		Wait(1)
	end

	RequestModel(Config.NPCModel)
	while not HasModelLoaded(Config.NPCModel) do
		Wait(1)
	end

	local spawnRadius = Config.DistanceSpawn

	local angle = math.random() * math.pi * 2
	local offsetX = math.cos(angle) * spawnRadius
	local offsetY = math.sin(angle) * spawnRadius

	local spawnX = loc.x + offsetX
	local spawnY = loc.y + offsetY

	local _, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, loc.z + 100.0, true)
	local spawnPos = vector3(spawnX, spawnY, groundZ + 1.0)

	if not DoesEntityExist(vehhash) then
		ambulanceVehicle = CreateVehicle(vehhash, spawnPos.x, spawnPos.y, spawnPos.z, GetEntityHeading(PlayerPedId()), true, false)
		ClearAreaOfVehicles(GetEntityCoords(ambulanceVehicle), 5.0, false, false, false, false, false)
		SetVehicleOnGroundProperly(ambulanceVehicle)
		SetVehicleNumberPlateText(ambulanceVehicle, "MEDICOFF")
		SetEntityAsMissionEntity(ambulanceVehicle, true, true)
		SetVehicleEngineOn(ambulanceVehicle, true, true, false)

		ambulanceNPC = CreatePedInsideVehicle(ambulanceVehicle, 26, GetHashKey(Config.NPCModel), -1, true, false)

		mechBlip = AddBlipForEntity(ambulanceVehicle)
		SetBlipFlashes(mechBlip, true)
		SetBlipColour(mechBlip, 5)

		PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
		Wait(2000)

		TaskVehicleDriveToCoord(
			ambulanceNPC,
			ambulanceVehicle,
			loc.x, loc.y, loc.z,
			20.0,
			0,
			GetEntityModel(ambulanceVehicle),
			524863,
			2.0
		)

		StartVehicleHorn(ambulanceVehicle, 100, GetHashKey("NORMAL"), false)
		SetVehicleSiren(ambulanceVehicle, true)
		callActive = true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if callActive and DoesEntityExist(ambulanceVehicle) and DoesEntityExist(ambulanceNPC) then
            local playerPed = PlayerPedId()
            local loc = GetEntityCoords(playerPed)
            local vehPos = GetEntityCoords(ambulanceVehicle)
            local npcPos = GetEntityCoords(ambulanceNPC)

            local distVehicle = #(loc - vehPos)
            local distNPC = #(loc - npcPos)

            if distVehicle <= 10.0 then
                TaskVehicleTempAction(ambulanceNPC, ambulanceVehicle, 27, 2000)
                TaskLeaveVehicle(ambulanceNPC, ambulanceVehicle, 0)
                callActive = false

                Citizen.SetTimeout(3000, function()
                    DoctorNPC()
                end)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOCTORNPC
-----------------------------------------------------------------------------------------------------------------------------------------
function DoctorNPC()
    local playerPed = PlayerPedId()
    local npc = ambulanceNPC

    if not DoesEntityExist(npc) then return end

    TaskGoToEntity(npc, playerPed, -1, 1.5, 2.0, 1073741824, 0)

    Citizen.CreateThread(function()
        local timeout = 15000
        local startTime = GetGameTimer()

        while #(GetEntityCoords(npc) - GetEntityCoords(playerPed)) > 2.0 do
            Citizen.Wait(500)
            if GetGameTimer() - startTime > timeout then
                return
            end
        end

        RequestAnimDict("amb@medic@standing@tendtodead@idle_a")
        while not HasAnimDictLoaded("amb@medic@standing@tendtodead@idle_a") do
            Citizen.Wait(100)
        end

        TaskPlayAnim(npc, "amb@medic@standing@tendtodead@idle_a", "idle_a", 8.0, -8.0, 5000, 1, 0, false, false, false)
        Citizen.Wait(5000)

        ClearPedTasksImmediately(npc)

        if DoesEntityExist(ambulanceVehicle) then
            TaskEnterVehicle(npc, ambulanceVehicle, -1, -1, 2.0, 1, 0)
            Citizen.Wait(500)
            SetPedIntoVehicle(playerPed, ambulanceVehicle, 2)

            HandleAmbulanceNPC()
        end
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDONPCTOHOSPITAL
-----------------------------------------------------------------------------------------------------------------------------------------
function SendNPCToHospital(playerPed, destination)
    local ambulance = ambulanceVehicle
    local npc = ambulanceNPC  
    TaskWarpPedIntoVehicle(playerPed, ambulance, 2) 
    TaskVehicleDriveToCoordLongrange(npc, ambulance, destination.x, destination.y, destination.z, 20.0, 786603, 5.0)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            if not IsPedInAnyVehicle(npc, false) or not IsVehicleOnAllWheels(ambulance) then
                TaskVehicleDriveToCoordLongrange(npc, ambulance, destination.x, destination.y, destination.z, 20.0, 786603, 5.0)
            end
          
            if HasNPCReachedDestination(npc, destination) then
				DoScreenFadeOut(400)
				Citizen.Wait(1000)   
				TaskLeaveVehicle(playerPed, ambulance, 64)
				TriggerEvent("Night:Treatment")
				StopScreenEffect('DeathFailOut')	
				
				RemovePedElegantly(ambulanceNPC)
				DeleteEntity(ambulanceVehicle)
				Citizen.Wait(5000)    
				DoScreenFadeIn(5000)
                canCallAmbulance = true
                break
            end
        end
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASNPCREACHEDDESTINATION
-----------------------------------------------------------------------------------------------------------------------------------------
function HasNPCReachedDestination(npc, destination, tolerance)
    local npcCoords = GetEntityCoords(npc)
    local distance = #(npcCoords - vector3(destination.x, destination.y, destination.z))
    return distance <= (tolerance or 10.0) 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEAMBULANCENPC
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleAmbulanceNPC()
    local playerPed = PlayerPedId()
    local destination = Config.Hospital 
    Citizen.Wait(1000) 
    SendNPCToHospital(playerPed, destination)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NIGHT:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night:Treatment")
AddEventHandler("Night:Treatment", function()
    local ped = PlayerPedId()
    local randomBed = Config.HospitalBeds[math.random(#Config.HospitalBeds)]

    SetEntityCoords(ped, randomBed.x, randomBed.y, randomBed.z, false, false, false, false)
    SetEntityHeading(ped, randomBed.w)

    TriggerServerEvent("Night:RevivePlayer")

    Citizen.Wait(500)

    local dict = "missfinale_c1@"
    local anim = "lying_dead_player0"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE NPC SE JOGADOR FOR REVIVIDO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        if callActive then
            local playerPed = PlayerPedId()
            if GetEntityHealth(playerPed) > 100 then
                if ambulanceNPC and DoesEntityExist(ambulanceNPC) then
                    ClearPedTasksImmediately(ambulanceNPC)
                    DeleteEntity(ambulanceNPC)
                    ambulanceNPC = nil
                end

                if ambulanceVehicle and DoesEntityExist(ambulanceVehicle) then
                    DeleteEntity(ambulanceVehicle)
                    ambulanceVehicle = nil
                end

                callActive = false
                canCallAmbulance = true
            end
        end
    end
end)