-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Bahamas = {}
Tunnel.bindInterface("doors",Bahamas)
vTASKBAR = Tunnel.getInterface("taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Doors"] = {
-- Police-1 dp principal
[1] = { x = -959.94, y =  -2052.77, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
[2] = { x = -956.13, y = -2049.3, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
[3] = { x =  -953.45, y = -2051.84, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
[4] = { x = 625.72, y = 6.4, z = 82.63, hash = -1821777087, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
[5] = { x = -925.98, y = -2035.20, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police",  },
[6] = { x = -926.82, y = -2034.42, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police",  },
[7] = { x = -953.81, y = -2044.32, z = 9.7, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police" },
[8] = { x = -954.02, y = -2058.36, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", },
[9] = { x = -954.78, y = -2057.61, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police",  },
[10] = { x = -912.94, y = -2033.33, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", },
[11] = { x = -913.69, y = -2032.55, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "Police", },
-- Muni01
[12] = { x = -583.33, y = 228.27, z = 79.43, hash = -612979079, lock = true, text = true, distance = 10, press = 2, perm = "Muni01" },
---lavagem

---lavagem01
[13] = { x =  81.08, y = -231.98, z = 54.66, hash = 1900761809, lock = true, text = true, distance = 10, press = 2, perm = "Lavagem01", },
[14] = { x = 81.2, y = -231.52, z = 54.66, hash = -1680428199, lock = true, text = true, distance = 10, press = 2, perm = "Lavagem01", },
[15] = { x = 88.22, y = -229.5, z = 54.64, hash = 1548312508, lock = true, text = true, distance = 10, press = 2, perm = "Lavagem01", },
---Lester contrabando ,,,25.52
[16] = { x =  1274.51, y = -1720.08, z = 54.76, hash = 1145337974, lock = true, text = true, distance = 10, press = 2, perm = "Lester", },
	---police2 dip
[17] = { x = 399.02, y = -1608.85, z = 29.28, hash = 12866535678, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[18] = { x = 392.55, y = -1635.4, z = 29.28, hash = -1156020871, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[19] = { x = 370.83, y = -1615.45, z = 30.04, hash = 1670919150, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[20] = { x = 369.97, y = -1614.67, z = 30.04, hash = 618295057, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[21] = { x = 369.97, y = -1614.67, z = 30.04, hash = 618295057, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[22] = { x = 380.35, y = -1593.23, z = 30.04, hash = 1670919150, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[23] = { x = 381.12, y = -1593.89, z = 30.04, hash = 618295057, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[24] = { x = 375.01, y = -1613.16, z = 30.04, hash = -1335406364, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
[25] = { x = 383.97, y = -1602.44, z = 30.04, hash = -1335406364, lock = true, text = true, distance = 10, press = 2, perm = "Police" },
---ballas  -1052955611 -2.9,-1809.36,25.34,240.95
[26] = { x = -2.9, y = -1809.36, z = 25.34, hash = -1351120742, lock = true, text = true, distance = 10, press = 2, perm = "Ballas" },
[27] = { x = -0.26, y = -1824.21, z = 29.54, hash = -1052955611, lock = true, text = true, distance = 10, press = 2, perm = "Ballas" },
---Famillies ,,33.65,56.7
[28] = { x = -150.98, y = -1621.93, z = 33.65, hash = 1381046002, lock = true, text = true, distance = 10, press = 2, perm = "Famillies" },
--Marabuntas
[29] = { x = 1251.55, y = -1583.38, z = 54.54, hash = -955445187, lock = true, text = true, distance = 10, press = 2, perm = "Marabuntas" },
[30] = { x =  1252.82, y = -1568.2, z = 58.76, hash = -658590816, lock = true, text = true, distance = 10, press = 2, perm = "Marabuntas" },
--core
[31] = { x =  854.01, y = -1310.28, z = 26.49, hash = -1033001619, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
[32] = { x = 847.11, y = -1314.96, z = 26.45, hash =  -1033001619, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
[33] = { x = 830.35, y = -1310.33, z = 28.26, hash =  -1033001619, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
[34] = { x =  833.37, y = -1298.21, z = 28.17, hash =  -131296141, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
[35] = { x =  835.18, y = -1288.77, z = 28.17, hash = 1557126584, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
[36] = { x =  857.78, y = -1302.09, z = 26.91, hash = -1033001619, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
[37] = { x =   848.95, y = -1284.51, z = 28.17, hash = -1033001619, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
[38] = { x =   858.27, y = -1320.77, z = 28.14, hash = -1033001619, lock = true, text = true, distance = 10, press = 2, perm = "Police", },
--vagos 
[39] = { x =   325.28, y = -1989.91, z = 24.16, hash = 2118614536, lock = true, text = true, distance = 10, press = 2, perm = "Vagos", },
[40] = { x =   336.1, y = -1992.69, z = 24.2, hash = 2118614536, lock = true, text = true, distance = 10, press = 2, perm = "Vagos", },
--Vanilla,,,212.6
[41] = { x =   128.66, y = -1298.63, z = 29.25, hash = 390840000, lock = true, text = true, distance = 10, press = 2, perm = "Vanilla", },
[42] = { x =   113.85, y = -1296.75, z = 29.27, hash = 390840000, lock = true, text = true, distance = 10, press = 2, perm = "Vanilla", },
[43] = { x =    99.83, y = -1293.16, z = 29.27, hash = 390840000, lock = true, text = true, distance = 10, press = 2, perm = "Vanilla", },
[44] = { x =   95.48, y = -1285.19, z = 29.27, hash = 1695461688, lock = true, text = true, distance = 10, press = 2, perm = "Vanilla", },

[45] = { x = -140.43, y = -1599.57, z = 34.83, hash = 852775515, lock = true, text = true, distance = 10, press = 2, perm = "Famillies" },
	[46] = { x = -147.96, y = -1596.47, z = 34.83, hash = 852775515, lock = true, text = true, distance = 10, press = 2, perm = "Famillies" },
	[47] = { x = -157.17, y = -1596.18, z = 35.03, hash = 1150875108, lock = true, text = true, distance = 10, press = 2, perm = "Famillies" },
	[48] = { x = 72.06, y = -1939.54, z = 21.38, hash = -543490328, lock = true, text = true, distance = 10, press = 2, perm = "Ballas" },
	[49] = { x = 118.59, y = -1921.04, z = 21.31, hash = -543490328, lock = true, text = true, distance = 10, press = 2, perm = "Ballas" },
	[50] = { x = 981.62, y = -102.6, z = 74.85, hash = 190770132, lock = true, text = true, distance = 10, press = 2, perm = "Ballas" },
-------------mecanica 
[51] = { x = -797.02, y = -2579.81, z = 14.0, hash = -427498890, lock = true, text = true, distance = 10, press = 2, perm = "Mechanic" },
[52] = { x = -779.63, y = -2588.9, z = 17.66, hash = -2017681528, lock = true, text = true, distance = 10, press = 2, perm = "Mechanic" },
	-------------paramedic 
[53] = { x = -2784.01, y = -74.95, z = 18.6, hash = -341973294, lock = true, text = true, distance = 10, press = 2, perm = "Paramedic" },
[54] = { x = 981.62, y = -102.6, z = 74.85, hash = 190770132, lock = true, text = true, distance = 10, press = 2, perm = "Ballas" }
}




-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
function Bahamas.doorsStatistics(doorNumber,doorStatus)
	local Doors = GlobalState["Doors"]

	Doors[doorNumber]["lock"] = doorStatus

	if Doors[doorNumber]["other"] ~= nil then
		local doorSecond = Doors[doorNumber]["other"]
		Doors[doorSecond]["lock"] = doorStatus
	end

	GlobalState["Doors"] = Doors
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Bahamas.doorsPermission(doorNumber)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if GlobalState["Doors"][doorNumber]["perm"] ~= nil then
			if vRP.HasGroup(Passport,GlobalState["Doors"][doorNumber]["perm"]) then
				return true
			end
		end
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDPORTA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("doors:addDoor")
AddEventHandler("doors:addDoor",function(coords,hash,perm)
	local source = source
	local user_id = vRP.getUserId(source)
	print("DEBUG SERVER: Recebido pedido para adicionar porta. Source: "..tostring(source).." UserID: "..tostring(user_id))
	
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			print("DEBUG SERVER: Permissão aceita.")
			local Doors = GlobalState["Doors"]
			local newId = #Doors + 1
			print("DEBUG SERVER: Novo ID será: "..tostring(newId))

			Doors[newId] = { 
				x = math.floor(coords.x*100)/100, 
				y = math.floor(coords.y*100)/100, 
				z = math.floor(coords.z*100)/100, 
				hash = hash, 
				lock = true, 
				text = true, 
				distance = 10, 
				press = 2, 
				perm = perm 
			}
			GlobalState["Doors"] = Doors
			print("DEBUG SERVER: GlobalState atualizado.")

			local content = LoadResourceFile(GetCurrentResourceName(),"server-side/server.lua")
			if content then
				print("DEBUG SERVER: Arquivo lido com sucesso. Tamanho: "..string.len(content))
				local lines = {}
				for line in content:gmatch("([^\r\n]*)\r?\n") do
					table.insert(lines,line)
				end

				local insertIndex = 0
				-- Procura pelo fechamento da tabela GlobalState["Doors"]
				-- Vamos procurar a linha que contem apenas "}" antes da proxima seção
				for i,line in ipairs(lines) do
					if line:find("function Bahamas.doorsStatistics") then
						print("DEBUG SERVER: Encontrou a função seguinte na linha "..i)
						for j=i-1,1,-1 do
							-- Procura um '}' isolado ou no inicio da linha
							if lines[j]:match("^%s*}") then
								insertIndex = j
								print("DEBUG SERVER: Local de inserção encontrado na linha "..j)
								break
							end
						end
						break
					end
				end

				if insertIndex > 0 then
					-- Garante que a linha anterior tenha virgula antes de adicionar a nova (que nao tera virgula)
					-- Scan backwards for the last meaningful line to add a comma if needed
					local previousDataIndex = 0
					for j = insertIndex - 1, 1, -1 do
						local lineContent = lines[j]:gsub("%s+", "") -- Remove whitespace for check
						if lineContent ~= "" and not lineContent:find("^%-%-") then -- Not empty and not just a comment
							previousDataIndex = j
							break
						end
					end

					if previousDataIndex > 0 then
						-- If the line has an inline comment, we need to handle it carefully
						local line = lines[previousDataIndex]
						local commentStart = line:find("%-%-")
						
						if commentStart then
							-- Check content before comment
							local preComment = line:sub(1, commentStart-1)
							if not preComment:match(",%s*$") and not preComment:find("GlobalState") then
								-- Insert comma before comment
								lines[previousDataIndex] = preComment .. "," .. line:sub(commentStart)
							end
						else
							if not line:find(",%s*$") and not line:find("GlobalState") then
								lines[previousDataIndex] = line .. ","
							end
						end
					end

					local newDoor = string.format('\t[%d] = { x = %.2f, y = %.2f, z = %.2f, hash = %d, lock = true, text = true, distance = 10, press = 2, perm = "%s" }',newId,coords.x,coords.y,coords.z,hash,perm)
					table.insert(lines,insertIndex,newDoor)
					
					local newContent = table.concat(lines,"\n")
					local saved = SaveResourceFile(GetCurrentResourceName(),"server-side/server.lua",newContent,-1)
					
					if saved then
						print("DEBUG SERVER: Arquivo salvo com sucesso!")
						TriggerClientEvent("Notify",source,"verde","Porta adicionada e salva com sucesso. ID: "..newId,5000)
					else
						print("DEBUG SERVER: FALHA ao salvar o arquivo!")
						TriggerClientEvent("Notify",source,"vermelho","Erro ao salvar no arquivo.",5000)
					end
				else
					print("DEBUG SERVER: Não foi possível encontrar o local correto para inserir a nova porta no arquivo.")
					TriggerClientEvent("Notify",source,"vermelho","Erro ao encontrar local de inserção no script.",5000)
				end
			else
				print("DEBUG SERVER: Falha ao ler o arquivo server.lua")
			end
		else
			print("DEBUG SERVER: Permissão negada para user_id "..user_id)
			TriggerClientEvent("Notify",source,"vermelho","Sem permissão.",5000)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REMPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("doors:removeDoor")
AddEventHandler("doors:removeDoor",function(coords,hash)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local Doors = GlobalState["Doors"]
			local doorId = nil
			local doorDist = 1.5

			for k,v in pairs(Doors) do
				local distance = #(vector3(v.x,v.y,v.z) - vector3(coords.x,coords.y,coords.z))
				if distance < doorDist then
					doorId = k
					doorDist = distance
				end
			end

			if doorId then
				local doorData = Doors[doorId]
				
				-- Desbloquear a porta para todos os clientes antes de remover
				TriggerClientEvent("doors:forceUnlock",-1,doorData,doorData.hash)
				
				Doors[doorId] = nil
				GlobalState["Doors"] = Doors
				
				local content = LoadResourceFile(GetCurrentResourceName(),"server-side/server.lua")
				if content then
					local lines = {}
					for line in content:gmatch("([^\r\n]*)\r?\n") do
						table.insert(lines,line)
					end

					local removed = false
					for i,line in ipairs(lines) do
						-- Procura pelo padrao do ID da porta: [ID] = { ... }
						if line:find("%["..doorId.."%]%s*=") then
							table.remove(lines,i)
							removed = true
							print("DEBUG SERVER: Linha removida: "..i)
							break
						end
					end

					if removed then
						local newContent = table.concat(lines,"\n")
						SaveResourceFile(GetCurrentResourceName(),"server-side/server.lua",newContent,-1)
						TriggerClientEvent("Notify",source,"verde","Porta removida com sucesso! (ID: "..doorId..")",5000)
					else
						TriggerClientEvent("Notify",source,"amarelo","Porta removida do jogo, mas não encontrada no arquivo (ID: "..doorId..").",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"vermelho","Nenhuma porta registrada encontrada próxima.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Sem permissão.",5000)
		end
	end
end)