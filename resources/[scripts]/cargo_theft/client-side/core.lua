-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Truck = nil
local Driver = nil
local EscortVehicles = {}
local EscortDrivers = {}
local SpawnedCrates = {} -- Rastrear caixas para cleanup
local AlreadyExploded = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- START EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cargo_theft:Start")
AddEventHandler("cargo_theft:Start",function(Route)
	print("CARGO_THEFT: Evento recebido no cliente.")
	
	if not Route then
		print("CARGO_THEFT: Erro - Rota não recebida.")
		return
	end

	print("CARGO_THEFT: Rota recebida - Spawn: " .. json.encode(Route.spawn) .. " | Destino: " .. json.encode(Route.destination))

	local mhash = GetHashKey(Config.TruckModel)
	local dhash = GetHashKey(Config.DriverModel)

	print("CARGO_THEFT: Carregando modelos... " .. Config.TruckModel .. " / " .. Config.DriverModel)

	RequestModel(mhash)
	while not HasModelLoaded(mhash) do
		Wait(10)
	end

	RequestModel(dhash)
	while not HasModelLoaded(dhash) do
		Wait(10)
	end

	print("CARGO_THEFT: Modelos carregados.")

	if HasModelLoaded(mhash) and HasModelLoaded(dhash) then
		-- Verifica coordenadas
		local x, y, z, w = Route.spawn.x, Route.spawn.y, Route.spawn.z, Route.spawn.w
		if not w then w = 0.0 end -- Fallback se w não existir (vector3)

		print("CARGO_THEFT: Criando veiculo em: " .. x .. ", " .. y .. ", " .. z)
		
		Truck = CreateVehicle(mhash,x,y,z,w,true,true)
		print("CARGO_THEFT: Veiculo criado: " .. tostring(Truck))
		
		Driver = CreatePed(4,dhash,x,y,z,w,true,true)
		print("CARGO_THEFT: Ped criado: " .. tostring(Driver))

		SetEntityAsMissionEntity(Truck,true,true)
		SetEntityAsMissionEntity(Driver,true,true)

		SetModelAsNoLongerNeeded(mhash)
		SetModelAsNoLongerNeeded(dhash)

		SetPedIntoVehicle(Driver,Truck,-1)

		SetDriverAbility(Driver, 1.0)
		SetDriverAggressiveness(Driver, 0.0)
		
		-- Performance do Caminhão
		SetVehicleModKit(Truck, 0)
		SetVehicleMod(Truck, 11, 2, false) -- Motor Nível 3
		SetVehicleMod(Truck, 12, 2, false) -- Freio Nível 3
		SetVehicleMod(Truck, 13, 2, false) -- Transmissão Nível 3
		SetVehicleEnginePowerMultiplier(Truck, 20.0) -- Boost de Potência

		-- Dirigir até o destino
		print("CARGO_THEFT: Iniciando rota para: " .. json.encode(Route.destination))
		TaskVehicleDriveToCoord(Driver, Truck, Route.destination.x, Route.destination.y, Route.destination.z, Config.Speed, 0, mhash, Config.DrivingStyle, 2.0, 0.0)
		
		-- Escolta
		if Config.Escort.enabled then
			SpawnEscort(Route.spawn, Truck)
		end

		-- Sincronizar com o servidor
		TriggerServerEvent("cargo_theft:Sync", NetworkGetNetworkIdFromEntity(Truck), NetworkGetNetworkIdFromEntity(Driver))

		-- Adicionar Blip
		AddBlipForTruck(Truck, Route.cratetype)

	else
		print("CARGO_THEFT: Falha ao carregar modelos.")
	end
end)

function AddBlipForTruck(entity, cargoType)
	local blip = AddBlipForEntity(entity)
	SetBlipSprite(blip,477)
	SetBlipColour(blip,2) -- Verde
	SetBlipScale(blip,0.8)
	SetBlipAsShortRange(blip,false)

	local cargoName = cargoType
	if cargoType == "mat" then
		cargoName = "Material"
	elseif cargoType == "weapons" then
		cargoName = "Weapons"
	end

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Carga de " .. cargoName)
	EndTextCommandSetBlipName(blip)
