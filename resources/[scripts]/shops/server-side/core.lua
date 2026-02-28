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
Tunnel.bindInterface("shops",Creative)
vCLIENT = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local shops = {
	["BurgerShot"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["bread"] = 5,
			["cheese"] = 10,
			["hamburger2"] = 125,
			["onionrings"] = 70,
			["coffeemilk"] = 70,
			["sandwich"] = 15,
			["tacos"] = 25,
			["chandon"] = 15,
			["dewars"] = 15,
			["hennessy"] = 15,
			["absolut"] = 15,
			["guarananatural"] = 75,
			["orangejuice"] = 100,
			["tangejuice"] = 100,
			["grapejuice"] = 100,
			["strawberryjuice"] = 100,
			["bananajuice"] = 100,
			["acerolajuice"] = 100,
			["passionjuice"] = 100,
			["pizzamozzarella"] = 125,
			["pizzamushroom"] = 125,
			["pizzabanana"] = 125,
			["pizzachocolate"] = 125,
			["calzone"] = 125,
			["mushroomtea"] = 300,
			["chickenfries"] = 100,
			["mushroom"] = 10
		}
	},
	["PizzaThis"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "PizzaThis",
		["List"] = {
			["bread"] = 5,
			["cheese"] = 10,
			["pizzamozzarella"] = 125,
			["pizzamushroom"] = 125,
			["pizzabanana"] = 125,
			["pizzachocolate"] = 125,
			["calzone"] = 125,
			["mushroomtea"] = 300,
			["chickenfries"] = 100,
			["mushroom"] = 10
		}
	},
	["UwuCoffee"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "UwuCoffee",
		["List"] = {
			["bread"] = 5,
			["nigirizushi"] = 50,
			["sushi"] = 50,
			["cupcake"] = 50,
			["applelove"] = 50,
			["milkshake"] = 100,
			["cappuccino"] = 125,
			["cookies"] = 35,
			["mushroom"] = 10
		}
	},
	["BeanMachine"] = {
		["perm"] = "BeanMachine",
		["Type"] = "Cash",
		["List"] = {
			["coffeemilk"] = 70,
			["sandwich"] = 15,
			["tacos"] = 25,
			["chandon"] = 15,
			["dewars"] = 15,
			["hennessy"] = 15,
			["absolut"] = 15
		}
	},
	["Identity"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["identity"] = 5000
		}
	},
	["Identity2"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["fidentity"] = 10000
		}
	},
	["Weeds"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["silk"] = 5
		}
	},
	["Departament"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["postit"] = 20,
			["sandwich"] = 30, 
			["cola"] = 30, 
			["rope"] = 650,
			["notepad"] = 10, 
			["hamburger"] = 200,
			["emptybottle"] = 30,
			["orangejuice"] = 100,
			["backpack"] = 1500,
			["rose"] = 25,
			["lighter"] = 200,
			["energetic"] = 200,
			["firecracker"] = 100,
			["teddy"] = 75
		}
	},
	["Sugar"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["sugar"] = 5,
			["cupcake"] = 300,
			["milkshake"] = 500,
			["applelove"] = 300
		}
	},
	["Verdinha"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["vape"] = 1250,
			["cigarette"] = 10,
			["lighter"] = 100
		}
	},
	["Digital"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["cellphone"] = 675,
			["radio"] = 650,
			["scanner"] = 3250
		}
	}, 
	
	["Mecanica"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["tyres"] = 225,
			["toolbox"] = 600,
			["advtoolbox"] = 8000,
			["WEAPON_WRENCH"] = 1000
		}
	},
	
   ["ilegal"] = {
	["mode"] = "Buy",
	["type"] = "CashSujo",
	["List"] = {
			["lockpick"] = 1200,
 			["c4"] = 2000,
 			["hood"] = 7000,
 			["cocaine"] = 300,
 			["credential"] = 1000,
 			["blocksignal"] = 7000,
 			["pager"] = 5000,
			["handcuff"] = 10000,
 			["card01"] = 10000,
 			["card03"] = 20000,
 			["card05"] = 50000
		}
	},

	["Harmony2"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["tyres"] = 300,
			["toolbox"] = 625,
			["advtoolbox"] = 1525,
			["notebook"] = 20000,
			["WEAPON_CROWBAR"] = 725,
			["WEAPON_WRENCH"] = 725
		}
	},
	["Harmony"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["tyres"] = 300,
			["toolbox"] = 625,
			["advtoolbox"] = 1525,
			["notebook"] = 20000,
			["WEAPON_CROWBAR"] = 725,
			["WEAPON_WRENCH"] = 725
		}
	},
	["Fuel"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["WEAPON_PETROLCAN"] = 250
		}
	},
	["Weapons"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["pistolbody"] = 425,
			["smgbody"] = 525,
			["riflebody"] = 625
		}
	},
	["Farmacia"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["medkit"] = 575,
			["bandage"] = 225,
			["gauze"] = 100,
			["analgesic"] = 125
		}
	},
	["Paramedic"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Paramedic",
		["List"] = {
			["badge02"] = 10,
			["syringe"] = 2,
			["bandage"] = 225,
			["gauze"] = 100,
			["gdtkit"] = 20,
			["medkit"] = 575,
			["sinkalmy"] = 375,
			["analgesic"] = 125,
			["ritmoneury"] = 475,
			["wheelchair"] = 2750,
			["defibrillator"] = 325,
			["medicbag"] = 425,
			["medicbed"] = 725
		}
	},
	["Ammunation"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["GADGET_PARACHUTE"] = 475,
			["WEAPON_HATCHET"] = 975,
			["WEAPON_BAT"] = 975,
			["WEAPON_BATTLEAXE"] = 975,
			["WEAPON_GOLFCLUB"] = 975,
			["WEAPON_HAMMER"] = 975,
			["WEAPON_MACHETE"] = 975,
			["WEAPON_POOLCUE"] = 975,
			["WEAPON_STONE_HATCHET"] = 975,
			["WEAPON_KNUCKLE"] = 975,
			["WEAPON_KARAMBIT"] = 975,
			["WEAPON_KATANA"] = 975,
			["WEAPON_FLASHLIGHT"] = 975,
			["pickaxe"] = 525,
			["repairkit01"] = 525,
			["repairkit02"] = 3225
		}
	},
	-- ["Premium"] = {
	-- 	["mode"] = "Buy",
	-- 	["type"] = "Premium",
	-- 	["List"] = {
	-- 		["gemstone"] = 1,
	-- 		["premium"] = 30,
	-- 		["rolepass"] = 50,
	-- 		["creator"] = 25,
	-- 		["premiumplate"] = 30,
	-- 		["newchars"] = 15,
	-- 		["namechange"] = 20
	-- 	}
	-- },
	["Hunting"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["meat"] = 16,
			["animalpelt"] = 25,
			["tomato"] = 10,
			["banana"] = 10,
			["guarana"] = 10,
			["acerola"] = 10,
			["passion"] = 10,
			["grape"] = 10,
			["tange"] = 10,
			["orange"] = 10,
			["apple"] = 10,
			["strawberry"] = 10,
			["coffee2"] = 10,
			["animalfat"] = 10,
			["leather"] = 20
		}
	},
	["Fishing"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["octopus"] = 14,
			["shrimp"] = 14,
			["carp"] = 12,
			["horsefish"] = 12,
			["tilapia"] = 14,
			["codfish"] = 16,
			["catfish"] = 16,
			["goldenfish"] = 30,
			["pirarucu"] = 26,
			["pacu"] = 24,
			["tambaqui"] = 28
		}
	},
	["Hunting2"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["switchblade"] = 525,
			["WEAPON_MUSKET"] = 3250,
			["WEAPON_MUSKET_AMMO"] = 7
		}
	},
	["Fishing2"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["bait"] = 5,
			["scuba"] = 975,
			["fishingrod"] = 725
		}
	},
	["Recycle"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["notepad"] = 5,
			["plastic"] = 10,
			["glass"] = 10,
			["rubber"] = 10,
			["aluminum"] = 15,
			["copper"] = 15,
			["radio"] = 485,
			["rope"] = 435,
			["cellphone"] = 325,
			["binoculars"] = 135,
			["emptybottle"] = 15,
			["switchblade"] = 215,
			["camera"] = 135,
			["vape"] = 2375,
			["rose"] = 15,
			["lighter"] = 75,
			["teddy"] = 35,
			["tyres"] = 100,
			["bait"] = 2,
			["firecracker"] = 50,
			["fishingrod"] = 365,
			["scuba"] = 485,
			["silvercoin"] = 10,
			["goldcoin"] = 20,
			["techtrash"] = 60,
			["tarp"] = 20,
			["sheetmetal"] = 20,
			["roadsigns"] = 20,
			["explosives"] = 30,
			["codeine"] = 15,
			["amphetamine"] = 20,
			["acetone"] = 15,
			["cotton"] = 20,
			["plaster"] = 15,
			["sulfuric"] = 12,
			["saline"] = 20,
			["alcohol"] = 15
		}
	},
	["Miners"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["emerald"] = 85,
			["diamond"] = 75,
			["ruby"] = 55,
			["sapphire"] = 45,
			["amethyst"] = 35,
			["amber"] = 25,
			["turquoise"] = 15
		}
	},
	["coffeeMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["coffee"] = 20
		}
	},
	["sodaMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["donutMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["donut"] = 15,
			["chocolate"] = 15
		}
	},
	["burgerMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hamburger"] = 25
		}
	},
	["hotdogMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hotdog"] = 15
		}
	},
	["Chihuahua"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["hotdog"] = 15,
			["hamburger"] = 25,
			["coffee"] = 20,
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["waterMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["List"] = {
			["water"] = 30
		}
	},
	["Police"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Police",
		["List"] = {
			["vest"] = 1,
			["radio"] = 1,
			["gsrkit"] = 1,
			["gdtkit"] = 1,
			["barrier"] = 1,
			["handcuff"] = 1,
			["WEAPON_SMG"] = 1,
			-- ["WEAPON_PUMPSHOTGUN"] = 111,
			-- ["WEAPON_CARBINERIFLE"] = 1,
			-- ["WEAPON_CARBINERIFLE_MK2"] = 1,
			-- ["WEAPON_STUNGUN"] = 111,
			-- ["WEAPON_PARAFAL"] = 111,	
			-- ["WEAPON_FNFAL"] = 111,
			["WEAPON_COMBATPISTOL"] = 1,
			["WEAPON_HEAVYPISTOL"] = 1,
			["WEAPON_NIGHTSTICK"] = 1,
			["WEAPON_PISTOL_AMMO"] = 1,
			["WEAPON_SMG_AMMO"] = 1,
			["WEAPON_RIFLE_AMMO"] = 1,
			--["WEAPON_SHOTGUN_AMMO"] = 5,
			["badge11"] = 1,
			["WEAPON_SMOKEGRENADE"] = 1,
			["energetic"] = 1
			-- ["megaphone"] = 100
		}
	},
	["Criminal"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["keyboard"] = 75,
			["mouse"] = 75,
			["playstation"] = 75,
			["xbox"] = 75,
			["dish"] = 75,
			["pan"] = 100,
			["fan"] = 75,
			["blender"] = 75,
			["switch"] = 45,
			["cup"] = 100,
			["lampshade"] = 75
		}
	},
	["Criminal2"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["watch"] = 75,
			["bracelet"] = 75,
			["dildo"] = 75,
			["spray01"] = 75,
			["spray02"] = 75,
			["spray03"] = 75,
			["spray04"] = 75,
			["slipper"] = 75,
			["rimel"] = 75,
			["brush"] = 75,
			["soap"] = 75
		}
	},
	["Criminal3"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["eraser"] = 75,
			["legos"] = 75,
			["ominitrix"] = 75,
			["dices"] = 45,
			["domino"] = 45,
			["floppy"] = 45,
			["horseshoe"] = 75,
			["deck"] = 75
		}
	},
	["Criminal4"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["List"] = {
			["goldbar"] = 1000,
			["pliers"] = 55,
			["pager"] = 125,
			["card01"] = 325,
			["card02"] = 325,
			["card03"] = 375,
			["card04"] = 275,
			["card05"] = 425,
			["pendrive"] = 325
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NAMES
-----------------------------------------------------------------------------------------------------------------------------------------
local nameMale = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio" }
local nameFemale = { "Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local userName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.requestPerm(Type)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		print("[shops] requestPerm",Type,Passport)
		-- Bloqueio de procurado (se HUD estiver disponível); sempre liberar para "ilegal".
		if Type ~= "ilegal" then
			if exports and exports["hud"] and exports["hud"].Wanted then
				if exports["hud"]:Wanted(Passport,source) then
					print("[shops] requestPerm blocked by Wanted",Type,Passport)
					return false
				end
			end
		end

		if not shops[Type] then
			print("[shops] requestPerm type not found",Type)
			return false
		end

		if shops[Type]["perm"] ~= nil then
			if not vRP.HasService(Passport,shops[Type]["perm"]) then
				print("[shops] requestPerm missing service",Type,shops[Type]["perm"])
				return false
			end
		end

		print("[shops] requestPerm allowed",Type,Passport)
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.requestShop(name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		print("[shops] requestShop",name,Passport)
		local shopSlots = 20
		local inventoryShop = {}
		for k,v in pairs(shops[name]["List"]) do
			inventoryShop[#inventoryShop + 1] = { key = k, price = parseInt(v), name = itemName(k), index = itemIndex(k), peso = itemWeight(k), economy = parseFormat(itemEconomy(k)), max = itemMaxAmount(k), desc = itemDescription(k) }
		end

		local inventoryUser = {}
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

			inventoryUser[k] = v
		end

		if parseInt(#inventoryShop) > 20 then
			shopSlots = parseInt(#inventoryShop)
		end

		return inventoryShop,inventoryUser,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),shopSlots,vRP.HasGroup(Passport,"Bolso")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.getShopType(Type)
	local mode = "Buy"
	if shops[Type] and shops[Type]["mode"] then
		mode = shops[Type]["mode"]
	end
	print("[shops] getShopType",Type,mode)
	return mode
end---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.functionShops(Type,Item,Amount,Slot)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if (tostring(Slot) == "4" or tostring(Slot) == "5") and not vRP.HasGroup(Passport,"Bolso") then
			TriggerClientEvent("Notify",source,"negado","Você não possui Bolso.",5000)
			vCLIENT.updateShops(source,"requestShop")
			return
		end

		if shops[Type] then
			if Amount <= 0 then Amount = 1 end

			local inventory = vRP.Inventory(Passport)
			if (inventory[tostring(Slot)] and inventory[tostring(Slot)]["item"] == Item) or not inventory[tostring(Slot)] then
				if shops[Type]["mode"] == "Buy" then
					if vRP.MaxItens(Passport,Item,Amount) then
						TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
						vCLIENT.updateShops(source,"requestShop")
						return
					end

					if (vRP.InventoryWeight(Passport) + itemWeight(Item) * Amount) <= vRP.GetWeight(Passport) then
						if shops[Type]["type"] == "Cash" then
							if shops[Type]["List"][Item] then
								if vRP.PaymentFull(Passport,shops[Type]["List"][Item] * Amount) then
									if Item == "identity" or string.sub(Item,1,5) == "badge" then
										vRP.GiveItem(Passport,Item.."-"..Passport,Amount,false,Slot)
									elseif Item == "fidentity" then
										local Identity = vRP.Identity(Passport)
										if Identity then
											if Identity["sex"] == "M" then
												vRP.Query("fidentity/NewIdentity",{ name = nameMale[math.random(#nameMale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											else
												vRP.Query("fidentity/NewIdentity",{ name = nameFemale[math.random(#nameFemale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											end

											local Identity = vRP.Identity(Passport)
											local consult = vRP.Query("fidentity/GetIdentity")
											if consult[1] then
												vRP.GiveItem(Passport,Item.."-"..consult[1]["id"],Amount,false,Slot)
											end
										end
									else
										if Type == "Police" and (itemType(Item) == "Armamento" or itemType(Item) == "Munição") then
											vRP.GiveItem(Passport,Item.."-police",Amount,false,Slot)
										else
											vRP.GenerateItem(Passport,Item,Amount,false,Slot)
										end

										if Item == "WEAPON_PETROLCAN" then
											vRP.GenerateItem(Passport,"WEAPON_PETROLCAN_AMMO",4500,false)
										end
									end

									TriggerClientEvent("sounds:Private",source,"cash",0.1)
									local Identity = vRP.Identity(Passport)
									local buyer = Identity and (Identity["name"].." "..Identity["name2"].." ("..Passport..")") or ("Passaporte "..Passport)
									local total = parseInt(shops[Type]["List"][Item] * Amount)
									TriggerEvent("Discord","LojasGeraiscomprou",""..buyer.." comprou "..Amount.."x "..itemName(Item).." por R$ "..total.." | Loja: "..Type.." | Pagamento: Dinheiro limpo",3066993)
								else
									TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
								end
							end
						elseif shops[Type]["type"] == "CashSujo" then
							if shops[Type]["List"][Item] then
								local price = shops[Type]["List"][Item] * Amount
								if vRP.TakeItem(Passport,"dollars2",parseInt(price)) then
									if Item == "identity" or string.sub(Item,1,5) == "badge" then
										vRP.GiveItem(Passport,Item.."-"..Passport,Amount,false,Slot)
									elseif Item == "fidentity" then
										local Identity = vRP.Identity(Passport)
										if Identity then
											if Identity["sex"] == "M" then
												vRP.Query("fidentity/NewIdentity",{ name = nameMale[math.random(#nameMale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											else
												vRP.Query("fidentity/NewIdentity",{ name = nameFemale[math.random(#nameFemale)], name2 = userName2[math.random(#userName2)], blood = math.random(4) })
											end

											local Identity = vRP.Identity(Passport)
											local consult = vRP.Query("fidentity/GetIdentity")
											if consult[1] then
												vRP.GiveItem(Passport,Item.."-"..consult[1]["id"],Amount,false,Slot)
											end
										end
									else
										if Type == "Police" and (itemType(Item) == "Armamento" or itemType(Item) == "Munição") then
											vRP.GiveItem(Passport,Item.."-police",Amount,false,Slot)
										else
											vRP.GenerateItem(Passport,Item,Amount,false,Slot)
										end

										if Item == "WEAPON_PETROLCAN" then
											vRP.GenerateItem(Passport,"WEAPON_PETROLCAN_AMMO",4500,false)
										end
									end

									TriggerClientEvent("sounds:Private",source,"cash",0.1)
									local Identity = vRP.Identity(Passport)
									local buyer = Identity and (Identity["name"].." "..Identity["name2"].." ("..Passport..")") or ("Passaporte "..Passport)
									local total = parseInt(price)
									TriggerEvent("Discord","LojasGeraiscomprou",""..buyer.." comprou "..Amount.."x "..itemName(Item).." por R$ "..total.." | Loja: "..Type.." | Pagamento: Dinheiro sujo",15158332)
								else
									TriggerClientEvent("Notify",source,"vermelho","<b>Dólares sujos</b> insuficientes.",5000)
								end
							end
						elseif shops[Type]["type"] == "Consume" then
							if vRP.TakeItem(Passport,shops[Type]["item"],parseInt(shops[Type]["List"][Item] * Amount)) then
								vRP.GenerateItem(Passport,Item,Amount,false,Slot)
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>"..itemName(shops[Type]["item"]).."</b> insuficiente.",5000)
							end
						elseif shops[Type]["type"] == "Premium" then
							if vRP.PaymentGems(Passport,shops[Type]["List"][Item] * Amount) then
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
								vRP.GenerateItem(Passport,Item,Amount,false,Slot)
								TriggerClientEvent("Notify",source,"verde","Comprou <b>"..Amount.."x "..itemName(Item).."</b> por <b>"..shops[Type]["List"][Item] * Amount.." Gemas</b>.",5000)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					end
				elseif shops[Type]["mode"] == "Sell" then
					local splitName = splitString(Item,"-")

					if shops[Type]["List"][splitName[1]] then
						local itemPrice = shops[Type]["List"][splitName[1]]

						if itemPrice > 0 then
							local splitD = splitString(Item,"-")
							local isDamaged = false
							if itemDurability(Item) then
								local ts = tonumber(splitD[2])
								if ts then
									isDamaged = vRP.CheckDamaged(Item)
								end
							end
							if isDamaged then
								TriggerClientEvent("Notify",source,"vermelho","Itens danificados não podem ser vendidos.",5000)
								vCLIENT.updateShops(source,"requestShop")
								return
							end
						end

						if shops[Type]["type"] == "Cash" then
							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								if itemPrice > 0 then
									vRP.GenerateItem(Passport,"dollars",parseInt(itemPrice * Amount),false)
									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						elseif shops[Type]["type"] == "Consume" then
							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								if itemPrice > 0 then
									vRP.GenerateItem(Passport,shops[Type]["item"],parseInt(itemPrice * Amount),false)
									TriggerClientEvent("sounds:Private",source,"cash",0.1)
								end
							end
						end
					end
				end
			end
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("shops:populateSlot")
AddEventHandler("shops:populateSlot",function(Item,Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if (tostring(Target) == "4" or tostring(Target) == "5") and not vRP.HasGroup(Passport,"Bolso") then
			TriggerClientEvent("Notify",source,"negado","Você não possui Bolso.",5000)
			vCLIENT.updateShops(source,"requestShop")
			return
		end

		if Amount <= 0 then Amount = 1 end

		if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
			vRP.GiveItem(Passport,Item,Amount,false,Target)
			vCLIENT.updateShops(source,"requestShop")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("shops:updateSlot")
AddEventHandler("shops:updateSlot",function(Item,Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport then
		if (tostring(Target) == "4" or tostring(Target) == "5") and not vRP.HasGroup(Passport,"Bolso") then
			TriggerClientEvent("Notify",source,"negado","Você não possui Bolso.",5000)
			vCLIENT.updateShops(source,"requestShop")
			return
		end

		if Amount <= 0 then Amount = 1 end

		local inventory = vRP.Inventory(Passport)
		if inventory[tostring(Slot)] and inventory[tostring(Target)] and inventory[tostring(Slot)]["item"] == inventory[tostring(Target)]["item"] then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GiveItem(Passport,Item,Amount,false,Target)
			end
		else
			vRP.SwapSlot(Passport,Slot,Target)
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end)
