local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local function hasPermission(passport)
    return vRP.HasGroup(passport,"Admin")
end

RegisterCommand("monacogames", function(source)
    local passport = vRP.Passport(source)
    if not passport or not hasPermission(passport) then
        TriggerClientEvent("Notify", source, "vermelho", "Sem permissão.", 5000)
        return
    end
    local ped = GetPlayerPed(source)
    if ped and ped ~= 0 then
        local coords = GetEntityCoords(ped)
        TriggerClientEvent("monacogames:addBlip", -1, coords.x, coords.y, coords.z)
        TriggerClientEvent("Notify",-1,"ilegal","O Monaco Games está começando! Verifique a área no mapa. Duração de 1 minuto.",30000)

        Citizen.CreateThread(function()
            Citizen.Wait(60000)

            TriggerClientEvent("monacogames:removeBlip", -1)
            TriggerClientEvent("Notify",-1,"verde","O Monaco Games finalizou e o God Area foi aplicado na zona!",10000)

            local players = vRP.Players()
            local count = 0
            for user_id,player_source in pairs(players) do
                local player_ped = GetPlayerPed(player_source)
                if player_ped and player_ped ~= 0 then
                    local player_coords = GetEntityCoords(player_ped)
                    local distance = #(coords - player_coords)
                    if distance <= 250.0 then
                        vRP.UpgradeThirst(user_id,100)
                        vRP.UpgradeHunger(user_id,100)
                        vRP.DowngradeStress(user_id,100)
                        vRP.Revive(player_source,200)
                        TriggerClientEvent("paramedic:Reset",player_source)
                        TriggerClientEvent("Notify",player_source,"verde","Você recebeu o buff do Monaco Games!",5000)
                    end
                end
                
                count = count + 1
                if count % 10 == 0 then
                    Citizen.Wait(1)
                end
            end
        end)
    end
end)

RegisterCommand("monacogamesrem", function(source)
    local passport = vRP.Passport(source)
    if not passport or not hasPermission(passport) then
        TriggerClientEvent("Notify", source, "vermelho", "Sem permissão.", 5000)
        return
    end
    TriggerClientEvent("monacogames:removeBlip", -1)
end)
