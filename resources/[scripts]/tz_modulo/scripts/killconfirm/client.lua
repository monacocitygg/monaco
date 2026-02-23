-- estado do marcador de kill na tela
local killConfirmActive = false
local killConfirmStart = 0


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

-- detecta quando o jogador local mata outro player
-- usa o evento nativo CEventNetworkEntityDamage com flag de morte
AddEventHandler('gameEventTriggered', function(name, args)
    if not Config.KillConfirm.Enabled then return end
    if name ~= 'CEventNetworkEntityDamage' then return end

    local victim = args[1]
    local attacker = args[2]
    local isFatal = args[6]

    -- so interessa se foi o jogador local que causou e se foi fatal
    if attacker ~= PlayerPedId() then return end
    if isFatal ~= 1 then return end
    if not IsPedAPlayer(victim) then return end

    local victimServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
    if victimServerId <= 0 then return end

    if Config.KillConfirm.Debug then
        print(('[KILL-CONFIRM] Kill detectado -> vitima server id: %d'):format(victimServerId))
    end

    -- avisa o server pra validar o kill
    TriggerServerEvent('killconfirm:reportKill', victimServerId)
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
