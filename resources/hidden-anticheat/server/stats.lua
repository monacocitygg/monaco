local Stats = {}
Stats.Data = {}

-- Initialize player stats
function Stats.Init(identifier)
    Stats.Data[identifier] = {
        kills = 0,
        headshots = 0,
        shots = 0,
        hits = 0,
        damageDealt = 0,
        distanceTraveled = 0.0,
        startTime = os.time(),
        warnings = 0
    }
end

-- Update stats on events
function Stats.Update(source, identifier, type, value)
    if not Stats.Data[identifier] then Stats.Init(identifier) end
    
    if type == "kill" then
        Stats.Data[identifier].kills = Stats.Data[identifier].kills + 1
    elseif type == "headshot" then
        Stats.Data[identifier].headshots = Stats.Data[identifier].headshots + 1
    elseif type == "shot" then
        Stats.Data[identifier].shots = Stats.Data[identifier].shots + 1
    elseif type == "hit" then
        Stats.Data[identifier].hits = Stats.Data[identifier].hits + 1
    elseif type == "damage" then
        Stats.Data[identifier].damageDealt = Stats.Data[identifier].damageDealt + value
    end
    
    Stats.Analyze(source, identifier)
end

-- Analyze stats for anomalies (Simple Heuristics / "ML-lite")
function Stats.Analyze(source, identifier)
    local data = Stats.Data[identifier]
    local duration = os.time() - data.startTime
    
    if duration < 60 then return end -- Need at least 1 minute of data
    
    -- 1. Headshot Ratio Anomaly
    if data.hits > 20 then
        local ratio = data.headshots / data.hits
        if ratio > 0.9 then -- 90% headshot ratio is superhuman over time
            FlagPlayer(source, 'Aimbot (Statistical)', ratio)
        end
    end
    
    -- 2. Accuracy Anomaly
    if data.shots > 50 then
        local accuracy = data.hits / data.shots
        if accuracy > 0.95 then -- 95% accuracy is suspicious
            FlagPlayer(source, 'Aimbot (Accuracy)', accuracy)
        end
    end
    
    -- 3. Kills Per Minute (KPM)
    local kpm = data.kills / (duration / 60)
    if kpm > 30 then -- 30 kills per minute is suspicious
        FlagPlayer(source, 'Mass Kill', kpm)
    end
end

-- End of file
-- return Stats -- Not needed as Stats is global now
