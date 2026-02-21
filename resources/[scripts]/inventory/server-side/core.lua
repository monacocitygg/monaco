-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("inventory",Creative)
vPLAYER = Tunnel.getInterface("player")

function Creative.checkBolso()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		return vRP.HasGroup(Passport,"Bolso")
	end
	return false
end

function Creative.invUpdate(Slot,Target,Amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Slot = tostring(Slot)
		Target = tostring(Target)
		Amount = parseInt(Amount)

		if (parseInt(Target) == 4 or parseInt(Target) == 5) and not vRP.HasGroup(Passport,"Bolso") then
			TriggerClientEvent("Notify",source,"negado","Você não possui Bolso.",5000)
			TriggerClientEvent("inventory:Update",source,"Backpack")
			return
		end

		local maxSlots = 17
		if vRP.HasGroup(Passport,"Painite") then
			maxSlots = 25
		elseif vRP.HasGroup(Passport,"Serendibite") then
			maxSlots = 21
		end
		if parseInt(Target) > maxSlots and not vRP.HasGroup(Passport,"vipslots") then
			TriggerClientEvent("Notify",source,"negado","Você não possui  Vip.",5000)
			TriggerClientEvent("inventory:Update",source,"Backpack")
			return
		end

		local Inventory = vRP.Inventory(Passport)
		
		-- Determine Inventory Key Type
		local KeyType = "string" -- Default to string
		for k,v in pairs(Inventory) do
			if type(k) == "number" then
				KeyType = "number"
			end
			break
		end
		
		-- Helper to get item and key
		local function GetItem(Inv, Key)
			if Inv[Key] then return Inv[Key], Key end
			local NumKey = tonumber(Key)
			if NumKey and Inv[NumKey] then return Inv[NumKey], NumKey end
			return nil, nil
		end

		local SlotItem, RealSlotKey = GetItem(Inventory, Slot)
		
		if SlotItem then
			if Amount > SlotItem["amount"] then Amount = SlotItem["amount"] end
			if Amount <= 0 then return end

			local TargetItem, RealTargetKey = GetItem(Inventory, Target)
            
            -- Default to Target if new, respecting KeyType
			if not RealTargetKey then
				if KeyType == "number" then
					RealTargetKey = tonumber(Target)
				else
					RealTargetKey = tostring(Target)
				end
			end
            
            -- Ensure RealSlotKey matches KeyType (consistency)
            if KeyType == "number" and type(RealSlotKey) == "string" then
                RealSlotKey = tonumber(RealSlotKey)
            elseif KeyType == "string" and type(RealSlotKey) == "number" then
                RealSlotKey = tostring(RealSlotKey)
            end

			-- Case 1: Target is Empty -> Move
			if not TargetItem then
				if vRP.TakeItem(Passport,SlotItem["item"],Amount,false,RealSlotKey) then
					vRP.GiveItem(Passport,SlotItem["item"],Amount,false,RealTargetKey)
				end
			
			-- Case 2: Target has SAME item -> Stack
			elseif TargetItem["item"] == SlotItem["item"] then
				if vRP.TakeItem(Passport,SlotItem["item"],Amount,false,RealSlotKey) then
					vRP.GiveItem(Passport,SlotItem["item"],Amount,false,RealTargetKey)
				end

			-- Case 3: Target has DIFFERENT item -> Swap
			else
				if vRP.TakeItem(Passport,SlotItem["item"],Amount,false,RealSlotKey) then
					if vRP.TakeItem(Passport,TargetItem["item"],TargetItem["amount"],false,RealTargetKey) then
						vRP.GiveItem(Passport,SlotItem["item"],Amount,false,RealTargetKey)
						vRP.GiveItem(Passport,TargetItem["item"],TargetItem["amount"],false,RealSlotKey)
					else
						vRP.GiveItem(Passport,SlotItem["item"],Amount,false,RealSlotKey)
					end
				end
			end

			TriggerClientEvent("inventory:Update",source,"Backpack")
		else
			-- SlotItem not found
		end
	end
end
vGARAGE = Tunnel.getInterface("garages")
vTASKBAR = Tunnel.getInterface("taskbar")
vDELIVER = Tunnel.getInterface("deliver")
vCLIENT = Tunnel.getInterface("inventory")
vKEYBOARD = Tunnel.getInterface("keyboard")
vPARAMEDIC = Tunnel.getInterface("paramedic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Drops = {}
Drugs = {}
Carry = {}
Ammos = {}
Loots = {}
Boxes = {}
Active = {}
Trashs = {}
Armors = {}
Plates = {}
Trunks = {}
Healths = {}
Animals = {}
Attachs = {}
Skins = {}
Scanners = {}
Temporary = {}
atmTimers = {}
Dismantle = {}
verifyObjects = {}
verifyAnimals = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
-----------------------------------------------------------------------------------------------------------------------------------------
Buffs = {
	["Dexterity"] = {},
	["Luck"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUGSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
DrugsList = {
	["cocaine"] = {
		Price = { ["Min"] = 400, ["Max"] = 600 },
		Amount = { ["Min"] = 2, ["Max"] = 3 }
	},
	["meth"] = {
		Price = { ["Min"] = 400, ["Max"] = 600 },
		Amount = { ["Min"] = 2, ["Max"] = 3 }
	},
	["lean"] = {
		Price = { ["Min"] = 400, ["Max"] = 600 },
		Amount = { ["Min"] = 2, ["Max"] = 3 }
	},
	["oxy"] = {
		Price = { ["Min"] = 400, ["Max"] = 600 },
		Amount = { ["Min"] = 2, ["Max"] = 3 }
	},
	["joint"] = {
		Price = { ["Min"] = 400, ["Max"] = 600 },
		Amount = { ["Min"] = 2, ["Max"] = 3 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
Objects = {
	["1"] = { x = 70.27, y = -1389.11, z = 29.13, h = 90.28, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["2"] = { x = -706.01, y = -150.49, z = 37.17, h = 28.61, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["3"] = { x = -167.66, y = -301.67, z = 39.49, h = 161.34, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["4"] = { x = -821.69, y = -1067.22, z = 11.08, h = 31.23, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["5"] = { x = -1186.62, y = -772.55, z = 17.09, h = 215.93, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["6"] = { x = -1446.85, y = -240.38, z = 49.57, h = 316.88, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["7"] = { x = 5.53, y = 6506.07, z = 31.63, h = 222.68, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["8"] = { x = 1699.51, y = 4819.72, z = 41.82, h = 277.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["9"] = { x = 117.83, y = -223.56, z = 54.31, h = 70.89, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["10"] = { x = 621.58, y = 2765.81, z = 41.84, h = 275.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["11"] = { x = 1200.46, y = 2715.37, z = 37.98, h = 0.24, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["12"] = { x = -3178.48, y = 1044.46, z = 20.62, h = 66.61, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["13"] = { x = -1102.05, y = 2716.93, z = 18.86, h = 40.85, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["14"] = { x = 430.72, y = -810.01, z = 29.25, h = 270.35, object = "p_v_43_safe_s", item = "", Distance = 50 },

	-- ROBBERY WEAPONSSHOP
	["15"] = { x = 1688.78, y = 3759.13, z = 34.46, h = 47.5, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["16"] = { x = 256.35, y = -47.51, z = 69.7, h = 249.76, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["17"] = { x = 846.13, y = -1036.62, z = 27.95, h = 178.74, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["18"] = { x = -335.18, y = 6083.29, z = 31.21, h = 45.57, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["19"] = { x = -665.98, y = -932.24, z = 21.58, h = 358.38, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["20"] = { x = -1301.93, y = -391.36, z = 36.45, h = 255.85, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["21"] = { x = -1122.59, y = 2698.25, z = 18.31, h = 42.82, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["22"] = { x = 2571.67, y = 291.28, z = 108.49, h = 180.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["23"] = { x = 2571.66, y = 291.29, z = 108.49, h = 181.06, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["24"] = { x = 19.57, y = -1103.0, z = 29.55, h = 339.07, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["25"] = { x = 813.92, y = -2160.34, z = 29.37, h = 179.33, object = "p_v_43_safe_s", item = "", Distance = 50 },

	-- ROBBERY BARBERSHOP
	["26"] = { x = -807.9, y = -180.83, z = 37.32, h = 299.3, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["27"] = { x = 139.56, y = -1704.12, z = 29.05, h = 320.25, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["28"] = { x = -1278.11, y = -1116.66, z = 6.75, h = 270.07, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["29"] = { x = 1928.89, y = 3734.04, z = 32.6, h = 29.2, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["30"] = { x = 1217.05, y = -473.45, z = 65.96, h = 255.89, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["31"] = { x = -34.08, y = -157.01, z = 56.83, h = 159.63, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["32"] = { x = -274.5, y = 6225.27, z = 31.45, h = 225.27, object = "p_v_43_safe_s", item = "", Distance = 50 },

	-- ROBBERY TATTOOSHOP
	["33"] = { x = 1327.98, y = -1654.78, z = 52.03, h = 218.71, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["34"] = { x = -1149.04, y = -1428.64, z = 4.71, h = 215.2, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["35"] = { x = 322.01, y = 186.24, z = 103.34, h = 339.28, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["36"] = { x = -3175.64, y = 1075.54, z = 20.58, h = 65.96, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["37"] = { x = 1866.01, y = 3748.07, z = 32.79, h = 299.38, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["38"] = { x = -295.51, y = 6199.21, z = 31.24, h = 133.05, object = "p_v_43_safe_s", item = "", Distance = 50 },
	["39"] = { x = 986.14, y = -2129.69, z = 30.46, h = 357.17, object = "p_v_43_safe_s", item = "", Distance = 50 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRODUCTS
-----------------------------------------------------------------------------------------------------------------------------------------
Products = {
	["paper"] = {
		{ ["timer"] = 20, ["need"] = {
			{ ["item"] = "woodlog", ["amount"] = 3 }
		}, ["needAmount"] = 1, ["item"] = "paper", ["itemAmount"] = 1 }
	},
	["tablecoke"] = {
		{ ["timer"] = 20, ["need"] = {
			{ ["item"] = "sulfuric", ["amount"] = 1 },
			{ ["item"] = "cokeleaf", ["amount"] = 1 }
		}, ["item"] = "cocaine", ["itemAmount"] = 1 }
	},
	["tablemeth"] = {
		{ ["timer"] = 20, ["need"] = {
			{ ["item"] = "saline", ["amount"] = 1 },
			{ ["item"] = "acetone", ["amount"] = 1 }
		}, ["item"] = "meth", ["itemAmount"] = 1 }
	},
	["tableweed"] = {
		{ ["timer"] = 20, ["need"] = {
			{ ["item"] = "silk", ["amount"] = 1 },
			{ ["item"] = "weedleaf", ["amount"] = 1 }
		}, ["item"] = "joint", ["itemAmount"] = 1 }
	},
	["burgershot1"] = {
		{ ["timer"] = 10, ["item"] = "burgershot1", ["itemAmount"] = 1 }
	},
	["burgershot2"] = {
		{ ["timer"] = 10, ["item"] = "burgershot2", ["itemAmount"] = 1 }
	},
	["burgershot3"] = {
		{ ["timer"] = 10, ["need"] = {
			{ ["item"] = "burgershot2", ["amount"] = 1 },
			{ ["item"] = "burgershot1", ["amount"] = 1 }
		}, ["needAmount"] = 1, ["item"] = "burgershot3", ["itemAmount"] = 1 }
	},
	["pizzathis1"] = {
		{ ["timer"] = 10, ["item"] = "pizzathis1", ["itemAmount"] = 1 }
	},
	["pizzathis2"] = {
		{ ["timer"] = 10, ["item"] = "pizzathis2", ["itemAmount"] = 1 }
	},
	["pizzathis3"] = {
		{ ["timer"] = 10, ["need"] = {
			{ ["item"] = "pizzathis2", ["amount"] = 1 },
			{ ["item"] = "pizzathis1", ["amount"] = 1 }
		}, ["needAmount"] = 1, ["item"] = "pizzathis3", ["itemAmount"] = 1 }
	},
	["uwucoffee1"] = {
		{ ["timer"] = 10, ["item"] = "uwucoffee1", ["itemAmount"] = 1 }
	},
	["uwucoffee2"] = {
		{ ["timer"] = 10, ["item"] = "uwucoffee2", ["itemAmount"] = 1 }
	},
	["uwucoffee3"] = {
		{ ["timer"] = 10, ["need"] = {
			{ ["item"] = "uwucoffee2", ["amount"] = 1 },
			{ ["item"] = "uwucoffee1", ["amount"] = 1 }
		}, ["needAmount"] = 1, ["item"] = "uwucoffee3", ["itemAmount"] = 1 }
	},
	["beanmachine1"] = {
		{ ["timer"] = 10, ["item"] = "beanmachine1", ["itemAmount"] = 1 }
	},
	["beanmachine2"] = {
		{ ["timer"] = 10, ["item"] = "beanmachine2", ["itemAmount"] = 1 }
	},
	["beanmachine3"] = {
		{ ["timer"] = 10, ["need"] = {
			{ ["item"] = "beanmachine2", ["amount"] = 1 },
			{ ["item"] = "beanmachine1", ["amount"] = 1 }
		}, ["needAmount"] = 1, ["item"] = "beanmachine3", ["itemAmount"] = 1 }
	},
	["milkBottle"] = {
		{ ["timer"] = 10, ["need"] = "emptybottle", ["needAmount"] = 1, ["item"] = "milkbottle", ["itemAmount"] = 1 }
	},
	["scanner"] = {
		{ ["timer"] = 5, ["item"] = "sheetmetal", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "roadsigns", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "syringe", ["itemAmount"] = 3 },
		{ ["timer"] = 5, ["item"] = "fishingrod", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "plate", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "aluminum", ["itemAmount"] = 3 },
		{ ["timer"] = 5, ["item"] = "copper", ["itemAmount"] = 3 },
		{ ["timer"] = 5, ["item"] = "lighter", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "battery", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "metalcan", ["itemAmount"] = 1 }
	},
	["cemitery"] = {
		{ ["timer"] = 5, ["item"] = "silk", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "cotton", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "plaster", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "pouch", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "switchblade", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "joint", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "acetone", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "slipper", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "water", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "copper", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "cigarette", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "lighter", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "elastic", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "rose", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "teddy", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "binoculars", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "camera", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "silvercoin", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "goldcoin", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "watch", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "bracelet", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "WEAPON_BRICK", ["itemAmount"] = 3 },
		{ ["timer"] = 5, ["item"] = "WEAPON_SHOES", ["itemAmount"] = 2 },
		{ ["timer"] = 5, ["item"] = "dices", ["itemAmount"] = 1 },
		{ ["timer"] = 5, ["item"] = "cup", ["itemAmount"] = 1 }
	},
	["fishfillet"] = {
		{ ["timer"] = 10, ["need"] = "fishfillet", ["needAmount"] = 1, ["item"] = "cookedfishfillet", ["itemAmount"] = 1 }
	},
	["marshmallow"] = {
		{ ["timer"] = 10, ["need"] = "sugar", ["needAmount"] = 4, ["item"] = "marshmallow", ["itemAmount"] = 1 }
	},
	["animalmeat"] = {
		{ ["timer"] = 10, ["need"] = "meat", ["needAmount"] = 1, ["item"] = "cookedmeat", ["itemAmount"] = 1 }
	},
	["emptybottle"] = {
		{ ["timer"] = 3, ["need"] = "emptybottle", ["needAmount"] = 1, ["item"] = "water", ["itemAmount"] = 1 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEALPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
StealPeds = {
	{ ["item"] = "pendrive", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "slipper", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "soap", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "pliers", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "deck", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "floppy", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "domino", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "brush", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "rimel", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "WEAPON_SHOES", ["min"] = 2, ["max"] = 2 },
	{ ["item"] = "dices", ["min"] = 2, ["max"] = 3 },
	{ ["item"] = "spray04", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "spray03", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "spray02", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "spray01", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "bracelet", ["min"] = 2, ["max"] = 3 },
	{ ["item"] = "watch", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "goldcoin", ["min"] = 3, ["max"] = 5 },
	{ ["item"] = "silvercoin", ["min"] = 4, ["max"] = 6 },
	{ ["item"] = "oxy", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "analgesic", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "pager", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "camera", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "binoculars", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "hennessy", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "dewars", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "teddy", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "chocolate", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "notepad", ["min"] = 1, ["max"] = 3 },
	{ ["item"] = "emptybottle", ["min"] = 1, ["max"] = 2 },
	{ ["item"] = "card01", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "card02", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "card03", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "card04", ["min"] = 1, ["max"] = 1 },
	{ ["item"] = "card05", ["min"] = 1, ["max"] = 1 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEALITENS
-----------------------------------------------------------------------------------------------------------------------------------------
StealItens = {
	{ ["item"] = "pendrive", ["min"] = 1, ["max"] = 1, ["rand"] = 150 },
	{ ["item"] = "slipper", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	{ ["item"] = "soap", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	{ ["item"] = "pliers", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	{ ["item"] = "deck", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	{ ["item"] = "floppy", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "domino", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "brush", ["min"] = 1, ["max"] = 4, ["rand"] = 225 },
	{ ["item"] = "rimel", ["min"] = 2, ["max"] = 4, ["rand"] = 225 },
	{ ["item"] = "WEAPON_SHOES", ["min"] = 2, ["max"] = 2, ["rand"] = 225 },
	{ ["item"] = "dices", ["min"] = 2, ["max"] = 4, ["rand"] = 225 },
	{ ["item"] = "spray04", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "spray03", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "spray02", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "spray01", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "bracelet", ["min"] = 2, ["max"] = 4, ["rand"] = 200 },
	{ ["item"] = "xbox", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	{ ["item"] = "playstation", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	{ ["item"] = "watch", ["min"] = 2, ["max"] = 3, ["rand"] = 200 },
	{ ["item"] = "goldcoin", ["min"] = 4, ["max"] = 6, ["rand"] = 175 },
	{ ["item"] = "silvercoin", ["min"] = 4, ["max"] = 8, ["rand"] = 175 },
	{ ["item"] = "oxy", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	{ ["item"] = "analgesic", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	{ ["item"] = "firecracker", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	{ ["item"] = "pager", ["min"] = 1, ["max"] = 1, ["rand"] = 150 },
	{ ["item"] = "GADGET_PARACHUTE", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	{ ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 1, ["rand"] = 50 },
	{ ["item"] = "WEAPON_WRENCH", ["min"] = 1, ["max"] = 1, ["rand"] = 125 },
	{ ["item"] = "WEAPON_POOLCUE", ["min"] = 1, ["max"] = 1, ["rand"] = 125 },
	{ ["item"] = "WEAPON_BAT", ["min"] = 1, ["max"] = 1, ["rand"] = 125 },
	{ ["item"] = "card02", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	{ ["item"] = "camera", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	{ ["item"] = "binoculars", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	{ ["item"] = "hennessy", ["min"] = 1, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "dewars", ["min"] = 1, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "teddy", ["min"] = 1, ["max"] = 1, ["rand"] = 225 },
	{ ["item"] = "chocolate", ["min"] = 1, ["max"] = 3, ["rand"] = 225 },
	{ ["item"] = "lighter", ["min"] = 1, ["max"] = 1, ["rand"] = 225 },
	{ ["item"] = "cellphone", ["min"] = 1, ["max"] = 1, ["rand"] = 150 },
	{ ["item"] = "tyres", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	{ ["item"] = "notepad", ["min"] = 1, ["max"] = 5, ["rand"] = 225 },
	{ ["item"] = "plate", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	{ ["item"] = "emptybottle", ["min"] = 2, ["max"] = 5, ["rand"] = 225 },
	{ ["item"] = "bait", ["min"] = 1, ["max"] = 6, ["rand"] = 225 },
	{ ["item"] = "switchblade", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	{ ["item"] = "card01", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	{ ["item"] = "card02", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	{ ["item"] = "card03", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	{ ["item"] = "card04", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	{ ["item"] = "card05", ["min"] = 1, ["max"] = 1, ["rand"] = 200 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
LootItens = {
	["Medic"] = {
		["Cooldown"] = 3600,
		["List"] = {
			{ ["item"] = "alcohol", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "syringe", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "codeine", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "amphetamine", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "acetone", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "cotton", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "plaster", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "saline", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "sulfuric", ["min"] = 1, ["max"] = 3 }
		}
	},
	["Weapons"] = {
		["Cooldown"] = 7200,
		["List"] = {
			{ ["item"] = "roadsigns", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "techtrash", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "pistolbody", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "smgbody", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "riflebody", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "sheetmetal", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "explosives", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "aluminum", ["min"] = 2, ["max"] = 3 },
			{ ["item"] = "copper", ["min"] = 2, ["max"] = 3 }
		}
	},
	["Supplies"] = {
		["Cooldown"] = 3600,
		["List"] = {
			{ ["item"] = "tarp", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "sheetmetal", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "roadsigns", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "leather", ["min"] = 1, ["max"] = 3 },
			{ ["item"] = "animalfat", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "cotton", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "plaster", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "sulfuric", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "saline", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "alcohol", ["min"] = 1, ["max"] = 2 },
			{ ["item"] = "syringe", ["min"] = 2, ["max"] = 3 },
			{ ["item"] = "card01", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "card02", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "card03", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "card04", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "card05", ["min"] = 1, ["max"] = 1 },
			{ ["item"] = "silk", ["min"] = 1, ["max"] = 3 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.requestInventory()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if GetPlayerRoutingBucket(source) < 900000 then
			if vRP.CheckRolepass(source) then
				TriggerEvent("vRP:Rewards",source)
			end
		end

		local Inv = {}
		local Inventory = vRP.Inventory(Passport)
		for Index,v in pairs(Inventory) do
			if (parseInt(v["amount"]) <= 0 or not itemBody(v["item"])) then
				vRP.RemoveItem(Passport,v["item"],parseInt(v["amount"]),false)
			else
				v["amount"] = parseInt(v["amount"])
				v["name"] = itemName(v["item"])
				v["peso"] = itemWeight(v["item"])
				v["index"] = itemIndex(v["item"])

				if Config and Config.itensRegister and Config.itensRegister[v["item"]] then
					v["name"] = Config.itensRegister[v["item"]].name
					local image = Config.itensRegister[v["item"]].image
					if string.find(image, ".png") then
						image = string.gsub(image, ".png", "")
					end
					v["index"] = "skins/" .. image
				end
				v["max"] = itemMaxAmount(v["item"])
				v["desc"] = itemDescription(v["item"])
				v["economy"] = parseFormat(itemEconomy(v["item"]))
				v["key"] = v["item"]
				v["slot"] = Index

				local Split = splitString(v["item"],"-")
				if Split[2] ~= nil then
					if Split[1] == "identity" or Split[1] == "fidentity" or string.sub(v["item"],1,5) == "badge" then
						local Number = parseInt(Split[2])
						local Identity = vRP.Identity(Number)

						if Split[1] == "fidentity" then
							Identity = vRP.FalseIdentity(Number)
						end

						if Identity then
							v["Passport"] = Number
							v["idPremium"] = "Nenhum"
							v["idRolepass"] = "Inativo"
							v["idBlood"] = Sanguine(Identity["blood"])
							v["idName"] = Identity["name"].." "..Identity["name2"]

							if Number == Passport and Split[1] == "identity" then
								if Identity["premium"] > os.time() then
									local Groups = vRP.Hierarchy("Premium")
									local Number = vRP.HasPermission(Passport,"Premium")

									v["idVality"] = MinimalTimers(Identity["premium"] - os.time())
									v["idPremium"] = Groups[Number]
								end

								if Identity["rolepass"] > 0 then
									v["idRolepass"] = "Ativo"
								end
							end
						end
					end

					if Split[1] == "vehkey" then
						v["Vehkey"] = Split[2]
					end

					if Split[1] == "notepad" and Split[2] then
						v["desc"] = vRP.GetSrvData(v["item"])
					end

					if Split[1] == "suitcase" then
						v["Suitcase"] = parseFormat(Split[2])
					end

					if itemCharges(v["item"]) then
						v["charges"] = parseInt(Split[2] * 33)
					end

					if itemDurability(v["item"]) then
						local ts = tonumber(Split[2])
						if ts then
							v["durability"] = parseInt(os.time() - ts)
						else
							v["durability"] = 0
						end
						v["days"] = itemDurability(v["item"])
					else
						v["durability"] = 0
						v["days"] = 1
					end
				else
					v["durability"] = 0
					v["days"] = 1
				end

				if Split[1] == "weedclone" or Split[1] == "weedleaf" or Split[1] == "joint" then
					local Item = "da clonagem"
					if Split[1] == "weedleaf" then
						Item = "da folha"
					elseif Split[1] == "joint" then
						Item = "do baseado"
					end

					v["desc"] = "A pureza "..Item.." se encontra em <green>"..(Split[2] or 0).."%</green>."
				end

				Inv[Index] = v
			end
		end

		local Identity = vRP.Identity(Passport)
	if Identity then
		Identity["passport"] = Passport
	end
	return Inv,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),Identity,vRP.HasGroup(Passport,"Bolso"),vRP.HasGroup(Passport,"vipslots"),vRP.HasGroup(Passport,"Serendibite"),vRP.HasGroup(Passport,"Painite")
end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DropServer(Coords,Item,Amount)
	local Number = 0

	repeat
		Number = Number + 1
	until not Drops[tostring(Number)]

	Drops[tostring(Number)] = {
		["key"] = Item,
		["amount"] = Amount,
		["Coords"] = { Coords["x"],Coords["y"],Coords["z"] },
		["name"] = itemName(Item),
		["peso"] = itemWeight(Item),
		["index"] = itemIndex(Item),
		["days"] = 1,
		["durability"] = 0,
		["charges"] = nil
	}

	TriggerClientEvent("drops:Adicionar",-1,tostring(Number),Drops[tostring(Number)])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Drops(Item,Slot,Amount,x,y,z)
	local source = source
	local Slot = tostring(Slot)
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] and not Player(source)["state"]["Handcuff"] and not vRP.InsideVehicle(source) and GetPlayerRoutingBucket(source) < 900000 then
			if itemBlock(Item) then
				TriggerClientEvent("inventory:Update",source,"Backpack")
				return
			end

			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				local Days = 1
				local Number = 0
				local Charges = nil
				local Durability = 0
				local Split = splitString(Item,"-")

				repeat
					Number = Number + 1
				until not Drops[tostring(Number)]

				if Split[2] ~= nil then
					if itemCharges(Item) then
						Charges = parseInt(Split[2] * 33)
					end

					if itemDurability(Item) then
						local ts = tonumber(Split[2])
						if ts then
							Durability = parseInt(os.time() - ts)
						else
							Durability = 0
						end
						Days = itemDurability(Item)
					end
				end

				Drops[tostring(Number)] = {
					["key"] = Item,
					["amount"] = Amount,
					["Coords"] = { x,y,z },
					["name"] = itemName(Item),
					["peso"] = itemWeight(Item),
					["index"] = itemIndex(Item),
					["days"] = Days,
					["durability"] = Durability,
					["charges"] = Charges
				}

				Player(source)["state"]["Buttons"] = true
				Player(source)["state"]["Cancel"] = true

				if not vRP.InsideVehicle(source) then
					vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)
					Active[Passport] = os.time() + 100

					SetTimeout(1000,function()
						vRPC.removeObjects(source)
						Active[Passport] = nil
					end)
				end

				TriggerClientEvent("drops:Adicionar",-1,tostring(Number),Drops[tostring(Number)])
				TriggerClientEvent("inventory:Update",source,"Backpack")
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false
			else
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("inventory:Update",source,"Backpack")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Pickup(Number,Amount,Slot)
	local source = source
	local Slot = tostring(Slot)
	local Number = tostring(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		if (parseInt(Slot) == 4 or parseInt(Slot) == 5) and not vRP.HasGroup(Passport,"Bolso") then
		TriggerClientEvent("Notify",source,"negado","Você não possui Bolso.",5000)
		TriggerClientEvent("inventory:Update",source,"Backpack")
		return
	end

	local maxSlots2 = 17
	if vRP.HasGroup(Passport,"Painite") then
		maxSlots2 = 25
	elseif vRP.HasGroup(Passport,"Serendibite") then
		maxSlots2 = 21
	end
	if parseInt(Slot) > maxSlots2 and not vRP.HasGroup(Passport,"vipslots") then
		TriggerClientEvent("Notify",source,"negado","Você não possui o grupo Vip.",5000)
		TriggerClientEvent("inventory:Update",source,"Backpack")
		return
	end

		if not Active[Passport] and GetPlayerRoutingBucket(source) < 900000 then
			if not Drops[Number] then
				TriggerClientEvent("inventory:Update",source,"Backpack")
				return
			else
				if (vRP.InventoryWeight(Passport) + itemWeight(Drops[Number]["key"]) * Amount) <= vRP.GetWeight(Passport) then
					if not Drops[Number] or Drops[Number]["amount"] < Amount then
						TriggerClientEvent("inventory:Update",source,"Backpack")
						return
					end

					if vRP.MaxItens(Passport,Drops[Number]["key"],Amount) then
						TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
						TriggerClientEvent("inventory:Update",source,"Backpack")
						return
					end

					if Drops[Number] then
						local inventory = vRP.Inventory(Passport)
						if inventory[Slot] and Drops[Number]["key"] then
							if inventory[Slot]["item"] == Drops[Number]["key"] then
								vRP.GiveItem(Passport,Drops[Number]["key"],Amount,false,Slot)
							else
								vRP.GiveItem(Passport,Drops[Number]["key"],Amount,false)
							end
						else
							if Drops[Number] then
								vRP.GiveItem(Passport,Drops[Number]["key"],Amount,false,Slot)
							end
						end

						Drops[Number]["amount"] = Drops[Number]["amount"] - Amount
						if Drops[Number]["amount"] <= 0 then
							TriggerClientEvent("drops:Remover",-1,Number)
							Drops[Number] = nil
						else
							TriggerClientEvent("drops:Atualizar",-1,Number,Drops[Number]["amount"])
						end

						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true

						if not vRP.InsideVehicle(source) then
							vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)
							Active[Passport] = os.time() + 100

							SetTimeout(1000,function()
								vRPC.removeObjects(source)
								Active[Passport] = nil
							end)
						end

						TriggerClientEvent("inventory:Update",source,"Backpack")
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
					else
						TriggerClientEvent("inventory:Update",source,"Backpack")
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					TriggerClientEvent("inventory:Update",source,"Backpack")
					return
				end
			end
		else
			TriggerClientEvent("inventory:Update",source,"Backpack")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SendItem(Slot,Amount)
	local source = source
	local Slot = tostring(Slot)
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and GetPlayerRoutingBucket(source) < 900000 then
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			Active[Passport] = os.time() + 100

			local inventory = vRP.Inventory(Passport)
			if not inventory[Slot] or not inventory[Slot]["item"] then
				Active[Passport] = nil
				return
			end

			if Amount <= 0 then Amount = 1 end
			local Item = inventory[Slot]["item"]

			local splitSend = splitString(Item,"-")
			local isDamaged = false
			if itemDurability(Item) then
				local ts = tonumber(splitSend[2])
				if ts then
					isDamaged = vRP.CheckDamaged(Item)
				end
			end
			if isDamaged or itemBlock(Item) then
				Active[Passport] = nil
				return
			end

			local OtherPassport = vRP.Passport(ClosestPed)
			if not vRP.MaxItens(OtherPassport,Item,Amount) then
				if (vRP.InventoryWeight(OtherPassport) + itemWeight(Item) * Amount) <= vRP.GetWeight(OtherPassport) then
					Active[Passport] = os.time() + 3
					Player(source)["state"]["Cancel"] = true
					Player(source)["state"]["Buttons"] = true
					Player(ClosestPed)["state"]["Cancel"] = true
					Player(ClosestPed)["state"]["Buttons"] = true
					vRPC.createObjects(source,"mp_safehouselost@","package_dropoff","prop_paper_bag_small",16,28422,0.0,-0.05,0.05,180.0,0.0,0.0)

					repeat
						if os.time() >= parseInt(Active[Passport]) then
							Active[Passport] = nil
							vRPC.removeObjects(source)
							Player(source)["state"]["Cancel"] = false
							Player(source)["state"]["Buttons"] = false
							Player(ClosestPed)["state"]["Cancel"] = false
							Player(ClosestPed)["state"]["Buttons"] = false


							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								vRP.GiveItem(OtherPassport,Item,Amount,true)
								TriggerClientEvent("inventory:Update",source,"Backpack")
								TriggerClientEvent("inventory:Update",ClosestPed,"Backpack")
							end
						end

						Wait(100)
					until not Active[Passport]
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
			end

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deliver(Slot)
	local source = source
	local Slot = tostring(Slot)
	local Passport = vRP.Passport(source)
	if Passport then
		local Inventory = vRP.Inventory(Passport)
		if not Inventory[Slot] or not Inventory[Slot]["item"] then
			return
		end

		local Split = splitString(Inventory[Slot]["item"],"-")
		local Full = Inventory[Slot]["item"]
		local Item = Split[1]

		if Item == "woodlog" then
			if not vRPC.LastVehicle(source,"ratloader") then
				TriggerClientEvent("Notify",source,"amarelo","Precisa utilizar o veículo do <b>Lenhador</b>.",3000)
				return
			end

			if vDELIVER.Deliver(source,"Lumberman") then
				if vRP.TakeItem(Passport,Full,3,false,Slot) then
					local Experience = vRP.GetExperience(Passport,"Lumberman")
					local Category = ClassCategory(Experience)
					local Valuation = 100

					if Category == "B+" then
						Valuation = Valuation + 20
					elseif Category == "A" then
						Valuation = Valuation + 40
					elseif Category == "A+" then
						Valuation = Valuation + 60
					elseif Category == "S" then
						Valuation = Valuation + 80
					elseif Category == "S+" then
						Valuation = Valuation + 100
					end

					if Buffs["Dexterity"][Passport] then
						if Buffs["Dexterity"][Passport] > os.time() then
							Valuation = Valuation + (Valuation * 0.1)
						end
					end

					TriggerClientEvent("inventory:Update",source,"Backpack")
					vRP.GenerateItem(Passport,"dollars",Valuation,true)
					vRP.PutExperience(Passport,"Lumberman",1)
					vDELIVER.Update(source)
				end
			end
		elseif Item == "pouch" then
			if not vRPC.LastVehicle(source,"stockade") then
				TriggerClientEvent("Notify",source,"amarelo","Precisa utilizar o veículo do <b>Transportador</b>.",3000)
				return
			end

			if vDELIVER.Deliver(source,"Transporter") then
				if vRP.TakeItem(Passport,Full,1,false,Slot) then
					local Experience = vRP.GetExperience(Passport,"Transporter")
					local Category = ClassCategory(Experience)
					local Valuation = 60

					if Category == "B+" then
						Valuation = Valuation + 10
					elseif Category == "A" then
						Valuation = Valuation + 20
					elseif Category == "A+" then
						Valuation = Valuation + 30
					elseif Category == "S" then
						Valuation = Valuation + 40
					elseif Category == "S+" then
						Valuation = Valuation + 50
					end

					if Buffs["Dexterity"][Passport] then
						if Buffs["Dexterity"][Passport] > os.time() then
							Valuation = Valuation + (Valuation * 0.1)
						end
					end

					TriggerClientEvent("inventory:Update",source,"Backpack")
					vRP.GenerateItem(Passport,"dollars",Valuation,true)
					vRP.PutExperience(Passport,"Transporter",1)
					vDELIVER.Update(source)
				end
			end
		elseif Item == "burgershot3" or Item == "burgershot4" then
			if vDELIVER.Deliver(source,"BurgerShot") then
				if vRP.TakeItem(Passport,Full,1,false,Slot) then
					local Experience = vRP.GetExperience(Passport,"Delivery")
					local Category = ClassCategory(Experience)
					local Valuation = 200

					if Item == "burgershot4" then
						Valuation = 350
					end

					if Category == "B+" then
						Valuation = Valuation + 15
					elseif Category == "A" then
						Valuation = Valuation + 30
					elseif Category == "A+" then
						Valuation = Valuation + 45
					elseif Category == "S" then
						Valuation = Valuation + 60
					elseif Category == "S+" then
						Valuation = Valuation + 75
					end

					if Buffs["Dexterity"][Passport] then
						if Buffs["Dexterity"][Passport] > os.time() then
							Valuation = Valuation + (Valuation * 0.1)
						end
					end

					TriggerClientEvent("inventory:Update",source,"Backpack")
					vRP.GenerateItem(Passport,"dollars",Valuation,true)
					vRP.DirectChest("BurgerShot","100",Valuation * 0.05)
					vRP.PutExperience(Passport,"Delivery",1)
					vDELIVER.Update(source)
				end
			end
		elseif Item == "pizzathis3" or Item == "pizzathis4" then
			if vDELIVER.Deliver(source,"PizzaThis") then
				if vRP.TakeItem(Passport,Full,1,false,Slot) then
					local Experience = vRP.GetExperience(Passport,"Delivery")
					local Category = ClassCategory(Experience)
					local Valuation = 200

					if Item == "pizzathis4" then
						Valuation = 350
					end

					if Category == "B+" then
						Valuation = Valuation + 15
					elseif Category == "A" then
						Valuation = Valuation + 30
					elseif Category == "A+" then
						Valuation = Valuation + 45
					elseif Category == "S" then
						Valuation = Valuation + 60
					elseif Category == "S+" then
						Valuation = Valuation + 75
					end

					if Buffs["Dexterity"][Passport] then
						if Buffs["Dexterity"][Passport] > os.time() then
							Valuation = Valuation + (Valuation * 0.1)
						end
					end

					TriggerClientEvent("inventory:Update",source,"Backpack")
					vRP.GenerateItem(Passport,"dollars",Valuation,true)
					vRP.DirectChest("PizzaThis","100",Valuation * 0.05)
					vRP.PutExperience(Passport,"Delivery",1)
					vDELIVER.Update(source)
				end
			end
		elseif Item == "uwucoffee3" or Item == "uwucoffee4" then
			if vDELIVER.Deliver(source,"UwuCoffee") then
				if vRP.TakeItem(Passport,Full,1,false,Slot) then
					local Experience = vRP.GetExperience(Passport,"Delivery")
					local Category = ClassCategory(Experience)
					local Valuation = 200

					if Item == "uwucoffee4" then
						Valuation = 350
					end

					if Category == "B+" then
						Valuation = Valuation + 15
					elseif Category == "A" then
						Valuation = Valuation + 30
					elseif Category == "A+" then
						Valuation = Valuation + 45
					elseif Category == "S" then
						Valuation = Valuation + 60
					elseif Category == "S+" then
						Valuation = Valuation + 75
					end

					if Buffs["Dexterity"][Passport] then
						if Buffs["Dexterity"][Passport] > os.time() then
							Valuation = Valuation + (Valuation * 0.1)
						end
					end

					TriggerClientEvent("inventory:Update",source,"Backpack")
					vRP.GenerateItem(Passport,"dollars",Valuation,true)
					vRP.DirectChest("UwuCoffee","100",Valuation * 0.05)
					vRP.PutExperience(Passport,"Delivery",1)
					vDELIVER.Update(source)
				end
			end
		elseif Item == "beanmachine3" or Item == "beanmachine4" then
			if vDELIVER.Deliver(source,"BeanMachine") then
				if vRP.TakeItem(Passport,Full,1,false,Slot) then
					local Experience = vRP.GetExperience(Passport,"Delivery")
					local Category = ClassCategory(Experience)
					local Valuation = 200

					if Item == "beanmachine4" then
						Valuation = 350
					end

					if Category == "B+" then
						Valuation = Valuation + 15
					elseif Category == "A" then
						Valuation = Valuation + 30
					elseif Category == "A+" then
						Valuation = Valuation + 45
					elseif Category == "S" then
						Valuation = Valuation + 60
					elseif Category == "S+" then
						Valuation = Valuation + 75
					end

					if Buffs["Dexterity"][Passport] then
						if Buffs["Dexterity"][Passport] > os.time() then
							Valuation = Valuation + (Valuation * 0.1)
						end
					end

					TriggerClientEvent("inventory:Update",source,"Backpack")
					vRP.GenerateItem(Passport,"dollars",Valuation,true)
					vRP.DirectChest("BeanMachine","100",Valuation * 0.05)
					vRP.PutExperience(Passport,"Delivery",1)
					vDELIVER.Update(source)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESTRUIR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Trash(Slot,Amount)
	local source = source
	local Slot = tostring(Slot)
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] and not Player(source)["state"]["Handcuff"] and not exports["hud"]:Wanted(Passport) and not vRP.InsideVehicle(source) and GetPlayerRoutingBucket(source) < 900000 then
			if Amount <= 0 then Amount = 1 end

			local Inventory = vRP.Inventory(Passport)
			if not Inventory[Slot] or not Inventory[Slot]["item"] then
				return
			end

			local Split = splitString(Inventory[Slot]["item"],"-")
			local Full = Inventory[Slot]["item"]
			local Item = Split[1]

			if vRP.TakeItem(Passport,Full,Amount,true,Slot) then
				Player(source)["state"]["Buttons"] = true
				Player(source)["state"]["Cancel"] = true

				if not vRP.InsideVehicle(source) then
					vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)
					Active[Passport] = os.time() + 100

					SetTimeout(1000,function()
						vRPC.removeObjects(source)
						Active[Passport] = nil
					end)
				end

				TriggerClientEvent("inventory:Update",source,"Backpack")
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false

				-- TriggerEvent("Discord","Inventory","**Passaporte:** "..Passport.."\n**Lixo:** "..Amount.."x "..itemName(Item),13541152)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONAMMOS
-----------------------------------------------------------------------------------------------------------------------------------------
local weaponAmmos = {
	["WEAPON_PISTOL_AMMO"] = {
		"WEAPON_PISTOL",
		"WEAPON_PISTOL_MK2",
		"WEAPON_PISTOL50",
		"WEAPON_REVOLVER",
		"WEAPON_COMBATPISTOL",
		"WEAPON_APPISTOL",
		"WEAPON_HEAVYPISTOL",
		"WEAPON_SNSPISTOL",
		"WEAPON_SNSPISTOL_MK2",
		"WEAPON_VINTAGEPISTOL"
	},
	["WEAPON_NAIL_AMMO"] = {
		"WEAPON_NAILGUN"
	},
	["WEAPON_SMG_AMMO"] = {
		"WEAPON_MICROSMG",
		"WEAPON_MINISMG",
		"WEAPON_SMG",
		"WEAPON_SMG_MK2",
		"WEAPON_GUSENBERG",
		"WEAPON_MACHINEPISTOL"
	},
	["WEAPON_RIFLE_AMMO"] = {
		"WEAPON_FNFAL",
		"WEAPON_PARAFAL",
		"WEAPON_COLTXM177",
		"WEAPON_COMPACTRIFLE",
		"WEAPON_CARBINERIFLE",
		"WEAPON_CARBINERIFLE_MK2",
		"WEAPON_BULLPUPRIFLE",
		"WEAPON_BULLPUPRIFLE_MK2",
		"WEAPON_ADVANCEDRIFLE",
		"WEAPON_ASSAULTRIFLE",
		"WEAPON_ASSAULTSMG",
		"WEAPON_ASSAULTRIFLE_MK2",
		"WEAPON_SPECIALCARBINE",
		-- skins
		"WEAPON_G3HELLFIRE",
		"WEAPON_ONI",
		"WEAPON_G3AGUA",
		
		"WEAPON_SPECIALCARBINE_MK2"
	},
	["WEAPON_SHOTGUN_AMMO"] = {
		"WEAPON_PUMPSHOTGUN",
		"WEAPON_PUMPSHOTGUN_MK2",
		"WEAPON_SAWNOFFSHOTGUN"
	},
	["WEAPON_MUSKET_AMMO"] = {
		"WEAPON_MUSKET"
	},
	["WEAPON_PETROLCAN_AMMO"] = {
		"WEAPON_PETROLCAN"
	}
}

if Config and Config.itensRegister then
	for skinName,data in pairs(Config.itensRegister) do
		if data.class then
			if data.class == 1 then
				if weaponAmmos["WEAPON_RIFLE_AMMO"] then
					table.insert(weaponAmmos["WEAPON_RIFLE_AMMO"],skinName)
				end
			elseif data.class == 2 then
				if weaponAmmos["WEAPON_SMG_AMMO"] then
					table.insert(weaponAmmos["WEAPON_SMG_AMMO"],skinName)
				end
			elseif data.class == 3 then
				if weaponAmmos["WEAPON_PISTOL_AMMO"] then
					table.insert(weaponAmmos["WEAPON_PISTOL_AMMO"],skinName)
				end
			end
		else
			local baseWeapon = data.weapon
			for ammoType,weapons in pairs(weaponAmmos) do
				for _,v in pairs(weapons) do
					if v == baseWeapon then
						table.insert(weaponAmmos[ammoType],skinName)
						break
					end
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMMO
-----------------------------------------------------------------------------------------------------------------------------------------
function itemAmmo(Weapon)
	for ammo,weapons in pairs(weaponAmmos) do
		for _,v in pairs(weapons) do
			if v == Weapon then
				return ammo
			end
		end
	end
	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UseItem(Slot,Amount)
	local source = source
	local Slot = tostring(Slot)
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		if Amount <= 0 then Amount = 1 end

		local Inventory = vRP.Inventory(Passport)
		if not Inventory[Slot] or not Inventory[Slot]["item"] then
			return
		end

		local Split = splitString(Inventory[Slot]["item"],"-")
		local Full = Inventory[Slot]["item"]
		local Item = Split[1]

		if itemDurability(Full) then
			local ts = tonumber(Split[2])
			if ts and vRP.CheckDamaged(Full) then
				TriggerClientEvent("Notify",source,"vermelho","<b>"..itemName(Item).."</b> danificado.",5000)
				return
			end
		end

		if (vCLIENT.checkWater(source) and Item ~= "soap") or (not vCLIENT.checkWater(source) and Item == "soap") then
			return
		end

		if itemType(Full) == "Armamento" and parseInt(Slot) <= 5 then
			if string.find(Full,"-police") and not vRP.HasService(Passport,"Police") then
				TriggerClientEvent("Notify",source,"negado","Item exclusivo da polícia.",5000)
				return
			end
			if vCLIENT.CheckArms(source) then
				TriggerClientEvent("Notify",source,"amarelo","Mão machucada.",5000)
				return
			end

			if vRP.InsideVehicle(source) then
				if not itemVehicle(Full) then
					return
				end
			end

			if vCLIENT.returnWeapon(source) then
				local Check,Ammo,Hash = vCLIENT.storeWeaponHands(source)

				if Check then
					local realHash = Hash
					if Skins[Passport] then
						for base, skin in pairs(Skins[Passport]) do
							if skin == Hash then
								realHash = base
								break
							end
						end
					end

					local wHash = itemAmmo(realHash)
					if wHash then
						if Ammo > 0 then
							if not Ammos[Passport] then
								Ammos[Passport] = {}
							end

							Ammos[Passport][wHash] = Ammo
						else
							if Ammos[Passport] and Ammos[Passport][wHash] then
								Ammos[Passport][wHash] = nil
							end
						end
					end

					TriggerClientEvent("itensNotify",source,{ "guardou",itemIndex(Hash),1,itemName(Hash) })
					exports["inventory"]:CleanWeapons(Passport,false)
				end
			else
				Ammo = 0
				local wHash = itemAmmo(Item)
				if wHash then
					if not Ammos[Passport] then
						Ammos[Passport] = {}
					end

					if not Ammos[Passport][wHash] then
						Ammos[Passport][wHash] = 0
					else
						Ammo = Ammos[Passport][wHash]
					end
				end

				if not Attachs[Passport] then
					Attachs[Passport] = {}
				end

				if not Attachs[Passport][Item] then
					Attachs[Passport][Item] = {}
				end

				local weaponSkin = Item
				if not Skins[Passport] then
					Skins[Passport] = {}
				end

				local checkItem = Item
				if string.find(Item,"wbody|") then
					checkItem = string.gsub(Item,"wbody|","")
				end

				if Skins[Passport][checkItem] then
					weaponSkin = Skins[Passport][checkItem]
				end

				if vCLIENT.putWeaponHands(source,weaponSkin,Ammo,Attachs[Passport][Item]) then
					TriggerClientEvent("itensNotify",source,{ "equipou",itemIndex(Full),1,itemName(Full) })
				end
			end
		elseif itemType(Full) == "Munição" then
			if string.find(Full,"-police") and not vRP.HasService(Passport,"Police") then
				TriggerClientEvent("Notify",source,"negado","Item exclusivo da polícia.",5000)
				return
			end
			local Weapon,Hash,Ammo = vCLIENT.rechargeCheck(source,Item)

			if Weapon then
				if Hash == "WEAPON_PETROLCAN" then
					if (Ammo + Amount) > 4500 then
						Amount = 4500 - Ammo
					end
				else
					if (Ammo + Amount) > 250 then
						Amount = 250 - Ammo
					end
				end

				if Item ~= itemAmmo(Hash) or Amount <= 0 then
					return
				end

				if vRP.TakeItem(Passport,Full,Amount,false,Slot) then
					if not Ammos[Passport] then
						Ammos[Passport] = {}
					end

					Ammos[Passport][Item] = Ammo + Amount

					TriggerClientEvent("itensNotify",source,{ "equipou",itemIndex(Full),Amount,itemName(Full) })
					TriggerClientEvent("inventory:Update",source,"Backpack")
					vCLIENT.rechargeWeapon(source,Hash,Amount)
				end
			end
		elseif itemType(Full) == "Throwing" then
			if vCLIENT.returnWeapon(source) then
				local Check,Ammo,Hash = vCLIENT.storeWeaponHands(source)

				if Check then
					local realHash = Hash
					if Skins[Passport] then
						for base, skin in pairs(Skins[Passport]) do
							if skin == Hash then
								realHash = base
								break
							end
						end
					end

					local wHash = itemAmmo(realHash)
					if wHash then
						if Ammo > 0 then
							if not Ammos[Passport] then
								Ammos[Passport] = {}
							end

							Ammos[Passport][wHash] = Ammo
						else
							if Ammos[Passport] and Ammos[Passport][wHash] then
								Ammos[Passport][wHash] = nil
							end
						end
					end

					TriggerClientEvent("itensNotify",source,{ "guardou",itemIndex(Hash),1,itemName(Hash) })
					exports["inventory"]:CleanWeapons(Passport,false)
				end
			else
				if vCLIENT.putWeaponHands(source,Item,1,nil,Full) then
					TriggerClientEvent("itensNotify",source,{ "equipou",itemIndex(Full),1,itemName(Full) })
				end
			end
		elseif Item == "attachsFlashlight" or Item == "attachsCrosshair" or Item == "ATTACH_MUZZLE_FAT" or Item == "attachsSilencer" or Item == "attachsMagazine" or Item == "attachsGrip" then
			local Weapon = vCLIENT.returnWeapon(source)
			if Weapon then
				if vCLIENT.checkAttachs(source,Item,Weapon) then
					if not Attachs[Passport] then
						Attachs[Passport] = {}
					end

					if not Attachs[Passport][Weapon] then
						Attachs[Passport][Weapon] = {}
					end

					if not Attachs[Passport][Weapon][Item] then
						if vRP.TakeItem(Passport,Full,1,false,Slot) then
							TriggerClientEvent("itensNotify",source,{ "equipou",itemIndex(Full),1,itemName(Full) })
							TriggerClientEvent("inventory:Update",source,"Backpack")
							Attachs[Passport][Weapon][Item] = true
							vCLIENT.putAttachs(source,Item,Weapon)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","O armamento não possui suporte ao componente.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","O armamento já possui o componente equipado.",5000)
				end
			end
		elseif Use[Item] then
			Use[Item](source,Passport,Amount,Slot,Full,Item,Split)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:SAVETEMPORARY
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:saveTemporary",function(Passport)
	exports["inventory"]:CleanWeapons(Passport,false)

	if not Temporary[Passport] and Ammos[Passport] and Attachs[Passport] then
		Temporary[Passport] = {
			["Ammos"] = Ammos[Passport],
			["Attachs"] = Attachs[Passport]
		}

		Attachs[Passport] = {
			["WEAPON_COMBATPISTOL"] = {
				["attachsFlashlight"] = true
			},
			["WEAPON_PISTOL_MK2"] = {
				["attachsFlashlight"] = true,
				["attachsCrosshair"] = true
			}
		}

		Ammos[Passport] = {
			["WEAPON_PISTOL_AMMO"] = 250
		}
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:APPLYTEMPORARY
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:applyTemporary",function(Passport)
	exports["inventory"]:CleanWeapons(Passport,true)

	if Temporary[Passport] and Ammos[Passport] and Attachs[Passport] then
		Attachs[Passport] = Temporary[Passport]["Attachs"]
		Ammos[Passport] = Temporary[Passport]["Ammos"]
		Temporary[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Cancel()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Active[Passport] ~= nil then
			Active[Passport] = nil
			vGARAGE.UpdateHotwired(source,false)
			Player(source)["state"]["Buttons"] = false
			TriggerClientEvent("Progress",source,"Cancelando",1000)

			if verifyObjects[Passport] then
				local Model = verifyObjects[Passport][1]
				local Hash = verifyObjects[Passport][2]

				if Trashs[Model] then
					if Trashs[Model][Hash] then
						Trashs[Model][Hash] = nil
					end
				end

				verifyObjects[Passport] = nil
			end

			if verifyAnimals[Passport] then
				local Model = verifyAnimals[Passport][1]

				if Animals[Model] then
					local netObjects = verifyAnimals[Passport][2]

					if Animals[Model][netObjects] then
						Animals[Model][netObjects] = Animals[Model][netObjects] - 1
						verifyAnimals[Passport] = nil
					end
				end
			end

			if Loots[Passport] then
				local myLoots = Loots[Passport]

				if Boxes[myLoots] then
					if Boxes[myLoots][Passport] then
						Boxes[myLoots][Passport] = nil
					end
				end

				Loots[Passport] = nil
			end
		end

		if Carry[Passport] then
			TriggerClientEvent("player:ropeCarry",Carry[Passport],source)
			TriggerClientEvent("player:Commands",Carry[Passport],false)
			vRPC.removeObjects(Carry[Passport])
			Carry[Passport] = nil
		end

		if Scanners[Passport] then
			TriggerClientEvent("inventory:updateScanner",source,false)
			Player(source)["state"]["Buttons"] = false
			Scanners[Passport] = nil
		end

		vRPC.removeObjects(source)

		if GetPlayerRoutingBucket(source) > 900000 then
			TriggerEvent("arena:Cancel",source,Passport)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkInventory()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Active[Passport] then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFYWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.verifyWeapon(Item,Ammo)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not vRP.ConsultItem(Passport,Item,1) then
		local checkItem = Item
		if string.find(checkItem,"wbody|") then
			checkItem = string.gsub(checkItem,"wbody|","")
		end

		if Config and Config.itensRegister and Config.itensRegister[checkItem] then
			local baseWeapon = Config.itensRegister[checkItem].weapon
			if vRP.ConsultItem(Passport,baseWeapon,1) then
				return true
			end

			if vRP.ConsultItem(Passport,"wbody|"..baseWeapon,1) then
				return true
			end
		end

		local Ammunation = itemAmmo(Item)
		if Ammunation and Ammos[Passport] and Ammos[Passport][Ammunation] then
			if Ammo and Ammo > 0 then
				Ammos[Passport][Ammunation] = Ammo
			end

			if Ammos[Passport][Ammunation] > 0 then
				vRP.GenerateItem(Passport,Ammunation,Ammos[Passport][Ammunation])
				Ammos[Passport][Ammunation] = nil
			end
		end

		if Attachs[Passport] and Attachs[Passport][Item] then
			for Component,_ in pairs(Attachs[Passport][Item]) do
				vRP.GenerateItem(Passport,Component,1)
			end

			Attachs[Passport][Item] = nil
		end

		TriggerClientEvent("inventory:Update",source,"Backpack")
		exports["inventory"]:CleanWeapons(Passport,false)

		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.dropWeapons(Item)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Item ~= "" and Item then
		local Inventory = vRP.Inventory(Passport)

		local function HasBase(keyBase)
			for _,v in pairs(Inventory) do
				if v and v["item"] then
					local key = v["item"]
					if key == keyBase or key == ("wbody|"..keyBase) then
						return true
					end

					local sp = splitString(key,"-")
					if sp[1] == keyBase then
						return true
					end
				end
			end
			return false
		end

		local checkItem = Item
		if string.find(checkItem,"wbody|") then
			checkItem = string.gsub(checkItem,"wbody|","")
		end

		if HasBase(checkItem) then
			return false
		end

		if Config and Config.itensRegister and Config.itensRegister[checkItem] then
			local baseWeapon = Config.itensRegister[checkItem].weapon
			if HasBase(baseWeapon) then
				return false
			end
		end

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETHROWING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.removeThrowing(Item)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Item ~= "" and Item ~= nil then
		vRP.TakeItem(Passport,Item,1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVENTWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.preventWeapon(Item,Ammo)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Ammos[Passport] then
		local checkItem = Item
		if string.find(checkItem,"wbody|") then
			checkItem = string.gsub(checkItem,"wbody|","")
		end

		if Config and Config.itensRegister and Config.itensRegister[checkItem] then
			checkItem = Config.itensRegister[checkItem].weapon
		end

		local Ammunation = itemAmmo(checkItem)

		if Ammunation and Ammos[Passport][Ammunation] then
			if Ammo > 0 then
				Ammos[Passport][Ammunation] = Ammo
			else
				Ammos[Passport][Ammunation] = nil
				exports["inventory"]:CleanWeapons(Passport,false)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFYOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.VerifyObjects(Entity,Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		if Service == "Lixeiro" then
			if not vRPC.LastVehicle(source,"trash") then
				TriggerClientEvent("Notify",source,"amarelo","Precisa utilizar o veículo do <b>Lixeiro</b>.",3000)
				return
			end
		end

		if Entity[1] ~= nil and Entity[2] ~= nil and Entity[4] ~= nil then
			local Hash = Entity[1]
			local Model = Entity[2]
			local Coords = Entity[4]

			if not verifyObjects[Passport] then
				if not Trashs[Model] then
					Trashs[Model] = {}
				end

				for k,v in pairs(Trashs[Model]) do
					if #(v["Coords"] - Coords) <= 0.75 and os.time() <= v["timer"] then
						local Cooldown = parseInt(v["timer"] - os.time())
						TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Cooldown.."</b> segundos.",5000)
						return
					end
				end

				Active[Passport] = os.time() + 5
				TriggerClientEvent("Progress",source,"Vasculhando",5000)
				vRPC.playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)

				verifyObjects[Passport] = { Model,Hash }
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				Trashs[Model][Hash] = { ["Coords"] = Coords, ["timer"] = os.time() + 3600 }

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						local itemSelect = { "",1 }

						if Service == "Lixeiro" then
							local randItem = math.random(90)
							if parseInt(randItem) >= 61 and parseInt(randItem) <= 70 then
								itemSelect = { "aluminum",math.random(2) }
							elseif parseInt(randItem) >= 51 and parseInt(randItem) <= 60 then
								itemSelect = { "copper",math.random(2) }
							elseif parseInt(randItem) >= 41 and parseInt(randItem) <= 50 then
								itemSelect = { "rubber",math.random(2) }
							elseif parseInt(randItem) >= 21 and parseInt(randItem) <= 40 then
								itemSelect = { "plastic",math.random(2) }
							elseif parseInt(randItem) <= 20 then
								itemSelect = { "glass",math.random(2) }
							end
							if itemSelect[1] ~= "" then
								if vRP.HasGroup(Passport,"Painite") then
									itemSelect[2] = math.max(1, math.floor(itemSelect[2] * 1.3))
								elseif vRP.HasGroup(Passport,"Serendibite") then
									itemSelect[2] = math.max(1, math.floor(itemSelect[2] * 1.2))
								end
							end
						end

						if itemSelect[1] == "" then
							TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
						else
							if (vRP.InventoryWeight(Passport) + itemWeight(itemSelect[1]) * itemSelect[2]) <= vRP.GetWeight(Passport) then
								vRP.GenerateItem(Passport,itemSelect[1],itemSelect[2],true)
								vRP.UpgradeStress(Passport,1)
							else
								TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
								Trashs[Model][Hash] = nil
							end
						end

						verifyObjects[Passport] = nil
					end

					Wait(100)
				until not Active[Passport]
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Loot(Entity,Service)
	local source = source
	local Entity = tostring(Entity)
	local Passport = vRP.Passport(source)
	if Passport and LootItens[Service] then
		if not Loots[Passport] and not Active[Passport] then
			if not Boxes[Entity] then
				Boxes[Entity] = {}
			end

			if Boxes[Entity][Passport] then
				if os.time() <= Boxes[Entity][Passport] then
					local Cooldown = parseInt(Boxes[Entity][Passport] - os.time())
					TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Cooldown.."</b> segundos.",5000)
					return
				end
			end

			if Objects[Entity]["perm"] then
				if not vRP.HasService(Passport,Objects[Entity]["perm"]) then
					return
				end
			end

			Loots[Passport] = Entity
			Active[Passport] = os.time() + 5
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Vasculhando",5000)
			Boxes[Entity][Passport] = os.time() + LootItens[Service]["Cooldown"]
			vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.stopAnim(source,false)
					Player(source)["state"]["Buttons"] = false

					local randItem = math.random(#LootItens[Service]["List"])
					local randAmount = math.random(LootItens[Service]["List"][randItem]["min"],LootItens[Service]["List"][randItem]["max"])
					local itemSelect = { LootItens[Service]["List"][randItem]["item"],randAmount }

					if (vRP.InventoryWeight(Passport) + itemWeight(itemSelect[1]) * itemSelect[2]) <= vRP.GetWeight(Passport) then
						vRP.GenerateItem(Passport,itemSelect[1],itemSelect[2],true)
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
						Boxes[Entity][Passport] = nil
					end

					Loots[Passport] = nil
				end

				Wait(100)
			until not Active[Passport]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:APPLYPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:applyPlate")
AddEventHandler("inventory:applyPlate",function(Entity)
	local source = source
	local consultItem = {}
	local Plate = Entity[1]
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		if not Plates[Plate] then
			consultItem = vRP.InventoryItemAmount(Passport,"plate")
			if consultItem[1] <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("plate").."</b>.",5000)
				return
			end
		end

		local consultPliers = vRP.InventoryItemAmount(Passport,"pliers")
		if consultPliers[1] <= 0 then
			TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("pliers").."</b>.",5000)
			return
		end

		if Plates[Plate] ~= nil then
			if os.time() < Plates[Plate][1] then
				local plateTimers = parseInt(Plates[Plate][1] - os.time())
				if plateTimers ~= nil then
					TriggerClientEvent("Notify",source,"azul","Aguarde "..CompleteTimers(plateTimers)..".",5000)
				end

				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("Progress",source,"Trocando",10000)
		vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if not Plates[Plate] then
					if vRP.TakeItem(Passport,consultItem[2],1,true) then
						local newPlate = vRP.GeneratePlate()
						TriggerEvent("plateEveryone",newPlate)
						Plates[newPlate] = { os.time() + 3600,Plate }

						local Network = NetworkGetEntityFromNetworkId(Entity[4])
						if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
							SetVehicleNumberPlateText(Network,newPlate)
						end
					end
				else
					local Network = NetworkGetEntityFromNetworkId(Entity[4])
					if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
						SetVehicleNumberPlateText(Network,Plates[Plate][2])
					end

					if math.random(100) >= 50 then
						vRP.GenerateItem(Passport,"plate",1,true)
					else
						TriggerClientEvent("Notify",source,"azul","Após remove-la a mesma quebrou.",5000)
					end

					TriggerEvent("plateReveryone",Plate)
					Plates[Plate] = nil
				end
			end

			Wait(100)
		until not Active[Passport]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEALTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StealTrunk(Entity)
	local source = source
	local Plate = Entity[1]
	local Network = Entity[4]
	local vehModels = Entity[2]
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		if not vCLIENT.checkWeapon(source,"WEAPON_CROWBAR") then
			TriggerClientEvent("Notify",source,"amarelo","<b>Pé de Cabra</b> não encontrado.",5000)
			return
		end

		if not vRP.PassportPlate(Plate) then
			if not Trunks[Plate] then
				Trunks[Plate] = os.time()
			end

			if os.time() >= Trunks[Plate] then
				vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
				Active[Passport] = os.time() + 100

				if vTASKBAR.stealTrunk(source) then
					Active[Passport] = os.time() + 20
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("Progress",source,"Vasculhando",20000)
					TriggerClientEvent("player:Residuals",source,"Resíduo de Ferro.")
					TriggerClientEvent("player:syncDoorsOptions",source,Network,"open")

					repeat
						if os.time() >= parseInt(Active[Passport]) then
							Active[Passport] = nil
							vRPC.stopAnim(source,false)
							Player(source)["state"]["Buttons"] = false
							TriggerClientEvent("player:syncDoorsOptions",source,Network,"close")

							if os.time() >= Trunks[Plate] then
								local randItens = math.random(#StealItens)
								if math.random(250) <= StealItens[randItens]["rand"] then
									local randAmounts = math.random(StealItens[randItens]["min"],StealItens[randItens]["max"])

									if (vRP.InventoryWeight(Passport) + itemWeight(StealItens[randItens]["item"]) * randAmounts) <= vRP.GetWeight(Passport) then
										vRP.GenerateItem(Passport,StealItens[randItens]["item"],randAmounts,true)
										Trunks[Plate] = os.time() + 3600
										vRP.UpgradeStress(Passport,2)
									else
										TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
									end
								else
									TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
									Trunks[Plate] = os.time() + 3600
								end
							end
						end

						Wait(100)
					until not Active[Passport]
				else
					TriggerClientEvent("inventory:vehicleAlarm",source,Network,Plate)
					vRPC.stopAnim(source,false)
					Active[Passport] = nil

					local Coords = vRP.GetEntityCoords(source)
					local Service = vRP.NumPermission("Police")
					for Passports,Sources in pairs(Service) do
						async(function()
							TriggerClientEvent("NotifyPush",Sources,{ code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehModels).." - "..Plate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
						end)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Veículo protegido pela seguradora.",1000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Animals(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Entity[2] ~= nil and Entity[3] ~= nil then
			local Item = "switchblade"
			local consultItem = vRP.InventoryItemAmount(Passport,Item)
			if consultItem[1] <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Necessário possuir um <b>"..itemName(Item).."</b>.",5000)
				return
			end

			local splitC = splitString(consultItem[2],"-")
			local isDamaged = false
			if itemDurability(consultItem[2]) then
				local ts = tonumber(splitC[2])
				if ts then
					isDamaged = vRP.CheckDamaged(consultItem[2])
				end
			end
			if isDamaged then
				TriggerClientEvent("Notify",source,"vermelho","<b>"..itemName(Item).."</b> danificado.",5000)
				return
			end

			local Model = Entity[2]
			local netObjects = Entity[3]

			if not Animals[Model] then
				Animals[Model] = {}
			end

			if not Animals[Model][netObjects] then
				Animals[Model][netObjects] = 0
			end

			if not verifyAnimals[Passport] and not Active[Passport] and Animals[Model][netObjects] < 5 then
				if (vRP.InventoryWeight(Passport) + itemWeight("meat")) <= vRP.GetWeight(Passport) then
					if vTASKBAR.taskOne(source) then
						Active[Passport] = os.time() + 5
						TriggerClientEvent("Progress",source,"Esfolando",5000)

						if not vCLIENT.animalAnim(source) then
							vRPC.removeObjects(source)
							vRPC.playAnim(source,false,{"amb@medic@standing@kneel@base","base"},true)
							vRPC.playAnim(source,true,{"anim@gangops@facility@servers@bodysearch@","player_search"},true)
						end

						Player(source)["state"]["Buttons"] = true
						TriggerClientEvent("inventory:Close",source)
						verifyAnimals[Passport] = { Model,netObjects }
						Animals[Model][netObjects] = Animals[Model][netObjects] + 1

						repeat
							if os.time() >= parseInt(Active[Passport]) then
								Active[Passport] = nil
								verifyAnimals[Passport] = nil
								Player(source)["state"]["Buttons"] = false

								if Animals[Model] then
									if parseInt(Animals[Model][netObjects]) <= 1 then
										vRP.GenerateItem(Passport,"meat",1,true)
									elseif parseInt(Animals[Model][netObjects]) == 2 then
										vRP.GenerateItem(Passport,"meat",1,true)
									elseif parseInt(Animals[Model][netObjects]) == 3 then
										local randItens = math.random(8)
										vRP.GenerateItem(Passport,"animalfat",randItens,true)
									elseif parseInt(Animals[Model][netObjects]) == 4 then
										local randItens = math.random(4)
										vRP.GenerateItem(Passport,"leather",randItens,true)
									elseif parseInt(Animals[Model][netObjects]) >= 5 then
										vRPC.removeObjects(source)
										local randItens = math.random(2)
										Animals[Model][netObjects] = nil
										TriggerEvent("DeletePed",netObjects)
										vRP.GenerateItem(Passport,"animalpelt",randItens,true)
									end
								end
							end

							Wait(100)
						until not Active[Passport]
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				end
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StoreObjects(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Objects[Number] then
			if (vRP.InventoryWeight(Passport) + itemWeight(Objects[Number]["item"])) <= vRP.GetWeight(Passport) then
				vRP.GiveItem(Passport,Objects[Number]["item"],1,true)
				TriggerClientEvent("objects:Remover",-1,Number)
				Objects[Number] = nil
			else
				TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEPRODUCTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MakeProducts(Table)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		local Split = splitString(Table,"-")
		local Selected = Split[1]

		if Products[Selected] then
			if Selected == "cemitery" then
				if not vTASKBAR.taskOne(source) then
					local Coords = vRP.GetEntityCoords(source)
					local Service = vRP.NumPermission("Police")
					for Passports,Sources in pairs(Service) do
						async(function()
							vRPC.PlaySound(Sources,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
							TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Roubo de Pertences", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
						end)
					end
				end
			end

			local Need = {}
			local Consult = {}
			local Number = math.random(#Products[Selected])

			if Products[Selected][Number]["item"] then
				if vRP.MaxItens(Passport,Products[Selected][Number]["item"],Products[Selected][Number]["itemAmount"]) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					return
				end

				if (vRP.InventoryWeight(Passport) + itemWeight(Products[Selected][Number]["item"]) * Products[Selected][Number]["itemAmount"]) > vRP.GetWeight(Passport) then
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					return
				end
			end

			if Products[Selected][Number]["need"] then
				local needItem = Products[Selected][Number]["need"]

				if type(needItem) == "table" then
					for k,v in pairs(needItem) do
						Consult = vRP.InventoryItemAmount(Passport,v["item"])
						if Consult[1] < v["amount"] then
							TriggerClientEvent("Notify",source,"amarelo","Necessário possuir <b>"..v["amount"].."x "..itemName(v["item"]).."</b>.",5000)
							return
						end

						Need[k] = { Consult[2],v["amount"] }
					end
				else
					needAmount = Products[Selected][Number]["needAmount"]
					Consult = vRP.InventoryItemAmount(Passport,needItem)
					if Consult[1] < needAmount then
						TriggerClientEvent("Notify",source,"amarelo","Necessário possuir <b>"..needAmount.."x "..itemName(needItem).."</b>.",5000)
						return
					end
				end
			end

			Player(source)["state"]["Buttons"] = true
			Active[Passport] = os.time() + Products[Selected][Number]["timer"]
			TriggerClientEvent("Progress",source,"Produzindo",Products[Selected][Number]["timer"] * 1000)

			if Selected == "tablecoke" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "paper" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "tablemeth" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "tableweed" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "burgershot1" or Selected == "pizzathis1" or Selected == "uwucoffee1" or Selected == "beanmachine1" then
				vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			elseif Selected == "burgershot2" or Selected == "pizzathis2" or Selected == "uwucoffee2" or Selected == "beanmachine2" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "burgershot3" or Selected == "pizzathis3" or Selected == "uwucoffee3" or Selected == "beanmachine3" then
				vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			elseif Selected == "milkBottle" then
				vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			elseif Selected == "cemitery" then
				vRPC.playAnim(source,false,{"amb@medic@standing@tendtodead@idle_a","idle_a"},true)
			elseif Selected == "fishfillet" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "marshmallow" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "animalmeat" then
				vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
			elseif Selected == "emptybottle" then
				vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			end

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Player(source)["state"]["Buttons"] = false
					Active[Passport] = nil
					local Points = 0

					if Selected ~= "scanner" then
						vRPC.stopAnim(source,false)
					end

					if Products[Selected][Number]["need"] then
						if type(Products[Selected][Number]["need"]) == "table" then
							for k,v in pairs(Need) do
								local Split = splitString(v[1],"-")
								if Split[1] == "weedleaf" and Split[2] ~= nil then
									Points = Split[2]
								end

								vRP.RemoveItem(Passport,v[1],v[2],false)
							end
						else
							vRP.RemoveItem(Passport,Consult[2],needAmount,false)
						end
					end

					if Products[Selected][Number]["item"] then
						if Selected == "tableweed" then
							vRP.GenerateItem(Passport,Products[Selected][Number]["item"].."-"..Points,Products[Selected][Number]["itemAmount"],true)
						else
							vRP.GenerateItem(Passport,Products[Selected][Number]["item"],Products[Selected][Number]["itemAmount"],true)
						end
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Dismantle(Entity)
	local source = source
	local vehName = Entity[2]
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Desmanchando",10000)
		vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.removeObjects(source)
				Player(source)["state"]["Buttons"] = false
				TriggerEvent("garages:deleteVehicle",Entity[4],Entity[1])
				TriggerClientEvent("player:Residuals",source,"Resíduo de Metal.")
				TriggerClientEvent("player:Residuals",source,"Resíduo de Alumínio.")

				local Class = "B"
				if Dismantle[Passport] then
					Class = ClassCategory(Dismantle[Passport])
				end

				local AmountItens = math.random(100,150)
				local VehSelected = "suspension"
				local VehParts = math.random(4)
				local VehRandom = 1000

				if Class == "B" or Class == "B+" then
					VehRandom = math.random(4500)
					AmountItens = math.random(150,200)
				elseif Class == "A" or Class == "A+" then
					VehRandom = math.random(3500)
					AmountItens = math.random(200,250)
				elseif Class == "S" or Class == "S+" then
					VehRandom = math.random(2500)
					AmountItens = math.random(250,300)
				end

				if VehParts <= 1 then
					VehSelected = "engine"
				elseif VehParts == 2 then
					VehSelected = "transmission"
				elseif VehParts == 3 then
					VehSelected = "brake"
				end

				if VehRandom <= 10 then
					vRP.GenerateItem(Passport,VehSelected.."e",1,true)
				elseif VehRandom >= 10 and VehRandom <= 30 then
					vRP.GenerateItem(Passport,VehSelected.."d",1,true)
				elseif VehRandom >= 31 and VehRandom <= 60 then
					vRP.GenerateItem(Passport,VehSelected.."c",1,true)
				elseif VehRandom >= 61 and VehRandom <= 100 then
					vRP.GenerateItem(Passport,VehSelected.."b",1,true)
				elseif VehRandom >= 101 and VehRandom <= 150 then
					vRP.GenerateItem(Passport,VehSelected.."a",1,true)
				end

				local Members = exports["vrp"]:Party(Passport,source,20)
				if #Members > 1 then
					for _,v in pairs(Members) do
						vRP.GenerateItem(v["Passport"],"dollars",AmountItens * #Members,true)
						vRP.PutExperience(v["Passport"],"Dismantle",2)
					end
				else
					vRP.GenerateItem(Passport,"dollars",AmountItens,true)
					vRP.PutExperience(Passport,"Dismantle",1)
				end

				vRP.GenerateItem(Passport,"dismantle",1,true)

				if math.random(1000) <= 100 then
					vRP.GenerateItem(Passport,"plate",1,true)
				end
			end

			Wait(100)
		until not Active[Passport]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RemoveTyres(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and Entity[2] ~= "veto" and Entity[2] ~= "veto2" then
		if not vCLIENT.checkWeapon(source,"WEAPON_WRENCH") then
			TriggerClientEvent("Notify",source,"amarelo","<b>Chave Inglesa</b> não encontrada.",5000)
			return
		end

		local Vehicle = NetworkGetEntityFromNetworkId(Entity[4])
		if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
			if vCLIENT.tyreHealth(source,Entity[4],Entity[5]) == 1000.0 then
				if vRP.MaxItens(Passport,"tyres",1) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					return
				end

				if vRP.PassportPlate(Entity[1]) then
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)
					vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

					if vTASKBAR.taskTyre(source) then
						Active[Passport] = os.time() + 10
						TriggerClientEvent("Progress",source,"Removendo",10000)

						repeat
							if os.time() >= parseInt(Active[Passport]) then
								Active[Passport] = nil

								local Vehicle = NetworkGetEntityFromNetworkId(Entity[4])
								if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
									if vCLIENT.tyreHealth(source,Entity[4],Entity[5]) == 1000.0 then
										TriggerClientEvent("inventory:explodeTyres",source,Entity[4],Entity[1],Entity[5])
										vRP.GenerateItem(Passport,"tyres",1,true)
									end
								end
							end

							Wait(100)
						until not Active[Passport]
					end

					Player(source)["state"]["Buttons"] = false
					vRPC.removeObjects(source)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DRINK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Drink")
AddEventHandler("inventory:Drink",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.createObjects(source,"amb@world_human_drinking@coffee@male@idle_a","idle_c","prop_plastic_cup_02",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRP.UpgradeThirst(Passport,15)
				vRPC.removeObjects(source,"one")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEALPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StealPeds()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Rand = math.random(#StealPeds)
		local Amount = math.random(StealPeds[Rand]["min"],StealPeds[Rand]["max"])

		if vRP.MaxItens(Passport,StealPeds[Rand]["item"],Amount) then
			TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
			return true
		end

		if (vRP.InventoryWeight(Passport) + itemWeight(StealPeds[Rand]["item"]) * Amount) <= vRP.GetWeight(Passport) then
			vRP.GenerateItem(Passport,StealPeds[Rand]["item"],Amount,true)

			if math.random(100) >= 80 then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				local Service = vRP.NumPermission("Police")
				for Passports,Sources in pairs(Service) do
					async(function()
						vRPC.PlaySound(Sources,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
						TriggerClientEvent("NotifyPush",Sources,{ code = 32, title = "Assalto a mão armada", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Ligação Anônima", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
					end)
				end
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AMOUNTDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AmountDrugs()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		for k,v in pairs(DrugsList) do
			local Amount = math.random(v["Amount"]["Min"],v["Amount"]["Max"])
			local Price = math.random(v["Price"]["Min"],v["Price"]["Max"])

			local Consult = vRP.InventoryItemAmount(Passport,k)
			if Consult[1] >= Amount then
				Drugs[Passport] = { k,Amount,Price * Amount }
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRUGPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DrugPeds()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Drugs[Passport] then
		local Points = 0
		local Percentage = 95
		local Split = splitString(Drugs[Passport][1],"-")
		if Split[2] ~= nil then
			Points = parseInt(Split[2])
		end

		if vRP.TakeItem(Passport,Drugs[Passport][1],Drugs[Passport][2],true) then
			vRP.GenerateItem(Passport,"dollars",Drugs[Passport][3] + (Points * 2),true)
			TriggerClientEvent("player:Residuals",source,"Resíduo Orgânico.")
			Percentage = Percentage - Points

			if Percentage <= 25 then
				Percentage = 25
			end

			if math.random(100) >= Percentage then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				local Service = vRP.NumPermission("Police")
				for Passports,Sources in pairs(Service) do
					async(function()
						vRPC.PlaySound(Sources,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
						TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Venda de Drogas", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Ligação Anônima", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
					end)
				end
			end

			Drugs[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ROLLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:RollVehicle")
AddEventHandler("player:RollVehicle",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 60
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Desvirando",60000)
		vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.removeObjects(source)
				Player(source)["state"]["Buttons"] = false

				local Players = vRPC.Players(source)
				for _,v in pairs(Players) do
					async(function()
						TriggerClientEvent("target:RollVehicle",v,Entity[4])
					end)
				end
			end

			Wait(100)
		until not Active[Passport]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BUFFSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:BuffServer",function(source,Passport,Name,Amount)
	if not Buffs[Name][Passport] then
		Buffs[Name][Passport] = 0
	end

	if os.time() >= Buffs[Name][Passport] then
		Buffs[Name][Passport] = os.time() + Amount
	else
		Buffs[Name][Passport] = Buffs[Name][Passport] + Amount

		if (Buffs[Name][Passport] - os.time()) >= 3600 then
			Buffs[Name][Passport] = os.time() + 3600
		end
	end

	TriggerClientEvent("hud:"..Name,source,Buffs[Name][Passport] - os.time())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Ammos[Passport] and Attachs[Passport] then
		if Temporary[Passport] then
			Ammos[Passport] = Temporary[Passport]["Ammos"]
			Attachs[Passport] = Temporary[Passport]["Attachs"]
			Temporary[Passport] = nil
		end

		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Attachs", dvalue = json.encode(Attachs[Passport]) })
		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Ammos", dvalue = json.encode(Ammos[Passport]) })
		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Skins", dvalue = json.encode(Skins[Passport]) })

		Attachs[Passport] = nil
		Ammos[Passport] = nil
		Skins[Passport] = nil
	end

	if Active[Passport] then
		Active[Passport] = nil
	end

	if verifyObjects[Passport] then
		verifyObjects[Passport] = nil
	end

	if verifyAnimals[Passport] then
		verifyAnimals[Passport] = nil
	end

	if Loots[Passport] then
		Loots[Passport] = nil
	end

	if Healths[Passport] then
		Healths[Passport] = nil
	end

	if Armors[Passport] then
		Armors[Passport] = nil
	end

	if Scanners[Passport] then
		Scanners[Passport] = nil
	end

	if Carry[Passport] then
		TriggerClientEvent("player:Commands",Carry[Passport],false)
		vRPC.removeObjects(Carry[Passport])
		Carry[Passport] = nil
	end

	if Drugs[Passport] then
		Drugs[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	Ammos[Passport] = vRP.UserData(Passport,"Ammos")
	Attachs[Passport] = vRP.UserData(Passport,"Attachs")
	Skins[Passport] = vRP.UserData(Passport,"Skins")

	TriggerClientEvent("objects:Table",source,Objects)
	TriggerClientEvent("drops:Table",source,Drops)

	for Name,_ in pairs(Buffs) do
		if Buffs[Name][Passport] then
			if os.time() < Buffs[Name][Passport] then
				TriggerClientEvent("hud:"..Name,source,Buffs[Name][Passport] - os.time())
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("CleanWeapons",function(Passport,Clean)
	local source = vRP.Source(Passport)
	if source then
		local Ped = GetPlayerPed(source)
		local Weapon = GetSelectedPedWeapon(Ped)

		RemoveWeaponFromPed(Ped,Weapon)
		RemoveAllPedWeapons(Ped,false)
		SetPedAmmo(Ped,Weapon,0)

		if Clean then
			Attachs[Passport] = {}
			Ammos[Passport] = {}
		end
	end
end)
