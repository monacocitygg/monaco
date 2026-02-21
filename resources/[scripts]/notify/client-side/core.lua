-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,mensagem,timer)
	SendNUIMessage({ css = css, mensagem = mensagem, timer = timer, notify = true })
end)

RegisterCommand("testeilegal", function()
    TriggerEvent("Notify", "ilegal", "Roubo em andamento na loja de conveniência.", 10000)
end)