
local restrain = false

debugFunction = function(...)
    if debugMode() then
        print("^4[ PR0XY-AM ]^0 ".. ...)
    end
end

function CheckEquippedWeapon(player)
    local ped = GetPlayerPed(player)
    return GetSelectedPedWeapon(ped)
end

function StartWeaponCheckLoop(playerData)
    while restrain do

        local currentWeapon  = CheckEquippedWeapon(PlayerId())
        local allowedWeapons = Restrain:isWeaponAllowed(currentWeapon)
    
        if currentWeapon ~= GetHashKey("WEAPON_UNARMED") and not allowedWeapons.push  then
            debugFunction("O jogador pegou uma arma na mão")
            debugFunction('Hash: '.. currentWeapon)
            SetCurrentPedWeapon(PlayerPedId(), "WEAPON_UNARMED", true)    
        end

        if not allowedWeapons.attack then
            DisablePlayerFiring(player, true)
            DisableControlAction(0, 140)
            DisableControlAction(0, 141)
        end

        Citizen.Wait(1)
    end
end

function ProcessServerData(data)
    local receivedData = json.decode(data)

    if not receivedData.dataPlayer then return end

    debugFunction("Source: " .. receivedData.sourcePlayer)
    debugFunction("ID: " .. receivedData.userId)
    debugFunction("Dados: " .. tostring(receivedData.dataPlayer.dvalue))

    local playerData = json.decode(tostring(receivedData.dataPlayer.dvalue))
    if playerData and playerData.blocked then
        restrain = true
        StartWeaponCheckLoop(playerData)
    end

    if playerData and playerData.blocked == false then
        restrain = false
    end

end

Citizen.CreateThread(function()
    print("^4[ Tz - RESTRAIN ]^0 Iniciado.")
    TriggerServerEvent("proxy:playerCheck")

    RegisterNetEvent("proxy:playerCheck")
    AddEventHandler("proxy:playerCheck", ProcessServerData)
end)