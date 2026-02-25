local Config = Config or {}

RegisterCommand('testwallbang', function(source, args)
    local victimId = tonumber(args[1])
    if not victimId then
        print("Usage: /testwallbang [playerId]")
        return
    end
    
    local victim = GetPlayerPed(GetPlayerFromServerId(victimId))
    if not DoesEntityExist(victim) then
        print("Player not found")
        return
    end
    
    local attacker = PlayerPedId()
    local attackerPos = GetPedBoneCoords(attacker, 31086, 0.0, 0.0, 0.0)
    local victimPos = GetPedBoneCoords(victim, 31086, 0.0, 0.0, 0.0)
    
    -- Perform Raycast
    local rayHandle = StartShapeTestRay(attackerPos.x, attackerPos.y, attackerPos.z, victimPos.x, victimPos.y, victimPos.z, 273, attacker, 7)
    local _, hit, hitCoords, _, _, _ = GetShapeTestResult(rayHandle)
    
    if hit == 1 then
        local dist = #(hitCoords - victimPos)
        print("Raycast Hit! Distance from victim: " .. dist)
        if dist > 1.0 then
            print("RESULT: Wall detected! Shot would be blocked.")
        else
            print("RESULT: Clear shot (or hit victim/close enough).")
        end
    else
        print("RESULT: No obstruction detected.")
    end
end, false)

RegisterCommand('anticheat_tests', function()
    if not _G.HiddenAnticheat or type(_G.HiddenAnticheat.CombatLockNext) ~= "function" then
        print("CombatLockNext not available")
        return
    end
    
    local results = { pass = 0, fail = 0 }
    local function assertEq(name, actual, expected)
        if actual == expected then
            results.pass = results.pass + 1
        else
            results.fail = results.fail + 1
            print("FAIL " .. name .. " expected " .. tostring(expected) .. " got " .. tostring(actual))
        end
    end
    
    local lockMs = 200
    local state, ok = _G.HiddenAnticheat.CombatLockNext(nil, "magic", 1000, lockMs)
    assertEq("t1_ok", ok, true)
    
    state, ok = _G.HiddenAnticheat.CombatLockNext(state, "silent", 1100, lockMs)
    assertEq("t2_ok", ok, false)
    
    state, ok = _G.HiddenAnticheat.CombatLockNext(state, "silent", 1301, lockMs)
    assertEq("t3_ok", ok, true)
    
    state, ok = _G.HiddenAnticheat.CombatLockNext(state, "silent", 1350, lockMs)
    assertEq("t4_ok", ok, true)
    
    print("Anticheat tests: " .. results.pass .. " passed, " .. results.fail .. " failed")
end, false)
