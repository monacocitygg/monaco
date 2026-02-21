local dkey = "proxy:restrain"

local allTable = {};

Citizen.CreateThread(function()

    if IsDuplicityVersion() then
        print("^4[ Tz - RESTRAIN ]^0 Iniciado.")

        registerCommandFunction()
        allTable = SQL.select("tz_modulo", {"user_id","dvalue", "status"}, "dkey = '".. dkey .. "' AND status = 1")

        AddEventHandler(Restrain:spawnEvent(), function(user_id, source)
            if user_id then
                TriggerEvent("proxy:playerCheck", source)
            end
        end)

        checkTemporaryRestrictions()
    end

end)

registerCommandFunction = function()

    RegisterCommand(Restrain:CommandRestrain(), function(source, args)
        local user_id = getUserId(source)
        local tuser_id = tonumber(args[1])
    
        if not hasPermission(user_id, source) then
            return
        end
    
        local sendData = {
            blockedBy = user_id,
            blocked = true
        }
    
        if args[2] then
            local tempo = args[2]
            local totalSeconds = parseTime(tempo)
            if totalSeconds == 0 then
                infoNotify(source, "Formato de tempo inválido. Uso correto: /" .. Restrain:CommandRestrain() .. " id tempo. <br>Exemplo: <b>/amarrar ".. user_id .. " 21d4h1m</b>")
                return
            end
            sendData.time = os.time() + totalSeconds
            
            sendData.temporary = true
        end
        
        dataPlayer = Framework:usertzData(tuser_id, {"dvalue"}, {"dkey = '".. dkey .. "'"})[1]    

        if dataPlayer  and json.decode(dataPlayer.dvalue).blocked then
            return infoNotify(source, "O ID: " .. tuser_id .. " já possui restrição.")
        end

        setRestriction(tuser_id, sendData, 1)
        if sendData.temporary then
            successNotify(source, "Restrição temporária adicionada ao ID: " .. tuser_id)
        else
            successNotify(source, "Restrição adicionada ao ID: " .. tuser_id)
        end
    end)
    
    RegisterCommand(Restrain:CommandRemoveRestrain(), function(source, args)
        local user_id = getUserId(source)
        local tuser_id = tonumber(args[1])

        if not hasPermission(user_id, source) then
            return
        end

        if not (user_id and tuser_id) then
            infoNotify(source, "Parâmetros incorretos. Uso correto: /" .. Restrain:CommandRemoveRestrain() .. " <id>")
            return
        end

        dataPlayer = Framework:usertzData(tuser_id, {"dvalue"}, {"dkey = '".. dkey .. "'"})[1]    

        if not dataPlayer then
            return infoNotify(source, "O ID: " .. tuser_id .. " não possui restrição.")
        end
        
        local data = json.decode(dataPlayer.dvalue)

        if not data.blocked then
            return infoNotify(source, "O ID: " .. tuser_id .. " não possui restrição.")
        end

        local sendData = {
            blockedBy = json.decode(dataPlayer.dvalue).blockedBy,
            unblockedBy = user_id,
            blocked = false
        }

        setRestriction(tuser_id, sendData, 0)
        successNotify(source, "Restrição removida do ID: " .. tuser_id)
    end)

    RegisterCommand("amarrarg", function(source, args)
        local user_id = getUserId(source)
        local tgroup = args[1]

        if not hasPermission(user_id, source) then
            return
        end

        if not (user_id and tgroup) then
            infoNotify(source, "Parâmetros incorretos. Uso correto: /amarrarg <grupo> <tempo?>")
            return
        end

        local sendData = {
            blockedBy = user_id,
            blocked = true
        }

        if args[2] then
            local tempo = args[2]
            local totalSeconds = parseTime(tempo)
            if totalSeconds == 0 then
                infoNotify(source, "Formato de tempo inválido. Uso correto: /amarrarg grupo tempo. <br>Exemplo: <b>/amarrarg Favela 21d4h1m</b>")
                return
            end

            sendData.time = os.time() + totalSeconds

            sendData.temporary = true
        end

        local players = vRP.DataGroups(tgroup)
        for Pass, _ in pairs(players) do
            dataPlayer = Framework:usertzData(Pass, {"dvalue"}, {"dkey = '".. dkey .. "'"})[1]

            if not (dataPlayer and json.decode(dataPlayer.dvalue).blocked) then
                setRestriction(Pass, sendData, 1)
            end
        end

        if sendData.temporary then
            successNotify(source, "Restrição temporária adicionada ao Grupo: " .. tgroup)
        else
            successNotify(source, "Restrição adicionada ao Grupo: " .. tgroup)
        end
    end)

    RegisterCommand("ramarrarg", function(source, args)
        local user_id = getUserId(source)
        local tgroup = args[1]

        if not hasPermission(user_id, source) then
            return
        end

        if not (user_id and tgroup) then
            infoNotify(source, "Parâmetros incorretos. Uso correto: /ramarrarg <id> <tempo?>")
            return
        end

        local dataGroup = vRP.DataGroups(tgroup)
        for Pass,_ in pairs(dataGroup) do
            dataPlayer = Framework:usertzData(Pass, {"dvalue"}, {"dkey = '".. dkey .. "'"})[1]

            if dataPlayer then
                local data = json.decode(dataPlayer.dvalue)
                if data.blocked then
                    local sendData = {
                        blockedBy = json.decode(dataPlayer.dvalue).blockedBy,
                        unblockedBy = user_id,
                        blocked = false
                    }

                    setRestriction(Pass, sendData, 0)
                end
            end
        end

        successNotify(source, "Restrição removida do Grupo: " .. tgroup)
    end)
