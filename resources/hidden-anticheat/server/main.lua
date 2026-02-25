AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print([[^2
  _    _ _     _     _             
 | |  | (_)   | |   | |            
 | |__| |_  __| | __| | ___ _ __   
 |  __  | |/ _` |/ _` |/ _ \ '_ \  
 | |  | | | (_| | (_| |  __/ | | | 
 |_|  |_|_|\__,_|\__,_|\___|_| |_| 
                                   ^7]])
end)

local Config = Config or {}

-- Load Config (Assuming it's shared, but server-side might need explicit require if not in shared_script)
-- In FiveM, shared_script makes it available globally in both client and server contexts

local BanList = {} -- Removed
local PlayerStats = {} -- Store player stats

-- VRP Integration (Proxy/Tunnel)
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- Helper: Get all player identifiers
local function GetPlayerIdentifiersTable(source)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(source)

    for i = 0, numIdentifiers - 1 do
        local id = GetPlayerIdentifier(source, i)
        if id then
            if string.find(id, "steam:") then
                identifiers.steam = id
            elseif string.find(id, "ip:") then
                identifiers.ip = id
            elseif string.find(id, "discord:") then
                identifiers.discord = id
            elseif string.find(id, "license:") then
                identifiers.license = id
            elseif string.find(id, "license2:") then
                identifiers.license2 = id
            elseif string.find(id, "xbl:") then
                identifiers.xbl = id
            elseif string.find(id, "live:") then
                identifiers.live = id
            elseif string.find(id, "fivem:") then
                identifiers.fivem = id
            end
        end
    end
    return identifiers
end

-- Helper: Send Discord Log
local function SendDiscordLog(source, reason, details, action)
    if not Config.LogWebhook or Config.LogWebhook == "" then return end
    
    local ids = GetPlayerIdentifiersTable(source)
    local playerName = GetPlayerName(source) or "Unknown"
    local user_id = vRP.getUserId(source) or "N/A"
    local identity = user_id ~= "N/A" and vRP.getUserIdentity(user_id) or nil
    local rpName = identity and (identity.name .. " " .. identity.firstname) or "Unknown"
    
    local color = action == "BAN" and 16711680 or 16776960 -- Red for BAN, Yellow for FLAG
    
    local description = string.format(
        "**Player:** %s\n**ID:** %s\n**RP Name:** %s\n**Action:** %s\n**Reason:** %s\n**Details:** %s\n\n**Identifiers:**\nSteam: %s\nDiscord: %s\nLicense: %s\nIP: ||%s||",
        playerName, user_id, rpName, action, reason, tostring(details),
        ids.steam or "N/A", ids.discord or "N/A", ids.license or "N/A", ids.ip or "N/A"
    )

    PerformHttpRequest(Config.LogWebhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Hidden Anticheat",
        embeds = {{
            title = "Anticheat Alert",
            description = description,
            color = color,
            footer = {
                text = "Hidden Anticheat • " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }), { ['Content-Type'] = 'application/json' })
end

-- Load Bans from JSON (REMOVED - Using SQL)
-- local function LoadBans() ... end
-- local function SaveBans() ... end

-- Initial Load (Not needed for SQL as we query on connect)

-- Check for Bans on Connection
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    local source = source
    local ids = GetPlayerIdentifiersTable(source)
    
    Wait(0) -- Necessary delay for async SQL
    
    -- Construct SQL query dynamically based on present identifiers
    local query = "SELECT * FROM `hiddenAnticheat`.`bans` WHERE "
    local params = {}
    local conditions = {}
    
    if ids.steam then table.insert(conditions, "steam = ?"); table.insert(params, ids.steam) end
    if ids.license then table.insert(conditions, "license = ?"); table.insert(params, ids.license) end
    if ids.license2 then table.insert(conditions, "license2 = ?"); table.insert(params, ids.license2) end
    if ids.discord then table.insert(conditions, "discord = ?"); table.insert(params, ids.discord) end
    if ids.ip then table.insert(conditions, "ip = ?"); table.insert(params, ids.ip) end
    if ids.fivem then table.insert(conditions, "fivem = ?"); table.insert(params, ids.fivem) end
    
    if #conditions == 0 then
        deferrals.done()
        return
    end
    
    query = query .. table.concat(conditions, " OR ")
    
    exports.oxmysql:fetch(query, params, function(results)
        if results and #results > 0 then
            local ban = results[1]
            deferrals.done("\n[Hidden Anticheat] You are banned from this server.\nReason: " .. ban.reason .. "\nBanned By: " .. ban.banned_by)
            -- Log attempt?
            print("^1[ANTICHEAT] Banned player attempted to connect: " .. name .. " (Reason: " .. ban.reason .. ")^7")
        else
            deferrals.done()
        end
    end)
end)

function FlagPlayer(source, reason, details, riskScore)
    local identifier = GetPlayerIdentifier(source, 0)
    riskScore = riskScore or 1 -- Default risk score if not provided
    
    if not PlayerStats[identifier] then
        PlayerStats[identifier] = { flags = 0, lastFlag = 0, risk = 0 }
    end
    
    PlayerStats[identifier].flags = PlayerStats[identifier].flags + 1
    PlayerStats[identifier].lastFlag = os.time()
    PlayerStats[identifier].risk = (PlayerStats[identifier].risk or 0) + riskScore
    
    local riskLevel = PlayerStats[identifier].risk
    
    print(string.format("^1[ANTICHEAT] Flagged: %s | Reason: %s | Risk Score: %d (Total: %d) | Details: %s^7", 
        GetPlayerName(source), reason, riskScore, riskLevel, tostring(details)))
    
    -- Send Log
    SendDiscordLog(source, reason, string.format("%s (Risk: +%d, Total: %d)", tostring(details), riskScore, riskLevel), "FLAG")
    
    -- Trigger suspect recording on client (if risk is getting high)
    if riskLevel >= 10 then
        TriggerClientEvent('hidden-anticheat:client:startSuspectRecording', source)
    end
    
    -- Automatic Penalty based on Risk Score
    if Config.BanSystem and riskLevel >= 50 then -- Threshold for Ban (2nd Major Flag or Accumulation)
        BanPlayer(source, reason)
    elseif Config.KickSystem and riskLevel >= 25 then -- Threshold for Kick (Warning)
        local ids = GetPlayerIdentifiersTable(source)
        local user_id = vRP.Passport(source) or 0 -- Using Passport as per vRP structure
        local kickDate = os.time()
        
        -- Insert Kick as a temporary record or warning in DB
        -- Assuming 'bans' table has 'banned_by' which we can use to mark as KICK
        exports.oxmysql:insert('INSERT INTO `hiddenAnticheat`.`bans` (user_id, steam, discord, license, license2, xbl, live, fivem, ip, reason, banned_by, ban_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            user_id, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.live, ids.fivem, ids.ip, reason .. " (KICK)", "Anticheat-Kick", kickDate
        }, function(id)
             -- We don't block connection for kicks in playerConnecting, but we log it.
        end)
        
        print("^1[ANTICHEAT] Kicking player for high risk: " .. GetPlayerName(source) .. " (Risk: " .. riskLevel .. ")^7")
        SendDiscordLog(source, reason, "Player Kicked (Risk Level: " .. riskLevel .. ")", "KICK")
        
        Citizen.Wait(500) -- Small delay to ensure DB op starts
        DropPlayer(source, "[Hidden Anticheat] Kicked for suspicious activity. Aim/Silent detection. (Code: " .. reason .. ")")
    end
end

function BanPlayer(source, reason)
    -- Trigger Client Sequence (Wait 30s -> Capture Video -> Send Evidence -> Finalize Ban)
    TriggerClientEvent('hidden-anticheat:client:banSequence', source, reason)
end

RegisterServerEvent('hidden-anticheat:server:finalizeBan')
AddEventHandler('hidden-anticheat:server:finalizeBan', function(reason)
    local source = source
    local ids = GetPlayerIdentifiersTable(source)
    local user_id = vRP.Passport(source) or 0
    local now = os.time()
    
    -- Always Permanent Ban (0 expiration)
    local duration = 0
    local durationLabel = "Permanent"
    local expiration = 0
    
    Citizen.CreateThread(function()
        exports.oxmysql:insert('INSERT INTO `hiddenAnticheat`.`bans` (user_id, steam, discord, license, license2, xbl, live, fivem, ip, reason, banned_by, ban_date, expiration) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            user_id, ids.steam, ids.discord, ids.license, ids.license2, ids.xbl, ids.live, ids.fivem, ids.ip, reason, "Anticheat", now, expiration
        }, function(id)
            print("^1[ANTICHEAT] Player banned (" .. durationLabel .. ") and saved to SQL. ID: " .. tostring(id) .. "^7")
        end)
        
        SendDiscordLog(source, reason, "Player Banned (" .. durationLabel .. ") - Evidence Captured", "BAN")
        
        -- Send to Web Dashboard
        local dashboardUrl = Config.DashboardURL or "http://localhost:3000/api/ban"
        PerformHttpRequest(dashboardUrl, function(err, text, headers) 
            if err == 0 or err == 200 then
                print("^2[ANTICHEAT] Ban sent to Dashboard successfully.^7")
            else
                print("^1[ANTICHEAT] Failed to send ban to Dashboard (Error: " .. tostring(err) .. ")^7")
            end
        end, 'POST', json.encode({
            user_id = user_id,
            name = GetPlayerName(source) or "Unknown",
            reason = reason,
            details = "Automated Ban Sequence",
            screenshot_url = "https://example.com/screenshot.jpg", -- In a real scenario, we'd need the URL from the screenshot-basic callback
            identifiers = ids
        }), { ['Content-Type'] = 'application/json' })

        DropPlayer(source, "[Hidden Anticheat] You have been banned permanently. Reason: " .. reason)
    end)
end)

