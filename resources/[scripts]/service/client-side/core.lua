-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("service")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	{ -919.11,-2028.23,9.31,"Police-1",1.25 }, --dp principal
	{ 830.97,-1291.84,28.7,"Police-2",1.0 },--core
	{ -447.28,6013.01,32.41,"Police-3",1.0 }, 
	{ 1840.20,2578.48,46.07,"Police-4",1.0 },
	{ 385.43,794.42,187.48,"Police-5",1.0 },
	{ 362.58,-1590.71,29.28,"Police-6",1.25 }, --dip
	{ 1139.08,-1537.8,35.38,"Paramedic-1",1.25 },
	{ -254.77,6331.03,32.79,"Paramedic-2",1.5 },
	{ 1188.05,-1468.31,34.66,"Paramedic-3",1.5 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(List) do
		exports["target"]:AddCircleZone("Service:"..v[4],vec3(v[1],v[2],v[3]),0.50,{
			name = "Service:"..v[4],
			heading = 3374176
		},{
			shop = k,
			Distance = v[5],
			options = {
				{
					label = "Entrar em Serviço",
					event = "service:Toggle",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Toggle")
AddEventHandler("service:Toggle",function(Service)
	if LocalPlayer["state"]["Route"] < 900000 then
		TriggerServerEvent("service:Toggle",List[Service][4])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:LABEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Label")
AddEventHandler("service:Label",function(Service,Text)
	if Service == "Police" then
		exports["target"]:LabelText("Service:Police-1",Text)
		exports["target"]:LabelText("Service:Police-2",Text)
		exports["target"]:LabelText("Service:Police-3",Text)
		exports["target"]:LabelText("Service:Police-4",Text)
		exports["target"]:LabelText("Service:Police-5",Text)
		exports["target"]:LabelText("Service:Police-6",Text)
	elseif Service == "Paramedic" then
		exports["target"]:LabelText("Service:Paramedic-1",Text)
		exports["target"]:LabelText("Service:Paramedic-2",Text)
		exports["target"]:LabelText("Service:Paramedic-3",Text)
	else
		exports["target"]:LabelText("Service:"..Service,Text)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Open")
AddEventHandler("service:Open",function(Title)
	SetNuiFocus(true,true)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "openSystem", title = Title })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(Data,Callback)
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Request",function(Data,Callback)
	Callback({ Result = vSERVER.Request() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Remove",function(Data,Callback)
	TriggerServerEvent("service:Remove",Data["passport"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Add",function(Data,Callback)
	TriggerServerEvent("service:Add",Data["passport"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Update")
AddEventHandler("service:Update",function()
	SendNUIMessage({ action = "Update" })
end)