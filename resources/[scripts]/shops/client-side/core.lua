-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("shops",Creative)
vSERVER = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SendNUIMessage({ action = "hideNUI" })
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestShop",function(Data,Callback)
	local inventoryShop,inventoryUser,invPeso,invMaxpeso,shopSlots,hasBolso = vSERVER.requestShop(Data["shop"])
	if inventoryShop then
		Callback({ inventoryShop = inventoryShop, inventoryUser = inventoryUser, invPeso = invPeso, invMaxpeso = invMaxpeso, shopSlots = shopSlots, hasBolso = hasBolso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionShops",function(Data,Callback)
	vSERVER.functionShops(Data["shop"],Data["item"],Data["amount"],Data["slot"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(Data,Callback)
	TriggerServerEvent("shops:populateSlot",Data["item"],Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(Data,Callback)
	TriggerServerEvent("shops:updateSlot",Data["item"],Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateShops(action)
	SendNUIMessage({ action = action })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	{ -544.98,-204.11,38.22,"Identity",false,2.75 },
	{ -544.76,-185.81,52.2,"Identity2",false,2.75 },
	{ 24.9,-1346.8,29.49,"Departament",true },
	{ 2556.74,381.24,108.61,"Departament",true },
	{ 1164.82,-323.65,69.2,"Departament",true },
	{ -706.15,-914.53,19.21,"Departament",true },
	{ -47.38,-1758.68,29.42,"Departament",true },
	{ 373.1,326.81,103.56,"Departament",true },
	{ -3242.75,1000.46,12.82,"Departament",true },
	{ 1728.47,6415.46,35.03,"Departament",true },
	{ 1960.2,3740.68,32.33,"Departament",true },
	{ 2677.8,3280.04,55.23,"Departament",true },
	{ 1697.31,4923.49,42.06,"Departament",true },
	{ -1819.52,793.48,138.08,"Departament",true },
	{ 1391.69,3605.97,34.98,"Departament",true },
	{ -2966.41,391.55,15.05,"Departament",true },
	{ -3039.54,584.79,7.9,"Departament",true },
	{ 1134.33,-983.11,46.4,"Departament",true },
	{ 1165.28,2710.77,38.15,"Departament",true },
	{ -1486.72,-377.55,40.15,"Departament",true },
	{ -1221.45,-907.92,12.32,"Departament",true },
	{ 161.2,6641.66,31.69,"Departament",true },
	{ -160.62,6320.93,31.58,"Departament",true },
	{ 548.7,2670.73,42.16,"Departament",true },
	{ -1217.8,-1493.34,4.36,"Sugar",true },
	{ -1246.11,-1453.19,4.36,"Sugar",true },
	{ -1215.28,-1467.28,4.36,"Sugar",true }, 
	{ 29.15,-1770.14,29.6,"Verdinha",true }, 
	{ -1249.89,-1448.57,4.36,"Verdinha",true }, 
	{ -1221.32,-1488.56,4.36,"Verdinha",true }, 
	{ -657.16,-857.69,24.5,"Digital",true }, 
	{ 1133.44,-1563.94,35.38,"Farmacia",false }, 
	{ 1693.2,3760.13,34.69,"Ammunation",false },
	{ 252.61,-50.12,69.94,"Ammunation",false },
	{ 842.37,-1034.01,28.19,"Ammunation",false },
	{ -330.71,6084.1,31.46,"Ammunation",false },
	{ -662.28,-934.85,21.82,"Ammunation",false },
	{ -1305.36,-394.36,36.7,"Ammunation",false },
	{ -1118.1,2698.84,18.55,"Ammunation",false },
	{ 2567.9,293.86,108.73,"Ammunation",false },
	{ -3172.39,1087.88,20.84,"Ammunation",false },
	{ 22.17,-1106.71,29.79,"Ammunation",false },
	{ 810.18,-2157.77,29.62,"Ammunation",false },
	{ -1816.64,-1193.73,14.31,"Fishing",false },
	{ 1522.88,3783.63,34.47,"Fishing2",true,2.25 },
	{ -695.56,5802.12,17.32,"Hunting",false },
	{ -679.13,5839.52,17.32,"Hunting2",false },
	-- { -172.89,6381.32,31.48,"Farmacia",false },
	-- { 1690.07,3581.68,35.62,"Farmacia",false },
	-- { 318.18,-1077.71,30.45,"Farmacia",false },
	{ 1147.03,-1551.4,35.38,"Farmacia",false }, 
	{ 304.07,-600.83,43.29,"Paramedic",false },
	{ -254.64,6326.95,32.82,"Paramedic",false },
	{ 82.98,-1553.55,29.59,"Recycle",false }, 
	{ 287.77,2843.9,44.7,"Recycle",false },
	{ -413.97,6171.58,31.48,"Recycle",false },
	-- { -2038.33,-495.77,12.11,"Mecanica",false}, -- mecanica
	{ -947.94,-2040.35,9.4,"Police",false }, --1 BPM 
	{ 364.62,-1604.05,25.44,"Police",false },-- DIB
	{ 851.2,-1313.31,26.49,"Police",false },-- CORE ,181.42
	{ -628.79,-238.7,38.05,"Miners",false },
	{ 475.1,3555.28,33.23,"Criminal",false },
	{ 112.41,3373.68,35.25,"Criminal2",false },
	{ 2013.95,4990.88,41.21,"Criminal3",false },
	{ 186.9,6374.75,32.33,"Criminal4",false },
	{ -653.12,-1502.67,5.22,"Criminal",false },
	{ 389.71,-942.61,29.42,"Criminal2",false },
	{ 154.98,-1472.47,29.35,"Criminal3",false },
	{ 488.1,-1456.11,29.28,"Criminal4",false },
	{ 169.76,-1535.88,29.25,"Weapons",false },
	{ 301.14,-195.75,61.57,"Weapons",false },

	
	{  104.06,157.57,80.53,"Harmony2",false },
	{ 94.61,123.38,80.53,"Harmony",false },
	{ -523.96,-2229.24,6.39,"Tunners",false },
	{ -529.58,-2235.21,6.39,"Tunners",false },

	{ -1207.63,-1771.35,3.91,"ilegal",false },
	{ -1236.81,-271.84,37.76,"BurgerShot",false },
	{ 806.22,-761.68,26.77,"PizzaThis",false },
	{ -588.5,-1066.23,22.34,"UwuCoffee",false },
	{ 124.01,-1036.72,29.27,"BeanMachine",false },


	
	{ -2193.23,-402.56,10.35,"ilegal",false },
	{ -1174.54,-1571.4,4.35,"Weeds",false }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:openSystem",function(shopId)
	if LocalPlayer["state"]["Route"] < 900000 then
		local name = List[shopId][4]
		print("[shops] openSystem",shopId,name)
		if vSERVER.requestPerm(name) then
			local mode = vSERVER.getShopType(name)
			print("[shops] openSystem allowed",name,mode)
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "showNUI", name = name, type = mode })

			if List[shopId][5] then
				TriggerEvent("sounds:Private","shop",0.5)
			end
		else
			print("[shops] openSystem denied",name)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:COFFEEMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:coffeeMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ action = "showNUI", name = "coffeeMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:SODAMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:sodaMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ action = "showNUI", name = "sodaMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DONUTMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:donutMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ action = "showNUI", name = "donutMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:BURGERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:burgerMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ action = "showNUI", name = "burgerMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:HOTDOGMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:hotdogMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ action = "showNUI", name = "hotdogMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:CHIHUAHUA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Chihuahua",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ action = "showNUI", name = "Chihuahua", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:WATERMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:waterMachine",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		SendNUIMessage({ action = "showNUI", name = "waterMachine", type = "Buy" })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:MEDICBAG
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:medicBag",function()
	if LocalPlayer["state"]["Route"] < 900000 then
		if vSERVER.requestPerm("Paramedic") then
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "showNUI", name = "Paramedic", type = "Buy" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:FUEL
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Fuel",function()
	SendNUIMessage({ action = "showNUI", name = "Fuel", type = "Buy" })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:FUEL
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Premium",function()
	SendNUIMessage({ action = "showNUI", name = "Premium", type = "Buy" })
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(List) do
		exports["target"]:AddCircleZone("Shops:"..Number,vec3(v[1],v[2],v[3]),0.55,{
			name = "Shops:"..Number,
			heading = 3374176
		},{
			shop = Number,
			Distance = v[6] or 1.75,
			options = {
				{
					event = "shops:openSystem",
					label = "Abrir",
					tunnel = "shop"
				}
			}
		})
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- HOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)
	local Table = {}
	for Number,v in pairs(List) do
		Table[#Table + 1] = { v[1],v[2],v[3],v[6] or 2.0,"E",v[4],"Abrir" }
	end

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

		for Number,v in pairs(List) do
			local Distance = #(Coords - vec3(v[1],v[2],v[3]))
			if Distance <= (v[6] or 2.0) then
				TimeDistance = 4

				if IsControlJustPressed(1,38) then
					TriggerEvent("shops:openSystem",Number)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
