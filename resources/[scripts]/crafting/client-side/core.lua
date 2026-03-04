
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
Tunnel.bindInterface("crafting",Creative)
vSERVER = Tunnel.getInterface("crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCrafting",function(Data,Callback)
	local inventoryUser,recipes,invPeso,invMaxpeso = vSERVER.requestCrafting(Data["craftType"])
	if inventoryUser then
		Callback({ inventoryUser = inventoryUser, recipes = recipes, invPeso = invPeso, invMaxpeso = invMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionCraft",function(Data,Callback)
	vSERVER.functionCraft(Data["craftType"],Data["item"],Data["amount"])
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
-- Handled below with robust logic

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:updateCrafting")
AddEventHandler("crafting:updateCrafting",function()
    SendNUIMessage({ action = "updateCrafting" })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:progress")
AddEventHandler("crafting:progress",function(time)
    SendNUIMessage({ action = "progress", time = time })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(Crafting) do
        if v[1] and type(v[1]) == "vector3" then
            exports["target"]:AddCircleZone("Crafting:"..k,v[1],0.55,{
                name = "Crafting:"..k,
                heading = 0.0
            },{
                shop = k,
                Distance = 1.75,
                options = {
                    {
                        event = "crafting:openSystem",
                        label = "Abrir Crafting",
                        tunnel = "shop",
                        service = v[2]
                    }
                }
            })
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)
	local Table = {}
	for Number,v in pairs(Crafting) do
        if v[1] and type(v[1]) == "vector3" then
		    Table[#Table + 1] = { v[1].x,v[1].y,v[1].z,2.0,"E","Crafting","Abrir" }
        end
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

		for Number,v in pairs(Crafting) do
            if v[1] and type(v[1]) == "vector3" then
                local Distance = #(Coords - v[1])
                if Distance <= 2.0 then
                    TimeDistance = 4

                    if IsControlJustPressed(1,38) then
                        local craftType = v[2]
                        if vSERVER.checkPermission(craftType) then
                            if LocalPlayer["state"]["Route"] < 900000 then
                                SetNuiFocus(true,true)
                                SendNUIMessage({ action = "showNUI", name = craftType })
                            end
                        end
                    end
                end
            end
		end

		Wait(TimeDistance)
	end
end)

-- Event handler wrapper for target callback because target passes data differently usually
RegisterNetEvent("crafting:openSystem")
AddEventHandler("crafting:openSystem", function(data)
    local craftType = data
    print("DEBUG: Raw data received:", json.encode(data))

    -- Trata se vier como tabela do target
    if type(data) == "table" and data.service then
        craftType = data.service
    end
    print("DEBUG: craftType initial:", craftType, "Type:", type(craftType))

    -- Trata se vier como índice numérico (string ou number) (fallback)
    local index = tonumber(craftType)
    if index and Crafting[index] then
        print("DEBUG: Found in client config via index:", index, json.encode(Crafting[index]))
        craftType = Crafting[index][2]
    end
    
    print("DEBUG: Final craftType to send:", craftType)

    local route = LocalPlayer["state"]["Route"] or 0
    if route < 900000 then
        if vSERVER.checkPermission(craftType) then
            print("DEBUG: Permission granted")
            SetNuiFocus(true,true)
            SendNUIMessage({ action = "showNUI", name = craftType })
        else
            print("DEBUG: Permission denied")
        end
    else
        print("DEBUG: Route blocked", route)
    end
end)
