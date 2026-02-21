-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("wardrobe")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local CurrentMode = "perm" -- "perm" or "temp"
-----------------------------------------------------------------------------------------------------------------------------------------
-- WARDROBE:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("wardrobe:open")
AddEventHandler("wardrobe:open",function(mode)
	if mode then CurrentMode = mode else CurrentMode = "perm" end
	
	CreateThread(function()
		SetNuiFocus(true,true)
		local clothes, maxSlots = vSERVER.getClothes(CurrentMode)
		SendNUIMessage({ action = "open", clothes = clothes, maxSlots = maxSlots })
	end)
end)

RegisterCommand("wardrobe",function()
	TriggerEvent("wardrobe:open","perm")
end)

RegisterNUICallback("close",function(data,cb)
	SetNuiFocus(false,false)
	cb("ok")
end)

RegisterNUICallback("save",function(data,cb)
	local success, message = vSERVER.saveClothes(data.name,CurrentMode)
	
	if success then
		local clothes, maxSlots = vSERVER.getClothes(CurrentMode)
		SendNUIMessage({ action = "update", clothes = clothes, maxSlots = maxSlots })
	end
	
	cb({ success = success, message = message })
end)

RegisterNUICallback("update",function(data,cb)
	local success, message = vSERVER.updateClothes(data.name,CurrentMode)
	
	if success then
		local clothes, maxSlots = vSERVER.getClothes(CurrentMode)
		SendNUIMessage({ action = "update", clothes = clothes, maxSlots = maxSlots })
	end
	
	cb({ success = success, message = message })
end)

RegisterNUICallback("delete",function(data,cb)
	local success, message = vSERVER.deleteClothes(data.name,CurrentMode)
	
	if success then
		local clothes, maxSlots = vSERVER.getClothes(CurrentMode)
		SendNUIMessage({ action = "update", clothes = clothes, maxSlots = maxSlots })
	end
	
	cb({ success = success, message = message })
end)

RegisterNUICallback("equip",function(data,cb)
	local success, message = vSERVER.equipClothes(data.name,CurrentMode)
	cb({ success = success, message = message })
end)
