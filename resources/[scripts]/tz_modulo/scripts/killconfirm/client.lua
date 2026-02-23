-- estado do marcador de kill na tela
local killConfirmActive = false
local killConfirmStart = 0

-- tabela de players que o jogador local acertou recentemente
-- key = server id da vitima, value = { ped, time, dead }
local hitTargets = {}

-- desenha um ponto (retangulo pequeno) na tela
local function drawPoint(px, py, w, r, g, b, a)
    DrawRect(px, py, w, w, r, g, b, a)
end

-- renderiza o X no centro da tela usando pontos ao longo das diagonais
local function drawKillCross(alpha)
    local cfg = Config.KillConfirm
    local size = cfg.CrossSize
    local thickness = cfg.LineWidth / 1920.0
    local r, g, b = cfg.Color.r, cfg.Color.g, cfg.Color.b
    local a = math.floor(cfg.Color.a * alpha)

    local cx, cy = 0.5, 0.5
    local steps = 24

    for i = 0, steps do
        local t = i / steps
        local px = cx - size + (size * 2) * t
        local py = cy - size + (size * 2) * t
        drawPoint(px, py, thickness, r, g, b, a)
    end

    for i = 0, steps do
        local t = i / steps
        local px = cx + size - (size * 2) * t
        local py = cy - size + (size * 2) * t
        drawPoint(px, py, thickness, r, g, b, a)
    end
end

-- ativa o marcador de kill na tela
local function showKillMarker()
    killConfirmActive = true
    killConfirmStart = GetGameTimer()

    if Config.KillConfirm.Debug then
        print('[KILL-CONFIRM] Marcador ativado.')
    end
end

-- thread principal: detecta tiros, rastreia vitimas e checa morte
-- nao depende de gameEventTriggered que eh inconsistente no client do atacante
CreateThread(function()
    local wasShooting = false

    while true do
        Wait(0)
        if not Config.KillConfirm.Enabled then goto continue end

        local myPed = PlayerPedId()
        local shooting = IsPedShooting(myPed)

        -- quando o jogador dispara, detecta quem ta na mira e registra
        if shooting and not wasShooting then
            -- tenta pegar o ped que ta sendo mirado
            local found, targetEntity = GetEntityPlayerIsFreeAimingAt(PlayerId())

            if found and DoesEntityExist(targetEntity) and IsEntityAPed(targetEntity) and IsPedAPlayer(targetEntity) then
                local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetEntity))

                if serverId > 0 then
                    hitTargets[serverId] = {
                        ped = targetEntity,
                        time = GetGameTimer(),
                        dead = false
                    }

                    if Config.KillConfirm.Debug then
                        print(('[KILL-CONFIRM] Tiro registrado -> alvo server id: %d'):format(serverId))
                    end
                end
            end
        end

        wasShooting = shooting

        -- verifica se algum alvo que levou tiro morreu
        local now = GetGameTimer()
        for serverId, data in pairs(hitTargets) do
            if data.dead then
                -- ja processado, remove
                hitTargets[serverId] = nil
            elseif (now - data.time) > 5000 then
                -- dano antigo demais, descarta
                hitTargets[serverId] = nil
            elseif DoesEntityExist(data.ped) and IsEntityDead(data.ped) then
                -- vitima morreu, confirma o kill
                data.dead = true
                showKillMarker()

                if Config.KillConfirm.Debug then
                    print(('[KILL-CONFIRM] Kill confirmado -> vitima server id: %d'):format(serverId))
                end
            end
        end

        ::continue::
    end
end)

-- fallback: gameEventTriggered pra pegar kills que o metodo acima pode perder
-- (ex: vitima fora do free aim mas ainda levou dano por spread/explosao)
AddEventHandler('gameEventTriggered', function(name, args)
    if not Config.KillConfirm.Enabled then return end
    if name ~= 'CEventNetworkEntityDamage' then return end

    local victim = args[1]
    local attacker = args[2]
    local isFatal = args[6]

    if attacker ~= PlayerPedId() then return end
    if isFatal ~= 1 then return end
    if not DoesEntityExist(victim) then return end
    if not IsEntityAPed(victim) then return end
    if not IsPedAPlayer(victim) then return end

    local victimServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
    if victimServerId <= 0 then return end

    -- so mostra se ja nao foi detectado pelo metodo principal
    if hitTargets[victimServerId] and hitTargets[victimServerId].dead then
        return
    end

    if Config.KillConfirm.Debug then
        print(('[KILL-CONFIRM] Kill via evento -> vitima server id: %d'):format(victimServerId))
    end

    hitTargets[victimServerId] = nil
    showKillMarker()
end)

-- thread de renderizacao do X na tela
CreateThread(function()
    local cfg = Config.KillConfirm
    while true do
        if killConfirmActive then
            local elapsed = GetGameTimer() - killConfirmStart
            local duration = cfg.DisplayTime

            if elapsed >= duration then
                killConfirmActive = false
            else
                local alpha = 1.0

                if cfg.FadeOut then
                    local fadeStart = duration * 0.6
                    if elapsed > fadeStart then
                        alpha = 1.0 - ((elapsed - fadeStart) / (duration - fadeStart))
                    end
                end

                -- esconde o X nativo do GTA (reticulo) pra nao duplicar
                HideHudComponentThisFrame(14)

                drawKillCross(alpha)
            end

            Wait(0)
        else
            Wait(200)
        end
    end
end)
