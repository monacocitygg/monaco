-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("works",cRP)
vCLIENT = Tunnel.getInterface("works")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local works = {
	["Rota1"] = {
		["coords"] = { 19.32,-1599.09,29.28 },
		["upgradeStress"] = 2,
		["routeCollect"] = true,
		["routeDelivery"] = false,
		["usingVehicle"] = false,
		["collectRandom"] = false,
		["collectText"] = "COLETAR",
		["perm"] = "Ballas",
		["collectButtonDistance"] = 1,
		["collectShowDistance"] = 30,
		["collectConsume"] = {
			["min"] = 1,
			["max"] = 2
		},
		["collectCoords"] = {
			{ 264.03,-2504.0,6.44 },
			{ 766.8,-2481.74,20.17 },
			{ 939.42,-2127.42,30.62 },
			{ 1458.88,-1930.6,71.8 },
			{ 1231.64,-1083.07,38.52 },
			{ 1210.62,-448.83,66.84 },
			{ 642.3,260.3,103.29 },
			{ 232.24,365.21,106.04 },
			{ -242.04,279.66,92.03 },
			{ -719.1,256.83,79.9 },
			{ -766.31,-157.88,37.59 },
			{ -655.01,-414.25,35.47 },
			{ -773.41,-633.28,29.82 },
			{ -1004.09,-307.64,38.82 },
			{ -1253.56,-295.91,37.31 },
			{ -1484.26,-390.23,39.09 },
			{ -1388.38,-586.98,30.21 },
			{ -1190.9,-742.94,20.24 },
			{ -818.51,-1107.07,11.17 },
			{ -1191.49,-1340.36,4.94 },
			{ -1271.11,-1200.9,5.36 },
			{ -723.29,-855.27,23.0 },
			{ -582.15,-1000.61,22.33 },
			{ -296.32,-1295.82,31.26 },
			{ -115.84,-1772.65,29.82 },
			{ 222.56,-1842.68,27.11 }
		},
		["deliveryItem"] = "weedleaf"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
	["Mergulhador"] = {
		["coords"] = { 1520.56,3780.08,34.46 },
		["upgradeStress"] = 1,
		["routeCollect"] = false,
		["routeDelivery"] = false,
		["usingVehicle"] = false,
		["collectRandom"] = true,
		["collectText"] = "VASCULHAR",
		["deliveryText"] = "ENTREGAR",
		["collectButtonDistance"] = 1,
		["collectShowDistance"] = 500,
		["collectDuration"] = 12500,
		["collectAnim"] = { false,"amb@prop_human_parking_meter@female@idle_a","idle_a_female",true },
		["collectConsume"] = {
			["min"] = 2,
			["max"] = 3
		},
		["collectCoords"] = {
			{ 1018.69,4095.91,12.7 },
			{ 963.91,4036.36,3.35 },
			{ 960.66,3973.73,1.11 },
			{ 1015.39,3959.19,-3.0 },
			{ 1064.1,3974.58,-12.5 },
			{ 1045.07,4008.94,-12.45 },
			{ 995.48,4048.54,4.52 },
			{ 961.85,4034.99,2.95 },
			{ 907.1,3958.09,-4.3 },
			{ 935.89,3911.83,-9.69 },
			{ 927.22,3836.77,3.79 },
			{ 935.42,3791.86,16.85 },
			{ 975.34,3800.73,16.55 },
			{ 1030.63,3823.97,9.64 },
			{ 1068.02,3863.78,-7.23 },
			{ 1138.51,3991.73,-4.28 },
			{ 1093.69,4050.16,0.86 },
			{ 1045.61,4141.31,21.85 }
		},
		["deliveryItem"] = {
			"key",
			"octopus",
			"shrimp",
			"carp",
			"codfish",
			"catfish",
			"goldenfish",
			"horsefish",
			"tilapia",
			"pacu",
			"pirarucu",
			"tambaqui",
			"bait",
			"emptybottle",
			"plastic",
			"glass",
			"rubber",
			"aluminum",
			"copper",
			"silvercoin",
			"goldcoin"
		}
	},
	["Motorista"] = {
		["coords"] = { 453.05,-607.72,28.59 },
		["upgradeStress"] = 1,
		["routeCollect"] = true,
		["routeDelivery"] = false,
		["collectVehicle"] = -713569950,
		["usingVehicle"] = true,
		["collectRandom"] = false,
		["collectText"] = "PEGAR",
		["deliveryText"] = "ENTREGAR",
		["collectButtonDistance"] = 15,
		["collectShowDistance"] = 100,
		["collectConsume"] = {
			["min"] = 40,
			["max"] = 45
		},
		["collectCoords"] = {
			{ 418.92,-571.03,28.68 },
			{ 923.78,186.7,75.81 },
			{ 1644.11,1166.89,84.26 },
			{ 2104.23,2630.44,51.76 },
			{ 2402.38,2918.04,49.31 },
			{ 1786.57,3356.21,40.51 },
			{ 1620.82,3813.85,34.94 },
			{ 1911.6,3793.09,32.31 },
			{ 2493.37,4088.69,38.04 },
			{ 2068.51,4693.82,41.19 },
			{ 1676.39,4822.41,42.02 },
			{ 2250.19,4986.36,42.23 },
			{ 1667.97,6397.56,30.12 },
			{ 235.51,6574.7,31.57 },
			{ -85.11,6584.3,29.47 },
			{ -137.53,6440.85,31.42 },
			{ -235.39,6304.34,31.39 },
			{ -422.67,6031.56,31.34 },
			{ -756.66,5515.02,35.49 },
			{ -1538.42,4976.01,62.28 },
			{ -2246.9,4283.26,46.68 },
			{ -2731.13,2292.23,19.05 },
			{ -3233.06,1009.3,12.18 },
			{ -3002.44,416.76,14.97 },
			{ -1960.25,-504.23,11.82 },
			{ -1371.7,-982.24,8.43 },
			{ -1166.92,-1471.31,4.34 },
			{ -1052.56,-1511.78,5.09 },
			{ -900.75,-1206.71,4.94 },
			{ -628.94,-924.13,23.28 },
			{ -557.24,-845.49,27.61 },
			{ -1059.11,-2066.85,13.2 },
			{ -543.79,-2194.84,6.01 },
			{ -60.68,-1806.51,27.21 },
			{ 228.64,-1837.9,26.73 },
			{ 291.46,-2002.07,20.31 },
			{ 739.81,-2233.34,29.24 },
			{ 1045.03,-2384.93,30.28 },
			{ 1200.9,-685.64,60.6 },
			{ 954.37,-146.43,74.45 },
			{ 566.42,218.64,102.54 },
			{ -429.1,252.36,83.02 },
			{ -732.3,3.21,37.88 },
			{ -1244.38,-302.64,37.32 },
			{ -1403.93,-566.3,30.22 },
			{ -1202.05,-876.7,13.28 },
			{ -691.37,-961.63,19.79 },
			{ -387.71,-851.57,31.5 },
			{ 149.9,-1028.06,29.25 },
			{ 120.26,-1356.98,29.19 },
			{ 118.29,-785.88,31.3 },
			{ 98.34,-628.98,31.57 }
		},
		["deliveryItem"] = "dollars"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local collectAmount = {}
local paymentAmount = {}
local deliveryAmount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLLECTCONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.collectConsume(serviceName)
	local source = source
	local Passport = vRP.Passport(source)
	local License = vRP.Identities(source)
	local Account = vRP.Account(License)
	if Passport then
		if works[serviceName]["collectRandom"] then
			local amountItem = 0
			local selectItem = ""

			local randomItem = math.random(#works[serviceName]["deliveryItem"])
			selectItem = works[serviceName]["deliveryItem"][randomItem]
			amountItem = math.random(works[serviceName]["collectConsume"]["min"],works[serviceName]["collectConsume"]["max"])

			if (vRP.InventoryWeight(Passport) + (itemWeight(selectItem) * parseInt(amountItem))) <= vRP.GetWeight(Passport) then			
				vRP.GenerateItem(Passport,selectItem,amountItem,true)

				if works[serviceName]["upgradeStress"] > 0 then
					vRP.UpgradeStress(Passport,works[serviceName]["upgradeStress"])
				end

				return true
			else
				TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
			end
		else
			local deliveryItem = works[serviceName]["deliveryItem"]
			collectAmount[Passport] = math.random(works[serviceName]["collectConsume"]["min"],works[serviceName]["collectConsume"]["max"])

			if (vRP.InventoryWeight(Passport) + (itemWeight(deliveryItem) * parseInt(collectAmount[Passport]))) <= vRP.GetWeight(Passport) then	
				vRP.GenerateItem(Passport,deliveryItem,collectAmount[Passport],true)

				if deliveryItem == "dollars" then
					if vRP.LicensePremium(License) then
						vRP.GenerateItem(Passport,deliveryItem,collectAmount[Passport] * 0.10,true)
					end
				end

				if works[serviceName]["upgradeStress"] > 0 then
					vRP.UpgradeStress(Passport,works[serviceName]["upgradeStress"])
				end

				collectAmount[Passport] = nil

				return true
			else
				TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVERYCONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.deliveryConsume(serviceName)
	local source = source
	local Passport = vRP.Passport(source)
	local License = vRP.Identities(source)
	local Account = vRP.Account(License)
	if Passport then
		local deliveryItem = works[serviceName]["deliveryPayment"]["item"]
		deliveryAmount[Passport] = math.random(works[serviceName]["deliveryConsume"]["min"],works[serviceName]["deliveryConsume"]["max"])
		paymentAmount[Passport] = math.random(works[serviceName]["deliveryPayment"]["min"],works[serviceName]["deliveryPayment"]["max"])

		if (vRP.InventoryWeight(Passport) + (itemWeight(deliveryItem) * parseInt(paymentAmount[Passport]))) <= vRP.GetWeight(Passport) then		
			if vRP.tryGetInventoryItem(Passport,works[serviceName]["deliveryItem"],deliveryAmount[Passport]) then
				local paymentPrice = parseInt(paymentAmount[Passport] * deliveryAmount[Passport])

				vRP.GenerateItem(Passport,deliveryItem,paymentPrice,true)

				if deliveryItem == "dollars" then
					if vRP.LicensePremium(License) then
						vRP.GenerateItem(Passport,deliveryItem,paymentPrice * 0.10,true)
					end
				end

				deliveryAmount[Passport] = nil
				paymentAmount[Passport] = nil

				if works[serviceName]["upgradeStress"] > 0 then
					vRP.UpgradeStress(Passport,works[serviceName]["upgradeStress"])
				end

				return true
			else
				TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>"..parseFormat(deliveryAmount[Passport]).."x "..itemName(works[serviceName]["deliveryItem"]).."</b> para entregar.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission(serviceName)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if works[serviceName]["perm"] == nil then
			return true
		end

		if vRP.HasGroup(Passport,works[serviceName]["perm"]) then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	vCLIENT.updateworks(source,works)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENSURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ensureworks",function(source,args,rawCommand)
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("Notify",source,"amarelo","Script Recarregado",3000)
		if vRP.HasGroup(Passport,"Admin") then
			vCLIENT.updateworks(-1,works)
			vCLIENT.updateworks(source,works)
		end
	end
end)