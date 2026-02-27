-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("admin",Creative)
vCLIENT = Tunnel.getInterface("admin")
vKEYBOARD = Tunnel.getInterface("keyboard")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CARRYPLAYERADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
local playerCarryAdmin = {}
function Creative.CarryPlayerAdmin()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",3) then
			if not vRP.InsideVehicle(source) then
				if playerCarryAdmin[Passport] then
					TriggerClientEvent("player:playerCarryAdmin",playerCarryAdmin[Passport],source)
					TriggerClientEvent("player:Commands",playerCarryAdmin[Passport],false)
					playerCarryAdmin[Passport] = nil
				else
					local ClosestPed = vRPC.ClosestPed(source,2)
					if ClosestPed then
						playerCarryAdmin[Passport] = ClosestPed

						TriggerClientEvent("player:playerCarryAdmin",playerCarryAdmin[Passport],source)
						TriggerClientEvent("player:Commands",playerCarryAdmin[Passport],true)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTARTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("restarte",function(source,Message,History)
	if source == 0 then
		GlobalState["Weather"] = "THUNDER"
		TriggerClientEvent("Notify",-1,"amarelo","Um grande terremoto se aproxima, abriguem-se enquanto há tempo pois o terremoto chegará em" ..History:sub(9).. " minutos.",60000)
		print("Terremoto anunciado")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTARTEDCANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("restartecancel",function(source)
	if source == 0 then
		GlobalState["Weather"] = "EXTRASUNNY"
		TriggerClientEvent("Notify",-1,"amarelo","Nosso sistema meteorológico detectou que o terremoto passou por agora, porém o mesmo pode voltar a qualquer momento",60000)
		print("Terremoto cancelado")
	end
end)

RegisterCommand("id", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 1) and tonumber(args[1]) > 0 then
            local Identity = vRP.Identity(tonumber(args[1]))
            if Identity then
                TriggerClientEvent("Notify", source, "azul", "<b>Passaporte:</b> " .. args[1] .. "<br><b>Nome:</b> " .. Identity["name"] .. " " .. Identity["name2"] .. "<br><b>Telefone:</b> " .. Identity["phone"] .. "<br><b>Sexo:</b> " .. Identity["sex"] .. "<br><b>Gemas:</b> " .. Identity["gems"] .. "<br><b>Banco:</b> $" .. parseFormat(Identity["bank"]) .. "<br><b>Likes:</b> 👍" .. Identity["likes"] .. "<br><b>LDeslikes:</b> 👎" .. Identity["unlikes"], 15000)
            end
        end
    end
end, false)

RegisterCommand("copypreset", function(source, args, rawCommand)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport, "Admin", 2) then
        if Passport then       
            local targetSource = vRP.Source(tonumber(args[1]))
            if targetSource then
                local targetOutfit = vSKINSHOP.Customization(targetSource)
                if targetOutfit then
                    -- Aplica as roupas no jogador que executa o comando
                    TriggerClientEvent("adminClothes", source, targetOutfit)
                    TriggerClientEvent('Notify', source, 'verde', 'Roupa copiada com sucesso do ID ' .. tonumber(args[1]) .. '.', 5000)
                else
                    TriggerClientEvent('Notify', source, 'vermelho', 'Falha ao copiar roupa.', 5000)
                end
            else
                TriggerClientEvent('Notify', source, 'vermelho', 'ID do jogador inválido.', 5000)
            end
        end
    else
        TriggerClientEvent('Notify', source, 'vermelho', 'Você não tem permissão para usar este comando.', 5000)
    end
end)


