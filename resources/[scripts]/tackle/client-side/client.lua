local anim <const> = "dive_run_fwd_-45_loop"
local dict <const> = "swimming@first_person@diving"
local function GetForwardPed()
    local plyCds = GetEntityCoords(ply)
    local targetCds = GetOffsetFromEntityInWorldCoords(ply, 0.0, 2.0, 0.0)
    local shapeTest = StartShapeTestLosProbe(plyCds, targetCds, 4, ply, 7)
    local timeout = GetGameTimer() + 250
    local result, hit, entityCds, _, entity
    repeat
        result, hit, entityCds, _, entity = GetShapeTestResult(shapeTest)
        Wait(0)
    until hit ~= 0 or GetGameTimer() > timeout
    return result == 2 and hit and entity
end


local function Tackle()
    ply = PlayerPedId()
    plyVeh = GetVehiclePedIsIn(ply, false)
    plyInWorld = not IsPlayerSwitchInProgress() and not IsPedDeadOrDying(ply, true)
    while plyVeh == 0 and plyInWorld do
        if IsControlPressed(0, 38) and (IsPedRunning(ply) or IsPedSprinting(ply)) and not IsPedSwimming(ply) then
            local forwardPed = GetForwardPed()
            if forwardPed and IsEntityAPed(forwardPed) then
                if IsPedAPlayer(forwardPed) then TriggerServerEvent("tackle:Update", GetPlayerServerId(NetworkGetPlayerIndexFromPed(forwardPed))) end
                if not IsPedRagdoll(ply) then
                    LoadAnimDict(dict)
                    if not IsEntityPlayingAnim(ply, dict, anim, 3) then TaskPlayAnim(ply, dict, anim, 8.0, -8, -1, 49, 0, 0, 0, 0) end
                    local t = GetNetworkTime() + 300
                    while GetNetworkTime() < t do Wait(100) end
                    ClearPedSecondaryTask(ply)
                    SetPedToRagdoll(ply, 1000, 1000, 0, 0, 0, 0)
                    t = GetNetworkTime() + 3000
                    while GetNetworkTime() < t do Wait(250) end
                end
            end
        end
        Wait(100)
    end
end


Citizen.CreateThread(function()
    while true do
        Wait(500)
        ply = PlayerPedId()
        plyVeh = GetVehiclePedIsIn(ply, false)
        plyInWorld = not IsPlayerSwitchInProgress() and not IsPedDeadOrDying(ply, true)
        if plyVeh == 0 and plyInWorld then
            Tackle()
        end
    end
end)

RegisterNetEvent("tackle:Player")
AddEventHandler("tackle:Player", function()
    local myPed = PlayerPedId()
    SetPedToRagdoll(myPed, 5000, 5000, 0, false, false, false)
    TriggerEvent("inventory:Cancel")
end)