end

function SpawnEscort(spawnCoords, truckEntity)
	local eHash = GetHashKey(Config.Escort.model)
	local edHash = GetHashKey(Config.Escort.driver)
	
	ProcessedPeds = {} -- Resetar estado ao spawnar novos
	AlreadyExploded = false
	
	print("CARGO_THEFT: SpawnEscort iniciado.")

	RequestModel(eHash)
	while not HasModelLoaded(eHash) do Wait(10) end

	RequestModel(edHash)
	while not HasModelLoaded(edHash) do Wait(10) end

	print("CARGO_THEFT: Modelos de escolta carregados.")

	local offset = 10.0

	for i=1, Config.Escort.amount do
		local ex, ey, ez = table.unpack(GetOffsetFromEntityInWorldCoords(truckEntity, 0.0, -offset * i, 0.0))
		local heading = GetEntityHeading(truckEntity)

		local eVehicle = CreateVehicle(eHash, ex, ey, ez, heading, true, true)
		local eDriver = CreatePed(4, edHash, ex, ey, ez, heading, true, true)

		SetEntityAsMissionEntity(eVehicle, true, true)
		SetEntityAsMissionEntity(eDriver, true, true)

		SetPedIntoVehicle(eDriver, eVehicle, -1)
		
		SetDriverAbility(eDriver, 1.0)
		SetDriverAggressiveness(eDriver, 0.0)
		
		-- Impede que o NPC fuja ou reaja a tiros
		SetPedFleeAttributes(eDriver, 0, 0)
		SetPedCombatAttributes(eDriver, 17, false) -- BF_AlwaysFlee = false
		SetPedCombatAttributes(eDriver, 46, true)  -- BF_CanFightArmedPedsWhenNotArmed = true
		SetPedCombatAttributes(eDriver, 5, false)  -- BF_CanFightArmedPeds = false
		SetPedCombatAttributes(eDriver, 0, false)  -- BF_CanUseCover = false
		SetBlockingOfNonTemporaryEvents(eDriver, true)
		SetPedKeepTask(eDriver, true)
		
		-- Performance da Escolta
		SetVehicleModKit(eVehicle, 0)
		SetVehicleMod(eVehicle, 11, 2, false)
		SetVehicleMod(eVehicle, 12, 2, false)
		SetVehicleMod(eVehicle, 13, 2, false)
		SetVehicleEnginePowerMultiplier(eVehicle, 40.0)

		-- Seguir o caminhão
		TaskVehicleEscort(eDriver, eVehicle, truckEntity, -1, Config.Speed + 15.0, 1074528293, 10.0, 0, 0)
		
		table.insert(EscortVehicles, eVehicle)
		table.insert(EscortDrivers, eDriver)

		-- Adicionar passageiro
		for seat=0, 0 do
			if IsVehicleSeatFree(eVehicle, seat) then
				local ePassenger = CreatePed(4, edHash, ex, ey, ez, heading, true, true)
				SetEntityAsMissionEntity(ePassenger, true, true)
				SetPedIntoVehicle(ePassenger, eVehicle, seat)
				
				SetPedFleeAttributes(ePassenger, 0, 0)
				SetPedCombatAttributes(ePassenger, 17, false)
				SetPedCombatAttributes(ePassenger, 46, true)
				SetBlockingOfNonTemporaryEvents(ePassenger, true)
				SetPedKeepTask(ePassenger, true)
				
				table.insert(EscortDrivers, ePassenger)
			end
		end
	end
	
	print("CARGO_THEFT: SpawnEscort finalizado com sucesso.")
end

