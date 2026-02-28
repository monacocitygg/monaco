getCoins = {}
getCoins2 = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveBank(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount > 0 then
        vRP.Query("characters/addBank",{ Passport = Passport, amount = Amount })
        exports["bank"]:AddTransactions(Passport,"entry",Amount)

        local Source = vRP.Source(Passport)
        if Source then
            TriggerClientEvent("NotifyItens",Source,{ "+","dollars",parseFormat(Amount),"Dólares" })
        end

        if Characters[Source] then
            Characters[Source]["bank"] = Characters[Source]["bank"] + Amount
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveBank(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount > 0 then
        vRP.Query("characters/remBank",{ Passport = Passport, amount = Amount })
        exports["bank"]:AddTransactions(Passport,"exit",Amount)

        local Source = vRP.Source(Passport)
        if Source then
            TriggerClientEvent("NotifyItens",Source,{ "+","dollars",parseFormat(Amount),"Dólares" })
        end

        if Characters[Source] then
            Characters[Source]["bank"] = Characters[Source]["bank"] - Amount
            if 0 > Characters[Source]["bank"] then
                Characters[Source]["bank"] = 0
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetBank(source)
    if Characters[source] then
        return Characters[source]["bank"]
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetFine(source)
    if Characters[source] then
        return Characters[source]["fines"]
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveFine(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount > 0 then
        vRP.Query("characters/addFines",{ id = Passport, fines = Amount })
        if Characters[Source] then
            Characters[Source]["fines"] = Characters[Source]["fines"] + Amount
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveFine(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount > 0 then
        vRP.Query("characters/removeFines",{ id = Passport, fines = Amount })
        if Characters[Source] then
            Characters[Source]["fines"] = Characters[Source]["fines"] - Amount
            if 0 > Characters[Source]["fines"] then
                Characters[Source]["fines"] = 0
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentGems(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount > 0 and Characters[Source] and Amount <= vRP.UserGemstone(Characters[Source]["license"]) then
        vRP.Query("accounts/RemoveGems", { license = Characters[Source]["license"], gems = Amount })
        TriggerClientEvent("hud:RemoveGems", Source, Amount)
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentBank(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount > 0 and Characters[Source] and Amount <= Characters[Source]["bank"] then
        vRP.RemoveBank(Passport,Amount,(Source))
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentMoney(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		if vRP.ConsultItem(Passport,"dollars",Amount) then
            vRP.TakeItem(Passport,"dollars",Amount,true)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTDIRTY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentDirty(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		if vRP.ConsultItem(Passport,"dollarsroll",Amount) then
            vRP.TakeItem(Passport,"dollarsroll",Amount,true)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentFull(Passport,Amount)
    if parseInt(Amount) > 0 then
        if vRP.PaymentMoney(Passport,Amount) or vRP.PaymentBank(Passport,Amount) then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWCASH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.WithdrawCash(Passport,Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount > 0 and Characters[Source] and Amount <= Characters[Source]["bank"] then
        vRP.GenerateItem(Passport, "dollars", Amount, true)
        vRP.RemoveBank(Passport, Amount, (Source))
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "vrp" == Resource then
        Wait(3000)
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetBank(Passport, Amount)
    local Amount = parseInt(Amount)
    local Source = vRP.Source(Passport)
    if Amount >= 0 then
        vRP.Query("characters/setBank", { Passport = Passport, amount = Amount })
        if CreativeBank then
            exports.bank:AddTransactions(Passport, "entry", Amount)
        end
        if Characters[Source] then
            Characters[Source].bank = Amount
        end
    end
end


function vRP.SetBankCell(Passaporte, amount)
    vRP.Query("characters/setBank", { Passport = Passaporte, amount = amount })
    local source = vRP.Source(Passaporte)
    if Characters[source] then
        Characters[source].bank = amount
    end
        
end
function vRP.GetBankCell(Passaporte)
    local source = vRP.Source(Passaporte)
    if Characters[source] then
        return Characters[source]["bank"]
    else
        return vRP.Identity(Passaporte).bank
    end
    return 0
end

function vRP.getCoins(userId)
    local identity = vRP.Identity(userId)
	-- if getCoins[userId] == nil then
		local rows = vRP.Query("leste-box/getCoins",{ license = identity['license'] })
		if #rows > 0 then
			-- getCoins[parseInt(userId)] = rows[1].coins
			return rows[1].coins
		end
        return 0
	-- else
	-- 	return getCoins[parseInt(userId)]
	-- end
end

function vRP.setCoins(userId,value)
    local identity = vRP.Identity(userId)
	if userId then
		-- getCoins[parseInt(userId)] = value
		vRP.Query("leste-box/updateCoins",{ license = identity['license'], coins = value })
		local source = vRP.Source(userId)
		if(source~=nil)then
			TriggerClientEvent("Addcoins",source,value)
		end
	end
end

function vRP.tryPaymentCoins(userId,amount)
    local identity = vRP.Identity(userId)
	if amount >= 0 then
		local money = vRP.getCoins(userId) or 0
		if amount >= 0 and money >= amount then
			vRP.setCoins(userId,money-amount)
			return true
		else
			return false
		end
	end
	return false
end

function vRP.giveCoins(user_id,amount)
	if amount >= 0 then
		local money = vRP.getCoins(user_id) or 0
		vRP.setCoins(user_id,money+amount)
	end
end

-- coins2 (PREMIUMCOIN)
function vRP.getPremiumCoins(userId)
    local identity = vRP.Identity(userId)
	-- if getCoins2[userId] == nil then
		local rows = vRP.Query("leste-box/getCoins",{ license = identity['license'] })
		if #rows > 0 then
			-- getCoins2[parseInt(userId)] = rows[1].coins2
			return rows[1].coins2
		end
        return 0
	-- else
	-- 	return getCoins2[parseInt(userId)]
	-- end
end

function vRP.setPremiumCoins(userId,value)
    local identity = vRP.Identity(userId)
	if userId then
		-- getCoins2[parseInt(userId)] = value
        vRP.Query("leste-box/updateCoinsGold", { license = identity['license'], coins2 = value })
	end
end

function vRP.tryPaymentPremiumCoins(userId,amount)
	if amount >= 0 then
		local money = vRP.getPremiumCoins(userId) or 0
		if amount >= 0 and money >= amount then
			vRP.setPremiumCoins(userId,money-amount)
			return true
		else
			return false
		end
	end
	return false
end

function vRP.givePremiumCoins(userId,amount)
	if amount >= 0 then
		local money = vRP.getPremiumCoins(userId) or 0
		vRP.setPremiumCoins(userId,money+amount)
	end
end