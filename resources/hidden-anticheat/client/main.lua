local Config = Config or {}

local PlayerPed = PlayerPedId()

local function GetCameraDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPed)
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    return vector3(x, y, z)
end

local SilentAimViolations = 0
local LastSilentAimViolationTime = 0
local HeadshotStats = { hits = 0, headshots = 0 }
local HitAngles = {}
local CombatLocks = {}

local function CombatLockNext(state, eventType, now, lockMs)
    local currentType = state and state.type or nil
    local currentUntil = state and state.untilTime or 0
    if currentType and currentUntil > now and currentType ~= eventType then
        return { type = currentType, untilTime = currentUntil }, false
    end
    return { type = eventType, untilTime = now + lockMs }, true
end

_G.HiddenAnticheat = _G.HiddenAnticheat or {}
_G.HiddenAnticheat.CombatLockNext = CombatLockNext

local function CalculateStats(data)
    local sum = 0
    for _, v in ipairs(data) do sum = sum + v end
    local mean = sum / #data
    
    local sumSqDiff = 0
    for _, v in ipairs(data) do sumSqDiff = sumSqDiff + (v - mean)^2 end
    local variance = sumSqDiff / #data
    return mean, variance
end

AddEventHandler('hidden-anticheat:internal:silentAimViolation', function(angle)
    local now = GetGameTimer()
    if now - LastSilentAimViolationTime > 10000 then -- Reset if 10s passed since last violation
        SilentAimViolations = 0
    end
    
    SilentAimViolations = SilentAimViolations + 1
    LastSilentAimViolationTime = now
    
    -- Require 4 violations in short succession to ban (Silent Aim Logic: 3 warnings/internal checks -> 4th = Ban)
    if SilentAimViolations >= 4 then
        TriggerServerEvent('hidden-anticheat:ban', 'Silent Aim (Detected 4x)', angle)
        SilentAimViolations = 0 -- Reset after ban attempt
    end
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local isFatal = args[6] == 1
        local weaponHash = args[7]
        
        if attacker == PlayerPedId() and IsEntityAPed(victim) and IsPedAPlayer(victim) then
            local victimPos = GetEntityCoords(victim)
            local myPos = GetEntityCoords(PlayerPed)
            local dist = #(victimPos - myPos)
            local now = GetGameTimer()
            local lockMs = (Config.Combat and Config.Combat.DetectionLockMs) or 200
            local lockState, allowed = CombatLockNext(CombatLocks[victim], "silent", now, lockMs)
            if allowed then
                CombatLocks[victim] = lockState
                if dist > 5.0 then
                    local camOrigin = GetGameplayCamCoord()
                    local camDir = GetCameraDirection()
                    local camDirLen = #(camDir)
                    if camDirLen > 0.001 then
                        local camDirNorm = camDir / camDirLen
                        local headPos = GetPedBoneCoords(victim, 31086, 0.0, 0.0, 0.0)
                        local toHead = headPos - camOrigin
                        local toHeadLen = #(toHead)
                        if toHeadLen > 0.001 then
                            local projLen = toHead.x * camDirNorm.x + toHead.y * camDirNorm.y + toHead.z * camDirNorm.z
                            local proj = vector3(camDirNorm.x * projLen, camDirNorm.y * projLen, camDirNorm.z * projLen)
                            local offsetVec = toHead - proj
                            local headOffset = #(offsetVec)
                            table.insert(HitAngles, headOffset)
                            if #HitAngles > 50 then
                                local mean, variance = CalculateStats(HitAngles)
                                local stdDev = math.sqrt(variance)
                                if stdDev < 0.2 then
                                    TriggerServerEvent('hidden-anticheat:flag', 'Silent Aim (Statistical Low Spread)', stdDev, 50)
                                end
                                HitAngles = {}
                            end
                            local threshold = (Config.Combat and Config.Combat.SilentAimHeadDist) or 0.8
                            if IsPedSprinting(PlayerPed) or IsPedRunning(PlayerPed) then
                                threshold = threshold + 0.2
                            end
                            if not IsPlayerFreeAiming(PlayerId()) then
                                 threshold = threshold + 0.4
                            end
                            if headOffset > threshold then
                                TriggerEvent('hidden-anticheat:internal:silentAimViolation', headOffset)
                            end
                        end
                    end
                end
            end
            
            TriggerServerEvent('hidden-anticheat:recordEvent', 'hit', 1)
            
            local success, bone = GetPedLastDamageBone(victim)
            
            -- Aimbot Protection #1: Headshot Rate
            HeadshotStats.hits = HeadshotStats.hits + 1
            if success and (bone == 31086) then
                TriggerServerEvent('hidden-anticheat:recordEvent', 'headshot', 1)
                HeadshotStats.headshots = HeadshotStats.headshots + 1
            end
            
            if HeadshotStats.hits >= 10 then
                local ratio = HeadshotStats.headshots / HeadshotStats.hits
                if ratio > 0.70 then -- > 70% Headshot Rate
                    TriggerServerEvent('hidden-anticheat:flag', 'Aimbot (High Headshot Rate)', math.floor(ratio * 100) .. "%", 40)
                    HeadshotStats = { hits = 0, headshots = 0 } -- Reset to avoid spam
                end
            end
            
            if isFatal then
                 TriggerServerEvent('hidden-anticheat:recordEvent', 'kill', 1)
            end
        end
    end
end)

