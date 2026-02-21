local lastHit = {}
local pendingCheck = {}

-- cooldown em ms pra nao ficar enviando evento toda hora pro mesmo player
local COOLDOWN = 2000

-- checa se o bone atingido eh da cabeca
local function isHeadBone(bone)
    return Config.Antitank.HeadBones[bone] == true
end

-- quando o player local causa dano em alguem
AddEventHandler('gameEventTriggered', function(name, args)
    if not Config.Antitank.Enabled then return end
    if name ~= 'CEventNetworkEntityDamage' then return end

    local victim = args[1]
    local attacker = args[2]
    local isDead = args[4] == 1
    local weaponHash = args[7]
    local boneHit = args[10]

    -- so processa se o atacante eh o player local
    if attacker ~= PlayerPedId() then return end

    -- ignora se a vitima nao eh um ped de player
    if not IsPedAPlayer(victim) then return end

    -- ignora se ja ta morto
    if isDead or IsEntityDead(victim) then return end

    -- checa se bateu na cabeca
    if not isHeadBone(boneHit) then return end

    local victimServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
    local attackerServerId = GetPlayerServerId(PlayerId())

    if victimServerId <= 0 then return end

    local now = GetGameTimer()

    -- ignora se ja tem um check pendente pra essa vitima
    if pendingCheck[victimServerId] then return end

    -- ignora se ainda ta no cooldown (evita spam de evento)
    if lastHit[victimServerId] and (now - lastHit[victimServerId]) < COOLDOWN then
        return
    end

    lastHit[victimServerId] = now
    pendingCheck[victimServerId] = true

    if Config.Antitank.Debug then
        print(('[ANTI-TANK] HS detectado -> vitima: %d | atacante: %d | weapon: %s | bone: %d'):format(
            victimServerId, attackerServerId, weaponHash, boneHit
        ))
    end

    -- espera o delay e checa se o cara sobreviveu
    Citizen.SetTimeout(Config.Antitank.CheckDelay, function()
        pendingCheck[victimServerId] = nil

        local victimPed = GetPlayerPed(GetPlayerFromServerId(victimServerId))

        if victimPed and DoesEntityExist(victimPed) and not IsEntityDead(victimPed) then
            if Config.Antitank.Debug then
                print(('[ANTI-TANK] Player %d sobreviveu ao HS, enviando pro server'):format(victimServerId))
            end

            TriggerServerEvent('antitank:headshotSurvived', victimServerId, attackerServerId, weaponHash)
        end
    end)
end)