RegisterNetEvent("cargo_theft:SyncExplosion")
AddEventHandler("cargo_theft:SyncExplosion", function(netIdTruck)
	local truck = NetworkGetEntityFromNetworkId(netIdTruck)
	
	if DoesEntityExist(truck) then
		local coords = GetOffsetFromEntityInWorldCoords(truck, 0.0, -4.0, 1.0)
		
		-- Efeito visual e sonoro da explosão
		AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
		
		-- Atualiza o Blip para Vermelho e "Carga Roubada"
		local blip = GetBlipFromEntity(truck)
		if DoesBlipExist(blip) then
			SetBlipColour(blip, 1) -- Red
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Carga Roubada")
			EndTextCommandSetBlipName(blip)
		end

		-- Abre as portas traseiras
		SetVehicleDoorOpen(truck, 2, false, false) -- Traseira Esquerda
		SetVehicleDoorOpen(truck, 3, false, false) -- Traseira Direita
		SetVehicleDoorBroken(truck, 2, false)
		SetVehicleDoorBroken(truck, 3, false)
		
		-- Notifica
		TriggerEvent("Notify", "sucesso", "Carga liberada!", 5000)
	end
end)

RegisterNetEvent("cargo_theft:SpawnCrates")
AddEventHandler("cargo_theft:SpawnCrates", function(netIdTruck)
	if AlreadyExploded then return end -- Evita duplicidade
	AlreadyExploded = true

	local truck = NetworkGetEntityFromNetworkId(netIdTruck)
	if DoesEntityExist(truck) then
		SpawnCargoCrates(truck)
	end
end)

function SpawnCargoCrates(truck)
	local model = GetHashKey("prop_mil_crate_01")
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(10) end
	
	print("CARGO_THEFT: Iniciando Spawn das Caixas...")
	
	-- Coordenadas base atrás do caminhão
	local baseCoords = GetOffsetFromEntityInWorldCoords(truck, 0.0, -6.0, -0.9)
	local heading = GetEntityHeading(truck)
	
	-- Posições relativas para as 4 caixas (espalhadas atrás)
	-- Aumentando espaçamento para evitar colisão e sobreposição visual
	local offsets = {
		{x = -1.5, y = 0.0}, -- Esquerda Trás
		{x = 1.5, y = 0.0},  -- Direita Trás
		{x = -1.5, y = -2.5}, -- Esquerda Mais Trás (Afastado)
		{x = 1.5, y = -2.5}   -- Direita Mais Trás (Afastado)
	}
	
	local spawnedNetIds = {}
	
	for i, offset in ipairs(offsets) do
		-- Calcula a posição exata baseada na rotação do caminhão
		local crateCoords = GetOffsetFromEntityInWorldCoords(truck, offset.x, -6.0 + offset.y, 0.0)
		
		-- Raycast para colocar no chão corretamente
		local foundGround, zPos = GetGroundZFor_3dCoord(crateCoords.x, crateCoords.y, crateCoords.z + 10.0, 0)
		if foundGround then
			crateCoords = vector3(crateCoords.x, crateCoords.y, zPos)
		else
			-- Fallback se não achar o chão
			crateCoords = vector3(crateCoords.x, crateCoords.y, crateCoords.z - 0.9)
		end
		
		print("CARGO_THEFT: Criando caixa " .. i .. " em " .. crateCoords)
		
		local crate = CreateObjectNoOffset(model, crateCoords.x, crateCoords.y, crateCoords.z, true, true, false)
		SetEntityHeading(crate, heading + math.random(-20, 20))
		PlaceObjectOnGroundProperly(crate)
		FreezeEntityPosition(crate, true)
		
		-- Target Integration
		local netId = NetworkGetNetworkIdFromEntity(crate)
		
		-- Garante que o NetID existe
		if netId ~= 0 then
			local crateName = "CargoCrate:"..netId
			-- Usando CircleZone que é mais permissiva e fácil de acertar
			exports["target"]:AddCircleZone(crateName, vec3(crateCoords.x, crateCoords.y, crateCoords.z), 1.5, {
				name = crateName,
				heading = heading,
				useZ = true,
				debugPoly = false
			}, {
				shop = crateName,
				Distance = 2.5,
				options = {
					{
						event = "chest:Open",
						label = "Abrir Carga",
						tunnel = "shop",
						service = "Carga"
					}
				}
			})
			
			table.insert(SpawnedCrates, crate)
			table.insert(spawnedNetIds, netId)
		end
	end
	
	-- Envia os NetIDs para o servidor registrar
	if #spawnedNetIds > 0 then
		TriggerServerEvent("cargo_theft:RegisterCrates", spawnedNetIds)
	end
	
	SetModelAsNoLongerNeeded(model)
	print("CARGO_THEFT: Spawn das Caixas concluído.")
