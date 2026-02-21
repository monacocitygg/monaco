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
Tunnel.bindInterface("inspect",Creative)
vCLIENT = Tunnel.getInterface("inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local openPlayer = {}
local openSource = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:runInspect")
AddEventHandler("police:runInspect",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		-- Check if player is police to bypass request
		if vRP.HasGroup(Passport,"Police") then
			openSource[Passport] = Entity[1]
			openPlayer[Passport] = vRP.Passport(Entity[1])

			TriggerClientEvent("player:playerCarry",Entity[1],source,"handcuff")
			TriggerClientEvent("player:Commands",Entity[1],true)
			TriggerClientEvent("inventory:Close",Entity[1])
			TriggerClientEvent("inspect:Open",source)
		else
			-- Request for non-police players
			local OtherPassport = vRP.Passport(Entity[1])
			local Identity = vRP.Identity(Passport)
			if vRP.Request(Entity[1],"O jogador <b>"..Identity["name"].." "..Identity["name2"].." ("..Passport..")</b> quer te revistar. Deseja aceitar?","Aceitar","Recusar") then
				openSource[Passport] = Entity[1]
				openPlayer[Passport] = vRP.Passport(Entity[1])

				TriggerClientEvent("player:playerCarry",Entity[1],source,"handcuff")
				TriggerClientEvent("player:Commands",Entity[1],true)
				TriggerClientEvent("inventory:Close",Entity[1])
				TriggerClientEvent("inspect:Open",source)
			else
				TriggerClientEvent("Notify",source,"vermelho","O jogador recusou a revista.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.openChest()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local myInventory = {}
		local inventory = vRP.Inventory(Passport)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					local ts = tonumber(splitName[2])
					if ts then
						v["durability"] = parseInt(os.time() - ts)
						v["days"] = itemDurability(v["item"])
					else
						v["durability"] = 0
						v["days"] = 1
					end
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			myInventory[k] = v
		end

		local otherInventory = {}
		local inventory = vRP.Inventory(openPlayer[Passport])
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					local ts = tonumber(splitName[2])
					if ts then
						v["durability"] = parseInt(os.time() - ts)
						v["days"] = itemDurability(v["item"])
					else
						v["durability"] = 0
						v["days"] = 1
					end
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			otherInventory[k] = v
		end

		return myInventory,otherInventory,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.InventoryWeight(openPlayer[Passport]),vRP.GetWeight(openPlayer[Passport]),vRP.HasGroup(Passport,"Bolso"),vRP.HasGroup(Passport,"vipslots"),vRP.HasGroup(openPlayer[Passport],"Bolso"),vRP.HasGroup(openPlayer[Passport],"vipslots"),vRP.HasGroup(Passport,"Serendibite"),vRP.HasGroup(Passport,"Painite"),vRP.HasGroup(openPlayer[Passport],"Serendibite"),vRP.HasGroup(openPlayer[Passport],"Painite")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.resetInspect()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			TriggerClientEvent("player:Commands",openSource[Passport],false)
			TriggerClientEvent("player:playerCarry",openSource[Passport],source)
			openSource[Passport] = nil
		end

		if openPlayer[Passport] then
			openPlayer[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.storeItem(Item,Slot,Amount,Target)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			local Ped = GetPlayerPed(openSource[Passport])
			if DoesEntityExist(Ped) then
				if (tostring(Target) == "4" or tostring(Target) == "5") and not vRP.HasGroup(openPlayer[Passport],"Bolso") then
					TriggerClientEvent("Notify",source,"negado","O cidadão não possui a mochila.",5000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
					return
				end

				if (parseInt(Target) > 17) and not vRP.HasGroup(openPlayer[Passport],"vipslots") then
					if not (vRP.HasGroup(openPlayer[Passport],"Serendibite") and parseInt(Target) <= 21) and not (vRP.HasGroup(openPlayer[Passport],"Painite") and parseInt(Target) <= 25) then
						TriggerClientEvent("Notify",source,"negado","O cidadão não possui o grupo Vip.",5000)
						TriggerClientEvent("inspect:Update",source,"requestChest")
						return
					end
				end

				if vRP.MaxItens(openPlayer[Passport],Item,Amount) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
					return
				end

				if (vRP.InventoryWeight(openPlayer[Passport]) + (itemWeight(Item) * Amount)) <= vRP.GetWeight(openPlayer[Passport]) then
					if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
						vRP.GiveItem(openPlayer[Passport],Item,Amount,true,Target)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.takeItem(Item,Slot,Target,Amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		-- Restrict taking items for non-police
		if not vRP.HasGroup(Passport,"Police") then
			TriggerClientEvent("Notify",source,"vermelho","Você não pode pegar itens.",5000)
			return
		end

		if openSource[Passport] then
			if DoesEntityExist(GetPlayerPed(openSource[Passport])) then
				if (tostring(Target) == "4" or tostring(Target) == "5") and not vRP.HasGroup(Passport,"Bolso") then
					TriggerClientEvent("Notify",source,"negado","Você não possui a mochila.",5000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
					return
				end

				if (parseInt(Target) > 17) and not vRP.HasGroup(Passport,"vipslots") then
					if not (vRP.HasGroup(Passport,"Serendibite") and parseInt(Target) <= 21) and not (vRP.HasGroup(Passport,"Painite") and parseInt(Target) <= 25) then
						TriggerClientEvent("Notify",source,"negado","Você não possui o grupo Vip.",5000)
						TriggerClientEvent("inspect:Update",source,"requestChest")
						return
					end
				end

				if vRP.MaxItens(Passport,Item,Amount) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
					return
				end

				if (vRP.InventoryWeight(Passport) + (itemWeight(Item) * Amount)) <= vRP.GetWeight(Passport) then
					if vRP.TakeItem(openPlayer[Passport],Item,Amount,true,Slot) then
						vRP.GiveItem(Passport,Item,Amount,false,Target)
						TriggerClientEvent("inspect:Update",source,"requestChest")
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateChest(Slot,Target,Amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			local Ped = GetPlayerPed(openSource[Passport])
			if DoesEntityExist(Ped) then
				if vRP.invUpdate(openPlayer[Passport],Slot,Target,Amount) then
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end
