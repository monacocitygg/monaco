
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
                        service = v[2] -- Passing the craft type name (e.g. "Lixeiro")
                    }
                }
            })
        end
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
