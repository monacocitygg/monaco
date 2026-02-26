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

-- METODO 2: Raycast a cada tiro (funciona contra godmode que bloqueia o evento de dano)
local function doRaycastCheck(weaponHash, camCoords, camRot, ped)
    -- converte rotacao pra direcao
    local rX = camRot.x * math.pi / 180.0
    local rZ = camRot.z * math.pi / 180.0
    local dirX = -math.sin(rZ) * math.abs(math.cos(rX))
    local dirY = math.cos(rZ) * math.abs(math.cos(rX))
    local dirZ = math.sin(rX)

    local range = 200.0
    local endCoords = vector3(
        camCoords.x + dirX * range,
        camCoords.y + dirY * range,
        camCoords.z + dirZ * range
    )

    -- raycast com flags 12 (peds) + 1 (world) = 13, pra nao perder hit por colisao
    local ray = StartShapeTestLosProbe(camCoords.x, camCoords.y, camCoords.z, endCoords.x, endCoords.y, endCoords.z, 12, ped, 0)
    local result, hit, hitCoords, _, hitEntity = GetShapeTestResultIncludingMaterial(ray)
    local attempts = 0
    while result == 1 do
        Wait(0)
        attempts = attempts + 1
        if attempts > 50 then
            if Config.Antitank.Debug then
                print('[ANTI-TANK] [Raycast] timeout esperando resultado')
            end
            return
        end
        result, hit, hitCoords, _, hitEntity = GetShapeTestResultIncludingMaterial(ray)
    end

    if Config.Antitank.Debug then
        local isEntity = hitEntity and hitEntity ~= 0
        local isPed = isEntity and IsEntityAPed(hitEntity)
        local isPlayer = isPed and IsPedAPlayer(hitEntity)
        print(('[ANTI-TANK] [Raycast] result: %d | hit: %d | entity: %s | isPed: %s | isPlayer: %s'):format(
            result, hit,
            tostring(isEntity),
            tostring(isPed),
            tostring(isPlayer)
        ))
    end

    if hit == 1 and hitEntity and DoesEntityExist(hitEntity) and IsEntityAPed(hitEntity) and IsPedAPlayer(hitEntity) then
        -- checa o bone mais proximo do ponto de impacto
        local boneHead = GetPedBoneCoords(hitEntity, 31086, 0.0, 0.0, 0.0)

        local distHead = #(hitCoords - boneHead)

        local threshold = 0.3 -- distancia maxima pro bone contar como hit

        if Config.Antitank.Debug then
            print(('[ANTI-TANK] [Raycast] hit ped | distHead: %.2f | threshold: %.2f'):format(distHead, threshold))
        end

        if distHead < threshold then
            local victimServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(hitEntity))

            if Config.Antitank.Debug then
                print(('[ANTI-TANK] [Raycast] HS detectado | vitima: %d | distHead: %.2f'):format(
                    victimServerId, distHead
                ))
            end

            processHeadshot(victimServerId, weaponHash)
        end
    end
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

            if Config.Antitank.Debug then
                print(('[ANTI-TANK] [Loop] Tiro detectado! weapon: %s'):format(tostring(weaponHash)))
            end

            -- roda raycast em thread separada pra nao bloquear deteccao de tiros
            CreateThread(function()
                doRaycastCheck(weaponHash, camCoords, camRot, ped)
            end)
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
