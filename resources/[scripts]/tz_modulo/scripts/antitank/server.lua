RegisterNetEvent('antitank:headshot', function(victimId, attackerId, weaponHash)
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

    local victimName = GetPlayerName(victimId) or 'Desconhecido'
    local attackerName = GetPlayerName(attackerId) or 'Desconhecido'

    if Config.Antitank.Debug then
        print(('[ANTI-TANK] %s (ID: %d) levou HS/Pescoco de %s (ID: %d) | weapon: %s'):format(
            victimName, victimId, attackerName, attackerId, weaponHash
        ))
    end

    -- mata via vRP direto
    local user_id = Framework:userId(victimId)

    if Config.Antitank.Debug then
        print(('[ANTI-TANK] user_id: %s | victimId: %d'):format(tostring(user_id), victimId))
    end

    if user_id then
        if Config.Antitank.Debug then
            print(('[ANTI-TANK] %s (ID: %d) antitank:checkKill enviado.'):format(victimName, victimId))
        end
        TriggerClientEvent('antitank:checkKill', victimId)
    end
end)
