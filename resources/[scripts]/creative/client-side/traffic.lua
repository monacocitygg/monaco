local convarInt = 200
local onlinePlayers = 10
local crowdDensity = 1.0
local trafficDensity = 0.2
local crowdScaling = true
local crowdDensitivity = true
local trafficDensitivity = true
local trafficScaling = true
local nCrowd = crowdDensity - (onlinePlayers / convarInt / (2 / crowdDensity))
local nTraff = trafficDensity - (onlinePlayers / convarInt / (2 / trafficDensity))

if trafficDensitivity then
    nTraff = trafficDensity - ( onlinePlayers / convarInt / ( 2 / trafficDensity ) )
end

if trafficDensitivity or crowdDensitivity then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10000)
            local coords = GetEntityCoords(GetPlayerPed(-1),false)
            if coords["z"] < -100.0 then
                if crowdDensitivity then 
                    nCrowd = 0.0 
                end

                if trafficDensitivity then
                    nTraff = 0.0 
                end
            else
                if trafficDensity or crowdDensitivity then
                    if crowdScaling or trafficScaling then
                        onlinePlayers = 0
                        for i = 0, 63 do
                            if NetworkIsPlayerActive(i) then
                                onlinePlayers = onlinePlayers + 1
                            end
                        end

                        if crowdDensitivity then
                            nCrowd = crowdDensity - (onlinePlayers / convarInt / (2 / crowdDensity))
                            nCrowd = math.max(0.5, math.min(1.0, nCrowd))
                        end

                        if trafficDensitivity then
                            nTraff = trafficDensity - (onlinePlayers / convarInt / (2 / trafficDensity))
                            nTraff = math.max(0.05, math.min(1.0, nTraff))
                        end
                    end
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
    local player = GetPlayerPed(-1)
    while true do
        Citizen.Wait(0)

        if crowdDensitivity then 
            if crowdScaling then
                SetPedDensityMultiplierThisFrame(nCrowd)  
                SetScenarioPedDensityMultiplierThisFrame(nCrowd,nCrowd)
            else 
                local d = math.max(0.05, math.min(1.0, crowdDensity))
                SetPedDensityMultiplierThisFrame(d)
                SetScenarioPedDensityMultiplierThisFrame(d,d)
            end
        end
  
        if trafficDensitivity then
            if trafficScaling then
                SetVehicleDensityMultiplierThisFrame(nTraff)
                SetRandomVehicleDensityMultiplierThisFrame(nTraff)
                SetParkedVehicleDensityMultiplierThisFrame(nTraff)
            else
                local t = math.max(0.05, math.min(1.0, trafficDensity))
                SetVehicleDensityMultiplierThisFrame(t)
                SetRandomVehicleDensityMultiplierThisFrame(t)
                SetParkedVehicleDensityMultiplierThisFrame(t)
            end
        end
    end
end)

local cayoPeds = {}
local maxCayoPeds = 20
local cayoVehs = {}
local maxCayoVehs = 15

local function isInCayoArea(coords)
    return coords.x > 4500.0 and coords.x < 6000.0 and coords.y < -3800.0 and coords.y > -7000.0
end

local function requestModel(hash)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local tries = 0
        while not HasModelLoaded(hash) and tries < 50 do
            Citizen.Wait(100)
            tries = tries + 1
        end
    end
    return HasModelLoaded(hash)
end

