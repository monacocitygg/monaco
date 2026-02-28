-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

vRP.Prepare("skins/GetBoxes", "SELECT boxes FROM skins WHERE identifier = @identifier")
vRP.Prepare("skins/SetBoxes", "UPDATE skins SET boxes = @boxes WHERE identifier = @identifier")
vRP.Prepare("skins/GetSkins", "SELECT skins FROM skins WHERE identifier = @identifier")
vRP.Prepare("skins/SetSkins", "UPDATE skins SET skins = @skins WHERE identifier = @identifier")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("pause",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local PendingRewards = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCAROUSEL
-----------------------------------------------------------------------------------------------------------------------------------------
local function getCarousel()
	local Carousel = {}
	local Counter = 0
	for Number,v in pairs(ShopItens) do
		if (#Carousel + 1) > 3 then break end

		if v["Discount"] ~= 0 then
			Carousel[#Carousel + 1] = {
				["id"] = Counter,
				["Index"] = Number,
				["Image"] = itemIndex(Number),
				["Name"] = itemName(Number),
				["Amount"] = 1,
				["Price"] = v["Price"],
				["Discount"] = v["Price"] * (1 - (v["Discount"] / 100))
			}

			Counter += 1
		end
	end
    
	return Carousel
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPPING
-----------------------------------------------------------------------------------------------------------------------------------------
local function getShopping()
	local Shopping = {}
	for Number,v in pairs(ShopItens) do
		if (#Shopping + 1) > 5 then break end

		Shopping[#Shopping + 1] = {
			["Image"] = itemIndex(Number),
			["Name"] = itemName(Number),
			["Index"] = Number,
			["Amount"] = 1,
			["Price"] = v["Price"],
			["Discount"] = v["Discount"]
		}
	end

	return Shopping
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Home()
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    if Identity then
        -- Experience Calculation Removed

        local Identities = vRP.Identities(source)
        local Account = vRP.Account(Identities)
		local Sanguine = bloodTypes or "Sem Informação"
		local VIP = {}
		local VIPString = table.concat(VIP, " , ")

		if vRP.HasGroup(Passport, "Premium") then
    		table.insert(VIP, "Platina")
		end
		if vRP.HasGroup(Passport, "PremiumOuro") then
    		table.insert(VIP, "Ouro")
		end
		if vRP.HasGroup(Passport, "PremiumPrata") then
    		table.insert(VIP, "Prata")
		end
		if #VIP == 0 then
    		VIP = {"Sem Vip Ativos"}
		end

        local Home = {
            ["Information"] = {
                ["Passport"] = Passport,
                ["Name"] = Identity["name"].." "..Identity["name2"],
                ["Bank"] = vRP.GetBank(source),
                ["Sex"] = Identity["sex"],
                ["Blood"] = VIP,
                ["Phone"] = Identity["phone"] or "Chip não identificado",
                ["Diamonds"] = Account["gems"] or 0,
                ["Medic"] = " "
            },

            ["Premium"] = PremiumRenew,
            ["Carousel"] = getCarousel(),
            ["Shopping"] = getShopping()
        }
        return Home
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMRENEW
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PremiumRenew()
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local Premium = MinimalTimers(Identity["premium"] - os.time())
    if Passport then
        if not vRP.UserPremium(Passport) then
            if vRP.Request(source,"Adiquirir premium para você por <b>$"..PremiumRenew["Value"].."</b> diamantes?") then
                if vRP.PaymentGems(Passport,PremiumRenew["Value"]) then
                    vRP.SetPremium(source)
                    vRP.SetPermission(Passport,"Premium")
                    TriggerClientEvent("Notify",source,"verde","Premium ativo",10000)
                end
            end
        else
            if vRP.Request(source,"Você ainda possui <b>"..Premium.."</b> de premium ativo, deseja renovar mesmo assim?") then
                if vRP.HasPermission(Passport,"Premium") and vRP.PaymentGems(Passport,PremiumRenew["Value"]) then
                    vRP.UpgradePremium(source)
                    TriggerClientEvent("Notify",source,"verde","Premium renovado",10000)
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAMONDSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DiamondsList()
	local DiamondsList = {}

	for Number,v in pairs(ShopItens) do
		DiamondsList[#DiamondsList + 1] = {
			["Index"] = Number,
			["Description"] = itemDescription(Number),
			["Image"] = itemIndex(Number),
			["Name"] = itemName(Number),
			["Price"] = v["Price"],
			["Discount"] = v["Discount"]
		}
	end
    
	return DiamondsList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAMONDSBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DiamondsBuy(Item, Amount)
	local source = source
	local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local Name = Identity and (Identity["name"].." "..Identity["name2"]) or "Indefinido"

	if ShopItens[Item] then
		local Price = ShopItens[Item]["Price"] * ((100 - ShopItens[Item]["Discount"]) / 100)
		if vRP.PaymentGems(Passport, Amount * Price) then
			vRP.GenerateItem(Passport, Item, Amount, true)
			TriggerEvent("Discord","LojaVipitems","**[Compra de item]**\n\n**Source:** "..source.."\n**Passaporte:** "..(Passport or "N/A").." - ".. Name .."\n**Comprou:** "..Amount.."x "..(itemName(Item) or "Item").."\n**Por:** "..ShopItens[Item]["Price"] * Amount.." Gemas" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
            
			return "Compra realizada com sucesso."
		else
			return "Gemas insuficientes."
		end
	end
    
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENLOOTBOX
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OpenLootbox(Key)
	local source = source
	local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    local Name = Identity and (Identity["name"].." "..Identity["name2"]) or "Indefinido"

	local BoxConfig = Config.LootboxConfig[Key]
	
	if BoxConfig then
		local Price = BoxConfig.price
		if vRP.PaymentGems(Passport, Price) then
			
            local Query = vRP.Query("skins/GetBoxes", { identifier = Passport })
            local CurrentBoxes = {}
            
            if Query and Query[1] and Query[1].boxes then
                CurrentBoxes = json.decode(Query[1].boxes)
                if type(CurrentBoxes) ~= "table" then CurrentBoxes = {} end
            end
            
            table.insert(CurrentBoxes, Key)
            
            vRP.Query("skins/SetBoxes", { identifier = Passport, boxes = json.encode(CurrentBoxes) })

			TriggerEvent("Discord","LojaVipCompraCaixa","**[Compra de Lootbox]**\n\n**Passaporte:** "..(Passport or "N/A").." - ".. Name .."\n**Comprou:** "..(BoxConfig.name or "Caixa").." \n**Por:** "..Price.." Gemas" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
            
			return "Você comprou uma <b>"..BoxConfig.name.."</b>."
		else
			return "<b>"..itemName("gemstone").."s</b> insuficiente."
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMYBOXES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetMyBoxes()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Query = vRP.Query("skins/GetBoxes", { identifier = Passport })
        local myBoxes = {}
        
        if Query and Query[1] and Query[1].boxes then
            local dbBoxes = json.decode(Query[1].boxes)
            if type(dbBoxes) ~= "table" then dbBoxes = {} end
            
            -- Count the boxes
            local boxCounts = {}
            for _, boxKey in pairs(dbBoxes) do
                if not boxCounts[boxKey] then boxCounts[boxKey] = 0 end
                boxCounts[boxKey] = boxCounts[boxKey] + 1
            end

            -- Create the list for frontend
            for boxKey, count in pairs(boxCounts) do
                local boxConfig = Config.LootboxConfig[boxKey]
                if boxConfig then
                    table.insert(myBoxes, {
                        key = boxKey,
                        name = boxConfig.name,
                        image = boxConfig.image,
                        description = boxConfig.description,
                        amount = count,
                        items = boxConfig.items
                    })
                end
            end
        end
        return myBoxes
    end
    return {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMYBOX
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OpenMyBox(Key)
    local source = source
    local Passport = vRP.Passport(source)
    
    if not Passport then return false end
    
    local Identity = vRP.Identity(Passport)
    local Name = Identity and (Identity["name"].." "..Identity["name2"]) or "Indefinido"

    local Query = vRP.Query("skins/GetBoxes", { identifier = Passport })
    if not Query or not Query[1] or not Query[1].boxes then return false end
    
    local dbBoxes = json.decode(Query[1].boxes)
    if type(dbBoxes) ~= "table" then dbBoxes = {} end
    local boxIndex = -1
    
    -- Find and remove the box
    for i, boxKey in pairs(dbBoxes) do
        if boxKey == Key then
            boxIndex = i
            break
        end
    end
    
    if boxIndex == -1 then return { error = "Caixa não encontrada." } end
    
    table.remove(dbBoxes, boxIndex)
    vRP.Query("skins/SetBoxes", { identifier = Passport, boxes = json.encode(dbBoxes) })
    
    -- Select Reward
    local BoxConfig = Config.LootboxConfig[Key]
    if not BoxConfig then return { error = "Configuração da caixa inválida." } end
    
    local totalChance = 0
    for _, item in pairs(BoxConfig.items) do
        totalChance = totalChance + item.chance
    end
    
    local randomVal = math.random(1, totalChance)
    local currentChance = 0
    local winner = nil
    
    for _, item in pairs(BoxConfig.items) do
        currentChance = currentChance + item.chance
        if randomVal <= currentChance then
            winner = item
            break
        end
    end
    
    if winner then
        -- Try to find friendly name in Config.itensRegister
        if Config.itensRegister and Config.itensRegister[winner.item] then
            winner.name = Config.itensRegister[winner.item].name
        end

        -- Add to Skins Database
        local SkinQuery = vRP.Query("skins/GetSkins", { identifier = Passport })
        local currentSkins = {}
        if SkinQuery and SkinQuery[1] and SkinQuery[1].skins then
            currentSkins = json.decode(SkinQuery[1].skins)
            if type(currentSkins) ~= "table" then currentSkins = {} end
        end

        local hasSkin = false
        for _, s in pairs(currentSkins) do
            if s == winner.item then
                hasSkin = true
                break
            end
        end

        if not hasSkin then
            table.insert(currentSkins, winner.item)
            vRP.Query("skins/SetSkins", { identifier = Passport, skins = json.encode(currentSkins) })
        end

        -- Give Item
        vRP.GenerateItem(Passport, winner.item, 1, true)
        
        -- Log Discord
        TriggerEvent("Discord","LojaVipboxes","**[Abriu Lootbox]**\n\n**Passaporte:** "..(Passport or "N/A").." - ".. Name .."\n**Caixa:** ".. (BoxConfig.name or Key) .."\n**Ganhou:** ".. (winner.name or winner.item or "Item") .."\n**Raridade:** "..(winner.type or "Comum").."\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)

        return {
            success = true,
            winner = winner
        }
    else
        return { error = "Erro ao gerar recompensa." }
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTLOOTBOX
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PaymentLootbox()
	return "Ok"
end

-- Battle Pass Logic Removed
-----------------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- RESCUE
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- function Creative.RolepassRescue(Type,Index)
--     local source = source
--     local Passport = vRP.Passport(source)
--     if Passport then
--         local Item = RoleItens[Type][parseInt(Index)]["Item"]
--         local Amount = RoleItens[Type][parseInt(Index)]["Amount"]
--         if (vRP.InventoryWeight(Passport) + itemWeight(Item) * Amount) <= vRP.GetWeight(Passport) then
--             TriggerClientEvent("sounds:source",source,"finish",0.1)
--             Rolepass[Passport][Type] = parseInt(Index)
--             Rolepass[Passport]["Points"] = not Rolepass[Passport]["Points"] and 0 or Rolepass[Passport]["Points"] - 500            
--             vRP.GenerateItem(Passport,Item,Amount,false) 
--             TriggerEvent("Discord","**[Item resgatado]**\n\nReedemItemRolepass","**Passaporte:** "..Passport.."\n**Item:** "..Amount.."x "..itemName(Item) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
--             return true
--         end
--     end
-- end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- BUY
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- function Creative.RolepassBuy()
--     local source = source
--     local Passport = vRP.Passport(source)
--     if Passport then
--         if vRP.PaymentGems(Passport,800) then
--             local now = os.time()
--             local date = os.date("*t", now)
--             local Rolepass = GetRolepass(Passport)
--             Rolepass["RolepassBuy"] = true
--             vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Rolepass", dvalue = json.encode(Rolepass) })
--             TriggerEvent("Discord","BuyRolepass","**[Compra de Rolepass]**\n\n**Passaporte:** "..Passport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
--             return true
--         end
--     end
-- end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- XP
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- function Creative.ReceberXP()
--     local source = source
--     local Passport = vRP.Passport(source)
--     if Passport then
-- 		TriggerEvent("pause:AddPoints", Passport, 100)
--         TriggerClientEvent("Notify", source, "azul", "Recebeu um <b>10XP</b> no nosso BattlePass", 5000)
--     end
-- end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Disconnect()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.kick(source, "Você se desconectou.")
	end
end