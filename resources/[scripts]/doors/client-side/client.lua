-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("doors")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSNEARBYCACHE
-----------------------------------------------------------------------------------------------------------------------------------------
local nearbyDoors = {}

CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local temp = {}

		for k,v in pairs(GlobalState["Doors"]) do
			local distance = #(coords - vector3(v["x"],v["y"],v["z"]))
			if distance <= (v["distance"] or 10) + 10.0 then
				temp[k] = v
			end
		end

		nearbyDoors = temp
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(nearbyDoors) do
			local distance = #(coords - vector3(v["x"],v["y"],v["z"]))
			if distance <= v["distance"] then
				local closestDoor = GetClosestObjectOfType(v["x"],v["y"],v["z"],v["distance"] + 0.0,v["hash"],false,false,false)
				if closestDoor then
					if v["lock"] then
						local _,h = GetStateOfClosestDoorOfType(v["hash"],v["x"],v["y"],v["z"])
						if h > -0.02 and h < 0.02 then
							FreezeEntityPosition(closestDoor,true)
						end
					else
						FreezeEntityPosition(closestDoor,false)
					end

					if distance <= v["press"] then
						timeDistance = 0

						if v["text"] then
							if v["lock"] then
								DrawText3D(v["x"],v["y"],v["z"],"🔒")
							else
								DrawText3D(v["x"],v["y"],v["z"],"🔓")
							end
						end

						if IsControlJustPressed(1,38) and vSERVER.doorsPermission(k) then
							v["lock"] = not v["lock"]
							vRP.playAnim(true,{"anim@heists@keycard@","exit"},false)
							vSERVER.doorsStatistics(k,v["lock"])
							Wait(350)
							vRP.stopAnim()
						end
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDPORTA / REMPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local addingDoor = false
local removingDoor = false
local doorGroup = nil

RegisterCommand("addporta",function(source,args)
	if not args[1] then
		TriggerEvent("Notify","vermelho","Utilize: /addporta [permissao]",5000)
		return
	end

	doorGroup = args[1]
	addingDoor = not addingDoor
	removingDoor = false

	if addingDoor then
		TriggerEvent("Notify","verde","Modo adicionar porta <b>ATIVADO</b>.<br>Aponte para uma porta e pressione <b>E</b>.",5000)
	else
		TriggerEvent("Notify","amarelo","Modo adicionar porta <b>DESATIVADO</b>.",5000)
	end
end)

RegisterCommand("remport",function(source,args)
	removingDoor = not removingDoor
	addingDoor = false

	if removingDoor then
		TriggerEvent("Notify","verde","Modo remover porta <b>ATIVADO</b>.<br>Aponte para uma porta e pressione <b>E</b>.",5000)
	else
		TriggerEvent("Notify","amarelo","Modo remover porta <b>DESATIVADO</b>.",5000)
	end
end)

RegisterNetEvent("doors:forceUnlock")
AddEventHandler("doors:forceUnlock",function(coords,hash)
	local closestDoor = GetClosestObjectOfType(coords.x,coords.y,coords.z,2.0,hash,false,false,false)
	if closestDoor then
		FreezeEntityPosition(closestDoor,false)
	end
end)

CreateThread(function()
	while true do
		local timeDistance = 999
		if addingDoor or removingDoor then
			timeDistance = 4
			
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			
			local hit, hitCoords, entity = RayCastGamePlayCamera(10.0)
			
			if hit and entity ~= 0 and GetEntityType(entity) == 3 then
				local model = GetEntityModel(entity)
				local entCoords = GetEntityCoords(entity)
				local min,max = GetModelDimensions(model)
				
				local pad = 0.1
				local r,g,b = 255,0,255
				if removingDoor then r,g,b = 255,0,0 end

				DrawLine(entCoords.x + min.x - pad, entCoords.y + min.y - pad, entCoords.z + min.z - pad, entCoords.x + max.x + pad, entCoords.y + min.y - pad, entCoords.z + min.z - pad, r, g, b, 255)
				DrawLine(entCoords.x + max.x + pad, entCoords.y + min.y - pad, entCoords.z + min.z - pad, entCoords.x + max.x + pad, entCoords.y + min.y - pad, entCoords.z + min.z - pad, r, g, b, 255)
				DrawLine(entCoords.x + max.x + pad, entCoords.y + max.y + pad, entCoords.z + min.z - pad, entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + min.z - pad, r, g, b, 255)
				DrawLine(entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + min.z - pad, entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + min.z - pad, r, g, b, 255)
				
				DrawLine(entCoords.x + min.x - pad, entCoords.y + min.y - pad, entCoords.z + max.z + pad, entCoords.x + max.x + pad, entCoords.y + min.y - pad, entCoords.z + max.z + pad, r, g, b, 255)
				DrawLine(entCoords.x + max.x + pad, entCoords.y + min.y - pad, entCoords.z + max.z + pad, entCoords.x + max.x + pad, entCoords.y + max.y + pad, entCoords.z + max.z + pad, r, g, b, 255)
				DrawLine(entCoords.x + max.x + pad, entCoords.y + max.y + pad, entCoords.z + max.z + pad, entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + max.z + pad, r, g, b, 255)
				DrawLine(entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + max.z + pad, entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + max.z + pad, r, g, b, 255)
				
				DrawLine(entCoords.x + min.x - pad, entCoords.y + min.y - pad, entCoords.z + min.z - pad, entCoords.x + min.x - pad, entCoords.y + min.y - pad, entCoords.z + max.z + pad, r, g, b, 255)
				DrawLine(entCoords.x + max.x + pad, entCoords.y + min.y - pad, entCoords.z + min.z - pad, entCoords.x + max.x + pad, entCoords.y + min.y - pad, entCoords.z + max.z + pad, r, g, b, 255)
				DrawLine(entCoords.x + max.x + pad, entCoords.y + max.y + pad, entCoords.z + min.z - pad, entCoords.x + max.x + pad, entCoords.y + max.y + pad, entCoords.z + max.z + pad, r, g, b, 255)
				DrawLine(entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + min.z - pad, entCoords.x + min.x - pad, entCoords.y + max.y + pad, entCoords.z + max.z + pad, r, g, b, 255)

				local text = "~g~E~w~ - ADICIONAR PORTA"
				if removingDoor then text = "~r~E~w~ - REMOVER PORTA" end

				DrawText3D(entCoords.x,entCoords.y,entCoords.z,text)

				if IsControlJustPressed(1,38) then
					if addingDoor then
						print("DEBUG: Pressionou E. Tentando adicionar porta.")
						TriggerServerEvent("doors:addDoor",entCoords,model,doorGroup)
						TriggerEvent("Notify","verde","Solicitação enviada...",5000)
					elseif removingDoor then
						print("DEBUG: Pressionou E. Tentando remover porta.")
						TriggerServerEvent("doors:removeDoor",entCoords,model)
						TriggerEvent("Notify","verde","Solicitação de remoção enviada...",5000)
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)

function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = {
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}

	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 16, PlayerPedId(), 0))

	return b, c, e
end

function RotationToDirection(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)
	end
end
