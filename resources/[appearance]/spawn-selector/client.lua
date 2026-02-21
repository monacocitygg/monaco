local spawns = {
    {
        label = "Train",
        coords = {270.66,-1204.27,29.28},
        desc = 'Ótima localizção para se chegar no centro da cidade de forma rápida e segura.'
    },
    {
        label = 'Sandy',
        coords  = {342.23,2638.45,44.48},
        desc  = 'Para quem vive no norte e pretende chegar mais rápido essa é a melhor parada.'
    },
	{
        label = 'Paleto',
        coords  = {-409.58,6063.22,31.49},
        desc  = 'Bairro de Paleto é calmo e pacífico, seus moradores estão sempre bem humorados.'
    },
}


RegisterNUICallback('selectSpawn',function(data,cb)
    local ped = PlayerPedId()

    local mode = data.mode
    local coord = data.coord
    SetNuiFocus(false,false)

    if mode == 1 then
        brokenCamera = false
		DoScreenFadeOut(0)

		Citizen.Wait(500)

		SetCamRot(characterCamera,270.0)
		SetCamActive(characterCamera,true)
		brokenCamera = true
		local speed = 0.7
		weight = 270.0

		DoScreenFadeIn(500)
		SetEntityCoords(ped,coord[1],coord[2],coord[3],1,0,0,0)
		local coords = GetEntityCoords(ped)

		SetCamCoord(characterCamera,coord[1],coord[2],coord[3] + 200.0)
		local i = coord[3] + 200.0

		while i > coord[3] + 1.5 do
			i = i - speed
			SetCamCoord(characterCamera,coord[1],coord[2],i)

			if i <= coord[3] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(characterCamera,weight)
			end

			if not brokenCamera then
				break
			end

			Citizen.Wait(0)
		end
        LocalPlayer["state"]["Invisible"] = false
        SetEntityVisible(ped,true,false)
    else
		lastSpawn()
    end

	SetNuiFocus(false,false)
	TriggerEvent('playerConnect')
	-- TriggerServerEvent("removeFromResidence")
end)

RegisterNetEvent('playerConnect',function()
	
end)

function lastSpawn()
	local ped = PlayerPedId()
	DoScreenFadeOut(300)
	Wait(500)

	SetNuiFocus(false,false)

	LocalPlayer["state"]["Invisible"] = false
	RenderScriptCams(false,false,0,true,true)
		if DoesCamExist(characterCamera) then
		SetCamActive(characterCamera,false)
		DestroyCam(characterCamera,true)
		end
	SetEntityVisible(ped,true,false)
	characterCamera = nil
	brokenCamera = false

	Citizen.Wait(500)

	DoScreenFadeIn(300)
	TriggerEvent("SecondaryHud:enable")
	-- TriggerServerEvent("removeFromResidence")
end

RegisterNetEvent("hookSelector")
AddEventHandler("hookSelector",function(firstSpawn)
	if firstSpawn then
		for t,v in pairs(spawns) do
			local hash = GetStreetNameAtCoord(v.coords[1],v.coords[2],v.coords[3])
			if hash then
				local streetName = GetStreetNameFromHashKey(hash)
				spawns[t].streetName = streetName
			end
		end

		DoScreenFadeOut(0)
		SetNuiFocus(true,true)
		SendNUIMessage({
			'openMenu',GetEntityCoords(PlayerPedId()),spawns
		})
		TriggerEvent("SecondaryHud:enable")
	else
		lastSpawn()
	end
end)