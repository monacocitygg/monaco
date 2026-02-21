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
Tunnel.bindInterface("crafting",Creative)
vCLIENT = Tunnel.getInterface("crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkPermission(craftType)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Crafting[craftType] then
			if Crafting[craftType]["Permission"] then
				if vRP.HasService(Passport,Crafting[craftType]["Permission"]) then
					return true
				end
			else
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.requestCrafting(craftType)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local inventoryUser = {}
		local inventory = vRP.Inventory(Passport)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k
			inventoryUser[k] = v
		end

		local recipes = {}
		if Crafting[craftType] and Crafting[craftType]["List"] then
			for k,v in pairs(Crafting[craftType]["List"]) do
				local requiredList = {}
				for reqItem, reqAmount in pairs(v["Required"]) do
					table.insert(requiredList, {
						key = reqItem,
						amount = reqAmount,
						name = itemName(reqItem),
						index = itemIndex(reqItem)
					})
				end

				table.insert(recipes, {
					key = k,
					name = itemName(k),
					index = itemIndex(k),
					desc = itemDescription(k),
					amount = v["Amount"],
					time = v["Time"],
					required = requiredList
				})
			end
		end

		return inventoryUser, recipes, vRP.InventoryWeight(Passport), vRP.GetWeight(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.functionCraft(craftType, item, amount)
	local source = source
	local amount = parseInt(amount)
	local Passport = vRP.Passport(source)
	
	if Passport and amount > 0 then
		if Crafting[craftType] and Crafting[craftType]["List"][item] then
			local recipe = Crafting[craftType]["List"][item]
			
			if (vRP.InventoryWeight(Passport) + itemWeight(item) * amount) > vRP.GetWeight(Passport) then
				TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				return false
			end

			-- Check Ingredients first
			for reqItem, reqAmount in pairs(recipe["Required"]) do
				local totalRequired = reqAmount * amount
				if reqItem ~= "dollars" then
					if vRP.ItemAmount(Passport, reqItem) < totalRequired then
						TriggerClientEvent("Notify",source,"vermelho","<b>"..itemName(reqItem).."</b> insuficiente.",5000)
						return false
					end
				end
			end

			-- Process Payment/Take Items
			local canCraft = true
			if recipe["Required"]["dollars"] then
				local totalDollars = recipe["Required"]["dollars"] * amount
				if not vRP.PaymentFull(Passport, totalDollars) then
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
					canCraft = false
				end
			end

			if canCraft then
				for reqItem, reqAmount in pairs(recipe["Required"]) do
					if reqItem ~= "dollars" then
						vRP.TakeItem(Passport, reqItem, reqAmount * amount)
					end
				end

				TriggerClientEvent("crafting:progress", source, recipe["Time"] * amount)
				
				SetTimeout(recipe["Time"] * amount * 1000, function()
					vRP.GenerateItem(Passport, item, amount * recipe["Amount"], true)
					TriggerClientEvent("crafting:updateCrafting", source)
				end)
			end
		end
	end
end
