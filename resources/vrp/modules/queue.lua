-- Função para verificar se a conta Rockstar já está em uso
function isRockstarAccountInUse(rockstarIdentifier)
    for _, player in ipairs(GetPlayers()) do
        local identifiers = GetPlayerIdentifiers(player)
        for _, identifier in ipairs(identifiers) do
            if identifier == rockstarIdentifier then
                return true
            end
        end
    end
    return false
end

-- Função para obter o identificador da conta Rockstar
function getRockstarIdentifier(identifiers)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "license:") then
            return identifier
        end
    end
    return nil
end

function getQueue(ids, trouble, source, connect)
    for k, v in ipairs(connect and Queue.Connecting or Queue.List) do
        local inQueue = false

        if not source then
            for _, i in ipairs(v["ids"]) do
                if inQueue then
                    break
                end

                for _, o in ipairs(ids) do
                    if o == i then
                        inQueue = true
                        break
                    end
                end
            end
        else
            inQueue = ids == v["source"]
        end

        if inQueue then
            if trouble then
                return k, connect and Queue.Connecting[k] or Queue.List[k]
            end

            return true
        end
    end

    return false
end

function LicenseRunning(source)
    local result = false
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, BaseMode) then
            result = true
            break
        end
    end

    return result
end

-- Check the priority of the player
function CheckPriority(player)
    -- Iterate through the player identifiers
    for _, identifier in pairs(GetPlayerIdentifiers(player)) do
        -- Check if the identifier contains the base mode and the player has a premium license
        if string.find(identifier, BaseMode) and vRP.LicensePremium(splitString(identifier, ":")[2]) then
            break
        end
    end

    -- Return a priority of 10
    return 10
end

function addQueue(ids, connectTime, name, source, deferrals)
    if getQueue(ids) then
        return
    end

    local tmp = { source = source, ids = ids, name = name, firstconnect = connectTime, priority = CheckPriority(ids), timeout = 0, deferrals = deferrals }

    local _pos = false
    local queueCount = #Queue.List + 1

    for k, v in ipairs(Queue.List) do
        if tmp["priority"] then
            if not v["priority"] then
                _pos = k
            else
                if tmp["priority"] > v["priority"] then
                    _pos = k
                end
            end

            if _pos then
                break
            end
        end
    end

    if not _pos then
        _pos = #Queue.List + 1
    end

    table.insert(Queue.List, _pos, tmp)
end

function removeQueue(ids, source)
    if getQueue(ids, false, source) then
        local pos, data = getQueue(ids, true, source)
        table.remove(Queue.List, pos)
    end
end

function isConnect(ids, source, refresh)
    local k, v = getQueue(ids, refresh and true or false, source and true or false, true)

    if not k then
        return false
    end

    if refresh and k and v then
        Queue.Connecting[k]["timeout"] = 0
    end
    return true
end

function removeConnect(ids, source)
    for k, v in ipairs(Queue.Connecting) do
        local connect = false

        if not source then
            for _, i in ipairs(v["ids"]) do
                if connect then
                    break
                end

                for _, o in ipairs(ids) do
                    if o == i then
                        connect = true
                        break
                    end
                end
            end
        else
            connect = ids == v["source"]
        end

        if connect then
            table.remove(Queue.Connecting, k)
            return true
        end
    end
    return false
end

function addConnect(ids, ignorePos, autoRemove, done)
    local function removeFromQueue()
        if not autoRemove then
            return
        end

        done(Lang.Error)
        removeConnect(ids)
        removeQueue(ids)
    end

    if #Queue.Connecting >= 1000 then
        removeFromQueue()
        return false
    end

    if isConnect(ids) then
        removeConnect(ids)
    end

    local pos, data = getQueue(ids, true)
    if not ignorePos and (not pos or pos > 1) then
        removeFromQueue()
        return false
    end

    table.insert(Queue.Connecting, data)
    removeQueue(ids)
    return true
end

function steamIds(source)
    return GetPlayerIdentifiers(source)
end

function updateData(source, ids, deferrals)
    local pos, data = getQueue(ids, true)
    Queue.List[pos]["ids"] = ids
    Queue.List[pos]["timeout"] = 0
    Queue.List[pos]["source"] = source
    Queue.List[pos]["deferrals"] = deferrals
end

function notFull(firstJoin)
    local canJoin = Queue.Counts + #Queue.Connecting < Queue.Max and #Queue.Connecting < 1000
    if firstJoin and canJoin then
        canJoin = #Queue.List <= 1
    end

    return canJoin
end

function setPosition(ids, newPos)
    local pos, data = getQueue(ids, true)
    table.remove(Queue.List, pos)
    table.insert(Queue.List, newPos, data)
end

