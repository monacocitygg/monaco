-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("catcafe_totem",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK AVAILABILITY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkAvailability(index)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local shop = Config.Locations[index]
        if not shop then return false end

        local service = vRP.NumPermission(shop.groupCheck)
        -- Count how many are online
        local count = 0
        for k,v in pairs(service) do
            count = count + 1
        end

        if count == 0 then
            return true
        else
            TriggerClientEvent("Notify",source,"vermelho","Existem funcionários em serviço.",5000)
            return false
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.buyItems(cart)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local totalPrice = 0
        for _, itemData in ipairs(cart) do
            totalPrice = totalPrice + (itemData.price * itemData.amount)
        end

        if vRP.PaymentFull(Passport,totalPrice) then
            for _, itemData in ipairs(cart) do
                vRP.GiveItem(Passport,itemData.item,itemData.amount,true)
            end
            TriggerClientEvent("Notify",source,"verde","Compra realizada com sucesso.",5000)
            return true
        else
            TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
            return false
        end
    end
    return false
end
