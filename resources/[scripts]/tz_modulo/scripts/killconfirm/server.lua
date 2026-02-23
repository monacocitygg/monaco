-- recebe o report de kill vindo do client e valida antes de confirmar
RegisterNetEvent('killconfirm:reportKill', function(victimServerId)
    if not Config.KillConfirm.Enabled then return end

    local attackerSrc = source

    -- validacao basica dos ids
    if not victimServerId or victimServerId <= 0 then return end
    if attackerSrc == victimServerId then return end

    -- checa se a vitima ta realmente online
    local victimName = GetPlayerName(victimServerId)
    local attackerName = GetPlayerName(attackerSrc)
    if not victimName or not attackerName then return end

    -- confirma que o ped da vitima existe e ta morto de verdade
    local victimPed = GetPlayerPed(victimServerId)
    if not victimPed or victimPed == 0 then return end

    if Config.KillConfirm.Debug then
        print(('[KILL-CONFIRM] %s (ID: %d) matou %s (ID: %d)'):format(
            attackerName, attackerSrc, victimName, victimServerId
        ))
    end

    -- manda pro atacante exibir o marcador de kill
    TriggerClientEvent('killconfirm:show', attackerSrc)
end)