CreateThread(function()
    local function playerConnect(name, setKickReason, deferrals)
        local source = source
        local ids = steamIds(source)
        local connecting = true
        local connectTime = os.time()
        deferrals.defer()

        CreateThread(function()
            while connecting do
                Wait(500)
                if not connecting then
                    return
                end
                deferrals.update(Lang.Connecting)
            end
        end)

        Wait(1000)
        local function done(message)
            connecting = false
            CreateThread(function()
                if message then
                    deferrals.update(tostring(message) and tostring(message) or "")
                end

                Wait(1000)

                if message then
                    deferrals.done(tostring(message) and tostring(message) or "")
                    CancelEvent()
                end
            end)
        end

        local function update(message)
            connecting = false
            deferrals.update(tostring(message) and tostring(message) or "")
        end

        local rockstarIdentifier = getRockstarIdentifier(ids)
        if isRockstarAccountInUse(rockstarIdentifier) then
            done("Esta conta Rockstar já está em uso.")
            CancelEvent()
            return
        end

        if not LicenseRunning(source) then
            done("Você está sem sua steam ou algum dos nossos identificadores abertos.")
            CancelEvent()
            return
        end

        local reason = "Removido da fila."

        local function setReason(message)
            reason = tostring(message)
        end

        TriggerEvent("Queue:playerJoinQueue", source, setReason)

        if WasEventCanceled() then
            done(reason)

            removeQueue(ids)
            removeConnect(ids)

            CancelEvent()
            return
        end

        if getQueue(ids) then
            rejoined = true
            updateData(source, ids, deferrals)
        else
            addQueue(ids, connectTime, name, source, deferrals)
        end

        if isConnect(ids, false, true) then
            removeConnect(ids)

            if notFull() then
                local added = addConnect(ids, true, true, done)
                if not added then
                    CancelEvent()
                    return
                end

                done()
                TriggerEvent("Queue:Connecting", source, ids, deferrals)

                return
            else
                addQueue(ids, connectTime, name, source, deferrals)
                setPosition(ids, 1)
            end
        end

        local pos, data = getQueue(ids, true)

        if not pos or not data then
            done(Lang.error)
            RemoveFromQueue(ids)
            RemoveFromConnecting(ids)
            CancelEvent()
            return
        end

        if notFull(true) then
            local added = addConnect(ids, true, true, done)
            if not added then
                CancelEvent()
                return
            end

            done()

            TriggerEvent("Queue:Connecting", source, ids, deferrals)

            return
        end

        update(string.format(Lang.Position, pos, #Queue.List))

        CreateThread(function()
            if rejoined then
                return
            end

            Queue.Threads = Queue.Threads + 1
            local dotCount = 0

            while true do
                Wait(1000)
                local dots = ""

                dotCount = dotCount + 1
                if dotCount > 3 then
                    dotCount = 0
                end

                for i = 1, dotCount do
                    dots = dots .. "."
                end

                local pos, data = getQueue(ids, true)

                if not pos or not data then
                    if data and data.deferrals then
                        data.deferrals.done(Lang.error)
                    end

                    CancelEvent()
                    removeQueue(ids)
                    removeConnect(ids)
                    Queue.Threads = Queue.Threads - 1
                    return
                end

                if pos <= 1 and notFull() then
                    local added = addConnect(ids)
                    data.deferrals.update(Lang.join)
                    Wait(500)

                    if not added then
                        data.deferrals.done(Lang.connecterror)
                        CancelEvent()
                        Queue.Threads = Queue.Threads - 1
                        return
                    end

                    data.deferrals.update("Carregando conexão com o servidor.")

                    removeQueue(ids)
                    Queue.Threads = Queue.Threads - 1

                    TriggerEvent("Queue:Connecting", source, data.ids, data.deferrals)

                    return
                end

                local message = string.format("Street Shop\n\n" .. Lang.Position .. "%s\nEvite punições, fique por dentro das regras de conduta.\nAtualizações frequentes, deixe sua sugestão em nosso discord.", pos, #Queue.List, dots)
                data.deferrals.update(message)
            end
        end)
    end

    AddEventHandler("playerConnecting", playerConnect)

    local function checkTimeOuts()
        local i = 1

        while i <= #Queue.List do
            local data = Queue.List[i]
            local lastMsg = GetPlayerLastMsg(data.source)

            if lastMsg == 0 or lastMsg >= 30000 then
                data.timeout = data.timeout + 1
            else
                data.timeout = 0
            end

            if not data.ids or not data.name or not data.firstconnect or data.priority == nil or not data.source then
                data.deferrals.done(Lang.error)
                table.remove(Queue.List, i)
            elseif (data.timeout >= 120) and os.time() - data.firstconnect > 5 then
                data.deferrals.done(Lang.error)
                removeQueue(data.source, true)
                removeConnect(data.source, true)
            else
                i = i + 1
            end
        end

        i = 1

        while i <= #Queue.Connecting do
            local data = Queue.Connecting[i]
            local lastMsg = GetPlayerLastMsg(data.source)
            data.timeout = data.timeout + 1

            if ((data.timeout >= 300 and lastMsg >= 35000) or data.timeout >= 340) and os.time() - data.firstconnect > 5 then
                removeQueue(data.source, true)
                removeConnect(data.source, true)
            else
                i = i + 1
            end
        end

        SetTimeout(1000, checkTimeOuts)
    end

    checkTimeOuts()
end)

-- PLAYERCONNECT
RegisterServerEvent("Queue:Connect")
AddEventHandler("Queue:Connect", function()
    local source = source

    if not Queue.Players[source] then
        local ids = steamIds(source)

        Queue.Counts = Queue.Counts + 1
        Queue.Players[source] = true
        removeQueue(ids)
        removeConnect(ids)
    end
end)

-- PLAYERDROPPED
AddEventHandler("playerDropped", function()
    if Queue.Players[source] then
        local ids = steamIds(source)

        Queue.Counts = Queue.Counts - 1
        Queue.Players[source] = nil
        removeQueue(ids)
        removeConnect(ids)
    end
end)

-- REMOVEQUEUE
AddEventHandler("Queue:remove", function(ids)
    removeQueue(ids)
    removeConnect(ids)
end)