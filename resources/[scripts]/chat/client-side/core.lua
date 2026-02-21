-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local Permissions = {
	["Admin"] = true,
	["Police"] = true,
	["Paramedic"] = true,
	["Hornys"] = true,
	["UwuCoffee"] = true,
	["Burgershot"] = true,
	["Ballas"] = true,
	["Vagos"] = true,
	["Favela01"] = true, 
	["Vanilla"] = true,
	["Favela02"] = true, 
	["Favela03"] = true, 
	["Favela04"] = true, 
	["Favela05"] = true, 
	["Muni01"] = true,
	["Lavagem01"] = true,
	["Famillies"] = true,
	["Aztecas"] = true,
	["Triads"] = true,
	["Marabunta"] = true,
	["Records"] = true,
	["Arcade"] = true,
	["Bobcats"] = true,
	["Ranch"] = true,
	["Madrazo"] = true,
	["Tuners"] = true,
	["Ottos"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
for Perm,_ in pairs(Permissions) do
	LocalPlayer["state"]:set(Perm,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ChatEvent",function()
	if LocalPlayer["state"]["Active"] and not IsPauseMenuActive() and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Carry"] and not LocalPlayer["state"]["usingPhone"] and not IsPedReloading(Ped) then
		local Tags = {}
		for Index,_ in pairs(Permissions) do
			if LocalPlayer["state"][Index] then
				Tags[#Tags + 1] = Index
			end
		end

		SendNUIMessage({ name = "Chat", payload = { Tags,Block } })
		SetNuiFocus(true,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:CLIENTMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:ClientMessage")
AddEventHandler("chat:ClientMessage",function(Author,Message,Mode)
	SendNUIMessage({ name = "Message", payload = { Author,Message,Mode } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATSUBMIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChatSubmit",function(Data,Callback)
	SetNuiFocus(false,false)

	if LocalPlayer["state"]["Active"] and Data["message"] ~= "" then
		if Data["message"]:sub(1,1) == "/" then
			ExecuteCommand(Data["message"]:sub(2))
		else
			TriggerServerEvent("chat:ServerMessage",Data["tag"],Data["message"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("ChatEvent","Abrir o chat.","keyboard","T")