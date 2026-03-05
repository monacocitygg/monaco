functions = {
    getUserId = function(source)
        return vRP.Passport(source)
    end,

    user_id = function(source)
        return vRP.Passport(source)
    end,

    hasPermission = function(user_id, permission)
        return vRP.HasPermission(user_id, permission)
    end,

    getUsersByPermission = function(permission)
        local users = {}
        local sources = vRP.Players()
        for _, user_id in pairs(sources) do
            if vRP.HasService(user_id, permission) then
                table.insert(users, user_id)
            end
        end

        return users
    end,

    paymentfull = function(user_id, amount)
        return vRP.PaymentFull(user_id, amount)
    end,

    revive = function(source)
        if source then
            vRP.Revive(source, 101)
            TriggerClientEvent("Notify", source, "verde", "Tratamento iniciado.", 5000)

            Citizen.CreateThread(function()
                local Vida = 101
                while Vida < 200 and GetPlayerPed(source) do
                    Citizen.Wait(1000)
                    Vida = Vida + 1
                    vRP.Revive(source, Vida)
                end

                TriggerClientEvent("paramedic:Reset", source)
                TriggerClientEvent("Notify", source, "verde", "Tratamento concluido.", 5000)
            end)
        end
    end,

    NotifyMedicInService = function(source)
        TriggerClientEvent("Notify", source, "vermelho", "Existem paramédicos em serviço!", 5000)
    end,

    NotifyNoMoney = function(source)
        TriggerClientEvent("Notify", source, "vermelho", "Você não possui <b>dólares</b> suficientes.", 5000)
    end,

    NotifyAmbulanceComing = function()
        TriggerEvent("Notify", "amarelo", "A ambulância está a caminho.", 5000)
    end,

    NotifyNoPermission = function()
        TriggerEvent("Notify", "amarelo", "Você não pode usar esse comando.", 5000)
    end
}