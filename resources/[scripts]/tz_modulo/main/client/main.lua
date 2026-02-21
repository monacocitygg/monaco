local loaded = false
playerTables = {}

RegisterNetEvent('tz/setTables')
AddEventHandler('tz/setTables', function(name,tbl)
	playerTables[name] = tbl
end)

CreateThread(function()
	if not loaded then
		Wait(1000)
		TriggerServerEvent("tz/playerSpawned")
		loaded = true
	end
	playerCache = json.decode(GetResourceKvpString("tz/infos"))
	if not playerCache then
		playerCache = {}
		SetResourceKvp("tz/infos", json.encode({}))
	end
end)