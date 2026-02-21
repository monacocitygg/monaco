RegisterNetEvent('antitank:headshotSurvived', function(victimId, attackerId, weaponHash)
    if not Config.Antitank.Enabled then return end

    local src = source

    -- valida que quem mandou o evento eh realmente o atacante
    if src ~= attackerId then
        if Config.Antitank.Debug then
            print(('[ANTI-TANK] Evento rejeitado: source %d != atacante %d'):format(src, attackerId))
        end
        return
    end

    -- checa se a vitima ta online
    local victimPed = GetPlayerPed(victimId)
    if not victimPed or victimPed == 0 then return end

    -- mata o player que tankou o hs
    SetEntityHealth(victimPed, 0)

    if Config.Antitank.Debug then
        local victimName = GetPlayerName(victimId) or 'Desconhecido'
        local attackerName = GetPlayerName(attackerId) or 'Desconhecido'
        print(('[ANTI-TANK] %s (ID: %d) foi morto por tankar HS de %s (ID: %d) | weapon: %s'):format(
            victimName, victimId, attackerName, attackerId, weaponHash
        ))
    end
end)
