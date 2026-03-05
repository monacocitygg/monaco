-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Previous = nil
local Treatment = false
local TreatmentTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Beds = {
	-- Medical Center Sul
	{ ["Coords"] = vec3(-2769.62,-86.07,19.53), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(-2766.03,-85.91,19.53), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(-2762.53,-85.52,19.53), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(-2759.07,-85.18,19.53), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(-2755.63,-85.12,19.53), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(-2754.65,-84.76,18.6 ), ["Heading"] = 0.0 },
	{ ["Coords"] = vec3(1126.69,-1547.41,34.9), ["Heading"] = 175.75 },
	{ ["Coords"] = vec3(1123.64,-1547.41,34.9), ["Heading"] = 175.75 },
	{ ["Coords"] = vec3(1120.52,-1547.41,34.9), ["Heading"] = 175.75 },
	{ ["Coords"] = vec3(1121.1,-1538.06,34.9), ["Heading"] = 175.75 },
	{ ["Coords"] = vec3(1124.16,-1538.06,34.9), ["Heading"] = 175.75 },
	{ ["Coords"] = vec3(1127.16,-1538.07,34.9), ["Heading"] = 175.75 },
	-- Medical Center Norte Sandy
	{ ["Coords"] = vec3(1824.76,3681.69,34.19), ["Heading"] = 209.77 },
	{ ["Coords"] = vec3(1827.86,3683.42,34.19), ["Heading"] = 209.77 },
	{ ["Coords"] = vec3(1830.23,3679.29,34.19), ["Heading"] = 25.52 },
	{ ["Coords"] = vec3(1827.29,3677.57,34.19), ["Heading"] = 25.52 },
	-- Medical Center Norte Paleto
	{ ["Coords"] = vec3(-252.25,6323.07,32.35), ["Heading"] = 133.23 },
	{ ["Coords"] = vec3(-250.73,6321.67,32.35), ["Heading"] = 130.4 },
	{ ["Coords"] = vec3(-246.99,6317.99,32.35), ["Heading"] = 136.07 },
	{ ["Coords"] = vec3(-245.35,6316.21,32.35), ["Heading"] = 136.07 },
	{ ["Coords"] = vec3(-250.94,6310.49,32.35), ["Heading"] = 317.49 },
	{ ["Coords"] = vec3(-252.47,6312.21,32.35), ["Heading"] = 317.49 },
	{ ["Coords"] = vec3(-254.4,6313.8,32.35), ["Heading"] = 317.49 },
	{ ["Coords"] = vec3(-256.12,6315.49,32.35), ["Heading"] = 320.32 },
	{ ["Coords"] = vec3(-257.73,6317.26,32.35), ["Heading"] = 317.49 },
	-- Boolingbroke
	{ ["Coords"] = vec3(1761.87,2591.56,45.66), ["Heading"] = 272.13 },
	{ ["Coords"] = vec3(1761.87,2594.64,45.66), ["Heading"] = 272.13 },
	{ ["Coords"] = vec3(1761.87,2597.73,45.66), ["Heading"] = 272.13 },
	{ ["Coords"] = vec3(1771.98,2597.95,45.66), ["Heading"] = 87.88 },
	{ ["Coords"] = vec3(1771.98,2594.88,45.66), ["Heading"] = 87.88 },
	{ ["Coords"] = vec3(1771.98,2591.79,45.66), ["Heading"] = 87.88 },
	-- Clandestine
	{ ["Coords"] = vec3(-471.87,6287.56,13.63), ["Heading"] = 53.86 },
	-- DP D.P.B.C
	{ ["Coords"] = vec3(-937.12,-2059.38,9.33), ["Heading"] = 136.07 },
	{ ["Coords"] = vec3(-935.4,-2061.0,9.33), ["Heading"] = 136.07 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Beds) do
		AddBoxZone("Beds:"..Number,v["Coords"],1.0,1.0,{
			name = "Beds:"..Number,
			heading = v["Heading"],
			minZ = v["Coords"]["z"] - 1.0,
			maxZ = v["Coords"]["z"] + 1.0
		},{
			shop = Number,
			Distance = 2.0,
			options = {
				{
					event = "target:PutBed",
					label = "Deitar",
					tunnel = "client"
				},{
					event = "target:Treatment",
					label = "Tratamento",
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:PUTBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:PutBed")
AddEventHandler("target:PutBed",function(Number)
	if not Previous then
		local Ped = PlayerPedId()
		Previous = GetEntityCoords(Ped)
		SetEntityCoords(Ped,Beds[Number]["Coords"]["x"],Beds[Number]["Coords"]["y"],Beds[Number]["Coords"]["z"] - 1,false,false,false,false)
		vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
		SetEntityHeading(Ped,Beds[Number]["Heading"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:UpBed")
AddEventHandler("target:UpBed",function()
	if Previous then
		local Ped = PlayerPedId()
		SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"] - 1,false,false,false,false)
		Previous = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Treatment")
AddEventHandler("target:Treatment",function(Number)
	if not Previous then
		if vSERVER.CheckIn() then
			local Ped = PlayerPedId()
			Previous = GetEntityCoords(Ped)
			SetEntityCoords(Ped,Beds[Number]["Coords"]["x"],Beds[Number]["Coords"]["y"],Beds[Number]["Coords"]["z"] - 1,false,false,false,false)
			vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
			SetEntityHeading(Ped,Beds[Number]["Heading"])

			TriggerEvent("inventory:preventWeapon",true)
			LocalPlayer["state"]["Commands"] = true
			LocalPlayer["state"]["Cancel"] = true
			TriggerEvent("paramedic:Reset")

			if GetEntityHealth(Ped) <= 100 then
				exports["survival"]:Revive(101)
			end

			Treatment = true
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:StartTreatment")
AddEventHandler("target:StartTreatment",function()
	if not Treatment then
		LocalPlayer["state"]["Commands"] = true
		LocalPlayer["state"]["Cancel"] = true
		Treatment = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBEDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if Previous and not IsEntityPlayingAnim(Ped,"anim@gangops@morgue@table@","body_search",3) then
			SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"] - 1,false,false,false,false)
			Previous = nil
		end

		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Treatment then
			if GetGameTimer() >= TreatmentTimer then
				local Ped = PlayerPedId()
				local Health = GetEntityHealth(Ped)
				TreatmentTimer = GetGameTimer() + 1000

				if Health < 200 then
					SetEntityHealth(Ped,Health + 1)
				else
					Treatment = false
					LocalPlayer["state"]["Cancel"] = false
					LocalPlayer["state"]["Commands"] = false
					TriggerEvent("Notify","amarelo","Tratamento concluido.",5000)
				end
			end
		end

		Wait(1000)
	end
end)