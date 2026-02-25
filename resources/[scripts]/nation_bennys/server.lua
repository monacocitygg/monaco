local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

API = {}
Tunnel.bindInterface("nation_bennys",API)

local using_bennys = {}

local orders = {}
local migratedGarageMods = {}
local DEBUG_BENNYS = true

-- PREPARE QUERIES
vRP.Prepare("nation_bennys/create_orders_table",[[
    CREATE TABLE IF NOT EXISTS bennys_orders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        order_id VARCHAR(50),
        user_id INT,
        vehicle_name VARCHAR(50),
        plate VARCHAR(50),
        price INT,
        mods LONGTEXT,
        name VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
]])

vRP.Prepare("nation_bennys/add_order","INSERT INTO bennys_orders(order_id,user_id,vehicle_name,plate,price,mods,name) VALUES(@order_id,@user_id,@vehicle_name,@plate,@price,@mods,@name)")
vRP.Prepare("nation_bennys/get_orders","SELECT * FROM bennys_orders")
vRP.Prepare("nation_bennys/get_order","SELECT * FROM bennys_orders WHERE order_id = @order_id")
vRP.Prepare("nation_bennys/delete_order","DELETE FROM bennys_orders WHERE order_id = @order_id")

CreateThread(function()
    vRP.Query("nation_bennys/create_orders_table")
end)

local function dbg(msg)
	if DEBUG_BENNYS then
		print("[nation_bennys] "..tostring(msg))
	end
end

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
    return { ["1"] = r, ["2"] = g, ["3"] = b_ }
end

local function toGaragesCustomize(vehicle_mods)
    if type(vehicle_mods) == "string" then
        vehicle_mods = json.decode(vehicle_mods)
    end
    if type(vehicle_mods) ~= "table" then return nil end

    if type(vehicle_mods["mods"]) == "table" and type(vehicle_mods["colors"]) == "table" and type(vehicle_mods["extracolors"]) == "table" then
        local customize = vehicle_mods
        customize["wheeltype"] = n(customize["wheeltype"])
        customize["plateIndex"] = n(customize["plateIndex"])
        customize["xenonColor"] = n(customize["xenonColor"])

        local c1 = n(customize["colors"][1] or customize["colors"]["1"]) or 0
        local c2 = n(customize["colors"][2] or customize["colors"]["2"]) or 0
        customize["colors"] = { c1, c2 }

        local e1 = n(customize["extracolors"][1] or customize["extracolors"]["1"]) or 0
        local e2 = n(customize["extracolors"][2] or customize["extracolors"]["2"]) or 0
        customize["extracolors"] = { e1, e2 }

        customize["lights"] = rgb3(customize["lights"]) or { 0, 0, 0 }
        customize["smokecolor"] = rgb3(customize["smokecolor"]) or { 0, 0, 0 }
        if customize["customPcolor"] then customize["customPcolor"] = rgb3(customize["customPcolor"]) end
        if customize["customScolor"] then customize["customScolor"] = rgb3(customize["customScolor"]) end

        if type(customize["neon"]) == "table" then
            for i = 0,3 do
                customize["neon"][tostring(i)] = b(customize["neon"][tostring(i)])
            end
        else
            customize["neon"] = { ["0"] = false, ["1"] = false, ["2"] = false, ["3"] = false }
        end

        customize["var"] = customize["var"] or {}
        for i = 0,48 do
            local key = tostring(i)
            local entry = customize["mods"][key]
            if type(entry) == "table" then entry = entry["mod"] end
            if i >= 17 and i <= 22 then
                customize["mods"][key] = b(entry)
            else
                local iv = n(entry)
                if iv ~= nil then
                    customize["mods"][key] = iv
                else
                    customize["mods"][key] = nil
                end
            end
        end
        for i = 23,24 do
            local key = tostring(i)
            customize["var"][key] = b(customize["var"][key])
        end

        return customize
    end

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
    customize["tint"] = n(vehicle_mods["tint"])

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

