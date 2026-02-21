RegisterNUICallback("requestSkins",function(Data,Callback)
    local result = vSERVER.requestSkins()
    Callback(result)
end)

RegisterNUICallback("equipSkin",function(Data,Callback)
	print("DEBUG [CLIENT]: NUI equipSkin acionado")
	print("DEBUG [CLIENT]: Dados recebidos do UI:", json.encode(Data))
	
	local currentWeapon = exports["inventory"]:Weapons()
	local ped = PlayerPedId()
	local currentAmmo = GetAmmoInPedWeapon(ped,GetHashKey(currentWeapon))
	
	print("DEBUG [CLIENT]: Arma atual na mão:", currentWeapon)
	print("DEBUG [CLIENT]: Munição atual:", currentAmmo)

	vSERVER.equipSkin(Data,currentWeapon,currentAmmo)
	Callback("Ok")
end)

RegisterNUICallback("removeSkin",function(Data,Callback)
	local currentWeapon = exports["inventory"]:Weapons()
	local ped = PlayerPedId()
	local currentAmmo = GetAmmoInPedWeapon(ped,GetHashKey(currentWeapon))

	vSERVER.removeSkin(currentWeapon,currentAmmo)
	Callback("Ok")
end)