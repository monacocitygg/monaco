-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local TackleRange = 1.8 -- distância máxima pra empurrar (metros)
local TackleAnimDict = "missfinale_c2ig_11"
local TackleAnimName = "pushout_straddle_michael"
local TackleAnimDuration = 400 -- ms da animação antes do ragdoll

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO: PEGAR PLAYER MAIS PRÓXIMO DENTRO DO ALCANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function getClosestPlayer(range)
	local myPed = PlayerPedId()
	local myPos = GetEntityCoords(myPed)
	local closest, closestPed, closestDist = nil, nil, range + 1

	for _, v in ipairs(GetActivePlayers()) do
		local tPed = GetPlayerPed(v)
		if tPed ~= myPed and not IsPedInAnyVehicle(tPed) and not IsEntityDead(tPed) then
			local tPos = GetEntityCoords(tPed)
			local dist = #(myPos - tPos)
			if dist < closestDist then
				closest = v
				closestPed = tPed
				closestDist = dist
			end
		end
	end

	if closest then
		return closest, closestPed, closestDist
	end

	return nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 100
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) and not IsPedRagdoll(Ped) then
				TimeDistance = 1

				if IsControlJustReleased(1, 51) then
					local target, targetPed = getClosestPlayer(TackleRange)

					if target then
						-- Virar em direção ao alvo
						local tPos = GetEntityCoords(targetPed)
						local mPos = GetEntityCoords(Ped)
						local heading = GetHeadingFromVector_2d(tPos.x - mPos.x, tPos.y - mPos.y)
						SetEntityHeading(Ped, heading)
						Wait(0)

						-- Animação de empurrar
						RequestAnimDict(TackleAnimDict)
						while not HasAnimDictLoaded(TackleAnimDict) do Wait(1) end
						TaskPlayAnim(Ped, TackleAnimDict, TackleAnimName, 8.0, -8.0, TackleAnimDuration, 0, 0, false, false, false)
						Wait(TackleAnimDuration)
						ClearPedTasks(Ped)
						RemoveAnimDict(TackleAnimDict)

						-- Ragdoll no atacante
						local fwd = GetEntityForwardVector(Ped)
						SetPedToRagdollWithFall(Ped, 2500, 1500, 0, fwd, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

						-- Derrubar o alvo via server
						TriggerEvent("inventory:Cancel")
						TriggerServerEvent("tackle:Update", GetPlayerServerId(target), { fwd["x"], fwd["y"], fwd["z"] })
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TACKLE:PLAYER (quem recebe o empurrão)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tackle:Player")
AddEventHandler("tackle:Player", function(Coords)
	local Ped = PlayerPedId()

	-- Animação de empurrar antes de cair
	RequestAnimDict(TackleAnimDict)
	while not HasAnimDictLoaded(TackleAnimDict) do Wait(1) end
	TaskPlayAnim(Ped, TackleAnimDict, TackleAnimName, 8.0, -8.0, 300, 0, 0, false, false, false)
	Wait(200)
	ClearPedTasks(Ped)
	RemoveAnimDict(TackleAnimDict)

	-- Ragdoll na vítima
	SetPedToRagdollWithFall(Ped, 5000, 5000, 0, Coords[1], Coords[2], Coords[3], 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	TriggerEvent("inventory:Cancel")
end)