-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vSERVER = Tunnel.getInterface("catcafe_totem")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local nearTotem = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for i,loc in ipairs(Config.Locations) do
        exports["target"]:AddCircleZone("CatCafeTotem"..i,loc.coords,0.5,{
            name = "CatCafeTotem"..i,
            heading = 0.0
        },{
            shop = "CatCafeTotem"..i,
            Distance = 1.5,
            options = {
                {
                    event = "catcafe_totem:openMenu",
                    label = loc.label,
                    tunnel = "client"
                }
            }
        })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    Wait(1000)
    local hovers = {}
    for i,loc in ipairs(Config.Locations) do
        table.insert(hovers,{ loc.coords.x, loc.coords.y, loc.coords.z, 2.0, "E", "Totem", loc.label })
    end
    TriggerEvent("hoverfy:Insert",hovers)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD (KEY INTERACTION)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for i,loc in ipairs(Config.Locations) do
            local distance = #(coords - loc.coords)

            if distance <= 2.0 then
                timeDistance = 4
                
                if IsControlJustPressed(1,38) then
                    TriggerEvent("catcafe_totem:openMenu")
                end
            end
        end

        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("catcafe_totem:openMenu")
AddEventHandler("catcafe_totem:openMenu",function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for i,loc in ipairs(Config.Locations) do
        local distance = #(coords - loc.coords)
        if distance <= 2.0 then
            if vSERVER.checkAvailability(i) then
                SetNuiFocus(true,true)
                SendNUIMessage({ action = "open", items = loc.items })
            end
            break
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data,cb)
    SetNuiFocus(false,false)
    cb("ok")
end)

RegisterNUICallback("buy",function(data,cb)
    vSERVER.buyItems(data.cart)
    SetNuiFocus(false,false)
    cb("ok")
end)