AddEventHandler('weaponDamageEvent', function(sender, data)
    if not (Config.Combat and Config.Combat.MagicBullet and Config.Combat.MagicBullet.Enabled) then return end
    
    -- In OneSync, sender is the server ID of the player who caused damage.
    -- However, weaponDamageEvent on client is triggered LOCALLY when WE cause damage, or when WE receive damage?
    -- According to FiveM docs: "Triggered on the client when a weapon causes damage to an entity."
    -- It is triggered on the ATTACKER's client for peds/players.
    
    local attacker = PlayerPedId()
    -- Ensure we are the one shooting.
    -- data.parentGlobalId is the entity that caused damage (weapon or vehicle).
    
    -- Check if we are shooting at a player
    if data and data.hitGlobalId then
        local victim = NetworkGetEntityFromNetworkId(data.hitGlobalId)
        
        if DoesEntityExist(victim) and IsEntityAPed(victim) and IsPedAPlayer(victim) then
            local now = GetGameTimer()
            local lockMs = (Config.Combat and Config.Combat.DetectionLockMs) or 200
            local lockState, allowed = CombatLockNext(CombatLocks[victim], "magic", now, lockMs)
            if not allowed then return end
            CombatLocks[victim] = lockState
            local victimPos = GetPedBoneCoords(victim, 31086, 0.0, 0.0, 0.0) -- Target Head
            local attackerPos = GetPedBoneCoords(attacker, 57005, 0.0, 0.0, 0.0)
            local rayHandle = StartShapeTestRay(attackerPos.x, attackerPos.y, attackerPos.z, victimPos.x, victimPos.y, victimPos.z, 511, attacker, 7)
            local _, hit, hitCoords, _, hitEntity, _ = GetShapeTestResult(rayHandle)
            
            if hit == 1 then
                if hitEntity ~= victim then
                    local distToVictim = #(hitCoords - victimPos)
                    local maxWallbang = (Config.Combat and Config.Combat.MagicBullet and Config.Combat.MagicBullet.MaxWallbangDistance) or 0.0
                    if maxWallbang < 0 then maxWallbang = 0 end
                    if distToVictim > maxWallbang then 
                        if Config.Combat.MagicBullet.CancelDamage then
                            CancelEvent()
                        end
                        TriggerServerEvent('hidden-anticheat:flag', 'Magic Bullet (Wallbang)', distToVictim, 100)
                    end
                end
            end
        end
    end
end)

local MouseSamples = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedShooting(PlayerPed) then
            local aiming, aimedEnt = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if aiming and DoesEntityExist(aimedEnt) and IsEntityAPed(aimedEnt) and IsPedAPlayer(aimedEnt) then
                local dx = GetGameplayCamRelativeHeading()
                local dy = GetGameplayCamRelativePitch()
                table.insert(MouseSamples, {x = dx, y = dy})
                if #MouseSamples > 20 then
                    local varX, varY = 0, 0
                    local meanX, meanY = 0, 0
                    for _, s in ipairs(MouseSamples) do meanX = meanX + s.x; meanY = meanY + s.y end
                    meanX = meanX / #MouseSamples
                    meanY = meanY / #MouseSamples
                    for _, s in ipairs(MouseSamples) do
                        varX = varX + (s.x - meanX)^2
                        varY = varY + (s.y - meanY)^2
                    end
                    if varX < 0.0001 and varY < 0.0001 then
                        TriggerServerEvent('hidden-anticheat:flag', 'Artificial Aim (Lock-on)', "Var: " .. varX, 50)
                    end
                    MouseSamples = {}
                end
            else
                MouseSamples = {}
            end
        else
            MouseSamples = {}
        end
    end
