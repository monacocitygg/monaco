-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("pause", Creative)
vSERVER = Tunnel.getInterface("pause")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Pause = false

local function OpenPauseMenu()
	print("DEBUG: OpenPauseMenu called")
	if UsingLbPhone then
		print("DEBUG: UsingLbPhone is true")
		if not Pause and not IsPauseMenuActive() and not exports["lb-phone"]:IsOpen() then
			print("DEBUG: Opening menu (Phone mode)")
			Pause = true
			SetNuiFocus(true, true)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ name = "Open" })
			vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "prop_cs_tablet", 49, 28422, -0.05, 0.0, 0.0, 0.0, 0.0, 0.0)
		else
			print("DEBUG: Failed to open (Phone mode) - Pause:", Pause, "IsPauseMenuActive:", IsPauseMenuActive(), "PhoneOpen:", exports["lb-phone"]:IsOpen())
		end	
	else
		print("DEBUG: UsingLbPhone is false")
		if not Pause and not IsPauseMenuActive() then
			print("DEBUG: Opening menu (Normal mode)")
			Pause = true
			SetNuiFocus(true, true)
			SetCursorLocation(0.5,0.5)
			SendNUIMessage({ name = "Open" })
			vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "prop_cs_tablet", 49, 28422, -0.05, 0.0, 0.0, 0.0, 0.0, 0.0)
		else
			print("DEBUG: Failed to open (Normal mode) - Pause:", Pause, "IsPauseMenuActive:", IsPauseMenuActive())
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAUSEBREAK
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("PauseBreak", function()
-- 	OpenPauseMenu()
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEMAP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ActiveMap",function()
	ActivateFrontendMenu("FE_MENU_VERSION_MP_PAUSE",0,-1)
end)

RegisterCommand("tablet2",function()
	vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_a","prop_cs_tablet",49,28422,-0.05,0.0,0.0,0.0,0.0,0.0)
end)
RegisterCommand("tabletoff2",function()
	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("ActiveMap","Abrir o mapa","keyboard","P")

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)

-- 		DisableControlAction(0, 322, true)
-- 		DisableControlAction(0, 44, true)
-- 		SetPauseMenuActive(false)
-- 	end
-- end)

-- TARGET
Citizen.CreateThread(function()
	print("DEBUG: Trying to register target zone")
	if GetResourceState("target") == "started" or GetResourceState("ox_target") == "started" then
		print("DEBUG: Target resource found")
		exports["target"]:AddCircleZone("PauseMenu",vector3(-1082.18,-247.55,37.76),0.75,{
			name = "PauseMenu",
			heading = 0.0
		},{
			Distance = 1.50,
			options = {
				{
					event = "pause:openMenu",
					label = "Abrir Loja vip",
					tunnel = "client"
				}
			}
		})
		print("DEBUG: Target zone registered")
	else
		print("DEBUG: Target resource NOT found or not started")
	end
end)

RegisterNetEvent("pause:openMenu")
AddEventHandler("pause:openMenu",function()
	print("DEBUG: Event pause:openMenu triggered")
	OpenPauseMenu()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Disconnect",function(Data,Callback)
	vSERVER.Disconnect()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Settings",function(Data,Callback)
	Pause = false
	SetNuiFocus(false,false)
	ActivateFrontendMenu("FE_MENU_VERSION_LANDING_MENU",0,-1)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Map",function(Data,Callback)
	Pause = false
	SetNuiFocus(false,false)
	ActivateFrontendMenu("FE_MENU_VERSION_MP_PAUSE",0,-1)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Home",function(Data,Callback)
	Callback(vSERVER.Home())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAMONDSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("DiamondsList",function(Data,Callback)
	Callback(vSERVER.DiamondsList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMRENEW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PremiumRenew",function(Data,Callback)
	Callback(vSERVER.PremiumRenew())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAMONDSBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("DiamondsBuy",function(Data,Callback)
	if not LocalPlayer["state"]["Prison"] then
		Callback(vSERVER.DiamondsBuy(Data["Index"],Data["Amount"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	Pause = false
	vRP.removeObjects()
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rolepass",function(Data,Callback)
	Callback(vSERVER.Rolepass())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLEPASSBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RolepassBuy",function(Data,Callback)
	Callback(vSERVER.RolepassBuy())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLEPASSRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RolepassRescue",function(Data,Callback)
	if not LocalPlayer["state"]["Prison"] then
		Callback(vSERVER.RolepassRescue(Data[1],Data[2]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Boxes",function(Data,Callback)
	local boxesList = {}
	if Config.LootboxConfig then
		for k,v in pairs(Config.LootboxConfig) do
			table.insert(boxesList, {
				key = k,
				name = v.name,
				image = v.image,
				price = v.price,
				description = v.description,
				items = v.items
			})
		end
	end
	Callback(boxesList)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENLOOTBOX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("OpenLootbox",function(Data,Callback)
	Callback(vSERVER.OpenLootbox(Data.key))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMYBOXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetMyBoxes",function(Data,Callback)
	Callback(vSERVER.GetMyBoxes())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMYBOX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("OpenMyBox",function(Data,Callback)
	Callback(vSERVER.OpenMyBox(Data.key))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTLOOTBOX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("PaymentLootbox",function(Data,Callback)
	Callback(vSERVER.PaymentLootbox())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)
	local Table = {}
	Table[#Table + 1] = { -1082.18,-247.55,37.76,2.0,"E","Loja VIP","Abrir" }

	TriggerEvent("hoverfy:Insert",Table)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 1000
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local Distance = #(Coords - vector3(-1082.18,-247.55,37.76))

		if Distance <= 2.0 then
			TimeDistance = 4

			if IsControlJustPressed(1,38) and not IsPauseMenuActive() then
				if UsingLbPhone and exports["lb-phone"]:IsOpen() then
					return
				end

				OpenPauseMenu()
			end
		end

		Wait(TimeDistance)
	end
end)
