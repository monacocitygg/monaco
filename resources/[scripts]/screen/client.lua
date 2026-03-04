RegisterNetEvent("screen:openUI")
AddEventHandler("screen:openUI", function(name, surname, playerId)
    print("[CLIENT] Evento recebido: screen:openUI", name, surname, playerId)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openUI",
        name = name,
        surname = surname,
        id = playerId
    })
end)


RegisterNetEvent("screen:closeUI")
AddEventHandler("screen:closeUI", function()
    SetNuiFocus(false, false) -- Bloqueia o mouse novamente
    SendNUIMessage({ action = "closeUI" })
end)

RegisterCommand("vertela", function()
    local name = "Teste"
    local surname = "Design"
    local playerId = 1234
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openUI",
        name = name,
        surname = surname,
        id = playerId
    })
    print("Modo de visualização do design ativado.")
end)

RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
    cb("ok")
end)

RegisterCommand("xcx", function()
    print(LocalPlayer.state.InWeapon)
end)