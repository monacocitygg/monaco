-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hypex = {}
Tunnel.bindInterface("hud",Hypex)
vSERVER = Tunnel.getInterface("hud")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
Display = false
local showMovie = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Hood = false
local Frequency = ""
local Pause = false
local Hours = 0
local Minutes = 0
local Weather = 0
local LastMinRoad = 0
local LastMinCross = 0
local LastMinutes = -1
local FullRoad = ""
local FullCross = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
local Health = 999
local Armour = 999
local Stamine = 999
-----------------------------------------------------------------------------------------------------------------------------------------
-- THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
local Thirst = 999
local ThirstTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
local Hunger = 999
local HungerTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
local Stress = 999
local StressTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
local Wanted = 0
local WantedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
local Reposed = 0
local ReposedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
local Luck = 0
local LuckTimer = 0
local Direction = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
local Dexterity = 0
local DexterityTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()

			if IsPauseMenuActive() then
				if not Pause and Display then
					SendNUIMessage({ Action = "Body", Status = false })
					Pause = true
				end
			else
				if Display then
					if Pause then
						SendNUIMessage({ Action = "Body", Status = true })
						Pause = false
					end

					local Armouring = GetPedArmour(Ped)
					local Healing = GetEntityHealth(Ped) - 100
					local currentStamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())

					local Coords = GetEntityCoords(Ped)
					local Heading = GetEntityHeading(Ped)
					local flexDirection = "Norte"
					local MinRoad,MinCross = GetStreetNameAtCoord(Coords["x"],Coords["y"],Coords["z"])

					if LastMinRoad ~= MinRoad then
						FullRoad = GetStreetNameFromHashKey(MinRoad)
						LastMinRoad = MinRoad
					end
					
					if LastMinCross ~= MinCross then
						FullCross = GetStreetNameFromHashKey(MinCross)
						LastMinCross = MinCross
					end
	
					if Heading >= 315 or Heading < 45 then
						flexDirection = "Norte"
					elseif Heading >= 45 and Heading < 135 then
						flexDirection = "Oeste"
					elseif Heading >= 135 and Heading < 225 then
						flexDirection = "Sul"
					elseif Heading >= 225 and Heading < 315 then
						flexDirection = "Leste"
					end

					if Health ~= Healing then
						if Healing < 0 then
							Healing = 0
						end

						SendNUIMessage({ Action = "Health", Number = Healing })
						Health = Healing
					end

					if Armour ~= Armouring then
						SendNUIMessage({ Action = "Armour", Number = Armouring })
						Armour = Armouring
					end

					if Stamine ~= currentStamina then
						SendNUIMessage({ Action = "Stamine", Number = parseInt(currentStamina) })
						Stamine = currentStamina
					end

					if (FullRoad ~= "" and Road ~= FullRoad) or Direction ~= flexDirection then
						SendNUIMessage({ Action = "Road", Name = FullRoad, Direction = flexDirection })
						Road = FullRoad
						Direction = flexDirection
					end
	
					if FullCross ~= "" and Crossing ~= FullCross then
						SendNUIMessage({ Action = "Crossing", Name = FullCross, Direction = flexDirection })
						Crossing = FullCross
					end

					if LastMinutes ~= GlobalState["Minutes"] then
						SendNUIMessage({ Action = "Clock", Hours = GlobalState["Hours"], Minutes = GlobalState["Minutes"] })
						LastMinutes = GlobalState["Minutes"]
					end
				end
			end

			if Luck > 0 and LuckTimer <= GetGameTimer() then
				Luck = Luck - 1
				LuckTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Luck", Number = Luck })
			end

			if Dexterity > 0 and DexterityTimer <= GetGameTimer() then
				Dexterity = Dexterity - 1
				DexterityTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Dexterity", Number = Dexterity })
			end

			if Wanted > 0 and WantedTimer <= GetGameTimer() then
				Wanted = Wanted - 1
				WantedTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Wanted", Number = Wanted })
			end

			if Reposed > 0 and ReposedTimer <= GetGameTimer() then
				Reposed = Reposed - 1
				ReposedTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Reposed", Number = Reposed })
			end

			if HungerTimer <= GetGameTimer() then
				HungerTimer = GetGameTimer() + 10000

				if Hunger < 25 and GetEntityHealth(Ped) > 100 then
					ApplyDamageToPed(Ped,math.random(2),false)
					TriggerEvent("Notify","fome","Sofrendo de fome.",2500,"Aviso","Fome")
				end
			end

			if ThirstTimer <= GetGameTimer() then
				ThirstTimer = GetGameTimer() + 10000

				if Thirst < 25 and GetEntityHealth(Ped) > 100 then
					ApplyDamageToPed(Ped,math.random(2),false)
					TriggerEvent("Notify","sede","Sofrendo de sede.",2500,"Aviso","Sede")
				end
			end

			if StressTimer <= GetGameTimer() then
				StressTimer = GetGameTimer() + 20000

				if Stress >= 80 and GetEntityHealth(Ped) > 100 then
					DoScreenFadeOut(0)

					ApplyDamageToPed(Ped,math.random(2),false)
					TriggerEvent("Notify","amarelo","Sofrendo de stress.",2500,"Aviso","Stress")

					if not IsPedInAnyVehicle(Ped) then
						SetPedToRagdoll(Ped,2500,2500,0,0,0,0)
					end

					SetTimeout(2500,function()
						DoScreenFadeIn(0)
					end)
				end
			end
		end

		Wait(1000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAPUZ (TOGGLE HOOD)
-----------------------------------------------------------------------------------------------------------------------------------------
local HoodActive = false
RegisterNetEvent("hud:toggleHood")
AddEventHandler("hud:toggleHood",function()
    HoodActive = not HoodActive

    if HoodActive then
        DoScreenFadeOut(0)
        TriggerEvent("inventory:Close")
    else
        DoScreenFadeIn(0)
    end

    SendNUIMessage({ hood = HoodActive })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEHOOD (ao morrer/respawnar)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveHood")
AddEventHandler("hud:RemoveHood",function()
    if HoodActive then
        HoodActive = false
        DoScreenFadeIn(0)
        SendNUIMessage({ hood = false })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voip")
AddEventHandler("hud:Voip",function(Number)
	local Target = { "Baixo","Normal","Médio","Alto","Megafone" }

	SendNUIMessage({ Action = "Voip", Voip = Target[Number] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLECONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleConnected",function()
	SendNUIMessage({ Action = "Voip", Voip = "Online" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLEDISCONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleDisconnected",function()
	SendNUIMessage({ Action = "Voip", Voip = "Offline" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voice")
AddEventHandler("hud:Voice",function(Status)
	SendNUIMessage({ Action = "Voice", Status = Status })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Hood")
AddEventHandler("hud:Hood",function()
	if Hood then
		DoScreenFadeIn(0)
		Hood = false
	else
		DoScreenFadeOut(0)
		Hood = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:UPDATELIFE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:updateLife",function()
    local Ped = PlayerPedId()
    local Armouring = GetPedArmour(Ped)
    local Healing = GetEntityHealth(Ped) - 100
    if Health ~= Healing then
        if Healing < 0 then
            Healing = 0
        end

        SendNUIMessage({ Action = "Health", Number = Healing / 3 })
        Health = Healing
    end

    if Armour ~= Armouring then
        SendNUIMessage({ Action = "Armour", Number = Armouring })
        Armour = Armouring
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active",function(Status)
	SendNUIMessage({ Action = "Body", Status = Status })
	Display = Status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function()
	Display = not Display
	SendNUIMessage({ Action = "Body", Status = Display })

	if not Display then
		if IsMinimapRendering() then
			DisplayRadar(false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("movie",function(source,args)
	showMovie = not showMovie
	SendNUIMessage({ Action = "Movie", Movie = showMovie })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(Message,Timer)
	SendNUIMessage({ Action = "Progress", Message = Message, Timer = Timer })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst",function(Number)
	if Thirst ~= Number then
		SendNUIMessage({ Action = "Thirst", Number = Number })
		Thirst = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Hunger")
AddEventHandler("hud:Hunger",function(Number)
	if Hunger ~= Number then
		SendNUIMessage({ Action = "Hunger", Number = Number })
		Hunger = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Stress")
AddEventHandler("hud:Stress",function(Number)
	if Stress ~= Number then
		SendNUIMessage({ Action = "Stress", Number = Number })
		Stress = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Luck")
AddEventHandler("hud:Luck",function(Seconds)
	Luck = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Dexterity")
AddEventHandler("hud:Dexterity",function(Seconds)
	Dexterity = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Radio")
AddEventHandler("hud:Radio",function(Frequency)
	SendNUIMessage({ Action = "Frequency", Frequency = Frequency })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Wanted")
AddEventHandler("hud:Wanted",function(Seconds)
	Wanted = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wanted",function()
	return Wanted > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Reposed")
AddEventHandler("hud:Reposed",function(Seconds)
	Reposed = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Reposed",function()
	return Reposed > 0 and true or false
end)

local Quadrado = true
local Default = 1920 / 1080
local OffsetX,OffsetY = 0,0
local ResolutionX,ResolutionY = GetActiveScreenResolution()
local AspectRatio = ResolutionX / ResolutionY
local AspectDiff = Default - AspectRatio

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADTEXTURE
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadTexture(Dict)
	if not HasStreamedTextureDictLoaded(Dict) then
		RequestStreamedTextureDict(Dict,true)
		while not HasStreamedTextureDictLoaded(Dict) do
			Wait(1)
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    if Quadrado then
        if LoadTexture("circleminimap") then
            AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circleminimap", "radarmasksm")

            SetMinimapComponentPosition("minimap", "L", "B", 0.005, -0.025, 0.245, 0.185)
            SetMinimapComponentPosition("minimap_mask", "L", "B", 0.02, 0.39, 0.1135, 0.5)
            SetMinimapComponentPosition("minimap_blur", "L", "B", -0.02, -0.01, 0.335, 0.185)

            SetBigmapActive(true, false)

            repeat
                Wait(100)
                SetMinimapClipType(1)
                SetBigmapActive(false, false)
            until not IsBigmapActive()

            while Quadrado do
                SetRadarZoom(1100)
                Wait(500)
            end
        end
    end
end)