RegisterCommand('setpreset', function(source, args, rawCmd)
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)

    if vRP.HasPermission(Passport, 'Admin') or vRP.HasGroup(Passport, 'Vipwide') or vRP.HasGroup(Passport, "Moderador") or vRP.HasGroup(Passport, "Suporte") or vRP.HasGroup(Passport, "AcessoBooster") or vRP.HasGroup(Passport, "Booster") or vRP.HasGroup(Passport,"Vipbasic") or vRP.HasGroup(Passport,"PremiumOuro") then
        if not args[1] then 
            TriggerClientEvent('Notify', source, 'vermelho', 'ID do jogador não informado.', 5000)
            return 
        end

        local targetSource = vRP.Source(tonumber(args[1]))
        if targetSource then
            local senderOutfit = vSKINSHOP.Customization(source)
            if senderOutfit then
                if vRP.Request(targetSource, "Deseja aceitar o preset de roupa enviado por #" .. Passport .. "?", "Y - Sim", "U - Não") then
                    -- Aplica o preset no jogador alvo
                    TriggerClientEvent("adminClothes", targetSource, senderOutfit)
                    TriggerClientEvent('Notify', source, 'verde', 'Você setou sua roupa no ID ' .. tonumber(args[1]) .. '.', 5000)
                    TriggerClientEvent('Notify', targetSource, 'verde', 'Você aceitou o preset de roupa.', 5000)
                else
                    TriggerClientEvent('Notify', source, 'vermelho', 'O jogador ID ' .. tonumber(args[1]) .. ' recusou o preset.', 5000)
                end
            else
                TriggerClientEvent('Notify', source, 'vermelho', 'Falha ao obter sua roupa.', 5000)
            end
        else
            TriggerClientEvent('Notify', source, 'vermelho', 'ID do jogador inválido.', 5000)
        end
    else
        TriggerClientEvent('Notify', source, 'vermelho', 'Você não tem permissão para usar este comando.', 5000)
    end
end)

RegisterCommand("shop",function(source)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") or vRP.HasGroup(Passport,"Moderador") or vRP.HasGroup(Passport,"Suporte") or vRP.HasGroup(Passport, "AcessoBooster") or vRP.HasGroup(Passport,"Booster") or vRP.HasGroup(Passport,"Vipwide") or vRP.HasGroup(Passport,"Vipbasic") or vRP.HasGroup(Passport, "Streamer") then
			TriggerClientEvent("skinshop:Open",source)
		end
	end
end)

