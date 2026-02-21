-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("painel",Creative)
vCLIENT = Tunnel.getInterface("painel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Panel = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("painel",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and Message[1] ~= "Premium" then
		if vRP.HasPermission(Passport,Message[1],1) then
			Panel[Passport] = Message[1]

			local Members = {}
			local Sources = vRP.Players()
			local Entitys = vRP.DataGroups(Panel[Passport])
			local Hierarchy = vRP.Hierarchy(Panel[Passport])

			for Number,v in pairs(Entitys) do
				local Number = parseInt(Number)
				local Identity = vRP.Identity(Number)
				if Identity then
					if vRP.HasPermission(Number,Panel[Passport],1) then
						Members[#Members + 1] = { ["name"] = Identity["name"].." "..Identity["name2"], ["phone"] = Identity["phone"], ["online"] = Sources[Number], ["id"] = Number, ["role"] = Hierarchy[v] or Hierarchy, ["role_id"] = 1 }
					else
						Members[#Members + 1] = { ["name"] = Identity["name"].." "..Identity["name2"], ["phone"] = Identity["phone"], ["online"] = Sources[Number], ["id"] = Number, ["role"] = Hierarchy[v] or Hierarchy }
					end
				end
			end
			
			local Data = {
				groupName = Panel[Passport],
				members = Members
			}

			vCLIENT.Open(source,Data)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Dismiss(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and Number >= 1 and Passport ~= Number then
		if vRP.HasPermission(Passport,Panel[Passport],1) then
			vRP.RemovePermission(Number,Panel[Passport])

			TriggerClientEvent("Notify",source,"verde","Passaporte removido.",5000)
			TriggerClientEvent("painel:Update",source,Panel[Passport])
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVITE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Invite(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	
	if Passport and Panel[Passport] and Number >= 1 and Passport ~= Number and vRP.Identity(Number) then
		if vRP.HasPermission(Passport,Panel[Passport],1) then
			CreateThread(function()
				local OtherSource = vRP.Source(Number)

				if OtherSource then
					TriggerClientEvent("Notify",source,"amarelo","Aguardando confirmação...",5000)

					if vRP.Request(OtherSource,"Você recebeu um convite para o grupo <b>"..Panel[Passport].."</b>. Deseja aceitar?","Sim","Não") then
						vRP.SetPermission(Number,Panel[Passport])

						TriggerClientEvent("Notify",source,"verde","Passaporte adicionado.",5000)
						TriggerClientEvent("Notify",OtherSource,"verde","Você entrou para o grupo <b>"..Panel[Passport].."</b>.",5000)
						TriggerClientEvent("painel:Update",source,Panel[Passport])
					else
						TriggerClientEvent("Notify",source,"amarelo","O jogador recusou o convite.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Jogador não encontrado ou offline.",5000)
				end
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Hierarchy(OtherPassport,Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Panel[Passport] and OtherPassport >= 1 and Passport ~= OtherPassport and vRP.Identity(OtherPassport) then
		if vRP.HasPermission(Passport,Panel[Passport],1) then
			if not vRP.HasPermission(OtherPassport,Panel[Passport],2) or Mode == "Demote" then
				vRP.SetPermission(OtherPassport,Panel[Passport],nil,Mode)

				TriggerClientEvent("Notify",source,"verde","Hierarquia atualizada.",5000)
				TriggerClientEvent("painel:Update",source,Panel[Passport])
			end
		end
	end
end