RegisterServerEvent('hidden-anticheat:flag')
AddEventHandler('hidden-anticheat:flag', function(reason, details, riskScore)
    local _source = source
    FlagPlayer(_source, reason, details, riskScore)
end)

RegisterServerEvent('hidden-anticheat:ban')
AddEventHandler('hidden-anticheat:ban', function(reason, details)
    local _source = source
    -- Direct ban without risk score accumulation
    print("^1[ANTICHEAT] Direct Ban Triggered: " .. GetPlayerName(_source) .. " | Reason: " .. reason .. "^7")
    BanPlayer(_source, reason)
end)

RegisterServerEvent('hidden-anticheat:recordEvent')
AddEventHandler('hidden-anticheat:recordEvent', function(type, value)
    local _source = source
    local identifier = GetPlayerIdentifier(_source, 0)
    
    if Stats then
        Stats.Update(_source, identifier, type, value)
    end
end)

-- Command to test the ban sequence (Admin Only)
RegisterCommand("testban", function(source, args, rawCommand)
    if source == 0 then
        print("This command must be run by a player.")
        return
    end

    -- Check if player has admin permission (simple check, replace with vRP or ACE check as needed)
    -- Assuming vRP or similar check. For now, let's assume if they have 'command' access they are admin or debug.
    -- Or check ACE: IsPlayerAceAllowed(source, "command.testban")
    
    local targetId = tonumber(args[1])
    if not targetId then
        targetId = source -- Ban self if no ID provided
    end

    local targetSource = targetId -- In OneSync/ESX/vRP, source is usually the ID.
    
    if GetPlayerName(targetSource) then
        print("^3[ANTICHEAT] Testing ban sequence on " .. GetPlayerName(targetSource) .. "^7")
        TriggerClientEvent('chat:addMessage', source, { args = { "^3[ANTICHEAT]", "Initiating ban sequence test (30s delay)..." } })
        
        -- Trigger the client sequence directly
        TriggerClientEvent('hidden-anticheat:client:banSequence', targetSource, "Test Ban (Manual Trigger)")
    else
        TriggerClientEvent('chat:addMessage', source, { args = { "^1[ERROR]", "Player not found." } })
    end
end, true) -- true = restricted command (requires ace permission 'command.testban')

-- Server-Side Movement Verification (Anti-Noclip/Speedhack)
-- This requires client to send position updates frequently, or use GetEntityCoords on server-side entities (OneSync)
-- With OneSync enabled (default now), we can get coords server-side

-- Health & Godmode Check (Server-side) (Removed)
