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
Tunnel.bindInterface("survival",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Death = false
local DeathTimer = 250
local Cooldown = GetGameTimer()
local DeathUIVisible = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999

		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) <= 100 then
				if not Death then
					Death = true

					if LocalPlayer["state"]["Rope"] then
						DetachEntity(Ped,false,false)
						LocalPlayer["state"]:set("Rope",false,true)
						TriggerServerEvent("inventory:ropeClean")
					end

					local Coords = GetEntityCoords(Ped)
					NetworkResurrectLocalPlayer(Coords,0.0)

					NetworkSetFriendlyFireOption(true)
					SetEntityInvincible(Ped,true)
					SetEntityHealth(Ped,100)

					if LocalPlayer["state"]["Route"] < 900000 then
						if LocalPlayer["state"]["Vippolice"] then
							DeathTimer = 125
						else
							DeathTimer = 250
						end

						TriggerEvent("hud:RemoveHood")
						TriggerEvent("hud:ScubaRemove")
						TriggerEvent("radio:RadioClean")
						TriggerEvent("inventory:Cancel")
						TriggerEvent("inventory:CleanWeapons")
						TriggerServerEvent("paramedic:bloodDeath")
						TriggerServerEvent("pma-voice:toggleMute",true)
					else
						DeathTimer = 5
					end

					SendNUIMessage({ Action = "Display", Mode = "block" })
					if not LocalPlayer["state"]["Spectate"] then
						SendNUIMessage({ Action = "Display", Mode = "block" })
						DeathUIVisible = true
					else
						DeathUIVisible = false
					end
					vRP.playAnim(false,{"dead","dead_a"},true)
					TriggerEvent("inventory:Close")
				else
					TimeDistance = 1
					SetEntityHealth(Ped,100)

					DisableControlAction(1,18,true)
					if LocalPlayer["state"]["Spectate"] then
						if DeathUIVisible then
							SendNUIMessage({ Action = "Display", Mode = "none" })
							DeathUIVisible = false
						end
					else
						if not DeathUIVisible then
							SendNUIMessage({ Action = "Display", Mode = "block" })
							DeathUIVisible = true
						end
					end

					DisableControlAction(1,22,true)
					DisableControlAction(1,24,true)
					DisableControlAction(1,25,true)
					DisableControlAction(1,68,true)
					DisableControlAction(1,70,true)
					DisableControlAction(1,70,true)
					DisableControlAction(1,91,true)
					DisableControlAction(1,69,true)
					DisableControlAction(1,75,true)
					DisableControlAction(1,140,true)
					DisableControlAction(1,142,true)
					DisableControlAction(1,257,true)
					DisablePlayerFiring(Ped,true)

					if not IsEntityPlayingAnim(Ped,"dead","dead_a",3) and not IsPedInAnyVehicle(Ped) and not IsEntityPlayingAnim(Ped,"nm","firemans_carry",3) then
						vRP.playAnim(false,{"dead","dead_a"},true)
					end

					if IsPedInAnyVehicle(Ped) then
						local Vehicle = GetVehiclePedIsUsing(Ped)
						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
							SetVehicleEngineOn(Vehicle,false,true,true)
						end
					end

					if LocalPlayer["state"]["Route"] > 900000 and IsControlJustPressed(1,38) then
						TriggerEvent("arena:ResetStreek")
						TriggerEvent("arena:Respawn")
					end

					if GetGameTimer() >= Cooldown then
						Cooldown = GetGameTimer() + 1000

						if DeathTimer > 0 then
							DeathTimer = DeathTimer - 1
							
							local Message = ""
							if DeathTimer <= 0 then
								if LocalPlayer["state"]["Route"] < 900000 then
									Message = "Digite <color>/GG</color> para desistir imediatamente"
								else
									Message = "Pressione <color>E</color> para renascer dentro da arena"
								end
							end

							SendNUIMessage({ Action = "Update", Timer = DeathTimer, Message = Message })
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckDeath()
	if Death and DeathTimer <= 0 then
		return true
	end

	return false
end
RegisterNetEvent("survival:ForceDeath")
AddEventHandler("survival:ForceDeath",function()
	local Ped = PlayerPedId()
	Death = true
	if LocalPlayer["state"]["Route"] < 900000 then
		if LocalPlayer["state"]["Vippolice"] then
			DeathTimer = 125
		else
			DeathTimer = 250
		end
	else
		DeathTimer = 5
	end
	SetEntityInvincible(Ped,true)
	SetEntityHealth(Ped,100)
	if not LocalPlayer["state"]["Spectate"] then
		SendNUIMessage({ Action = "Display", Mode = "block" })
		DeathUIVisible = true
	else
		DeathUIVisible = false
	end
	vRP.playAnim(false,{"dead","dead_a"},true)
	TriggerEvent("inventory:Close")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORCEALIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("survival:ForceAlive")
AddEventHandler("survival:ForceAlive",function()
    Death = false
    DeathUIVisible = false
    SendNUIMessage({ Action = "Display", Mode = "none" })
    local Ped = PlayerPedId()
    if GetEntityHealth(Ped) <= 100 then
        SetEntityHealth(Ped,200)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Respawn(Coords)
	Death = false
	DeathTimer = 300

	ClearPedTasks(PlayerPedId())
	NetworkSetFriendlyFireOption(true)
	ClearPedBloodDamage(PlayerPedId())
	SetEntityHealth(PlayerPedId(),200)
	SetEntityInvincible(PlayerPedId(),false)

	if LocalPlayer["state"]["Rope"] then
		DetachEntity(PlayerPedId(),false,false)
		LocalPlayer["state"]:set("Rope",false,true)
		TriggerServerEvent("inventory:ropeClean")
	end

	TriggerEvent("paramedic:Reset")
	TriggerEvent("inventory:CleanWeapons")
	LocalPlayer["state"]["Handcuff"] = false
	TriggerServerEvent("pma-voice:toggleMute",false)

	DoScreenFadeOut(0)
	
	if Coords then
		SetEntityCoords(PlayerPedId(),Coords["x"],Coords["y"],Coords["z"])
	else
		SetEntityCoords(PlayerPedId(),271.77,-1204.14,29.28)
	end

	SendNUIMessage({ Action = "Display", Mode = "none" })
	DeathUIVisible = false
	Wait(1000)
	DoScreenFadeIn(1000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Revive",function(Health,Arena)
	local Ped = PlayerPedId()

	SetEntityHealth(Ped,Health)
	SetEntityInvincible(Ped,false)

	if Arena then
		SetPedArmour(Ped,99)
	end

	if LocalPlayer["state"]["Rope"] then
		DetachEntity(Ped,false,false)
		LocalPlayer["state"]:set("Rope",false,true)
		TriggerServerEvent("inventory:ropeClean")
	end

	if Death then
		Death = false
		DeathTimer = 300

		ClearPedTasks(Ped)
		NetworkSetFriendlyFireOption(true)

		SendNUIMessage({ Action = "Display", Mode = "none" })
		DeathUIVisible = false

		if LocalPlayer["state"]["Route"] < 900000 then
			TriggerEvent("paramedic:Reset")
			TriggerServerEvent("pma-voice:toggleMute",false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Revive(Health,Arena)
	exports["survival"]:Revive(Health,Arena)
end