local pedModels = {
    GetHashKey("a_m_y_beach_01"),
    GetHashKey("a_m_m_beach_01"),
    GetHashKey("a_f_y_beach_01"),
    GetHashKey("a_m_y_beachvesp_01"),
    GetHashKey("a_m_o_beach_01")
}
local vehicleModels = {
    GetHashKey("squaddie"),
    GetHashKey("blazer"),
    GetHashKey("dune"),
    GetHashKey("rebel")
}
-- modelos de ruas permanecem padrão do jogo

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,false)

        if isInCayoArea(coords) then
            local target = math.min(maxCayoPeds, 5 + math.floor(onlinePlayers / 2))
            local targetVeh = math.min(maxCayoVehs, 4 + math.floor(onlinePlayers / 3))
            -- continente: sem gerador custom
            for i = #cayoPeds, 1, -1 do
                local p = cayoPeds[i]
                if not DoesEntityExist(p) or #(GetEntityCoords(p) - coords) > 250.0 then
                    if DoesEntityExist(p) then
                        DeleteEntity(p)
                    end
                    table.remove(cayoPeds,i)
                end
            end
            for i = #cayoVehs, 1, -1 do
                local v = cayoVehs[i]
                if not v or not DoesEntityExist(v.veh) or #(GetEntityCoords(v.veh) - coords) > 350.0 then
                    if v then
                        if v.ped and DoesEntityExist(v.ped) then
                            DeleteEntity(v.ped)
                        end
                        if v.veh and DoesEntityExist(v.veh) then
                            DeleteEntity(v.veh)
                        end
                    end
                    table.remove(cayoVehs,i)
                end
            end

            if #cayoPeds < target then
                local spawnHash = pedModels[math.random(1,#pedModels)]
                if requestModel(spawnHash) then
                    local offset = vector3(coords.x + math.random(-60,60), coords.y + math.random(-60,60), coords.z + 10.0)
                    local ok, groundZ = GetGroundZFor_3dCoord(offset.x, offset.y, offset.z, 0)
                    local scOk, safePos = GetSafeCoordForPed(offset.x, offset.y, groundZ or coords.z, true, 0)
                    local sx = scOk and safePos.x or offset.x
                    local sy = scOk and safePos.y or offset.y
                    local sz = scOk and safePos.z or (groundZ or coords.z)

                    local newPed = CreatePed(4, spawnHash, sx, sy, sz, math.random(0,360), true, true)
                    if DoesEntityExist(newPed) then
                        SetEntityAsMissionEntity(newPed,true,true)
                        SetPedCanRagdoll(newPed,true)
                        SetBlockingOfNonTemporaryEvents(newPed,false)
                        if SetEntityDistanceCullingRadius then
                            SetEntityDistanceCullingRadius(newPed,200.0)
                        end
                        TaskWanderStandard(newPed,10.0,10)
                        table.insert(cayoPeds,newPed)
                    end
                    SetModelAsNoLongerNeeded(spawnHash)
                end
            end
            while #cayoVehs < targetVeh do
                local vHash = vehicleModels[math.random(1,#vehicleModels)]
                local pHash = pedModels[math.random(1,#pedModels)]
                local vReady = requestModel(vHash)
                local pReady = requestModel(pHash)
                if vReady and pReady then
                    local offset = vector3(coords.x + math.random(-120,120), coords.y + math.random(-120,120), coords.z + 10.0)
                    local ok, groundZ = GetGroundZFor_3dCoord(offset.x, offset.y, offset.z, 0)
                    local sx = offset.x
                    local sy = offset.y
                    local sz = groundZ or coords.z
                    local v = CreateVehicle(vHash, sx, sy, sz, math.random(0,360), true, true)
                    if DoesEntityExist(v) then
                        SetEntityAsMissionEntity(v,true,true)
                        SetVehicleOnGroundProperly(v)
                        local d = CreatePed(4, pHash, sx, sy, sz, math.random(0,360), true, true)
                        if DoesEntityExist(d) then
                            SetEntityAsMissionEntity(d,true,true)
                            TaskWarpPedIntoVehicle(d, v, -1)
                            SetPedCanRagdoll(d,true)
                            SetBlockingOfNonTemporaryEvents(d,false)
                            TaskVehicleDriveWander(d, v, 12.0, 786603)
                            table.insert(cayoVehs,{ veh = v, ped = d })
                        else
                            DeleteEntity(v)
                        end
                    end
                    SetModelAsNoLongerNeeded(vHash)
                    SetModelAsNoLongerNeeded(pHash)
                else
                    break
                end
            end
        else
            for i = #cayoPeds, 1, -1 do
                local p = cayoPeds[i]
                if DoesEntityExist(p) then
                    DeleteEntity(p)
                end
                table.remove(cayoPeds,i)
            end
            for i = #cayoVehs, 1, -1 do
                local v = cayoVehs[i]
                if v then
                    if v.ped and DoesEntityExist(v.ped) then
                        DeleteEntity(v.ped)
                    end
                    if v.veh and DoesEntityExist(v.veh) then
                        DeleteEntity(v.veh)
                    end
                end
                table.remove(cayoVehs,i)
            end
        end
    end
end)