function API.migrateGarageMods()
    local source = source
    local user_id = vRP.Passport(source)
    if not user_id then return 0 end
    if migratedGarageMods[user_id] then return 0 end
    migratedGarageMods[user_id] = true

    local migrated = 0
    local ok, vehicles = pcall(function()
        return vRP.Query("vehicles/UserVehicles",{ Passport = user_id })
    end)
    if not ok or type(vehicles) ~= "table" then return 0 end

    for _,v in ipairs(vehicles) do
        local name = v["vehicle"]
        if name then
            local dkey = "Mods:"..user_id..":"..name
            local data = vRP.Query("entitydata/GetData",{ dkey = dkey })
            if data and data[1] and data[1]["dvalue"] then
                local decoded = json.decode(data[1]["dvalue"])
                local customize = toGaragesCustomize(decoded)
                if customize then
                    vRP.Query("entitydata/SetData",{ dkey = dkey, dvalue = json.encode(customize) })
                    migrated = migrated + 1
                end
            end
        end
    end

    dbg("migrateGarageMods user="..user_id.." migrated="..migrated)
    return migrated
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
    if identity then playerName = identity["name"] .. " " .. identity["name2"] end
    
    local orderId = tostring(os.time()) .. math.random(100, 999)
    
    print("DEBUG: Criando ordem - Price:", price) -- Debug price

    vRP.Query("nation_bennys/add_order", {
        order_id = orderId,
        user_id = user_id,
        vehicle_name = name,
        plate = plate,
        price = parseInt(price), -- Force INT
        mods = json.encode(mods),
        name = playerName
    })

    TriggerClientEvent("Notify", source, "sucesso", "Ordem enviada para a mecânica!", 5000)
    
    -- Notify mechanics
    local mechanics = vRP.NumPermission("Mechanic")
    for _, mechSource in pairs(mechanics) do
        TriggerClientEvent("Notify", mechSource, "aviso", "Nova ordem de serviço recebida!", 5000)
    end
    
    return true
end

function API.getOrders()
    local source = source
    local user_id = vRP.Passport(source)
    if vRP.hasPermission(user_id, "Mechanic") or vRP.hasPermission(user_id, "Admin") then
        local result = vRP.Query("nation_bennys/get_orders")
        local formattedOrders = {}
        for _, row in ipairs(result) do
            formattedOrders[row.order_id] = {
                id = row.order_id,
                user_id = row.user_id,
                name = row.name,
                vehicleName = row.vehicle_name,
                plate = row.plate,
                price = row.price,
                mods = json.decode(row.mods),
                status = "pending"
            }
        end
        return formattedOrders
    end
    return {}
end

function API.applyOrder(orderId, vehicleNetId)
    local source = source
    local user_id = vRP.Passport(source)
    
    if not (vRP.hasPermission(user_id, "Mechanic") or vRP.hasPermission(user_id, "Admin")) then
        return false, "Sem permissão"
    end

    local result = vRP.Query("nation_bennys/get_order", { order_id = orderId })
    if not result or #result == 0 then return false, "Ordem não encontrada" end
    
    local order = result[1]
    order.mods = json.decode(order.mods)

    if vRP.tryFullPayment(order.user_id, order.price) then
        TriggerEvent("nation:syncApplyMods", order.mods, vehicleNetId)
        vRP.Query("playerdata/SetData",{ Passport = order.user_id, dkey = "custom:"..order.vehicle_name, dvalue = json.encode(order.mods) })
        local garageCustomize = toGaragesCustomize(order.mods)
        if not garageCustomize then garageCustomize = toGaragesCustomize({}) end
        if garageCustomize then
            vRP.Query("entitydata/SetData",{ dkey = "Mods:"..order.user_id..":"..order.vehicle_name, dvalue = json.encode(garageCustomize) })
        end
        
        vRP.Query("nation_bennys/delete_order", { order_id = orderId })
        return true, "Ordem aplicada com sucesso"
    else
        return false, "Cliente sem dinheiro"
    end
end

function API.denyOrder(orderId)
    local source = source
    local user_id = vRP.Passport(source)
    
    if not (vRP.hasPermission(user_id, "Mechanic") or vRP.hasPermission(user_id, "Admin")) then
        return false, "Sem permissão"
    end

    vRP.Query("nation_bennys/delete_order", { order_id = orderId })
    return true, "Ordem recusada com sucesso"
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
        if not garageCustomize then
            dbg("saveVehicle failed customize user="..user_id.." car="..NameCar.." plate="..tostring(Plate))
            dbg("saveVehicle raw="..json.encode(vehicle_mods))
            garageCustomize = toGaragesCustomize({})
        end
        if garageCustomize then
            local dkey_val = "Mods:"..user_id..":"..NameCar
            vRP.Query("entitydata/SetData",{ dkey = dkey_val, dvalue = json.encode(garageCustomize) })
            dbg("saveVehicle ok user="..user_id.." car="..NameCar.." plate="..tostring(Plate).." dkey="..dkey_val)
            dbg("saveVehicle mods11="..tostring(garageCustomize["mods"] and garageCustomize["mods"]["11"]).." mods12="..tostring(garageCustomize["mods"] and garageCustomize["mods"]["12"]).." mods13="..tostring(garageCustomize["mods"] and garageCustomize["mods"]["13"]).." mods18="..tostring(garageCustomize["mods"] and garageCustomize["mods"]["18"]))
            dbg("saveVehicle colors="..json.encode(garageCustomize["colors"]).." extracolors="..json.encode(garageCustomize["extracolors"]))
            dbg("saveVehicle customPcolor="..json.encode(garageCustomize["customPcolor"]).." customScolor="..json.encode(garageCustomize["customScolor"]))
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