RegisterCommand("barber",function(source)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") or vRP.HasGroup(Passport,"Moderador") or vRP.HasGroup(Passport,"Suporte") or vRP.HasGroup(Passport, "AcessoBooster") or vRP.HasGroup(Passport,"Vipwide") or vRP.HasGroup(Passport,"vipbasic") or vRP.HasGroup(Passport,"Booster") or vRP.HasGroup(Passport, "Streamer") then
			TriggerClientEvent("barbershop:Open", source, "barber")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CROUPAS (mostra numeração de todas as roupas atuais, tipo CDS)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("croupas", function(source)
    local Passport = vRP.Passport(source)
    if not Passport or not vRP.HasGroup(Passport, "Admin", 4) then
        TriggerClientEvent("Notify", source, "vermelho", "Sem permissão.", 5000)
        return
    end
    TriggerClientEvent("admin:getRoupas", source)
end)

RegisterNetEvent("admin:sendRoupas")
AddEventHandler("admin:sendRoupas", function(lines)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport or not vRP.HasGroup(Passport, "Admin") then return end
    if type(lines) == "table" and #lines > 0 then
        local content = table.concat(lines, "\n")
        vKEYBOARD.keyCopy(source, "Roupas (drawable:texture):", content)
    else
        TriggerClientEvent("Notify", source, "amarelo", "Nenhuma roupa obtida.", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ugroups",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and parseInt(Message[1]) > 0 then
		local Messages = ""
		local Groups = vRP.Groups()
		local OtherPassport = Message[1]
		for Permission,_ in pairs(Groups) do
			local Data = vRP.DataGroups(Permission)
			if Data[OtherPassport] then
				Messages = Messages..Permission.."<br>"
			end
		end

		if Messages ~= "" then
			TriggerClientEvent("Notify",source,"verde",Messages,10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addvehs",function(source,Message)
	local source = source
	local Passport = vRP.Passport(source)
	local Sources = vRP.Source(Message[1])
	if vRP.HasGroup(Passport,"Admin",2) then
		if Passport and Message[1] and Message[2] then
			vRP.Query("vehicles/addVehicles",{ Passport = parseInt(Message[1]), vehicle = Message[2], plate = vRP.GeneratePlate(), work = tostring(false) })
			TriggerClientEvent("Notify",source,"verde","Adicionado o veiculo <b>"..Message[2].."</b> na garagem de ID <b>"..Message[1].."</b>.",10000)
			TriggerClientEvent("Notify",Sources,"verde","Adicionado o veiculo <b>"..Message[2].."</b> em sua garagem<b> .",10000)
			TriggerEvent("Discord","Addcar","**Add Car**\n\n**Passaporte:** "..Passport.."\n**Adicionou Carro :** "..Message[2].."\n**Na Garagem do ID :** "..Message[1].." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remvehs",function(source,Message)
	local source = source
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport,"Admin",2) then
		if Passport and Message[1] and Message[2] then
			vRP.Query("vehicles/removeVehicles",{ Passport = parseInt(Message[1]), vehicle = Message[2]})
			TriggerClientEvent("Notify",source,"verde","Retirado o veiculo <b>"..Message[2].."</b> da garagem de ID <b>"..Message[1].."</b>.",10000)
			TriggerEvent("Discord","Remcar","**Rem Car**\n\n**Passaporte:** "..Passport.."\n**Retirou Carro :** "..Message[2].."\n**Da Garagem do ID :** "..Message[1].." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearchest",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) and Message[1] then
			local Consult = vRP.Query("chests/GetChests",{ name = Message[1] })
			if Consult[1] then
				if vRP.Request(source,"Deseja Limpar o Chest do #"..Message[1].." ?") then
				TriggerClientEvent("Notify",source,"verde","Limpeza concluída.",5000)
				vRP.SetSrvData("Chest:"..Message[1],{},true)
				
				--TriggerEvent("Discord","Clearchest","**clearchest**\n\n**Passaporte:** "..Passport.."\n**Chest:** "..Message[2],3553599)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Checar a quantidade de players e ids online.     ~ admin/server-side/core.lua
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pon",function(source,args,rawCommand)
    local user_id = vRP.Passport(source)
    if vRP.HasGroup(user_id, "Admin") then
        local users = vRP.Players()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
        TriggerClientEvent("Notify",source,"amarelo","TOTAL ONLINE : <b>"..quantidade.."</b><br>ID's ONLINE : <b>"..players.."</b>",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM CAR
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("remvehs",function(source,Message)
--     local Passport = vRP.Passport(source)
--     if vRP.HasGroup(Passport,"Admin",1) then
--         if Message[1] and Message[2] then
--             local OtherPlayer = vRP.Passport(parseInt(Message[2]))
--             local OtherIdentity = vRP.Identity(parseInt(Message[2]))
--             if vRP.Request(source,"Deseja retirar o veículo <b>"..VehicleName(Message[1]).."</b> do Passaporte: <b>"..parseInt(Message[2]).." "..OtherIdentity.name.." "..OtherIdentity.name2.."</b> ?","Sim","Não") then
--                 vRP.Query("vehicles/removeVehicles",{ Passport = parseInt(Message[2]), vehicle = Message[1] })
--                 TriggerClientEvent("Notify",source,"verde", "Você removeu o veículo <b>"..VehicleName(Message[1]).."</b> do Passaporte: <b>"..parseInt(Message[2]).."</b>.", 5000)
--                 TriggerClientEvent("Notify",OtherPlayer,"vermelho", "O veículo <b>"..VehicleName(Message[1]).."</b> foi removido da sua garagem.", 5000)
--             end
--         end
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearinv",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) and parseInt(Message[1]) > 0 then
			TriggerClientEvent("Notify",source,"verde","Limpeza concluída.",5000)
			vRP.ClearInventory(Message[1])
			TriggerEvent("Discord","Clearinv","**clearinv**\n\n**Passaporte:** "..Passport.."\n**Limpou Inventario do ID:** "..Message[1],3553599)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gem",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",1) and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
			local Amount = parseInt(Message[2])
			local OtherPassport = parseInt(Message[1])
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				TriggerClientEvent("Notify",source,"verde","Gemas entregues.",5000)
				vRP.Query("accounts/AddGems",{ license = Identity["license"], gems = Amount })
				TriggerEvent("Discord","Gemstone","**Source:** "..source.."\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.."\n**Gemas:** "..Amount.."\n**Address:** "..GetPlayerEndpoint(source),3092790)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ALGEMAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("algemar", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and Message[1] then
        if vRP.HasGroup(Passport, "Admin", 3) then
            local OtherPassport = tonumber(Message[1])
            local OtherSource = vRP.Source(OtherPassport)

            if OtherSource then
                local PlayerState = Player(OtherSource)
                if PlayerState then
                    if PlayerState["state"]["Handcuff"] then
                        PlayerState["state"]["Handcuff"] = false
                        vRPC.stopAnim(source,true)
                        TriggerClientEvent("Notify", source, "verde", "Você desalgemou o jogador com ID " .. OtherPassport, 5000)
                    else
                        PlayerState["state"]["Handcuff"] = true
                        TriggerClientEvent("Hud:RadioClean",OtherSource)
                        TriggerClientEvent("Notify", source, "verde", "Você algemou o jogador com ID " .. OtherPassport, 5000)
                    end
                    TriggerClientEvent("sounds:source", source, "cuff", 0.5)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "ID do jogador inválido ou offline.", 5000)
            end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para usar este comando.", 5000)
        end
    else
        TriggerClientEvent("Notify", source, "vermelho", "Você não possui um passaporte válido para usar este comando.", 5000)
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Blips = {}

RegisterCommand("blips", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 3) then
            local Text = ""

            if not Blips[Passport] then
                Blips[Passport] = true
                Text = "Ativado"
				TriggerEvent("Discord", "Blips", "**blips**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text .. " \n**Horário:** " .. os.date("%H:%M:%S"), 3553599)
            else
                Blips[Passport] = nil
                Text = "Desativado"
				TriggerEvent("Discord", "Blips", "**blips**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text .. " \n**Horário:** " .. os.date("%H:%M:%S"), 3553599)
            end

            vRPC.BlipAdmin(source)

            if Blips[Passport] then
            else
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) then
			if Message[1] then
				TriggerEvent("Discord","God","**Passaporte:** "..Passport.."\n**Comando:** god "..Message[1],0xa3c846)
				local OtherPassport = parseInt(Message[1])
				local ClosestPed = vRP.Source(OtherPassport)
				if ClosestPed then
					vRP.UpgradeThirst(OtherPassport,100)
					vRP.UpgradeHunger(OtherPassport,100)
					vRP.DowngradeStress(OtherPassport,100)
					vRP.Revive(ClosestPed,200)
					TriggerEvent("Discord","God","**god**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
				end
			else
				vRP.Revive(source,200,true)
				vRP.SetArmour(source,99)
				vRP.UpgradeThirst(Passport,100)
				vRP.UpgradeHunger(Passport,100)
				vRP.DowngradeStress(Passport,100)
				TriggerEvent("Discord","God","**god**\n\n**Passaporte:** "..Passport.."\n**Deu God em Si mesmo:** \n**Horário:** "..os.date("%H:%M:%S"),3553599)

				TriggerClientEvent("paramedic:Reset",source)

				vRPC.Destroy(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) then
			if Message[1] and Message[2] and itemBody(Message[1]) ~= nil then
				local Amount = parseInt(Message[2])
				vRP.GenerateItem(Passport,Message[1],Amount,true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				TriggerEvent("Discord","Item","**item**\n\n**Passaporte:** "..Passport.."\n**Item:** "..Amount.."x "..itemName(Message[1]).." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
			end
		end
	end
end)

RegisterCommand("addback",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) then
			if Message[1] ~= nil and Message[2] ~= nil and parseInt(Message[1]) > 0 then
				local OtherPassport = parseInt(Message[1])
				local OtherSource = vRP.Source(OtherPassport)
				if OtherSource then
					local Amount = parseInt(Message[2])
					vRP.SetWeight(OtherPassport, Amount)
					TriggerClientEvent("inventory:Update", OtherSource, "Backpack")
					TriggerClientEvent("Notify", OtherSource, "verde", "Sua mochila foi ampliada em <b>"..Amount.."</b> espaços.", 5000)
					TriggerClientEvent("Notify", source, "verde", "Adicionado <b>"..Amount.."</b> de peso para o passaporte <b>"..OtherPassport.."</b>.", 5000)
					TriggerEvent("Discord","Addbackpack","**addbackpack**\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.."\n**Peso Adicionado:** "..Amount.."\n**Horário:** "..os.date("%H:%M:%S"),3553599)
				else
					TriggerClientEvent("Notify", source, "vermelho", "Jogador não encontrado ou offline.", 5000)
				end
			end
		end
	end
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item2",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) and Message[3] and itemBody(Message[1]) then
			local OtherPassport = parseInt(Message[3])
			if OtherPassport > 0 then
				local Amount = parseInt(Message[2])
				local Item = itemName(Message[1])
				vRP.GenerateItem(Message[3],Message[1],Amount,true)
				TriggerClientEvent("Notify",source,"verde","Você enviou <b>"..Amount.."x "..Item.."</b> para o passaporte <b>"..OtherPassport.."</b>.",5000)
				
				TriggerEvent("Discord","Item2","**item2*\n\n**Passaporte:** "..Passport.."\n**Para:** "..OtherPassport.."\n**Item:** "..Amount.."x "..Item.." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pd",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then
		if vRP.HasGroup(Passport,"Admin",1) then
			local OtherPassport = parseInt(Message[1])
			vRP.Query("characters/removeCharacter",{ id = OtherPassport })
			vRP.Kick(OtherPassport,"A Historia do seu Personagem Chegou ao FIM!.")
			TriggerClientEvent("Notify",source,"verde","Personagem <b>"..OtherPassport.."</b> levou PD e foi Deletado.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
local Noclip = {}

RegisterCommand("nc", function(source)
    local Passport = vRP.Passport(source)

    if Passport then 
        if vRP.HasGroup(Passport, "Admin", 4) then
            local Text = ""
            local Action = ""

            if not Noclip[Passport] then
                Noclip[Passport] = true
                Text = "Ativado"
                Action = "ativou"
            else
                Noclip[Passport] = false
                Text = "Desativado"
                Action = "desativou"
            end

            TriggerEvent("Discord", "Noclip", "**nc**\n\n**Passaporte:** " .. Passport .. "\n**Situação:** " .. Text .. " \n**Horário:** " .. os.date("%H:%M:%S"), 3553599)
            
            -- Move a chamada da função para cá, após enviar a mensagem
            vRPC.noClip(source, Noclip[Passport])
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",3) and parseInt(Message[1]) > 0 then
			local OtherSource = vRP.Source(Message[1])
			if OtherSource then
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..Message[1].."</b> expulso.",5000)
				vRP.Kick(OtherSource,"Expulso da cidade.")
				
				TriggerEvent("Discord","Kick","**kick**\n\n**Passaporte:** "..Passport.."\n**Expulsou Passaporte:** "..Message[1].." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",3) and parseInt(Message[1]) > 0 and parseInt(Message[2]) > 0 then
			local Days = parseInt(Message[2])
			local OtherPassport = parseInt(Message[1])
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				vRP.Query("banneds/InsertBanned",{ license = Identity["license"], time = Days })
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..OtherPassport.."</b> banido por <b>"..Days.."</b> dias.",5000)
				TriggerEvent("Discord","Ban","**ban**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Message[1].."\n**Tempo:** "..Message[2].." dias \n**Horário:** "..os.date("%H:%M:%S"),3553599)
				
				local OtherSource = vRP.Source(OtherPassport)
				if OtherSource then
					vRP.Kick(OtherSource,"Banido.")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) and parseInt(Message[1]) > 0 then
			local OtherPassport = parseInt(Message[1])
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				vRP.Query("banneds/RemoveBanned",{ license = Identity["license"] })
				TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..OtherPassport.."</b> desbanido.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) then
			local Keyboard = vKEYBOARD.keySingle(source,"Cordenadas:")
			if Keyboard then
				local Split = splitString(Keyboard[1],",")
				vRP.Teleport(source,Split[1] or 0,Split[2] or 0,Split[3] or 0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("announce",function(source)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") then
			local Keyboard = vKEYBOARD.keyTertiary(source,"Mensagem:","Cor:","Tempo (em MS):")
			if Keyboard then
				TriggerClientEvent("Notify",-1,Keyboard[2],Keyboard[1],Keyboard[3])
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- anuncio
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anuncio", function(source, args)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local identity = vRP.Identity(source)
        if vRP.HasGroup(Passport, "Admin",3) then
            local message = vKEYBOARD.keyArea(source, "Mensagem:")
            if message and message[1] then
                --local playerName = Governador
                local finalMessage = message[1] .. "<br></br>Enviada Por: Governador"
                TriggerClientEvent("Notify", -1, "verde", finalMessage .. "</b>", 45000)
            else
                TriggerClientEvent("Notify", source, "vermelho", "A mensagem não pode estar vazia.", 5000)
            end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissões para isso.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)

			vKEYBOARD.keyCopy(source,"Cordenadas:",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"])..","..mathLength(heading))
		end
	end
end)
RegisterCommand("cds2",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)

			vKEYBOARD.keyCopy(source,"Cordenadas:","x = "..mathLength(Coords["x"])..", y = "..mathLength(Coords["y"])..", z = "..mathLength(Coords["z"])..", h = "..mathLength(heading))
		end
	end
end)
RegisterCommand("cds3",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)

			vKEYBOARD.keyCopy(source,"Cordenadas:","['x'] = "..mathLength(Coords["x"])..", ['y'] = "..mathLength(Coords["y"])..", ['z'] = "..mathLength(Coords["z"])..", ['h'] = "..mathLength(heading))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group", function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 1) then
            if parseInt(Message[1]) > 0 and Message[2] then
                TriggerClientEvent("Notify", source, "verde", "Adicionado <b>"..Message[2].."</b> ao passaporte <b>"..Message[1].."</b>.", 5000)
				TriggerEvent("Discord","Group","**ID:** "..Passport.."\n**Setou:** "..Message[1].." \n**Grupo:** "..Message[2].." \n**Horário:** "..os.date("%H:%M:%S"),3092790)
                vRP.SetPermission(Message[1], Message[2], Message[3])
            end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para usar este comando.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) and parseInt(Message[1]) > 0 and Message[2] then
			TriggerClientEvent("Notify",source,"verde","Removido <b>"..Message[2].."</b> ao passaporte <b>"..Message[1].."</b>.",5000)
			TriggerEvent("Discord","UnGroup","**ID:** "..Passport.."\n**Removeu:** "..Message[1].." \n**Grupo:** "..Message[2].." \n**Horário:** "..os.date("%H:%M:%S"),3092790)
			vRP.RemovePermission(Message[1],Message[2])
			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) and parseInt(Message[1]) > 0 then
			local ClosestPed = vRP.Source(Message[1])
			if ClosestPed then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				
				vRP.Teleport(ClosestPed,Coords["x"],Coords["y"],Coords["z"])
				TriggerEvent("Discord","Tptome","**tptome**\n\n**Passaporte:** "..Passport.."\n**Puxou o ID:** "..Message[1].." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- godarea
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("godarea",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) then
			local Range = parseInt(Message[1])
			if Range then
				local Text = ""
				local Players = vRPC.ClosestPeds(source,Range)
				for _,v in pairs(Players) do
					async(function()
						local OtherPlayer = vRP.Passport(v)
						vRP.UpgradeThirst(OtherPlayer,100)
						vRP.UpgradeHunger(OtherPlayer,100)
						vRP.DowngradeStress(OtherPlayer,100)
						vRP.Revive(v,200)

						TriggerClientEvent("paramedic:Reset",v)

						if Text == "" then
							Text = OtherPlayer
						else
							Text = Text..", "..OtherPlayer
						end
					end)
				end

				TriggerEvent("Discord","goda","**GODAREA**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Text,3553599)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) and parseInt(Message[1]) > 0 then
			local ClosestPed = vRP.Source(Message[1])
			if ClosestPed then
				local Ped = GetPlayerPed(ClosestPed)
				local Coords = GetEntityCoords(Ped)
				vRP.Teleport(source,Coords["x"],Coords["y"],Coords["z"])
				TriggerEvent("Discord","Tpto","**tpto**\n\n**Passaporte:** "..Passport.."\n**Deu TPTO No ID:** "..Message[1].." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",4) then
			vCLIENT.teleportWay(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) <= 100 then
		vCLIENT.teleportLimbo(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") then
			local vehicle = vRPC.VehicleHash(source)
			if vehicle then
				vRP.Archive("hash.txt",vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 4) then
            TriggerClientEvent("admin:vehicleTuning", source)
            TriggerClientEvent("Notify", source, "verde", "Veículo modificado com sucesso.", 5000)
            
            -- Registre no Discord
            --local discordMessage = "Veículo Modificado\n\n" .."**Jogador (ID):** " .. source .. "\n".."**Ação:** Modificação de veículo"
            TriggerEvent("Discord", "Tuning", "Veículo Modificado\n\n" .."**Jogador (ID):** " .. source .. "\n".."**Ação:** usou o /tuning", 3553599) -- Substitua o número de cor pelo desejado
        else
            TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
        end
    end
end)
-------

-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix", function(source)
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, "Admin", 4) then
            local Vehicle, Network, Plate = vRPC.VehicleList(source, 10)
            if Vehicle then
                TriggerClientEvent("inventory:repairAdmin", source, Network, Plate)
                TriggerClientEvent("Notify", source, "verde", "Veículo " .. Plate .. " reparado com sucesso.", 5000)
                local playerId = source
                local message = string.format("**ID:%d** reparou o veículo com a placa **%s** com sucesso.", playerId, Plate)
                TriggerEvent("Discord", "Fix", message, 0x00FF00) -- O terceiro parâmetro define a cor (verde neste caso)
            else
                TriggerClientEvent("Notify", source, "amarelo", "Não há veículo próximo ou você não tem permissões para isso.", 5000)
            end
        else
            TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparea",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			TriggerClientEvent("syncarea",source,Coords["x"],Coords["y"],Coords["z"],100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",2) then
			TriggerClientEvent("Notify",source,"azul","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:Coords")
AddEventHandler("admin:Coords",function(Coords)
	vRP.Archive("coordenadas.txt",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.buttonTxt()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)

			vRP.Archive(Passport..".txt",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"])..","..mathLength(heading))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("announce2",function(source,Message,History)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") and Message[1] then
			TriggerClientEvent("chat:ClientMessage",-1,"Governador",History:sub(9))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console",function(source,Message,History)
	if source == 0 then
		TriggerClientEvent("chat:ClientMessage",-1,"Governador",History:sub(9))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin") then
			return
		end
	end

	local List = vRP.Players()
	for _,Sources in pairs(List) do
		vRP.Kick(Sources,"Desconectado, a cidade reiniciou.")
		Wait(100)
	end

	TriggerEvent("SaveServer",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("save",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin") then
			return
		end
	end

	TriggerEvent("SaveServer",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",1) then
			local Text = ""
			local List = vRP.Players()
			
			for OtherPlayer,_ in pairs(List) do
				async(function()
					if Text == "" then
						Text = OtherPlayer
					else
						Text = Text..", "..OtherPlayer
					end
					
					vRP.GenerateItem(OtherPlayer,Message[1],Message[2],true)
				end)
			end
			
			TriggerClientEvent("Notify",source,"verde","Envio concluído e Sua LOG foi Enviado para o Discord",10000)
				
				TriggerEvent("Discord","Itemall","**itemall**\n\n**Passaporte:** "..Passport.."\n**Para:** "..Text.."\n**Item:** "..Message[2].."x "..itemName(Message[1]).." \n**Horário:** "..os.date("%H:%M:%S"),3553599)
			end
		end
	end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Checkpoint = 0
function Creative.raceCoords(vehCoords,leftCoords,rightCoords)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Checkpoint = Checkpoint + 1

		vRP.Archive("races.txt","["..Checkpoint.."] = {")

		vRP.Archive("races.txt","{ "..mathLength(vehCoords["x"])..","..mathLength(vehCoords["y"])..","..mathLength(vehCoords["z"]).." },")
		vRP.Archive("races.txt","{ "..mathLength(leftCoords["x"])..","..mathLength(leftCoords["y"])..","..mathLength(leftCoords["z"]).." },")
		vRP.Archive("races.txt","{ "..mathLength(rightCoords["x"])..","..mathLength(rightCoords["y"])..","..mathLength(rightCoords["z"]).." }")

		vRP.Archive("races.txt","},")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = {}
RegisterCommand("spectate",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") then
			if Spectate[Passport] then
				local Ped = GetPlayerPed(Spectate[Passport])
				if DoesEntityExist(Ped) then
					SetEntityDistanceCullingRadius(Ped,0.0)
				end

				TriggerClientEvent("admin:resetSpectate",source)
				Spectate[Passport] = nil
			else
				local nsource = vRP.Source(Message[1])
				if nsource then
					local Ped = GetPlayerPed(nsource)
					if DoesEntityExist(Ped) then
						SetEntityDistanceCullingRadius(Ped,999999999.0)
						Wait(1000)
						TriggerClientEvent("admin:initSpectate",source,nsource)
						Spectate[Passport] = nsource
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Spectate[Passport] then
		Spectate[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,args)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",1) then
			local id = tonumber(args[1])
			local value = tonumber(args[2])
			if id and value and (value == 0 or value == 1) then
				vRP.Query("accounts/updateWhitelist",{ whitelist = value, id = id })
				if value == 1 then
					TriggerClientEvent("Notify",source,"verde","Whitelist do ID <b>"..id.."</b> foi <b>liberada</b>.",5000)
				else
					TriggerClientEvent("Notify",source,"vermelho","Whitelist do ID <b>"..id.."</b> foi <b>removida</b>.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Use: /wl [id] [0/1]",5000)
			end
		end
	end
end)