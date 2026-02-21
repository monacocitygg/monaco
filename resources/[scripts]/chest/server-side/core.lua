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
Tunnel.bindInterface("chest",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Open = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Verify()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetFine(Passport) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Você possui multas pendentes.",10000)
			return false
		end

		if exports["hud"]:Wanted(Passport,source) and exports["hud"]:Reposed(Passport) then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permissions(Name,Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Mode == "Personal" then
			Open[Passport] = { ["Name"] = Passport, ["Weight"] = 50, ["Logs"] = false, ["Save"] = true }
			return true
		elseif Mode == "Evidences" and vRP.HasGroup(Passport,"Police") then
			local Keyboard = vKEYBOARD.keySingle(source,"Passaporte:")
			if Keyboard then
				Open[Passport] = { ["Name"] = "Evidences:"..Keyboard[1], ["Weight"] = 50, ["Logs"] = false, ["Save"] = true }
				return true
			end
		elseif Mode == "Carga" then
			print("CHEST_DEBUG: Permissão Carga Solicitada. Nome: " .. tostring(Name))
			Open[Passport] = { ["Name"] = Name, ["Weight"] = 250, ["Logs"] = false, ["Save"] = false }
			return true
		elseif Mode == "Custom" then
			print("CHEST_DEBUG: Permissão Custom Solicitada. Nome: " .. tostring(Name))
			Open[Passport] = { ["Name"] = Name, ["Weight"] = 50, ["Logs"] = false, ["Save"] = false }
			return true
		elseif Mode == "Manager" then
			if vRP.HasGroup(Passport,Name,2) then
			    Open[Passport] = { ["Name"] = "Manager:"..Name, ["Weight"] = 1000, ["Logs"] = true, ["Save"] = true }
			    return true
			end
		elseif Mode == "Tray" then
			Open[Passport] = { ["Name"] = Name, ["Weight"] = 15, ["Logs"] = false, ["Save"] = true }
			return true
		else
			local Consult = vRP.Query("chests/GetChests",{ name = Name })
			if Consult[1] and vRP.HasGroup(Passport,Consult[1]["perm"]) then
				if Name == "Police" then
					Consult[1]["logs"] = true
				end

				Open[Passport] = { ["Name"] = Name, ["Weight"] = Consult[1]["weight"], ["Logs"] = Consult[1]["logs"], ["Save"] = true }
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Chest()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		local Inventory = {}
		local Inv = vRP.Inventory(Passport)
		for Index,v in pairs(Inv) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["desc"] = itemDescription(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["key"] = v["item"]
			v["slot"] = Index

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					local ts = tonumber(Split[2])
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

			Inventory[Index] = v
		end

		local Chest = {}
		local Result = vRP.GetSrvData("Chest:"..Open[Passport]["Name"],Open[Passport]["Save"])
		for Index,v in pairs(Result) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = Index

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					local ts = tonumber(Split[2])
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

			Chest[Index] = v
		end

		return Inventory,Chest,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Open[Passport]["Weight"],vRP.HasGroup(Passport,"Bolso"),vRP.HasGroup(Passport,"vipslots") or vRP.HasGroup(Passport,"Vip"),vRP.HasGroup(Passport,"Serendibite"),vRP.HasGroup(Passport,"Painite")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local OpenItens = {
	["mechanicpass"] = {
		["Open"] = "Mechanic",
		["Table"] = {
			{ ["Item"] = "advtoolbox", ["Amount"] = 1 },
			{ ["Item"] = "toolbox", ["Amount"] = 2 },
			{ ["Item"] = "tyres", ["Amount"] = 4 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["uwucoffeepass"] = {
		["Open"] = "UwuCoffee",
		["Table"] = {
			{ ["Item"] = "nigirizushi", ["Amount"] = 3 },
			{ ["Item"] = "sushi", ["Amount"] = 3 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["pizzathispass"] = {
		["Open"] = "PizzaThis",
		["Table"] = {
			{ ["Item"] = "nigirizushi", ["Amount"] = 3 },
			{ ["Item"] = "sushi", ["Amount"] = 3 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["burgershotpass"] = {
		["Open"] = "BurgerShot",
		["Table"] = {
			{ ["Item"] = "hamburger2", ["Amount"] = 1 },
			{ ["Item"] = "cookedmeat", ["Amount"] = 2 },
			{ ["Item"] = "cookedfishfillet", ["Amount"] = 1 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	},
	["paramedicpass"] = {
		["Open"] = "Paramedic",
		["Table"] = {
			{ ["Item"] = "gauze", ["Amount"] = 3 },
			{ ["Item"] = "medkit", ["Amount"] = 1 },
			{ ["Item"] = "analgesic", ["Amount"] = 4 },
			{ ["Item"] = "dollars", ["Amount"] = 200 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		if (tostring(Slot) == "4" or tostring(Slot) == "5") and not vRP.HasGroup(Passport,"Bolso") then
			TriggerClientEvent("Notify",source,"negado","Você não possui Bolso.",5000)
			TriggerClientEvent("chest:Update",source,"Refresh")
			return
		end

		local maxSlots = 17
		if vRP.HasGroup(Passport,"Painite") then
			maxSlots = 25
		elseif vRP.HasGroup(Passport,"Serendibite") then
			maxSlots = 21
		end

		if (parseInt(Slot) > maxSlots) and not vRP.HasGroup(Passport,"vipslots") and not vRP.HasGroup(Passport,"Vip") then
			TriggerClientEvent("Notify",source,"negado","Você não possui o grupo Vip.",5000)
			TriggerClientEvent("chest:Update",source,"Refresh")
			return
		end

		if Amount <= 0 then Amount = 1 end

		if itemBlock(Item) then
			TriggerClientEvent("Notify",source,"negado","Este item não pode ser armazenado.",5000)
			TriggerClientEvent("chest:Update",source,"Refresh")

			return true
		end

		if OpenItens[Item] and OpenItens[Item]["Open"] == Open[Passport]["Name"] then
			if vRP.TakeItem(Passport,Item,1) then
				for _,v in pairs(OpenItens[Item]["Table"]) do
					vRP.GenerateItem(Passport,v["Item"],v["Amount"])
				end
			end

			TriggerClientEvent("chest:Update",source,"Refresh")

			return true
		end

		if vRP.StoreChest(Passport,"Chest:"..Open[Passport]["Name"],Amount,Open[Passport]["Weight"],Slot,Target) then
			TriggerClientEvent("chest:Update",source,"Refresh")
		else
			local Result = vRP.GetSrvData("Chest:"..Open[Passport]["Name"],Open[Passport]["Save"])
			TriggerClientEvent("chest:Update",source,"Update",vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Open[Passport]["Weight"])

			if Open[Passport]["Logs"] then
				TriggerEvent("Discord",Open[Passport]["Name"],"**Passaporte:** "..Passport.."\n**Guardou:** "..Amount.."x "..itemName(Item).."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Target = parseInt(Target)
	local Slot = parseInt(Slot)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		if (tostring(Target) == "4" or tostring(Target) == "5") and not vRP.HasGroup(Passport,"Bolso") then
			TriggerClientEvent("Notify",source,"negado","Você não possui Bolso.",5000)
			TriggerClientEvent("chest:Update",source,"Refresh")
			return
		end

		local maxSlots = 17
		if vRP.HasGroup(Passport,"Painite") then
			maxSlots = 25
		elseif vRP.HasGroup(Passport,"Serendibite") then
			maxSlots = 21
		end

		if (parseInt(Target) > maxSlots) and not vRP.HasGroup(Passport,"vipslots") and not vRP.HasGroup(Passport,"Vip") then
			TriggerClientEvent("Notify",source,"negado","Você não possui o grupo Vip.",5000)
			TriggerClientEvent("chest:Update",source,"Refresh")
			return
		end

		if Amount <= 0 then Amount = 1 end

		if vRP.TakeChest(Passport,"Chest:"..Open[Passport]["Name"],Amount,Slot,Target) then
			TriggerClientEvent("chest:Update",source,"Refresh")
		else
			local Result = vRP.GetSrvData("Chest:"..Open[Passport]["Name"],Open[Passport]["Save"])
			TriggerClientEvent("chest:Update",source,"Update",vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.ChestWeight(Result),Open[Passport]["Weight"])

			if string.sub(Open[Passport]["Name"],1,9) == "Helicrash" and vRP.ChestWeight(Result) <= 0 then
				TriggerClientEvent("chest:Close",source)
				exports["helicrash"]:Box()
			end

			if Open[Passport]["Logs"] then
				TriggerEvent("Discord",Open[Passport]["Name"],"**Passaporte:** "..Passport.."\n**Retirou:** "..Amount.."x "..itemName(Item).."\n**Horário:** "..os.date("%H:%M:%S"),9317187)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and Open[Passport] then
		if Amount <= 0 then Amount = 1 end

		if vRP.UpdateChest(Passport,"Chest:"..Open[Passport]["Name"],Slot,Target,Amount) then
			TriggerClientEvent("chest:Update",source,"Refresh")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPGRADE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chest:Upgrade")
AddEventHandler("chest:Upgrade",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasService(Passport,Name) then
			if vRP.Request(source,"Aumentar <b>10Kg</b> por <b>$5.000</b> dólares?","Sim","Não") then
				if vRP.PaymentFull(Passport,5000) then
					vRP.Query("chests/UpdateChests",{ name = Name })
					TriggerClientEvent("Notify",source,"verde","Compra concluída.",3000)
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Open[Passport] then
		Open[Passport] = nil
	end
end)
