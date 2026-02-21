-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = nil
local ServerCrates = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("startcargo",function(source,args,rawCommand)
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport,"Admin") then
		if not Active then
			ServerCrates = {} -- Resetar caixas ao iniciar
			local routeIndex = math.random(#Config.Routes)
			Active = {
				spawn = {
					x = Config.Routes[routeIndex].spawn.x,
					y = Config.Routes[routeIndex].spawn.y,
					z = Config.Routes[routeIndex].spawn.z,
					w = Config.Routes[routeIndex].spawn.w
				},
				destination = {
					x = Config.Routes[routeIndex].destination.x,
					y = Config.Routes[routeIndex].destination.y,
					z = Config.Routes[routeIndex].destination.z
				},
				cratetype = Config.Routes[routeIndex].cratetype or "mat"
			}
			
			print("CARGO_THEFT: Iniciando rota " .. routeIndex)
			print("CARGO_THEFT: Spawn " .. json.encode(Active.spawn))
			
			TriggerClientEvent("cargo_theft:Start",source,Active)
			-- TriggerClientEvent("Notify",source,"verde","Roubo de carga iniciado.",5000)
		else
			TriggerClientEvent("Notify",source,"vermelho","Já existe um transporte em andamento.",5000)
		end
	end
end)

RegisterCommand("stopcargo",function(source,args,rawCommand)
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport,"Admin") then
		if Active then
			Active = nil
			-- Limpar dados dos baús
			for netId, _ in pairs(ServerCrates) do
				vRP.RemSrvData("Chest:CargoCrate:"..netId, false)
			end
			ServerCrates = {} -- Resetar caixas
			
			TriggerClientEvent("cargo_theft:Stop", -1) -- Enviar evento de stop
			TriggerClientEvent("Notify",source,"verde","Roubo de carga cancelado/finalizado.",5000)
		else
			TriggerClientEvent("Notify",source,"vermelho","Não existe transporte em andamento.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("cargo_theft:Sync")
AddEventHandler("cargo_theft:Sync",function(NetIdTruck,NetIdDriver)
	local source = source
	
	if not Active then return end

	-- Notificar Policia
	local Service = vRP.NumPermission(Config.PolicePermission)
	for Passports,Sources in pairs(Service) do
		async(function()
			TriggerClientEvent("NotifyPush",Sources,{ code = "QRU", title = "Transporte de Carga", x = Active.spawn.x, y = Active.spawn.y, z = Active.spawn.z, vehicle = "Caminhão Blindado", time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
			TriggerClientEvent("Notify",Sources,"police","Temos um novo transportador na cidade.",10000)
		end)
	end

	-- Notificar Ilegal
	local cargoType = "material"
	if Active.cratetype == "weapons" or Active.cratetype == "weapon" then
		cargoType = "armas"
	elseif Active.cratetype == "mat" then
		cargoType = "material"
	end

	local message = "Acabamos de identificar uma nova carga de <b>"..cargoType.."</b> circulando pela região. Nossos hackers invadiram o sistema e localizaram o trajeto. O ponto já está marcado no seu GPS. Intercepte antes que seja tarde."
	TriggerClientEvent("Notify",-1,"ilegal",message,15000)

	-- Resetar após tempo (opcional)
	SetTimeout(Config.ResetTime * 60 * 1000, function()
		if Active then
			-- Limpar dados dos baús
			for netId, _ in pairs(ServerCrates) do
				vRP.RemSrvData("Chest:CargoCrate:"..netId, false)
			end
			ServerCrates = {}
			
			Active = nil
			-- Logica de cleanup se necessário
			TriggerClientEvent("cargo_theft:Stop", -1)
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("cargo_theft:ExplodeTruck")
AddEventHandler("cargo_theft:ExplodeTruck", function(netIdTruck)
	local source = source
	-- Sincroniza explosão/abertura para todos (efeitos visuais)
	TriggerClientEvent("cargo_theft:SyncExplosion", -1, netIdTruck)
	
	-- Apenas quem explodiu spawna as caixas para evitar duplicidade
	TriggerClientEvent("cargo_theft:SpawnCrates", source, netIdTruck)
end)

RegisterServerEvent("cargo_theft:RegisterCrates")
AddEventHandler("cargo_theft:RegisterCrates", function(crateNetIds)
	local lootTable = {}
	local cratetype = "mat"
	
	if Active and Active.cratetype then
		cratetype = Active.cratetype
	end
	
	local rewards = Config.CaixasRewards[cratetype]
	if rewards then
		for _, reward in pairs(rewards) do
			table.insert(lootTable, { item = reward.item, amount = math.ceil(reward.amount / 4) })
		end
	end

	for _, netId in ipairs(crateNetIds) do
		-- Registra o baú no sistema (Chest:CargoCrate:NETID)
		-- Formato esperado: Chest:NOME_DO_BAU
		vRP.SetSrvData("Chest:CargoCrate:"..netId, lootTable, false)
		
		ServerCrates[netId] = true -- Apenas marca como existente
		print("CARGO_THEFT: Caixa registrada: " .. netId .. " | Tipo: " .. cratetype)
	end
end)

RegisterServerEvent("cargo_theft:CollectCrate")
AddEventHandler("cargo_theft:CollectCrate", function(netIdCrate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		print("CARGO_THEFT: Coleta solicitada. NetID Original: " .. tostring(netIdCrate))
		
		-- Tratamento para garantir que o netId seja um número
		local finalNetId = netIdCrate
		if type(netIdCrate) == "string" then
			-- Tenta extrair apenas os números se vier no formato "CargoCrate:32"
			local extractedId = string.match(netIdCrate, "CargoCrate:(%d+)")
			if extractedId then
				finalNetId = tonumber(extractedId)
			else
				finalNetId = tonumber(netIdCrate)
			end
		end
		
		print("CARGO_THEFT: NetID Processado: " .. tostring(finalNetId))
		
		-- Verifica se a caixa está registrada no sistema
		if ServerCrates[finalNetId] then
			local loot = ServerCrates[finalNetId]
			-- Remove do registro para evitar farm infinito
			ServerCrates[finalNetId] = nil
			
			local itemsText = ""
			for _, reward in pairs(loot) do
				vRP.GenerateItem(Passport, reward.item, reward.amount)
				itemsText = itemsText .. reward.amount .. "x " .. reward.item .. ", "
			end
			
			TriggerClientEvent("Notify", source, "verde", "Você coletou: " .. itemsText, 5000)
			
			-- Remove a caixa e o target para todos
			TriggerClientEvent("cargo_theft:RemoveCrate", -1, finalNetId)
			
			-- Tenta deletar server-side se possível (backup)
			local crate = NetworkGetEntityFromNetworkId(finalNetId)
			if DoesEntityExist(crate) then
				DeleteEntity(crate)
			end
			
			-- Verifica se TODAS as caixas foram coletadas
			if next(ServerCrates) == nil and Active then
				print("CARGO_THEFT: Todas as caixas coletadas. Resetando evento.")
				Active = nil
				ServerCrates = {}
				TriggerClientEvent("cargo_theft:Stop", -1)
				TriggerClientEvent("Notify", -1, "verde", "Roubo de carga finalizado com sucesso!", 10000)
			end
		else
			print("CARGO_THEFT: ERRO - Caixa " .. tostring(finalNetId) .. " não encontrada na tabela ServerCrates.")
			TriggerClientEvent("Notify", source, "vermelho", "Caixa não encontrada ou já coletada.", 5000)
		end
	end
end)

RegisterServerEvent("cargo_theft:RemoveTarget")
AddEventHandler("cargo_theft:RemoveTarget", function(netIdCrate)
	TriggerClientEvent("cargo_theft:RemoveTarget", -1, netIdCrate)
end)

RegisterServerEvent("cargo_theft:CrateEmptied")
AddEventHandler("cargo_theft:CrateEmptied", function(netIdCrate)
	local finalNetId = tonumber(netIdCrate)
	if not finalNetId then
		return
	end

	if ServerCrates[finalNetId] then
		ServerCrates[finalNetId] = nil

		if next(ServerCrates) == nil and Active then
			Active = nil
			ServerCrates = {}
			TriggerClientEvent("cargo_theft:Stop", -1)
			TriggerClientEvent("Notify", -1, "verde", "Roubo de carga finalizado com sucesso!", 10000)
		end
	end
end)
