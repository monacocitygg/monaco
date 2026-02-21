-----------------------------------------------------------------------------------------------------------------------------------------
-- ITENSNOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("itensNotify")
AddEventHandler("itensNotify",function(status)
	if status[1] == "guardou" then
		status[1] = "+"
	elseif status[1] == "equipou" then
		status[1] = "-"
	elseif status[1] == "quebrou" then
		status[1] = "-"
	elseif status[1] == "recebeu" then
		status[1] = "+"
	elseif status[1] == "removeu" then
		status[1] = "-"
	elseif status[1] == "pagou" then
		status[1] = "-"
	end
	SendNUIMessage({ mode = status[1], item = status[2], amount = status[3], name = status[4] })
end)