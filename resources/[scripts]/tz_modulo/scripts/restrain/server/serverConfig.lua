Restrain = {}


if IsDuplicityVersion() then
    function Restrain:CommandRestrain()
        return "amarrar"  -- amarrar id time | Exemplo time 1d = 1 dia, 1h = 1 hora, 1m = 1 minuto, pode ser combinado. Exp: /amarrar id 15d25h12m = 15 dias 25 horas e 12 minutos
    end
    
    function Restrain:CommandRemoveRestrain()
        return "ramarrar"
    end

    function Restrain:Permissions(user_id, source)
        if source == 0 then return true end
        if(Framework:hasPermission(user_id,"Admin")) then return true else Restrain:errorNotify(source, "Você não tem permissão para usar este comando.") end
    end

    function Restrain:spawnEvent()
        return "Connect"
    end

    function Restrain:WebhookUrl()
        return "" -- WebhookUrl
    end

    function Restrain:successNotify(source, mensagem) return TriggerClientEvent("Notify",source,"verde",mensagem,5000) end
    function Restrain:errorNotify(source, mensagem) return TriggerClientEvent("Notify",source,"vermelho",mensagem,5000) end
    function Restrain:infoNotify(source, mensagem) return TriggerClientEvent("Notify",source,"amarelo",mensagem,5000) end

end
