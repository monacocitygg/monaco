-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("dynamic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Dynamic = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
local HashAnimal = nil
local SpawnAnimal = false
local FollowAnimal = false
--------------------------------------------------------------------------------------port---------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server)
	SendNUIMessage({ addbutton = true,title = title,description = description,trigger = trigger,par = par,id = id,server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,id)
	SendNUIMessage({ addmenu = true,title = title,description = description,menuid = id })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("openMenu",function()
	SendNUIMessage({ show = true })
	SetNuiFocus(true,true)
	Dynamic = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(Data,Callback)
	if Data["trigger"] and Data["trigger"] ~= "" then
		if Data["server"] == "true" then
			TriggerServerEvent(Data["trigger"],Data["param"])
		else
			TriggerEvent(Data["trigger"],Data["param"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)
	Dynamic = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem",function()
	if Dynamic then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		Dynamic = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:POLICENOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:PoliceNotify")
AddEventHandler("dynamic:PoliceNotify",function(data)
	local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(data["x"],data["y"],data["z"]))
	TriggerEvent("Notify","police",data["code"].." "..street.."<br>Enviado por: "..data["name"],10000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions",function()
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Prison"] and not Dynamic and not IsPauseMenuActive() then
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		if GetEntityHealth(Ped) > 100 then
			if HashAnimal ~= nil then
				exports["dynamic"]:AddButton("Seguir","Seguir o proprietário.","dynamic:animalFunctions","follow","animals",false)
				exports["dynamic"]:AddButton("Colocar no Veículo","Colocar o animal no veículo.","dynamic:animalFunctions","putvehicle","animals",false)
				exports["dynamic"]:AddButton("Remover do Veículo","Remover o animal no veículo.","dynamic:animalFunctions","removevehicle","animals",false)
				exports["dynamic"]:SubMenu("Domésticos","Tudo sobre animais domésticos.","animals")
			end

			if LocalPlayer["state"]["Premium"] then
				exports["dynamic"]:AddButton("Vestir Premium","Vestir-se com as vestimentas guardadas.","player:Outfit","aplicarpre","wardrobe",true)
				exports["dynamic"]:AddButton("Guardar Premium","Salvar suas vestimentas do corpo.","player:Outfit","salvarpre","wardrobe",true)
			end

			exports["dynamic"]:AddButton("Armário","Colocar/Retirar roupas.","wardrobe:open","",false,false)

			exports["dynamic"]:AddButton("Chapéu","Colocar/Retirar o chapéu.","player:Outfit","Hat","clothes",true)
			exports["dynamic"]:AddButton("Máscara","Colocar/Retirar a máscara.","player:Outfit","Mask","clothes",true)
			exports["dynamic"]:AddButton("Óculos","Colocar/Retirar o óculos.","player:Outfit","Glasses","clothes",true)
			exports["dynamic"]:AddButton("Sapatos","Colocar/Retirar o sapato.","player:Outfit","Shoes","clothes",true)
			exports["dynamic"]:SubMenu("Roupas","Colocar/Retirar roupas.","clothes")

			local Vehicle = vRP.ClosestVehicle(7)
			if IsEntityAVehicle(Vehicle) then
				if not IsPedInAnyVehicle(Ped) then
					if vRP.ClosestPed(3) then
						exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","closestpeds",true)
						exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","closestpeds",true)

						exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","closestpeds")
					end
				else
					exports["dynamic"]:AddButton("Sentar no Motorista","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
					exports["dynamic"]:AddButton("Sentar no Passageiro","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
					exports["dynamic"]:AddButton("Sentar em Outros","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
					exports["dynamic"]:AddButton("Mexer nos Vidros","Levantar/Abaixar os vidros.","player:Windows","","vehicle",false)

					exports["dynamic"]:SubMenu("Veículo","Funções do veículo.","vehicle")
				end
			end

			exports["dynamic"]:AddButton("Rebocar","Colocar/Remover o veículo na prancha.","inventory:InvokeTow","","others",false)
			exports["dynamic"]:AddButton("Propriedades","Marcar/Desmarcar propriedades no mapa.","propertys:Blips","","others",false)
			exports["dynamic"]:AddButton("Armazéns","Marcar/Desmarcar armazéns no mapa.","warehouse:Blips","","others",false)
			exports["dynamic"]:AddButton("Ferimentos","Verificar ferimentos no corpo.","paramedic:Injuries","","others",false)
			exports["dynamic"]:AddButton("Desbugar","Recarregar o personagem.","player:Debug","","others",true)
			exports["dynamic"]:SubMenu("Outros","Todas as funções do personagem.","others")

			exports["dynamic"]:openMenu()
		end
	end
end)

RegisterNetEvent("dynamic:RemoverRoupasPreset")
AddEventHandler("dynamic:RemoverRoupasPreset",function()
	local Ped = PlayerPedId()
	local Model = GetEntityModel(Ped)
	if Model == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(Ped,11,15,0,0)
		SetPedComponentVariation(Ped,3,15,0,0)
		SetPedComponentVariation(Ped,4,14,0,0)
		SetPedComponentVariation(Ped,6,16,0,0)
		SetPedComponentVariation(Ped,8,15,0,0)
	else
		SetPedComponentVariation(Ped,4,14,0,0)
		SetPedComponentVariation(Ped,6,16,0,0)
		SetPedComponentVariation(Ped,8,15,0,0)
		SetPedComponentVariation(Ped,11,15,0,0)
		SetPedComponentVariation(Ped,3,15,0,0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TENCODEFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tencodeFunctions",function()
	if (LocalPlayer["state"]["Police"]) and not IsPauseMenuActive() then
		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and LocalPlayer["state"]["Route"] < 900000 then

			if LocalPlayer["state"]["Police"] then
				exports["dynamic"]:AddButton("QTI","Deslocamento.","dynamic:Tencode","1",false,true)
				exports["dynamic"]:AddButton("QTH","Localização.","dynamic:Tencode","2",false,true)
				exports["dynamic"]:AddButton("QRR","Apoio com prioridade.","dynamic:Tencode","3",false,true)
				exports["dynamic"]:AddButton("QRT","Oficial desmaiado/ferido.","dynamic:Tencode","4",false,true)
			end

			exports["dynamic"]:openMenu()
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions",function()
	if (LocalPlayer["state"]["Police"] or LocalPlayer["state"]["Paramedic"]) and not IsPauseMenuActive() then
		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not Dynamic and MumbleIsConnected() then
			local Ped = PlayerPedId()
			if LocalPlayer["state"]["Police"] then
				if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
					exports["dynamic"]:AddButton("Carregar","Carregar a pessoa mais próxima.","player:carryPlayer","","player",true)
					exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","player",true)
					exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","player",true)
					exports["dynamic"]:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","skinshop:Remove","Hat","player",true)
					exports["dynamic"]:AddButton("Remover Máscara","Remover da pessoa mais próxima.","skinshop:Remove","Mask","player",true)
					exports["dynamic"]:AddButton("Remover Óculos","Remover da pessoa mais próxima.","skinshop:Remove","Glasses","player",true)
					exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","player")
					exports["dynamic"]:AddButton("Anuncio para Ação", "Fazer um anúncio para todos os moradores.", "dynamic:PoliceAnuncio", "anuncio", false,true)
					exports["dynamic"]:AddButton("Fechar Perímetro", "Fechar Perímetro.", "dynamic:PoliceAnuncio2", "anuncio", false,true)
					exports["dynamic"]:AddButton("Abrir Perímetro", "Abrir Perímetro", "dynamic:PoliceAnuncio3", "anuncio", false,true)
				    exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce2", "anuncio", false,true)
					exports["dynamic"]:AddButton("Computador","Computador de bordo Policel.","police:Mdt","",false,false)
				end

				exports["dynamic"]:openMenu()
			elseif LocalPlayer["state"]["Paramedic"] then
				if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
					exports["dynamic"]:AddButton("Carregar","Carregar a pessoa mais próxima.","player:carryPlayer","","player",true)
					exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","player",true)
					exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","player",true)
					exports["dynamic"]:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","skinshop:Remove","Hat","player",true)
					exports["dynamic"]:AddButton("Remover Máscara","Remover da pessoa mais próxima.","skinshop:Remove","Mask","player",true)
					exports["dynamic"]:AddButton("Remover Óculos","Remover da pessoa mais próxima.","skinshop:Remove","Glasses","player",true)
					exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","player")
					exports["dynamic"]:openMenu()
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","F9")
RegisterKeyMapping("tencodeFunctions","Abrir menu de chamados policiais.","keyboard","F3")
RegisterKeyMapping("emergencyFunctions","Abrir menu de emergencial.","keyboard","F10")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalSpawn")
AddEventHandler("dynamic:animalSpawn",function(Model)
	if HashAnimal == nil then
		if not SpawnAnimal then
			SpawnAnimal = true

			local Ped = PlayerPedId()
			local Heading = GetEntityHeading(Ped)
			local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,1.0,0.0)
			local myObject,objNet = vRPS.CreatePed(Model,Coords["x"],Coords["y"],Coords["z"],Heading,28)
			if myObject then
				local Entity = LoadNetwork(objNet)
				if Entity then
					local SpawnAnimal = 0

					HashAnimal = NetworkGetEntityFromNetworkId(objNet)
					while not DoesEntityExist(HashAnimal) and SpawnAnimal <= 1000 do
						HashAnimal = NetworkGetEntityFromNetworkId(objNet)
						SpawnAnimal = SpawnAnimal + 1
						Wait(1)
					end

					SpawnAnimal = 0
					local PedControl = NetworkRequestControlOfEntity(HashAnimal)
					while not PedControl and SpawnAnimal <= 1000 do
						PedControl = NetworkRequestControlOfEntity(HashAnimal)
						SpawnAnimal = SpawnAnimal + 1
						Wait(1)
					end

					SetPedCanRagdoll(HashAnimal,false)
					SetEntityInvincible(HashAnimal,true)
					SetPedFleeAttributes(HashAnimal,0,0)
					SetEntityAsMissionEntity(HashAnimal,true,false)
					SetBlockingOfNonTemporaryEvents(HashAnimal,true)
					SetPedRelationshipGroupHash(HashAnimal,GetHashKey("k9"))
					GiveWeaponToPed(HashAnimal,GetHashKey("WEAPON_ANIMAL"),200,true,true)

					SetEntityAsNoLongerNeeded(HashAnimal)

					TriggerEvent("dynamic:animalFunctions","follow")

					vSERVER.RegisterAnimal(objNet)
				end
			end

			SpawnAnimal = false
		end
	else
		vSERVER.ClearAnimal()
		FollowAnimal = false
		HashAnimal = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalFunctions")
AddEventHandler("dynamic:animalFunctions",function(functions)
	if HashAnimal ~= nil then
		local Ped = PlayerPedId()
		if functions == "follow" then
			if not FollowAnimal then
				TaskFollowToOffsetOfEntity(HashAnimal,Ped,1.0,1.0,0.0,5.0,-1,2.5,1)
				SetPedKeepTask(HashAnimal,true)
				FollowAnimal = true
			else
				SetPedKeepTask(HashAnimal,false)
				ClearPedTasks(HashAnimal)
				FollowAnimal = false
			end
		elseif functions == "putvehicle" then
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				local vehicle = GetVehiclePedIsUsing(Ped)
				if IsVehicleSeatFree(vehicle,0) then
					TaskEnterVehicle(HashAnimal,vehicle,-1,0,2.0,16,0)
				end
			end
		elseif functions == "removevehicle" then
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				TaskLeaveVehicle(HashAnimal,GetVehiclePedIsUsing(Ped),256)
				TriggerEvent("dynamic:animalFunctions","follow")
			end
		elseif functions == "destroy" then
			vSERVER.ClearAnimal()
			FollowAnimal = false
			HashAnimal = nil
		end
	end
end)
