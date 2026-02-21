-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("admin",Creative)
vSERVER = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVISIBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Spectate"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.teleportWay()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		Ped = GetVehiclePedIsUsing(Ped)
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(GetBlipInfoIdCoord(waypointBlip,Citizen.ResultAsVector()))

	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(Ped,x,y,height,false,false,false)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(Ped) do
			Wait(1)
		end

		Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(Ped,0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(Ped) do
		Wait(1)
	end

	SetEntityCoordsNoOffset(Ped,x,y,z,false,false,false)
end

RegisterNetEvent("admin:blips")
AddEventHandler("admin:blips",function(players)
    Blipmin = not Blipmin

    while Blipmin do
        for Entity, v in pairs(GetPlayers()) do
            local playerID = GlobalState["Players"][v]
            if playerID then
                local fullName = players[playerID]["fullName"] -- FullName(Passport)
                DrawText3D(GetEntityCoords(Entity), "~o~ID:~w~ " .. playerID .. "     ~g~Vida:~w~ " .. GetEntityHealth(Entity) .. "     ~y~Colete:~w~ " .. GetPedArmour(Entity).. "     ~b~Nome:~w~ " .. fullName, 0.425)
            end
        end

        Wait(0)
    end

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.teleportLimbo()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local _,xCoords = GetNthClosestVehicleNode(Coords["x"],Coords["y"],Coords["z"],1,0,0,0)

	SetEntityCoordsNoOffset(Ped,xCoords["x"],xCoords["y"],xCoords["z"] + 1,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:vehicleTuning")
AddEventHandler("admin:vehicleTuning",function()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local vehicle = GetVehiclePedIsUsing(Ped)

		SetVehicleModKit(vehicle,0)
		SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11) - 1,false)
		SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12) - 1,false)
		SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13) - 1,false)
		SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15) - 1,false)
		ToggleVehicleMod(vehicle,18,true)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			vSERVER.buttonTxt()
-- 		end
-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONMAKERACE
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			local Ped = PlayerPedId()
-- 			local vehicle = GetVehiclePedIsUsing(Ped)
-- 			local vehCoords = GetEntityCoords(vehicle)
-- 			local leftCoords = GetOffsetFromEntityInWorldCoords(vehicle,5.0,0.0,0.0)
-- 			local rightCoords = GetOffsetFromEntityInWorldCoords(vehicle,-5.0,0.0,0.0)

-- 			vSERVER.raceCoords(vehCoords,leftCoords,rightCoords)
-- 		end

-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:INITSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:initSpectate")
AddEventHandler("admin:initSpectate",function(source)
	if not NetworkIsInSpectatorMode() then
		local Pid = GetPlayerFromServerId(source)
		local Ped = GetPlayerPed(Pid)

		LocalPlayer["state"]["Spectate"] = true
		NetworkSetInSpectatorMode(true,Ped)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:resetSpectate")
AddEventHandler("admin:resetSpectate",function()
	if NetworkIsInSpectatorMode() then
		NetworkSetInSpectatorMode(false)
		LocalPlayer["state"]["Spectate"] = false
	end
end)


RegisterNetEvent('adminClothes')
AddEventHandler('adminClothes', function(custom)
    local ped = PlayerPedId()
    if GetEntityHealth(ped) > 101 then
        TriggerEvent("skinshop:Apply", custom)
    end
end)


------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
------------------------------------------------------------------------------------------------------------------------------
local dickheaddebug = false
local processedEntities = {}

RegisterCommand("debug2", function()
    dickheaddebug = not dickheaddebug
    if dickheaddebug then
        debug()
        TriggerEvent('chatMessage', "DEBUG", {255, 70, 50}, "ON")
    else
        TriggerEvent('chatMessage', "DEBUG", {255, 70, 50}, "OFF")
    end
end)

local pools = {
    CPed   = {},
    CObject = {},
}

function updatePools()
    pools.CPed = GetGamePool('CPed')
    pools.CObject = GetGamePool('CObject')
end

function debug()
    CreateThread(function()
        while dickheaddebug do
            processedEntities = {} -- Reset the set of processed entities each frame
            local playerPos = GetEntityCoords(PlayerPedId())
            for poolName, pool in pairs(pools) do
                for i = 1, #pool do
                    local entity = pool[i]
                    if DoesEntityExist(entity) then
                        local entityPos = GetEntityCoords(entity)
                        if #(playerPos - entityPos) <= 30 then
                            local inContact = IsEntityTouchingEntity(PlayerPedId(), entity)
                            if not processedEntities[entity] then
                                local entityType = poolName == "CPed" and "Ped" or "Object"
                                local entityModel = GetEntityModel(entity)
                                local text = string.format("Obj: %d Model: %d %s", entity, entityModel, inContact and "IN CONTACT" or "")
                                DrawText3Ds(entityPos.x, entityPos.y, entityPos.z + 1, text)
                                processedEntities[entity] = true
                            end
                        end
                    end
                end
            end
            Wait(0)
        end
    end)

    CreateThread(function()
        while dickheaddebug do
            Wait(5000)
            updatePools()
        end
    end)
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

-- Comando para abrir o mapa
RegisterCommand('abrirMapa', function()
    -- Abrir o mapa como se fosse o ESC
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), false, -1)
end, false)

-- Mapeamento da tecla
RegisterKeyMapping('abrirMapa', 'Abrir mapa (ESC) com P', 'keyboard', 'P')


local deleteTime = 60
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(deleteTime * 60 * 1000)

        TriggerClientEvent("Notify",-1,"azul","Todos os veículos desocupados serão recolhidos em 60 segundos.",60000)

        Citizen.Wait(60 * 1000)

        local deletedVehicles = 0
        for _, entity in ipairs(GetAllVehicles()) do
            if DoesEntityExist(entity) then
                local pedOutVehicle = (GetPedInVehicleSeat(entity, -1) == 0)
                if pedOutVehicle then
                    DeleteEntity(entity)
                    deletedVehicles = deletedVehicles + 1
                end
            end
        end
        TriggerClientEvent("Notify",-1,"vermelho","Foram limpos "..deletedVehicles.." veículos.",60000)
    end
end)

