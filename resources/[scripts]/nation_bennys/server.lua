local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

API = {}
Tunnel.bindInterface("nation_bennys",API)

local using_bennys = {}

local orders = {}

local function n(v)
    local nv = tonumber(v)
    if nv == nil then return nil end
    return nv
end

local function b(v)
    if v == true then return true end
    if v == false then return false end
    local nv = tonumber(v)
    return nv ~= nil and nv > 0
end

local function rgb3(t)
    if type(t) ~= "table" then return nil end
    local r = n(t[1] or t["1"])
    local g = n(t[2] or t["2"])
    local b_ = n(t[3] or t["3"])
    if r == nil or g == nil or b_ == nil then return nil end
    return { r, g, b_ }
end

local function toGaragesCustomize(vehicle_mods)
    if type(vehicle_mods) == "string" then
        vehicle_mods = json.decode(vehicle_mods)
    end
    if type(vehicle_mods) ~= "table" then return nil end

    local customize = {}
    customize["wheeltype"] = n(vehicle_mods["wheeltype"])
    customize["plateIndex"] = n(vehicle_mods["plateindex"])
    customize["xenonColor"] = n(vehicle_mods["xenoncolor"])
    customize["colors"] = {
        n(vehicle_mods["color"] and (vehicle_mods["color"][1] or vehicle_mods["color"]["1"])) or 0,
        n(vehicle_mods["color"] and (vehicle_mods["color"][2] or vehicle_mods["color"]["2"])) or 0
    }
    customize["extracolors"] = {
        n(vehicle_mods["extracolor"] and (vehicle_mods["extracolor"][1] or vehicle_mods["extracolor"]["1"])) or 0,
        n(vehicle_mods["extracolor"] and (vehicle_mods["extracolor"][2] or vehicle_mods["extracolor"]["2"])) or 0
    }
    customize["lights"] = rgb3(vehicle_mods["neoncolor"]) or { 0, 0, 0 }
    customize["smokecolor"] = rgb3(vehicle_mods["smokecolor"]) or { 0, 0, 0 }
    customize["customPcolor"] = rgb3(vehicle_mods["customPcolor"])
    customize["customScolor"] = rgb3(vehicle_mods["customScolor"])

    local neonKit = vehicle_mods["neon"] == true
    customize["neon"] = { ["0"] = neonKit, ["1"] = neonKit, ["2"] = neonKit, ["3"] = neonKit }

    customize["mods"] = {}
    customize["var"] = {}
    if type(vehicle_mods["mods"]) == "table" then
        for i = 0, 48 do
            local entry = vehicle_mods["mods"][i] or vehicle_mods["mods"][tostring(i)]
            local value = entry
            local variation = nil

            if type(entry) == "table" then
                value = entry["mod"]
                variation = entry["variation"]
            end

            if i >= 17 and i <= 22 then
                customize["mods"][tostring(i)] = b(value)
            else
                local iv = n(value)
                if iv ~= nil then
                    customize["mods"][tostring(i)] = iv
                end
                if (i == 23 or i == 24) and variation ~= nil then
                    customize["var"][tostring(i)] = b(variation)
                end
            end
        end
    end

    return customize
end

function API.checkPermission()
	local source = source
	local user_id = vRP.Passport(source)
    local isMechanic = vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Mechanic")
	return true, isMechanic
end

function API.createOrder(mods, price, vehicleNetId, name, plate)
    local source = source
    local user_id = vRP.Passport(source)
    local identity = vRP.Identity(user_id)
    local playerName = "Cliente"
    if identity then playerName = identity.name .. " " .. identity.firstname end
    
    local orderId = tostring(os.time()) .. math.random(100, 999)
    orders[orderId] = {
        id = orderId,
        user_id = user_id,
        name = playerName,
        vehicleName = name,
        plate = plate,
        price = price,
        mods = mods,
        status = "pending"
    }
    TriggerClientEvent("Notify", source, "sucesso", "Ordem enviada para a mecânica!", 5000)
    return true
end

function API.getOrders()
    local source = source
    local user_id = vRP.Passport(source)
    if vRP.hasPermission(user_id, "Mechanic") or vRP.hasPermission(user_id, "Admin") then
        return orders
    end
    return {}
end

function API.applyOrder(orderId, vehicleNetId)
    local source = source
    local user_id = vRP.Passport(source)
    
    if not (vRP.hasPermission(user_id, "Mechanic") or vRP.hasPermission(user_id, "Admin")) then
        return false, "Sem permissão"
    end

    local order = orders[orderId]
    if not order then return false, "Ordem não encontrada" end

    if vRP.tryFullPayment(order.user_id, order.price) then
        TriggerEvent("nation:syncApplyMods", order.mods, vehicleNetId)
        vRP.Query("playerdata/SetData",{ Passport = order.user_id, dkey = "custom:"..order.vehicleName, dvalue = json.encode(order.mods) })
        local garageCustomize = toGaragesCustomize(order.mods)
        if garageCustomize then
            vRP.Query("entitydata/SetData",{ dkey = "Mods:"..order.user_id..":"..order.vehicleName, dvalue = json.encode(garageCustomize) })
        end
        orders[orderId] = nil
        return true, "Ordem aplicada com sucesso"
    else
        return false, "Cliente sem dinheiro"
    end
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
        local garageCustomize = toGaragesCustomize(vehicle_mods)
        if garageCustomize then
            vRP.Query("entitydata/SetData",{ dkey = "Mods:"..user_id..":"..NameCar, dvalue = json.encode(garageCustomize) })
        end
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