end

RegisterCommand("camarrarg", function(source, args)
    local user_id = getUserId(source)
    local tgroup = args[1]

    if not hasPermission(user_id, source) then
        return
    end

    if not (user_id and tgroup) then
        infoNotify(source, "Parâmetros incorretos. Uso correto: /camarrarg <grupo>")
        return
    end

    local dataGroup = vRP.DataGroups(tgroup)
    local hasRestrictions = false

    for Pass, _ in pairs(dataGroup) do
        local dataPlayer = Framework:usertzData(Pass, {"dvalue"}, {"dkey = '" .. dkey .. "'"})[1]

        if dataPlayer then
            local data = json.decode(dataPlayer.dvalue)

            if data.blocked then
                hasRestrictions = true
                if data.temporary and data.time then
                    local timeLeft = data.time - os.time()

                    if timeLeft > 0 then
                        local days = math.floor(timeLeft / (24 * 60 * 60))
                        local hours = math.floor((timeLeft % (24 * 60 * 60)) / (60 * 60))
                        local minutes = math.floor((timeLeft % (60 * 60)) / 60)
                        local timeLeftMsg = string.format("Faltam %d dias, %d horas e %d minutos.", days, hours, minutes)

                        infoNotify(source, "ID: " .. Pass .. " está amarrado. " .. timeLeftMsg)
                    else
                        infoNotify(source, "ID: " .. Pass .. " está amarrado, mas o tempo já expirou.")
                    end
                else
                    infoNotify(source, "ID: " .. Pass .. " está permanentemente amarrado.")
                end
            end
        end
    end

    if not hasRestrictions then
        infoNotify(source, "O grupo " .. tgroup .. " não está amarrado.")
    end
end)


function getUserId(source)
    if source == 0 then
        return "Console"
    else
        return Framework:userId(source)
    end
end

function hasPermission(user_id, source)
    if Restrain:Permissions(user_id, source) then
        return true
    end
    return false
end

function setRestriction(tuser_id, sendData, status)
  
    Framework:settzData(tuser_id, "proxy:restrain", sendData, status)
 
    sendLog(tuser_id, sendData, status)

    local userSource = Framework:userSource(tuser_id)

    if userSource then
        local sendData2 = {
            sourcePlayer = Framework:userSource(tuser_id),
            userId = tuser_id,
            dataPlayer = Framework:usertzData(tuser_id, {"dvalue"}, {"dkey = '".. dkey .. "'"})[1]
        }
    
        TriggerClientEvent("proxy:playerCheck", Framework:userSource(tuser_id), json.encode(sendData2))
    end
 
    allTable = SQL.select("tz_modulo", {"user_id","dvalue", "status"}, "dkey = '".. dkey .. "' AND status = 1")

