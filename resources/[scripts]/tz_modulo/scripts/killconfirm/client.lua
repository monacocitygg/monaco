-- estado do marcador de kill na tela
local killConfirmActive = false
local killConfirmStart = 0

-- guarda os peds que o jogador local deu dano recentemente
-- usado pra checar se morreram mesmo quando isFatal falha
local damagedPlayers = {}

-- desenha um ponto (retangulo pequeno) na tela
-- px, py = posicao normalizada (0.0 a 1.0), w = largura do ponto
local function drawPoint(px, py, w, r, g, b, a)
    DrawRect(px, py, w, w, r, g, b, a)
end

-- renderiza o X no centro da tela usando pontos ao longo das diagonais
-- alpha controla a transparencia geral (0.0 a 1.0) pro efeito de fade
local function drawKillCross(alpha)
    local cfg = Config.KillConfirm
    local size = cfg.CrossSize
    local thickness = cfg.LineWidth / 1920.0
    local r, g, b = cfg.Color.r, cfg.Color.g, cfg.Color.b
    local a = math.floor(cfg.Color.a * alpha)

    local cx, cy = 0.5, 0.5
    local steps = 24

    -- diagonal \ (canto superior esquerdo -> canto inferior direito)
    for i = 0, steps do
        local t = i / steps
        local px = cx - size + (size * 2) * t
        local py = cy - size + (size * 2) * t
        drawPoint(px, py, thickness, r, g, b, a)
    end

    -- diagonal / (canto superior direito -> canto inferior esquerdo)
    for i = 0, steps do
        local t = i / steps
        local px = cx + size - (size * 2) * t
        local py = cy - size + (size * 2) * t
        drawPoint(px, py, thickness, r, g, b, a)
    end
end

-- notifica o kill pro server
local function reportKill(victimServerId)
    if victimServerId <= 0 then return end

    if Config.KillConfirm.Debug then
        print(('[KILL-CONFIRM] Kill detectado -> vitima server id: %d'):format(victimServerId))
    end

    TriggerServerEvent('killconfirm:reportKill', victimServerId)
end

-- detecta dano e morte entre players
-- usa CEventNetworkEntityDamage pra pegar tanto kills instantaneos (isFatal)
-- quanto danos que resultam em morte logo depois (fallback)
AddEventHandler('gameEventTriggered', function(name, args)
    if not Config.KillConfirm.Enabled then return end
    if name ~= 'CEventNetworkEntityDamage' then return end

    local victim = args[1]
    local attacker = args[2]
    local isFatal = args[6]

    if attacker ~= PlayerPedId() then return end
    if not DoesEntityExist(victim) then return end
    if not IsEntityAPed(victim) then return end
    if not IsPedAPlayer(victim) then return end

    local victimServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
    if victimServerId <= 0 then return end

    -- se o evento ja diz que foi fatal, reporta direto
    if isFatal == 1 then
        reportKill(victimServerId)
        damagedPlayers[victimServerId] = nil
        return
    end

    -- se nao foi fatal, registra que esse player levou dano do jogador local
    -- a thread de verificacao vai checar se ele morreu
    damagedPlayers[victimServerId] = {
        ped = victim,
        time = GetGameTimer()
    }
end)

-- thread que verifica se players que levaram dano acabaram morrendo
-- resolve o caso onde isFatal nao dispara corretamente
CreateThread(function()
    while true do
        Wait(100)
        if not Config.KillConfirm.Enabled then goto skip end

        local now = GetGameTimer()
        for serverId, data in pairs(damagedPlayers) do
            -- descarta entradas com mais de 2 segundos (dano antigo demais)
            if (now - data.time) > 2000 then
                damagedPlayers[serverId] = nil
            elseif DoesEntityExist(data.ped) and IsEntityDead(data.ped) then
                reportKill(serverId)
                damagedPlayers[serverId] = nil
            end
        end

        ::skip::
    end
end)

-- recebe a confirmacao do server de que o kill foi valido
RegisterNetEvent('killconfirm:show', function()
    if not Config.KillConfirm.Enabled then return end

    killConfirmActive = true
    killConfirmStart = GetGameTimer()

    if Config.KillConfirm.Debug then
        print('[KILL-CONFIRM] Marcador ativado.')
    end
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

                -- fade out gradual nos ultimos 40% da duracao
                if cfg.FadeOut then
                    local fadeStart = duration * 0.6
                    if elapsed > fadeStart then
                        alpha = 1.0 - ((elapsed - fadeStart) / (duration - fadeStart))
                    end
                end

                drawKillCross(alpha)
            end

            Wait(0)
        else
            Wait(200)
        end
    end
end)
