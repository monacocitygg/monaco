-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 100
        local Ped = PlayerPedId()
        if not IsPedInAnyVehicle(Ped) and IsPedJumping(Ped) then
            TimeDistance = 1

            if IsControlJustReleased(1, 51) then
                local playerCoords = GetEntityCoords(Ped)
                local restrictedArea1 = vector3(169.53, -953.39, 30.09)
                local restrictedArea2 = vector3(-2785.1, -68.74, 18.82)
                local restrictedRadius = 250.0

                local inRestrictedArea1 = #(playerCoords - restrictedArea1) <= restrictedRadius
                local inRestrictedArea2 = #(playerCoords - restrictedArea2) <= restrictedRadius

                if not inRestrictedArea1 and not inRestrictedArea2 then
                    local Tackle = {}
                    local Coords = GetEntityForwardVector(Ped)

                    SetPedToRagdollWithFall(Ped, 2500, 1500, 0, Coords, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

                    while IsPedRagdoll(Ped) do
                        for _, v in ipairs(GetPlayers()) do
                            if not Tackle[v] then
                                Tackle[v] = true
                                TriggerEvent("inventory:Cancel")
                                TriggerServerEvent("tackle:Update", GetPlayerServerId(v), Coords)
                            end
                        end
                        Wait(1)
                    end
                else
                    TriggerEvent("Notify", "amarelo", "Você não pode usar essa animação aqui", 5000)
                end
            end
        end
        Wait(TimeDistance)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TACKLE:PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tackle:Player")
AddEventHandler("tackle:Player", function(Coords)
    SetPedToRagdollWithFall(PlayerPedId(), 5000, 5000, 0, Coords["x"], Coords["y"], Coords["z"], 10.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0)
    TriggerEvent("inventory:Cancel")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
    local Players = {}
    local Ped = PlayerPedId()

    for _, v in ipairs(GetActivePlayers()) do
        local OtherPed = GetPlayerPed(v)
        if IsEntityTouchingEntity(Ped, OtherPed) and not IsPedInAnyVehicle(OtherPed) and not IsEntityPlayingAnim(OtherPed, "amb@world_human_sunbathe@female@back@idle_a", "idle_a", 3) then
            Players[#Players + 1] = v
        end
    end

    return Players
end