-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
local Salary = {}
local websalario = "https://discord.com/api/webhooks/1223798200507433021/9yvG0K32LI1Vmn6PcUpgfokTimEofdfeGHtk_C24Qi8YYiHmUQ9Epx__TBfSGPJk1Z4O"
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetHierarchy(Passport,Permission)
    local Data = vRP.DataGroups(Permission)

    if Data[Passport] then
        return Data[Passport]
    end 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALARY:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Salary:Add",function(Passport,Permission)
    if not Salary[Permission] then
        Salary[Permission] = {}
    end
    if not Salary[Permission][Passport] then
        Salary[Permission][Passport] = os.time() + SalarySeconds
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALARY:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Salary:Remove",function(Passport,Permission)
    if Permission then
        if Salary[Permission] and Salary[Permission][Passport] then
            Salary[Permission][Passport] = nil
        end
    else
        for k, v in pairs(Salary) do
            if Salary[k][Passport] then
                Salary[k][Passport] = nil
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(SalarySeconds * 1000)
        for k, v in pairs(Salary) do
            for Passport, Sources in pairs(Salary[k]) do
                local level = vRP.GetHierarchy(Passport,k)
                Salary[k][Passport] = os.time() + SalarySeconds
                if vRP.HasGroup(Passport,k,level) then
                    if Groups[k] and Groups[k]["Salary"][level] and vRP.HasService(Passport,k) then
                        vRP.GiveBank(Passport,Groups[k]["Salary"][level])
                        TriggerClientEvent("Notify",Sources,"verde","Recebeu $"..Groups[k]["Salary"][level].." de salario [ "..k.." ]",15000)
                        SendWebhookMessage(websalario,"**Passaporte:** " .. Passport .. "\n Recebeu $"..Groups[k]["Salary"][level].." de salario [ "..k.." ]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                    end
                else
                    Salary[k][Passport] = nil
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
    for k,v in pairs(Salary) do
        if Salary[k][Passport] then
            Salary[k][Passport] = nil
        end
    end
end)