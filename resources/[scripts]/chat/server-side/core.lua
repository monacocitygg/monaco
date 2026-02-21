-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:SERVERMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chat:ServerMessage")
AddEventHandler("chat:ServerMessage", function(Tags, Message)
    local source = source
    local Passport = vRP.Passport(source)
     if Passport then
        if not vRP.Groups()[Tags] then
            if "ooc" == Tags then
            local Identity = vRP.Identity(Passport)
            local Messages = Message:gsub("[<>]","")

            local Players = vRPC.ClosestPeds(source,10)
            for _, v in pairs(Players) do
                async(function()
                TriggerClientEvent("chat:ClientMessage", v, Identity["name"].. " " ..Identity["name2"], Messages, Tags)
                end)
            end
            else
            TriggerClientEvent("chat:ClientMessage", -1, vRP.Identity((vRP.Passport(source))).name .. " " .. vRP.Identity((vRP.Passport(source))).name2, Message.gsub(Message, "[<>]", ""), Tags)
            end
        elseif vRP.HasService(vRP.Passport(source),Tags) then
            local Identity = vRP.Identity(Passport)
            for _, v in pairs((vRP.NumPermission(Tags))) do
            async(function()
                TriggerClientEvent("chat:ClientMessage", v, Identity["name"].. " " ..Identity["name2"], Message.gsub(Message, "[<>]", ""), Tags)
            end)
            end
        end
    end
end)