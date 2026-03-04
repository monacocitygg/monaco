local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

local telando = {}
local BAN_TIME_DEFAULT = 999 -- dias padrão para ban automático

RegisterCommand("telar", function(source, args, rawCommand)
    local StaffPassport = vRP.Passport(source)

    if StaffPassport and (vRP.HasGroup(StaffPassport, "Admin", 1) or vRP.HasGroup(StaffPassport, "Moderador") or  vRP.HasGroup(StaffPassport, "Suporte")  or  vRP.HasGroup(StaffPassport, "Head") or  vRP.HasGroup(StaffPassport, "Var") ) then
        local targetPassport = tonumber(args[1])
        if not targetPassport then
            TriggerClientEvent("Notify", source, "negado", "Informe o ID do passaporte corretamente.")
            return
        end

        local targetSource = vRP.Source(targetPassport)
        if not targetSource then
            TriggerClientEvent("Notify", source, "negado", "Jogador offline ou não encontrado.")
            return
        end

        local identity = vRP.Identity(targetPassport)
        if identity then
            local name = identity.name or "Jogador"
            local surname = identity.name2 or "Desconhecido"

            TriggerClientEvent("screen:openUI", targetSource, name, surname, targetPassport)

            telando[targetPassport] = true

            -- Log para o console
            print("[SCREEN] O jogador com source " .. source .. " (passaporte " .. StaffPassport .. ") está telando o passaporte " .. targetPassport)

            -- Log para o Discord
            TriggerEvent("Discord", "Telagem", 
                "**Staff:** "..StaffPassport..
                "\n**Source:** "..source..
                "\n**Telando o passaporte:** "..targetPassport..
                "\n**Horário:** "..os.date("%H:%M:%S"), 
            3092790) -- ID do webhook ou canal

        else
            TriggerClientEvent("Notify", source, "negado", "Identidade não encontrada.")
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para usar este comando.")
    end
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    local passport = vRP.Passport(source)

    if passport and telando[passport] then
        telando[passport] = nil

        -- Envia log pro Discord
        TriggerEvent("Discord", "Telagem2", 
            "**Passaporte:** " .. passport .. " **quitou durante a telagem.**" ..
            "\n**Horário:** " .. os.date("%H:%M:%S"), 
            3092790 -- ID do webhook ou canal
        )

        -- Busca identidade
        local identity = vRP.Identity(passport)
        if identity and identity.license then
            local token = identity.token or "" -- Token pode ser nulo
            vRP.Query("banneds/InsertBanned", {
                license = identity.license,
                token = token,
                time = BAN_TIME_DEFAULT
            })

            -- print("[SCREEN] Passaporte " .. passport .. " banido por " .. BAN_TIME_DEFAULT .. " dias (quitou telado).")
        end
    end
end)


RegisterCommand("cancelartela", function(source, args)
    local StaffPassport = vRP.Passport(source)

    if StaffPassport and (vRP.HasGroup(StaffPassport, "Admin",1) or vRP.HasGroup(StaffPassport, "Moderador") or vRP.HasGroup(StaffPassport, "Suporte") or  vRP.HasGroup(StaffPassport, "Head") ) then
        local targetPassport = tonumber(args[1])
        if not targetPassport then
            TriggerClientEvent("Notify", source, "negado", "Informe o ID do passaporte corretamente.")
            return
        end

        local targetSource = vRP.Source(targetPassport)
        if not targetSource then
            TriggerClientEvent("Notify", source, "negado", "Jogador offline ou não encontrado.")
            return
        end

        if telando[targetPassport] then
            telando[targetPassport] = nil -- Remove da lista
            TriggerClientEvent("screen:closeUI", targetSource)
            TriggerClientEvent("Notify", source, "sucesso", "Tela de telagem removida do passaporte " .. targetPassport)
           
        else
            TriggerClientEvent("Notify", source, "negado", "Jogador não está telado.")
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para usar este comando.")
    end
end)
