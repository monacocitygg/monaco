local lastHit = {}

-- cooldown em ms
local COOLDOWN = 2000
local wasShooting = false

-- limpa entries antigas do lastHit a cada 30s pra nao acumular memoria
CreateThread(function()
    while true do
        Wait(30000)
        local now = GetGameTimer()
        for k, v in pairs(lastHit) do
            if (now - v) > COOLDOWN then
                lastHit[k] = nil
            end
        end
    end
end)

print('[ANTI-TANK] Script carregado! Config: ' .. tostring(Config ~= nil) .. ' | Antitank: ' .. tostring(Config and Config.Antitank ~= nil))

-- checa se o bone eh da cabeca ou pescoco
local function isLethalBone(bone)
    return Config.Antitank.LethalBones[bone] == true
end

-- funcao que processa o headshot detectado
local function processHeadshot(victimServerId, weaponHash)
    local attackerServerId = GetPlayerServerId(PlayerId())
    if victimServerId <= 0 then return end

    local now = GetGameTimer()

    -- cooldown pra nao spammar
    if lastHit[victimServerId] and (now - lastHit[victimServerId]) < COOLDOWN then
        return
    end

    lastHit[victimServerId] = now

    if Config.Antitank.Debug then
        print(('[ANTI-TANK] HS/Pescoco -> vitima: %d | atacante: %d'):format(victimServerId, attackerServerId))
    end

    TriggerServerEvent('antitank:headshot', victimServerId, attackerServerId, weaponHash)
end

-- METODO 1: CEventNetworkEntityDamage (funciona contra players normais)
AddEventHandler('gameEventTriggered', function(name, args)
    if not Config.Antitank.Enabled then return end
    if name ~= 'CEventNetworkEntityDamage' then return end

    local victim = args[1]
    local attacker = args[2]
    local weaponHash = args[7]

    if attacker ~= PlayerPedId() then return end
    if not IsPedAPlayer(victim) then return end

    local boneHitSuccess, boneHit = GetPedLastDamageBone(victim)
    if not boneHitSuccess then return end

    if Config.Antitank.Debug then
        print(('[ANTI-TANK] [Evento] bone: %s | letal: %s'):format(tostring(boneHit), tostring(isLethalBone(boneHit))))
    end

    if not isLethalBone(boneHit) then return end

    local victimServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
    processHeadshot(victimServerId, weaponHash)
end)

-- METODO 2: Mira + proximidade (funciona contra godmode que reseta ped/bloqueia raycast)
-- calcula distancia perpendicular de um ponto ate uma linha (cam -> direcao)
local function pointToLineDistance(point, lineOrigin, lineDir)
    local diff = point - lineOrigin
    local t = diff.x * lineDir.x + diff.y * lineDir.y + diff.z * lineDir.z
    if t < 0 then return 999.0 end -- ponto atras da camera
    local closest = vector3(lineOrigin.x + lineDir.x * t, lineOrigin.y + lineDir.y * t, lineOrigin.z + lineDir.z * t)
    return #(point - closest)
end

CreateThread(function()
    while true do
        Wait(0)
        if not Config.Antitank.Enabled then goto continue end

        local ped = PlayerPedId()
        local isShooting = IsPedShooting(ped)

        if isShooting and not wasShooting then
            local weaponHash = GetSelectedPedWeapon(ped)
            local camCoords = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)

            -- converte rotacao pra vetor direcao
            local rX = camRot.x * math.pi / 180.0
            local rZ = camRot.z * math.pi / 180.0
            local dir = vector3(
                -math.sin(rZ) * math.abs(math.cos(rX)),
                math.cos(rZ) * math.abs(math.cos(rX)),
                math.sin(rX)
            )

            if Config.Antitank.Debug then
                print(('[ANTI-TANK] [Mira] Tiro detectado! weapon: %s'):format(tostring(weaponHash)))
            end

            -- percorre todos os players e checa se a cabeca ta na linha de mira
            local players = GetActivePlayers()
            for _, playerId in ipairs(players) do
                if playerId ~= PlayerId() then
                    local targetPed = GetPlayerPed(playerId)
                    if targetPed and DoesEntityExist(targetPed) then
                        local headCoords = GetPedBoneCoords(targetPed, 31086, 0.0, 0.0, 0.0) -- SKEL_Head
                        -- testa = posicao da cabeca + 0.12 pra cima no eixo Z do mundo
                        local foreheadCoords = vector3(headCoords.x, headCoords.y, headCoords.z + 0.12)
                        local neckCoords = GetPedBoneCoords(targetPed, 39317, 0.0, 0.0, 0.0) -- SKEL_Neck
                        local distFromCam = #(headCoords - camCoords)

                        -- ignora players muito longe (>200m)
                        if distFromCam < 200.0 then
                            local perpDistHead = pointToLineDistance(headCoords, camCoords, dir)
                            local perpDistForehead = pointToLineDistance(foreheadCoords, camCoords, dir)
                            local perpDistNeck = pointToLineDistance(neckCoords, camCoords, dir)
                            local perpDistCabeca = math.min(perpDistHead, perpDistForehead)

                            -- thresholds separados
                            local headThreshold = 0.06 + (distFromCam * 0.001)
                            local neckThreshold = 0.02 + (distFromCam * 0.001)

                            local isHeadshot = perpDistCabeca < headThreshold
                            local isNeckshot = perpDistNeck < neckThreshold

                            if Config.Antitank.Debug then
                                local sId = GetPlayerServerId(playerId)
                                print(('[ANTI-TANK] [Mira] player %d | dist: %.1f | headDist: %.2f | foreheadDist: %.2f | neckDist: %.2f | headTh: %.2f | neckTh: %.2f'):format(
                                    sId, distFromCam, perpDistHead, perpDistForehead, perpDistNeck, headThreshold, neckThreshold
                                ))
                            end

                            if isHeadshot or isNeckshot then
                                local victimServerId = GetPlayerServerId(playerId)

                                if Config.Antitank.Debug then
                                    local tipo = isHeadshot and (perpDistForehead < perpDistHead and 'testa' or 'cabeca') or 'pescoco'
                                    print(('[ANTI-TANK] [Mira] HS detectado! vitima: %d | tipo: %s'):format(
                                        victimServerId, tipo
                                    ))
                                end

                                processHeadshot(victimServerId, weaponHash)
                                break
                            end
                        end
                    end
                end
            end
        end

        wasShooting = isShooting
        ::continue::
    end
end)

-- evento recebido pela vitima: server avisa que levou HS, client espera e checa se tankou
RegisterNetEvent('antitank:checkKill', function()
    if Config.Antitank.Debug then
        print('[ANTI-TANK] checkKill recebido, aguardando 1s...')
    end

    CreateThread(function()
        Wait(1000)
        local ped = PlayerPedId()
        local hp = GetEntityHealth(ped)
        if hp <= 101 then
            if Config.Antitank.Debug then
                print(('[ANTI-TANK] Jogador morreu normalmente (HP: %d), ignorando.'):format(hp))
            end
            return
        end

        -- ainda vivo apos 1s = tankou
        if Config.Antitank.Debug then
            print(('[ANTI-TANK] Jogador tankou (HP: %d)! Forcando morte...'):format(hp))
        end
        SetPlayerInvincible(PlayerId(), false)
        SetEntityInvincible(ped, false)
        SetEntityCanBeDamaged(ped, true)
        SetEntityHealth(ped, 0)
    end)
end)
