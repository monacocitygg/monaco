local anim <const> = "dive_run_fwd_-45_loop"
local dict <const> = "swimming@first_person@diving"
local tackleCooldown = 0

local function LoadDict(d)
    if not HasAnimDictLoaded(d) then
        RequestAnimDict(d)
        local timeout = GetGameTimer() + 1000
        while not HasAnimDictLoaded(d) and GetGameTimer() < timeout do
            Wait(0)
        end
    end
end

local function GetForwardPed()
    local plyCds = GetEntityCoords(ply)
    local targetCds = GetOffsetFromEntityInWorldCoords(ply, 0.0, 3.0, 0.0)
    local shapeTest = StartShapeTestLosProbe(plyCds, targetCds, 12, ply, 7)
    local timeout = GetGameTimer() + 500
    local result, hit, entityCds, _, entity
    repeat
        result, hit, entityCds, _, entity = GetShapeTestResult(shapeTest)
        Wait(0)
    until result ~= 1 or GetGameTimer() > timeout
    if result == 2 and hit == 1 and entity and entity ~= 0 then
        return entity
    end
    return nil
end


Citizen.CreateThread(function()
    while true do
        Wait(0)
        ply = PlayerPedId()
        local plyVeh = GetVehiclePedIsIn(ply, false)
        local plyInWorld = not IsPlayerSwitchInProgress() and not IsPedDeadOrDying(ply, true)
        if plyVeh == 0 and plyInWorld and not IsPedSwimming(ply) and not IsPedRagdoll(ply) and GetGameTimer() > tackleCooldown then
            if IsControlPressed(0, 38) and (IsPedRunning(ply) or IsPedSprinting(ply)) then
                local forwardPed = GetForwardPed()
                if forwardPed and IsEntityAPed(forwardPed) and IsPedAPlayer(forwardPed) then
                    tackleCooldown = GetGameTimer() + 5000
                    TriggerServerEvent("tackle:Update", GetPlayerServerId(NetworkGetPlayerIndexFromPed(forwardPed)))
                    LoadDict(dict)
                    TaskPlayAnim(ply, dict, anim, 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                    Wait(300)
                    ClearPedSecondaryTask(ply)
                    SetPedToRagdoll(ply, 1000, 1000, 0, 0, 0, 0)
                    Wait(3000)
                end
            else
                Wait(100)
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent("tackle:Player")
AddEventHandler("tackle:Player", function()
    local myPed = PlayerPedId()
    SetPedToRagdoll(myPed, 5000, 5000, 0, false, false, false)
    TriggerEvent("inventory:Cancel")
end)