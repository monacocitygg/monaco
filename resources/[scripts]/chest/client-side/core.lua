-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Chests = {
	{ ["Name"] = "Police", ["Coords"] = vec3(-945.09,-2041.01,9.73), ["Mode"] = "1" }, --principal
	{ ["Name"] = "Police", ["Coords"] = vec3(833.94,-1287.2,28.17), ["Mode"] = "1" }, --core
	{ ["Name"] = "Police", ["Coords"] = vec3(1844.31,2573.84,46.26), ["Mode"] = "1" },
	{ ["Name"] = "Police", ["Coords"] = vec3(1851.51,3690.14,34.51), ["Mode"] = "1" },
	{ ["Name"] = "Police", ["Coords"] = vec3(-449.0,6016.89,32.43), ["Mode"] = "1" },
	{ ["Name"] = "Paramedic", ["Coords"] = vec3(306.17,-601.98,43.25), ["Mode"] = "2" },
	{ ["Name"] = "Paramedic", ["Coords"] = vec3(-258.00,6332.62,32.72), ["Mode"] = "2" },
	{ ["Name"] = "Bennys", ["Coords"] = vec3(-193.91,-1339.46,31.29), ["Mode"] = "2" },
	{ ["Name"] = "BurgerShot", ["Coords"] = vec3(-1203.11,-895.47,13.99), ["Mode"] = "2" },
	{ ["Name"] = "PizzaThis", ["Coords"] = vec3(796.55,-749.32,31.26), ["Mode"] = "2" },
	{ ["Name"] = "UwuCoffee", ["Coords"] = vec3(-572.65,-1049.74,26.61), ["Mode"] = "2" },
	{ ["Name"] = "BeanMachine", ["Coords"] = vec3(123.04,-1043.76,29.27), ["Mode"] = "2" },
	{ ["Name"] = "Ballas", ["Coords"] = vec3(51.84,-1944.48,15.67), ["Mode"] = "2" },
	{ ["Name"] = "TheLost", ["Coords"] = vec3(101.73,3619.46,40.49), ["Mode"] = "2" },
	{ ["Name"] = "Famillies", ["Coords"] = vec3(-137.11,-1608.58,35.03), ["Mode"] = "2" },
	{ ["Name"] = "Vagos", ["Coords"] = vec3(326.08,-2000.12,24.2), ["Mode"] = "2" },
	{ ["Name"] = "Marabuntas", ["Coords"] = vec3(1250.76,-1580.9,58.35), ["Mode"] = "2" },
	{ ["Name"] = "Records", ["Coords"] = vec3(-826.53,-714.09,32.33), ["Mode"] = "2" },
	{ ["Name"] = "Lester", ["Coords"] = vec3(1272.64,-1714.43,54.76), ["Mode"] = "2" },
	---guetos
	{ ["Name"] = "Gueto01", ["Coords"] = vec3(-16.98,-1440.83,31.1), ["Mode"] = "2" },
	{ ["Name"] = "Gueto02", ["Coords"] = vec3(-619.85,-1617.73,33.01), ["Mode"] = "2" },
	{ ["Name"] = "Gueto03", ["Coords"] = vec3(-571.64,289.1,79.18), ["Mode"] = "2" },
	{ ["Name"] = "Gueto04", ["Coords"] = vec3(1972.77,3819.43,33.43), ["Mode"] = "2" },
	---guetos
	---Favelas
	{ ["Name"] = "Favela01", ["Coords"] = vec3(1356.12,-256.53,152.0), ["Mode"] = "2" }, --barragem
	{ ["Name"] = "Favela02", ["Coords"] = vec3(3174.78,5145.09,31.48), ["Mode"] = "2" }, --farol
	{ ["Name"] = "Favela03", ["Coords"] = vec3(405.22,754.92,194.58), ["Mode"] = "2" }, --Parque
	{ ["Name"] = "Favela04", ["Coords"] = vec3(1546.49,-2454.71,80.33), ["Mode"] = "2" }, --ponte caio perigo
	{ ["Name"] = "Favela05", ["Coords"] = vec3(-3129.12,1704.1,41.2), ["Mode"] = "2" }, --praia 2
	--Attachs
	{ ["Name"] = "Muni01", ["Coords"] = vec3(-578.83,229.8,74.88), ["Mode"] = "2" }, --Attachs
	--Vanilla
	{ ["Name"] = "Vanilla", ["Coords"] = vec3(106.53,-1299.46,28.76), ["Mode"] = "2" }, --Vanilla
	
	{ ["Name"] = "Arcade", ["Coords"] = vec3(741.82,-810.77,24.26), ["Mode"] = "2" },
	{ ["Name"] = "Madrazzo", ["Coords"] = vec3(1391.57,1158.88,114.33), ["Mode"] = "2" },
	{ ["Name"] = "Playboy", ["Coords"] = vec3(-1525.14,148.95,60.79), ["Mode"] = "2" },
	{ ["Name"] = "Vineyard", ["Coords"] = vec3(-1870.29,2059.15,135.44), ["Mode"] = "2" },
	{ ["Name"] = "Bennys", ["Coords"] = vec3(994.87,-1490.74,31.49), ["Mode"] = "2" },
	{ ["Name"] = "trayShot", ["Coords"] = vec3(-1195.20,-893.13,14.41), ["Mode"] = "3" },
	{ ["Name"] = "trayDesserts", ["Coords"] = vec3(-584.01,-1059.30,22.41), ["Mode"] = "3" },
	{ ["Name"] = "trayPizza", ["Coords"] = vec3(811.10,-752.78,26.74), ["Mode"] = "3" },
	{ ["Name"] = "trayBean", ["Coords"] = vec3(121.8,-1037.27,29.25), ["Mode"] = "3" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Labels = {
	["1"] = {
		{
			event = "chest:Open",
			label = "Compartimento Geral",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Open",
			label = "Compartimento Pessoal",
			tunnel = "shop",
			service = "Personal"
		},{
			event = "chest:Open",
			label = "Compartimento Evidências",
			tunnel = "shop",
			service = "Evidences"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		}
	},
	["2"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "shop",
			service = "Normal"
		},{
			event = "chest:Upgrade",
			label = "Aumentar",
			tunnel = "server"
		},{
			event = "chest:Open",
			label = "Cofre",
			tunnel = "shop",
			service = "Manager"
		}
	},
	["3"] = {
		{
			event = "chest:Open",
			label = "Bandeja",
			tunnel = "shop",
			service = "Normal"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	for Name,v in pairs(Chests) do
-- 		exports["target"]:AddCircleZone("Chest:"..Name,v["Coords"],1.0,{
-- 			name = "Chest:"..Name,
-- 			heading = 3374176
-- 		},{
-- 			Distance = 1.5,
-- 			shop = v["Name"],
-- 			options = Labels[v["Mode"]]
-- 		})
-- 	end
-- end)

local SelectedOption = 1
local LastChest = nil

CreateThread(function()
	while true do
		local Idle = 1000
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local ClosestChest = nil
		local MinDist = 10.0

		for Name,v in pairs(Chests) do
			local Dist = #(Coords - v["Coords"])
			if Dist < MinDist then
				MinDist = Dist
				ClosestChest = { Name = Name, Data = v }
			end
		end

		if ClosestChest and MinDist <= 2.0 then
			Idle = 0
			
			if LastChest ~= ClosestChest.Name then
				SelectedOption = 1
				LastChest = ClosestChest.Name
			end

			local Options = Labels[ClosestChest.Data["Mode"]]
			local OnScreen, ScreenX, ScreenY = GetScreenCoordFromWorldCoord(ClosestChest.Data["Coords"].x, ClosestChest.Data["Coords"].y, ClosestChest.Data["Coords"].z + 0.5)

			if OnScreen then
				SendNUIMessage({
					Action = "HoverMenu",
					visible = true,
					x = ScreenX,
					y = ScreenY,
					options = Options,
					selected = SelectedOption
				})

				-- Scroll Up
				if IsControlJustPressed(1, 15) then -- Scroll Up
					SelectedOption = SelectedOption - 1
					if SelectedOption < 1 then SelectedOption = #Options end
				end

				-- Scroll Down
				if IsControlJustPressed(1, 14) then -- Scroll Down
					SelectedOption = SelectedOption + 1
					if SelectedOption > #Options then SelectedOption = 1 end
				end

				-- Press E
				if IsControlJustPressed(1, 38) then
					local Selected = Options[SelectedOption]
					if Selected then
						if Selected.tunnel == "server" then
							TriggerServerEvent(Selected.event, ClosestChest.Data["Name"])
						else
							TriggerEvent(Selected.event, ClosestChest.Data["Name"], Selected.service)
						end
					end
				end
			end
		else
			if LastChest then
				SendNUIMessage({ Action = "HoverMenu", visible = false })
				LastChest = nil
			end
		end

		Wait(Idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Open",function(Name,Init)
	print("CHEST_DEBUG: Evento chest:Open acionado.")
	print("CHEST_DEBUG: Name = " .. tostring(Name))
	print("CHEST_DEBUG: Init = " .. tostring(Init))

	if vSERVER.Permissions(Name,Init) then
		print("CHEST_DEBUG: Permissão concedida pelo servidor.")
		SetNuiFocus(true,true)
		SendNUIMessage({ Action = "Open" })
	else
		print("CHEST_DEBUG: Permissão negada pelo servidor.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	vSERVER.Take(Data["item"],Data["slot"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	vSERVER.Store(Data["item"],Data["slot"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	vSERVER.Update(Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Chest",function(Data,Callback)
	local Inventory,Chest,invPeso,invMaxpeso,chestPeso,chestMaxpeso,hasBolso,hasVipslots,hasSerendibite,hasPainite = vSERVER.Chest()
	if Inventory then
		Callback({ Inventory = Inventory, Chest = Chest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso, hasBolso = hasBolso, hasVipslots = hasVipslots, hasSerendibite = hasSerendibite, hasPainite = hasPainite })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Update")
AddEventHandler("chest:Update",function(Action,invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ Action = Action, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Close")
AddEventHandler("chest:Close",function(Action)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)
end)
