-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
local Tools  = module("vrp","lib/Tools")
local config = module(GetCurrentResourceName(),"config")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- variabless
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
local Spawn = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- database set
-----------------------------------------------------------------------------------------------------------------------------------------
DB = {}

DB.prepare = function(name, query)
    vRP.Prepare(name, query)
end

DB.execute = function(name, param)
    return vRP.Execute(name, param)
end

DB.query = function(name, param)
    return vRP.Query(name, param)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERYES
-----------------------------------------------------------------------------------------------------------------------------------------
DB.prepare("night_staff/all_users","SELECT I.*, U.* FROM vrp_user_identities AS I INNER JOIN vrp_users AS U ON U.id = I.user_id WHERE U.deleted = 0")
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserSource
-----------------------------------------------------------------------------------------------------------------------------------------
getUserSource = function(user_id)
    return vRP.Source(tonumber(user_id))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserId
-----------------------------------------------------------------------------------------------------------------------------------------
getUserId = function(source)
    return vRP.Passport(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserIdentity
-----------------------------------------------------------------------------------------------------------------------------------------
getUserIdentity = function(user_id)
    return vRP.Identity(user_id)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserFullName
-----------------------------------------------------------------------------------------------------------------------------------------
getUserFullName = function(user_id)
    local identity = getUserIdentity(user_id)
    local name = identity.name
    local name2 = identity.name2
    return name .. " " .. name2
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserImage
-----------------------------------------------------------------------------------------------------------------------------------------
getUserImage = function(user_id)
    local identity = getUserIdentity(user_id)
    local image = config.UserImage -- identity.foto
    return image
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserFines
-----------------------------------------------------------------------------------------------------------------------------------------
getUserFines = function(user_id)
    local fines = vRP.GetFine(user_id)
    if fines == "" then
        fines = 0
    end
    return tonumber(fines)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getProfission
-----------------------------------------------------------------------------------------------------------------------------------------
getProfission = function(user_id)
    local profission = 'Desempregado'
    local primary    = "job"-- vRP.getUserGroupByType(user_id,'job')
    local hie        = "hie" -- vRP.getUserGroupByType(user_id,'hie')

    if primary ~= '' then
        profission = primary
    end

    if hie ~= '' then
        profission = hie
    end

    return profission
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getVipName
-----------------------------------------------------------------------------------------------------------------------------------------
getVipName = function(user_id)
    local vip = "pass" -- vRP.getUserGroupByType(user_id,'pass')

    if vip == '' then
        vip = 'Nenhum'
    end

    return vip
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getStaffName
-----------------------------------------------------------------------------------------------------------------------------------------
getStaffName = function(user_id)
    local staff = "staff" -- vRP.getUserGroupByType(user_id,'staff')

    if staff == '' then
        staff = 'Nenhum'
    end

    return staff
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUsersList
-----------------------------------------------------------------------------------------------------------------------------------------
DB.prepare("night_staff/all_users_weedzz","SELECT id FROM characters ORDER BY id ASC")
getUsersList = function()
    local rows = DB.query("night_staff/all_users_weedzz", {})
    if #rows > 0 then
        local data = {}
        for k, v in pairs(rows) do
            local source = vRP.Source(tonumber(v.id))
            local Identity = vRP.Identity(tonumber(v.id))

            local userdata = {
                user_id = tonumber(v.id),
                name    = Identity["name"],
                online  = false
            }

            if source ~= nil then
                userdata.online = true
            end
            table.insert(data, userdata)
        end
        return data
    end
    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUserInfo
-----------------------------------------------------------------------------------------------------------------------------------------
getUserInfo = function(user_id)
    local Identity = vRP.Identity(user_id)
    local banned   = false
    local userdata = {
        user_id      = user_id,
        name         = Identity.name .. " " .. (Identity.name2 or ""),
        phone        = Identity.phone,
        registration = "SEM REGISTRO",
        age          = "20",
        image        = getUserImage(user_id),
        banned       = banned,
        bank         = Identity["bank"],
        fines        = vRP.GetFine(user_id),
        inventory    = {},
        groups       = {}
    }

    local checkbanned = exports.oxmysql:executeSync("SELECT * FROM banneds WHERE license = @license", { license = Identity["license"] })

    if #checkbanned > 0 then
        userdata.banned = true
    end

    local source = vRP.Source(user_id)
    if source ~= nil then
        local inv = vRP.Inventory(user_id)

		-- if not inv then
		-- 	local data = vRP.getUserDataTable(user_id)
		-- 	inv = data.inventory
		-- end

		if inv then
			local inventory = {}
			for k,v in pairs(inv) do
                local itemdata = {
                    index  = itemIndex(v.item),
                    image  = config.IPItems..itemIndex(v.item)..".png",
                    amount = tonumber(v.amount),
                    name   = itemName(v.item),
                }

                table.insert(inventory, itemdata)
            end

            userdata.inventory = inventory
        end


        local groups = {}
        local Groups = vRP.Groups()
		for Permission,_ in pairs(Groups) do
			local Data = vRP.DataGroups(Permission)
			if Data[tostring(user_id)] then
                local groupdata = {
                    group = Permission,
                    name  = Permission
                }

                table.insert(groups, groupdata)
    
                userdata.groups = groups
			end
		end


        -- local groupslist = vRP.GetGroups(user_id)

        -- if groupslist then
			-- local groups = {}
            -- for k, v in pairs(groupslist) do
            --     if v then
            --         local groupdata = {
            --             group = k,
            --             name  = k
            --         }

            --         table.insert(groups, groupdata)
            --     end
            -- end

            -- userdata.groups = groups
        -- end
    else
        -- local datatable = getUserData(user_id, "vRP:datatable")
        -- datatable = json.decode(datatable)

        -- local inv = datatable.inventorys
        local inv = vRP.Inventory(user_id)

		if inv then
			local inventory = {}
			for k,v in pairs(inv) do
                -- local itemdata = {
                --     index  = v.item,
                --     image  = config.IPItems..vRP.itemIndexList(v.item)..".png",
                --     amount = tonumber(v.amount),
                --     name   = vRP.itemNameList(v.item),
                -- }
                local itemdata = {
                    index  = itemIndex(v.item),
                    image  = config.IPItems..itemIndex(v.item)..".png",
                    amount = tonumber(v.amount),
                    name   = itemName(v.item),
                }

                table.insert(inventory, itemdata)
            end

            userdata.inventory = inventory
        end

        -- local groupslist = datatable.groups

        -- if groupslist then
		-- 	local groups = {}
        --     for k, v in pairs(groupslist) do
        --         if v then
        --             local groupdata = {
        --                 group = k,
        --                 name  = vRP.getGroupTitle(k)
        --             }

        --             table.insert(groups, groupdata)
        --         end
        --     end

        --     userdata.groups = groups
        -- end

        local groups = {}
        local Groups = vRP.Groups()
		for Permission,_ in pairs(Groups) do
			local Data = vRP.DataGroups(Permission)
			if Data[tostring(user_id)] then
                if Permission then
                    local groupdata = {
                        group = Permission,
                        name  = Permission
                    }

                    table.insert(groups, groupdata)
                end
    
                userdata.groups = groups
			end
		end
    end

    return userdata
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllGroups
-----------------------------------------------------------------------------------------------------------------------------------------
getAllGroups = function()
    local listgroups = vRP.Groups()
    local groups = {}
    for k, v in pairs(listgroups) do
        local groupdata = {
            group = k,
            name  = k
        }
        table.insert(groups, groupdata)
    end
    return groups
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllVehicles
-----------------------------------------------------------------------------------------------------------------------------------------
getAllVehicles = function()
    local listvehicles = VehicleGlobal()
    local vehicles = {}
    local excludedClasses = { "Militares", "Helicópteros", "Aviões", "Trens", "Trailers", "Industriais" }
    
    for k, v in pairs(listvehicles) do
        local vehicleClass = VehicleClass(k)
        local exclude = false
        
        for _, class in ipairs(excludedClasses) do
            if vehicleClass == class then
                exclude = true
                break
            end
        end
        
        if not exclude then
            local vehicledata = {
                vehicle = k,
                image   = config.IPVehicles..k..".png",
                name    = VehicleName(k)
            }
            table.insert(vehicles, vehicledata)
        end
    end
    return vehicles
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllItems
-----------------------------------------------------------------------------------------------------------------------------------------
getAllItems = function()
    local listitems = ItemListGlobal()
    local items = {}
    for k, v in pairs(listitems) do
        local itemdata = {
            item  = k,
            image = config.IPItems..itemIndex(k)..".png",
            name  = itemName(k)
        }
        table.insert(items, itemdata)
    end

    return items
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addUserGroup
-----------------------------------------------------------------------------------------------------------------------------------------
addUserGroup = function(user_id, group)
    local source = vRP.Source(user_id)
    if source then
        vRP.SetPermission(user_id,group,1)
    end
    -- if source then
    --     vRP.addUserGroup(user_id,group)
    -- else
    --     local data = vRP.query("vRP/get_userdata",{ user_id = user_id, key = "vRP:datatable" })
    --     if not data[1] then
    --         sendnotify(source,"negado","ID não encontrado no banco de dados")
    --         return false
    --     end
    --     local index = json.decode(data[1].dvalue)
    --     for k,v in pairs(index.groups) do
    --         if k == group then
    --             sendnotify(source,"negado","Esse id já tem esse cargo")
    --             return false
    --         end
    --     end
    --     index.groups[group] = true
    --     setUserData(user_id,"vRP:datatable",json.encode(index))
    -- end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- remUserGroup
-----------------------------------------------------------------------------------------------------------------------------------------
remUserGroup = function(user_id, group)
    local source = vRP.Soruce(user_id)
    if source then
        vRP.RemovePermission(user_id,group)
    end
    -- if source then
    --     vRP.removeUserGroup(user_id, group)
    -- else
    --     local data = vRP.query("vRP/get_userdata",{ user_id = user_id, key = "vRP:datatable" })
    --     if not data[1] then
    --         sendnotify(source,"negado","ID não encontrado no banco de dados")
    --         return false
    --     end
    --     local index = json.decode(data[1].dvalue)
    --     for k,v in pairs(index.groups) do
    --         if k == group then
    --             index.groups[k] = nil
    --         end
    --     end
    --     setUserData(user_id,"vRP:datatable",json.encode(index))
    -- end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getHasPermission
-----------------------------------------------------------------------------------------------------------------------------------------
getHasPermission = function(user_id, perm)
    return vRP.HasGroup(user_id,perm)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getBankMoney
-----------------------------------------------------------------------------------------------------------------------------------------
getBankMoney = function(user_id)
    local source = vRP.Source(user_id)
    if source then
        return vRP.GetBank(user_id)
    -- else
    --     local rows = vRP.query("vRP/get_money",{ user_id = user_id })
	-- 	if #rows > 0 then
	-- 		return tonumber(rows[1].bank)
	-- 	end
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- giveInventoryItem
-----------------------------------------------------------------------------------------------------------------------------------------
giveInventoryItem = function(user_id, item, amount)
    local source = vRP.Source(user_id)
    if source then
        -- vRP.giveInventoryItem(user_id, item, amount)
        vRP.GenerateItem(user_id,item,amount, true)
        return true
    end
    return false
end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- getUserData
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- getUserData = function(user_id, key)
--     return vRP.getUData(user_id, key)
-- end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- setUserData
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- setUserData = function(user_id, key, data)
--     vRP.setUData(user_id, key, data)
-- end


function ServerVehicleDurateston(Model, x, y, z, Heading, Plate, Nitrox, Doors, Body, Fuel)
    local Vehicle = CreateVehicle(Model, x, y, z, Heading, true, true)

    while not DoesEntityExist(Vehicle) do
        Wait(100)
    end

    if DoesEntityExist(Vehicle) then
        if Plate ~= nil then
            SetVehicleNumberPlateText(Vehicle, Plate)
        else
            Plate = vRP.GeneratePlate()
            SetVehicleNumberPlateText(Vehicle, Plate)
        end

        SetVehicleBodyHealth(Vehicle, Body + 0.0)

        if not Fuel then
            TriggerEvent("engine:tryFuel", Plate, 100)
        end

        if Doors then
            local DoorsDecoded = json.decode(Doors)
            if DoorsDecoded ~= nil then
                for Number, Status in pairs(DoorsDecoded) do
                    if Status then
                        SetVehicleDoorBroken(Vehicle, parseInt(Number), true)
                    end
                end
            end
        end

        local Network = NetworkGetNetworkIdFromEntity(Vehicle)

        if Model ~= "wheelchair" then
            local NetworkEntity = NetworkGetEntityFromNetworkId(Network)
            SetVehicleDoorsLocked(NetworkEntity, 2)
        end

        -- Uncomment if Nitro functionality is needed
        -- local Nitro = GlobalState["Nitro"]
        -- Nitro[Plate] = Nitrox or 0
        -- GlobalState:set("Nitro", Nitro, true)

        return true, Network, Vehicle
    end

    return false
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
vCLIENT = Tunnel.getInterface("Night_Admin")
spawnVehicle = function(user_id, vehicle)
    local source = vRP.Source(user_id)
    local Passport = vRP.Passport(source)
	if Passport then
        local VehicleName = vehicle
        local Ped = GetPlayerPed(source)
        local Coords = GetEntityCoords(Ped)
        local Heading = GetEntityHeading(Ped)
        local Plate = "VEH"..(10000 + Passport)
        local Exist,Network,Vehicle = ServerVehicleDurateston(VehicleName,Coords["x"],Coords["y"],Coords["z"],Heading,Plate,2000,nil,1000)
        
        if not Exist then
            return
        end

        vCLIENT.CreateVehicleDurateston(-1,VehicleName,Network,1000,1000,nil,false,false)
        Spawn[Plate] = { Passport,VehicleName,Network }
        TriggerEvent("engine:tryFuel",Plate,100)
        SetPedIntoVehicle(Ped,Vehicle,-1)

        local Plates = GlobalState["Plates"]
        Plates[Plate] = Passport
        GlobalState:set("Plates",Plates,true)
        return true
	end
    return false



    -- local source = vRP.Source(user_id)
    -- if source then
    --     local plate = vRP.GeneratePlate()
        
    --     -- TriggerClientEvent('spawnarveiculo',source,vehicle,plate)
    --     TriggerEvent("setPlateEveryone",plate)
    --     TriggerEvent("setPlateAdmin",plate,user_id)
    --     return true
    -- end
    -- return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
addVehicle = function(user_id, vehicle)
    vRP.Query("vehicles/addVehicles",{ Passport = user_id, vehicle = vehicle, plate = vRP.GeneratePlate(), work = "false" })
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- sendnotify
-----------------------------------------------------------------------------------------------------------------------------------------
sendnotify = function(source, type, message, time)
    if time == nil then
        time = 8000
    end
    if source then 
        TriggerClientEvent("Notify",source,type,message,time)
    end
end