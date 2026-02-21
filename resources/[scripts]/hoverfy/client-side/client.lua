-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local hoverCoords = {}
local hoverNumbers = 0
local hoverLocates = {}
local hoverInsert = false
local playerActive = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- GRIDCHUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function gridChunk(x)
    return math.floor((x + 8192) / 128)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOCHANNEL
-----------------------------------------------------------------------------------------------------------------------------------------
function toChannel(v)
    return (v["x"] << 8) | v["y"]
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGRIDZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function getGridzone(x, y)
    local gridChunk = vector2(gridChunk(x), gridChunk(y))
    return toChannel(gridChunk)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DEADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local timeDistance = 999
        if LocalPlayer["state"]["Active"] then
            local ply = PlayerPedId()
            if not IsPedInAnyVehicle(ply) then
                if not hoverInsert then
                    local coords = GetEntityCoords(ply)
                    local gridZone = getGridzone(coords["x"], coords["y"])
                    if hoverLocates[gridZone] then
                        for _, v in pairs(hoverLocates[gridZone]) do
                            local distance = #(coords - vector3(v["x"], v["y"], v["z"]))
                            if distance < v["distance"] then
                                SendNUIMessage({ show = true, key = v["key"], title = v["title"], legend = v["legend"] })
                                hoverCoords = { v["x"], v["y"], v["z"], v["distance"] }
                                hoverInsert = true
                            end
                        end
                    end
                end
            end
            if hoverInsert then
                local coords = GetEntityCoords(ply)
                local distance = #(coords - vector3(hoverCoords[1], hoverCoords[2], hoverCoords[3]))
                if distance > hoverCoords[4] then
                    SendNUIMessage({ show = false })
                    hoverInsert = false
                    timeDistance = 100
                end
            end
        end
        Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOVERFY:INSERTTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hoverfy:Insert")
AddEventHandler("hoverfy:Insert", function(innerTable)
    for _, v in pairs(innerTable) do
        local gridZone = getGridzone(v[1], v[2])
        if hoverLocates[gridZone] == nil then
            hoverLocates[gridZone] = {}
        end
        hoverNumbers = hoverNumbers + 1
        hoverLocates[gridZone][hoverNumbers] = {
            x = v[1],
            y = v[2],
            z = v[3],
            distance = v[4],
            key = v[5],
            title = v[6],
            legend = v[7]
        }
    end
end)
