-- estado do marcador de kill na tela
local killConfirmActive = false
local killConfirmStart = 0

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

-- deteccao de kill via CEventNetworkEntityDamage
-- checa todo dano do jogador local em players, e apos um curto delay confirma se a vitima morreu
local pendingVictims = {}

AddEventHandler('gameEventTriggered', function(name, args)
    if not Config.KillConfirm.Enabled then return end
    if name ~= 'CEventNetworkEntityDamage' then return end

    local victim = args[1]
    local attacker = args[2]

    if attacker ~= PlayerPedId() then return end
    if not DoesEntityExist(victim) then return end
    if not IsEntityAPed(victim) then return end
    if not IsPedAPlayer(victim) then return end

    local victimServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
    if victimServerId <= 0 then return end

    -- evita criar multiplas threads pro mesmo alvo
    if pendingVictims[victimServerId] then return end
    pendingVictims[victimServerId] = true

    CreateThread(function()
        Wait(200)
        pendingVictims[victimServerId] = nil

        if DoesEntityExist(victim) and (IsEntityDead(victim) or IsPedFatallyInjured(victim)) then
            if Config.KillConfirm.Debug then
                print(('[KILL-CONFIRM] Kill confirmado -> vitima server id: %d'):format(victimServerId))
            end
            showKillMarker()
        end
    end)
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
