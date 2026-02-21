Framework = {}

Framework["version"] = nil -- "crnetwork", "crv5", "crv3", "vrp"

if IsDuplicityVersion() then

    if GetResourceState('vrp') ~= 'missing' then
        
        -- Aqui ficam as principais funções relacionadas a framework, sinta-se livre para alterar

        function Framework:userSource(user_id)
            return vRP.getUserSource(user_id) or vRP.userSource(user_id) or vRP.Source(user_id)
        end
        
        function Framework:userId(source)
            return vRP.getUserId(source) or vRP.Passport(source)
        end

        function Framework:hasPermission(user_id,permission)
            return vRP.hasPermission(user_id,permission) or vRP.HasGroup(user_id,permission)
        end
        
        function Framework:paymentWallet(user_id,amount)
            return vRP.tryPayment(user_id,amount) or Framework:takeItem(user_id,"dollars",amount,true) or Framework:takeItem(user_id,"dinheiro",amount,true)
        end

        function Framework:addWallet(user_id,amount)
            if Framework.version == "vrp" then
                vRP.giveMoney(user_id,amount)
            else
                Framework:giveItem(user_id,"dollars",amount,true)
            end
        end

        function Framework:paymentBank(user_id,amount)
            return vRP.paymentBank(user_id,amount) or vRP.PaymentBank(user_id,amount) or vRP.tryFullPayment(user_id,amount)
        end

        function Framework:addBank(user_id,amount)
            if Framework.version == "vrp" then
                vRP.giveBankMoney(user_id,amount)
            elseif Framework.version == "crv3" or Framework.version == "crv5" then
                vRP.addBank(user_id,amount,"Private")
            elseif Framework.version == "crnetwork" then
                vRP.GiveBank(user_id,amount)
            end
        end

        function Framework:takeItem(...)
            return vRP.tryGetInventoryItem(...) or vRP.TakeItem(...)
        end

        function Framework:giveItem(...)
            if Framework.version == "vrp" then
                vRP.giveInventoryItem(...)
            elseif Framework.version == "crv3" or Framework.version == "crv5" then
                vRP.generateItem(...)
            elseif Framework.version == "crnetwork" then
                vRP.GenerateItem(...)
            end
        end

        function Framework:userIdentity(user_id)
            local identity = vRP.getUserIdentity(user_id) or vRP.userIdentity(user_id) or vRP.Identity(user_id)
            if identity then
                identity.name = identity.name or identity.Name or " "
                identity.name2 = identity.name2 or identity.firstname or identity.Lastname or " "
                identity.phone = identity.phone or identity.Phone or " "
                return identity
            else
                return {name = " ", name2 = " ", phone = " "}
            end
        end

        function Framework:userList()
            return vRP.Players() or vRP.userList() or vRP.getUsers() or {}
        end

        function Framework:getDatatable(user_id)
            return vRP.getDatatable(user_id) or vRP.getUserDataTable(user_id) or vRP.Datatable(user_id) or {}
        end

        function Framework:userData(user_id,name)
            if not name then
                return
            end
            if Framework.version == "vrp" and name == "Datatable" then
                name = "vRP:datatable"
            end
            return vRP.userData(user_id,name) or vRP.getUData(user_id,name) or vRP.UserData(user_id,name)
        end

        function Framework:setData(user_id,key,data)
            local tableName = ""
            local tableExists = {"vrp_user_data","summerz_playerdata","playerdata"}
            for _,v in pairs(tableExists) do
                if SQL.hasTable(v) then
                    tableName = v
                end
            end

            if Framework.version == "vrp" then
                if key == "Datatable" then
                    key = "vRP:datatable"
                end
            end

            SQL.replace(tableName,{
                user_id = parseInt(user_id),
                dkey = key,
                dvalue = data
            })
        end

        function Framework:usertzData(user_id, columns, additional_conditions)
            local conditions = {"user_id = " .. user_id}

            if additional_conditions and type(additional_conditions) == "table" then
                for _, condition in ipairs(additional_conditions) do
                    table.insert(conditions, condition)
                end
            end

            return SQL.select("tz_modulo", columns, table.concat(conditions, " AND "))
        end
        

        function Framework:settzData(user_id, key, data, status)
            if not key then
                return
            end
            if status == nil then
                status = 1
            end
            local existingData = Framework:usertzData(user_id, key)
            if #existingData > 0 then
                SQL.update("tz_modulo", {
                    dvalue = data,
                    status = status
                }, string.format("user_id = %d AND dkey = '%s'", parseInt(user_id), key))
            else
                SQL.replace("tz_modulo", {
                    user_id = parseInt(user_id),
                    dkey = key,
                    dvalue = data,
                    status = status
                })
            end
        end


        function Framework:request(source,text,time)
            if Framework.version == "crnetwork" then
                return vRP.Request(source,text,"Não, recusar.")
            elseif Framework.version == "crv5" then
                return vRP.request(source,text,"Sim","Não")
            else
                return vRP.request(source,text,time)
            end
        end

        function Framework:numPermission(permission)
            if Framework.version == "vrp" then
                local players = {}
                local byPerm = vRP.getUsersByPermission(permission) or {}
                for _,id in pairs(byPerm) do
                    table.insert(players,Framework:userSource(id))
                end
                return players
            end
            return vRP.numPermission(permission) or vRP.NumPermission(permission) or {}
        end

        -------------------------------------------------------------- Não altere as linha abaixo --------------------------------------------------------------------------
        vRP = {}
        vRP.__callbacks = {}
        vRP.__index = function(self, name) 
            self[name] = function(...)
                local p = promise.new()
                table.insert(self.__callbacks,p)
                TriggerEvent('vRP:proxy', name, {...}, GetCurrentResourceName(), #self.__callbacks)
                return table.unpack(Citizen.Await(p))
            end
            return self[name]
        end
        AddEventHandler('vRP:'..GetCurrentResourceName()..':proxy_res', function(id, args)
            local p = vRP.__callbacks[id]
            if p then
                p:resolve(args)
                vRP.__callbacks[id] = nil
            end
        end)
        setmetatable(vRP, vRP)
    end

    function parseInt(v)
        local n = tonumber(v)
        if n == nil then 
            return 0
        else
            return math.floor(n)
        end
    end
    
end
