-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vPLAYER = module("vrp", "lib/Tunnel").getInterface("player")
local showBlips = {}
local timeBlips = {}
local numberBlips = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("enterNotifys",function(source,args,rawCommand)
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(PlayerPedId()) > 101 then
		SendNUIMessage({ action = "showAll" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("enterNotifys","Consultar as notificações.","keyboard","F2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFYPUSH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("NotifyPush")
AddEventHandler("NotifyPush",function(data)
	data["id"] = GetGameTimer()
	data["time"] = vPLAYER.getTime()
	data["street"] = GetStreetNameFromHashKey(GetStreetNameAtCoord(data["x"],data["y"],data["z"]))

	SendNUIMessage({ action = "notify", data = data })

	numberBlips = numberBlips + 1

	timeBlips[numberBlips] = 60
	showBlips[numberBlips] = AddBlipForRadius(data["x"],data["y"],data["z"],150.0)
	SetBlipColour(showBlips[numberBlips],data["blipColor"])
	SetBlipAlpha(showBlips[numberBlips],150)
	CountingThread(numberBlips)

	if data["code"] == "QRT" or data["code"] == "AÇÃO" then
		TriggerEvent("sounds:source","deathcop",0.7)
	end

	-- Citizen.SetTimeout(60000, function()
	-- 	RemoveBlip(showBlips[numberBlips])
	-- 	showBlips[numberBlips] = nil
	-- 	timeBlips[numberBlips] = nil
	-- end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function CountingThread(numberBlips)
	Citizen.CreateThread(function()
		while timeBlips[numberBlips] > 0 do
			timeBlips[numberBlips] = timeBlips[numberBlips] - 1
			Citizen.Wait(1000)
		end

		RemoveBlip(showBlips[numberBlips])
		showBlips[numberBlips] = nil
		timeBlips[numberBlips] = nil
	end)
end
-- Citizen.CreateThread(function()
-- 	while true do
-- 		for k,v in pairs(timeBlips) do
-- 			if timeBlips[k] > 0 then
-- 				timeBlips[k] = timeBlips[k] - 1

-- 				if timeBlips[k] <= 0 then
-- 					RemoveBlip(showBlips[k])
-- 					showBlips[k] = nil
-- 					timeBlips[k] = nil
-- 				end
-- 			end
-- 		end

-- 		Citizen.Wait(1000)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOn",function()
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSOFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOff",function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setWay",function(data)
	SetNewWaypoint(data["x"] + 0.0001,data["y"] + 0.0001)
	SendNUIMessage({ action = "hideAll" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("phoneCall",function(data)
	if GetEntityHealth(PlayerPedId()) > 101 then
		exports["smartphone"]:callPlayer(data["phone"])
		SendNUIMessage({ action = "hideAll" })
	end
end)