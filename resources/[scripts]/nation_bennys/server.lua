local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

API = {}
Tunnel.bindInterface("nation_bennys",API)

local using_bennys = {}

function API.checkPermission()
	local source = source
	local user_id = vRP.Passport(source)
	return vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Mechanic")
end

function API.getSavedMods(NameCar, Plate)
    local vehinfo = vRP.PassportPlate(Plate)
    if vehinfo then 
        local user_id = vehinfo["Passport"]
        if user_id then
            local custom = vRP.Query("playerdata/GetData",{ Passport = user_id, dkey = "custom:"..NameCar })[1]

            if custom then
                return custom["dvalue"]
            end
        end
    end

    return nil
end

function API.checkPayment(amount)
    if not tonumber(amount) then
        return false
    end

    local source = source
    local user_id = vRP.Passport(source)
    if not vRP.tryFullPayment(user_id, tonumber(amount)) then
        TriggerClientEvent("Notify",source,"vermelho","Você não possui dinheiro suficiente.",5000)
        return false
    end
    TriggerClientEvent("Notify",source,"verde","Modificações aplicadas com <b>sucesso</b><br>Você pagou <b>$"..tonumber(amount).." dólares<b>.",5000)
    return true
end

function API.repairVehicle(vehicle, damage)

    TriggerEvent("tryreparar", vehicle)
    return true
end

function API.removeVehicle(vehicle)
    using_bennys[vehicle] = nil
    return true
end

function API.checkVehicle(vehicle)
    if using_bennys[vehicle] then
        return false
    end
    using_bennys[vehicle] = true
    return true
end

function API.saveVehicle(NameCar, Plate, vehicle_mods)
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        vRP.Query("playerdata/SetData",{ Passport = user_id, dkey = "custom:"..NameCar, dvalue = json.encode(vehicle_mods) })
    end

    return true
end


RegisterServerEvent("nation:syncApplyMods")
AddEventHandler("nation:syncApplyMods",function(vehicle_tuning,vehicle)
    TriggerClientEvent("nation:applymods_sync",-1,vehicle_tuning,vehicle)
end)

RegisterCommand('bennys',function(source,args,rawCommand)
    local user_id = vRP.Passport(source)
    if vRP.hasPermission(user_id,"Admin") then
        TriggerClientEvent('actionmenu',source)
    end
end)

-- [[!-!]] vcux3MfIy8qDzcrMz8rKycbPzsvKzcnIyM7M [[!-!]] --