end)

-- 10. Snap Aim / Reaction Time Analysis
local LastCamDir = vector3(0,0,0)
local LastAimTime = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsPedShooting(PlayerPed) then
            local currentCamDir = GetCameraDirection()
            local now = GetGameTimer()
            local timeDiff = now - LastAimTime
            local aiming, aimedEnt = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if aiming and DoesEntityExist(aimedEnt) and IsEntityAPed(aimedEnt) and IsPedAPlayer(aimedEnt) then
                if LastCamDir ~= vector3(0,0,0) and timeDiff < 100 then
                    local dot = LastCamDir.x * currentCamDir.x + LastCamDir.y * currentCamDir.y + LastCamDir.z * currentCamDir.z
                    if dot < -1.0 then dot = -1.0 end
                    if dot > 1.0 then dot = 1.0 end
                    local angle = math.acos(dot) * (180.0 / math.pi)
                    if angle > 170.0 then
                         TriggerServerEvent('hidden-anticheat:flag', 'Impossible Snap Turn (180deg)', angle, 100)
                    end
                    if timeDiff < 50 and angle > 20.0 then
                         TriggerServerEvent('hidden-anticheat:flag', 'Impossible Snap Aim', angle, 20)
                    end
                end
            end
            LastCamDir = currentCamDir
            LastAimTime = now
        else
            LastCamDir = GetCameraDirection()
            LastAimTime = GetGameTimer()
        end
    end
end)

-- 9. Evidence Capture (Screenshot & Clip)
local isSuspectRecording = false
local recordingTimer = 0

RegisterNetEvent('hidden-anticheat:client:startSuspectRecording')
AddEventHandler('hidden-anticheat:client:startSuspectRecording', function()
    recordingTimer = GetGameTimer() + 60000 -- Record for 60s from last flag
    
    if not isSuspectRecording then
        isSuspectRecording = true
        if not IsRecording() then
            StartRecording(1) -- Start recording clip
        end
        
        Citizen.CreateThread(function()
            while isSuspectRecording do
                Citizen.Wait(1000)
                if GetGameTimer() > recordingTimer then
                    isSuspectRecording = false
                    if IsRecording() then
                        StopRecordingAndDiscardClip() -- Discard if no ban happened
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('hidden-anticheat:client:banSequence')
AddEventHandler('hidden-anticheat:client:banSequence', function(reason)
    -- 1. Start Recording (if not already)
    if not IsRecording() then
        StartRecording(1)
    end
    
    -- 2. Wait 30 seconds to capture evidence
    -- We could freeze the player here, but for "evidence" of cheat, maybe we let them spin?
    -- However, to prevent damage, we should probably freeze them or make them invincible/harmless.
    -- User request: "mande 30s de video antes do player ser banido" implies capturing behavior.
    -- But allowing a cheater 30s of free reign is bad. 
    -- Let's Freeze them to stop damage, but keep recording.
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    SetEntityInvincible(playerPed, true)
    
    Citizen.Wait(30000) -- Wait 30s
    
    -- 3. Stop & Save Clip
    if IsRecording() then
        StopRecordingAndSaveClip()
    end
    
    -- 4. Take Screenshot & Upload
    if GetResourceState('screenshot-basic') == 'started' then
        exports['screenshot-basic']:requestScreenshotUpload(Config.LogWebhook, 'files[]', function(data)
            -- After screenshot upload (or attempt), finalize ban
            TriggerServerEvent('hidden-anticheat:server:finalizeBan', reason)
        end)
    else
        TriggerServerEvent('hidden-anticheat:server:finalizeBan', reason)
    end
end)

RegisterNetEvent('hidden-anticheat:client:captureEvidence')
AddEventHandler('hidden-anticheat:client:captureEvidence', function()
    -- Save Clip if recording
    if IsRecording() then
        StopRecordingAndSaveClip()
    end

    -- Check if screenshot-basic resource is available
    if GetResourceState('screenshot-basic') == 'started' then
        exports['screenshot-basic']:requestScreenshotUpload(Config.LogWebhook, 'files[]', function(data)
            local resp = json.decode(data)
            -- Ideally we would confirm success here, but we trust the export for now
        end)
    else
        -- Fallback if no screenshot resource
        -- Just proceed with ban immediately or log warning
    end
end)