end

function errorNotify(source, message)
    if source == 0 then
        return print(message)
    end
    Restrain:errorNotify(source, message)
end

function infoNotify(source, message)
    if source == 0 then
        return print(message)
    end
    Restrain:infoNotify(source, message)
end

function successNotify(source, message)
    if source == 0 then
        return print(message)
    end
    Restrain:successNotify(source, message)
end

RegisterNetEvent("proxy:playerCheck")
AddEventHandler("proxy:playerCheck", function(joinSource)
    if IsDuplicityVersion() then
        local source = source
        
        if joinSource then
            source = joinSource
        end

        local user_id = Framework:userId(source)

        if user_id then
            local data = Framework:usertzData(user_id, {"dvalue"}, {"dkey = '".. dkey .. "'"})[1]
 
            local sendData = {
                sourcePlayer = source,
                userId = user_id,
                dataPlayer = data
            }
    
            TriggerClientEvent("proxy:playerCheck", source, json.encode(sendData))
        end
    end
end)

function parseTime(input)
    local timePattern = "(%d+)([dhm])"
    local totalSeconds = 0
    
    for number, unit in input:gmatch(timePattern) do
        number = tonumber(number)
        if unit == "d" then
            totalSeconds = totalSeconds + number * 24 * 60 * 60
        elseif unit == "h" then
            totalSeconds = totalSeconds + number * 60 * 60
        elseif unit == "m" then
            totalSeconds = totalSeconds + number * 60
        end
    end
    
    return totalSeconds
end

function checkTemporaryRestrictions()
    while true do
        local currentTime = os.time()

        for _, userTable in ipairs(allTable) do
            local userData = json.decode(tostring(userTable.dvalue))
            if userData and userData.blocked and userData.time and userData.temporary then
                
                if userData.time <= currentTime then
                    local sendData = {
                        blockedBy = userData.blockedBy,
                        unblockedBy = "Restrição temporária expirada.",
                        blocked = false
                    }
                    setRestriction(userTable.user_id, sendData, 0)
                end
            end
        end
        Citizen.Wait(60 * 1000)
    end
end

function sendLog(user_id, message, status)
    local discordWebhook = Restrain:WebhookUrl()
    if discordWebhook == nil then return end

    local title = "Restrição adicionada!"
    local statusColor = "#00FF00"

    local userIdentity = Framework:userIdentity(user_id)

    local restrainAdm = "Console"
    local adminId = tonumber(message.blockedBy)
    if adminId then
        local userIdentityAdm = Framework:userIdentity(adminId)
        restrainAdm = string.format("%s %s [%s]", userIdentityAdm.name, userIdentityAdm.name2, adminId)
    end

    local fields = {
        { name = "**ID Restringido:**", value = string.format("`%s %s [%s]`", userIdentity.name, userIdentity.name2, user_id) },
        { name = "**Restringido por:**", value = string.format("`%s`", restrainAdm) },
    }

    if status == 0 then
        title = "Restrição removida!"
        statusColor = "#FF0000"

        local unblockedByStaff = tonumber(message.unblockedBy)
        local unblockedByValue = string.format("`%s`", message.unblockedBy) 
        if unblockedByStaff then
            local userIdentityRemoved = Framework:userIdentity(unblockedByStaff)
            unblockedByValue = string.format("`%s %s [%s]`", userIdentityRemoved.name, userIdentityRemoved.name2, unblockedByStaff)
        end

        table.insert(fields, { name = "**Removida por:**", value = unblockedByValue })
    end


    if message.temporary then
        local temporaryValue = string.format("<t:%s:F>", message.time)
        table.insert(fields, { name = "**Temporário:**", value = temporaryValue })
    end

    local embedData = {
        embeds = {
            {
                title = title,
                fields = fields,
                footer = {
                    text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S")
                },
                color = tonumber(statusColor:sub(2), 16)
            }
        }
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode(embedData), { ['Content-Type'] = 'application/json' })
end