end

RegisterNetEvent("cargo_theft:RemoveCrate")
AddEventHandler("cargo_theft:RemoveCrate", function(netIdCrate)
	-- Remove o target
	exports["target"]:RemCircleZone("CargoCrate:"..netIdCrate)
	
	-- Tenta remover a entidade se ela existir localmente
	if NetworkDoesNetworkIdExist(netIdCrate) then
		local entity = NetworkGetEntityFromNetworkId(netIdCrate)
		if DoesEntityExist(entity) then
			DeleteEntity(entity)
		end
	end
end)

RegisterNetEvent("cargo_theft:OpenChest")
AddEventHandler("cargo_theft:OpenChest", function(Name)
	-- Chama diretamente o evento do chest client-side
	TriggerServerEvent("chest:Open", Name, "Carga")
end)

-- Detecta explosão da C4 (vRP Item)
RegisterNetEvent("vRP:Explosion")
AddEventHandler("vRP:Explosion", function(coords)
	if DoesEntityExist(Truck) then
		local truckCoords = GetEntityCoords(Truck)
		local dist = #(vector3(coords.x, coords.y, coords.z) - truckCoords)
		
		-- Se a explosão for perto do caminhão (5 metros)
		if dist <= 5.0 then
			-- Verifica se as portas estão fechadas (GetVehicleDoorAngleRatio <= 0.1)
			if GetVehicleDoorAngleRatio(Truck, 2) <= 0.1 and GetVehicleDoorAngleRatio(Truck, 3) <= 0.1 then
				print("CARGO_THEFT: Explosão detectada perto do caminhão! Abrindo portas...")
				TriggerServerEvent("cargo_theft:ExplodeTruck", NetworkGetNetworkIdFromEntity(Truck))
			end
		end
	end
end)

RegisterNetEvent("cargo_theft:Stop")
AddEventHandler("cargo_theft:Stop", function()
	Cleanup()
end)

function Cleanup()
	-- Limpar Veículos e NPCs
	if DoesEntityExist(Truck) then DeleteEntity(Truck) end
	if DoesEntityExist(Driver) then DeleteEntity(Driver) end
	
	for _, veh in pairs(EscortVehicles) do
		if DoesEntityExist(veh) then DeleteEntity(veh) end
	end
	
	for _, ped in pairs(EscortDrivers) do
		if DoesEntityExist(ped) then DeleteEntity(ped) end
	end
	
	-- Limpar Caixas e Targets
	for _, crate in pairs(SpawnedCrates) do
		if DoesEntityExist(crate) then
			local netId = NetworkGetNetworkIdFromEntity(crate)
			exports["target"]:RemCircleZone("CargoCrate:"..netId)
			DeleteEntity(crate)
		end
	end
	
	-- Resetar Variáveis
	Truck = nil
	Driver = nil
	EscortVehicles = {}
	EscortDrivers = {}
	SpawnedCrates = {}
	AlreadyExploded = false
	InCombat = false
	
	print("CARGO_THEFT: Limpeza concluída.")
end

AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end
	Cleanup()
	print("CARGO_THEFT: Recurso parado. Entidades limpas.")
end)
