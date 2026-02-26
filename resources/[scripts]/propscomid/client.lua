local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("ozk_int")
-- local int_stock2 = GetInteriorAtCoordsWithType(162.10260,-1711.327,22.207,"int_stock")
-- local int_stock3 = GetInteriorAtCoordsWithType()
-- local int_stock4 = GetInteriorAtCoordsWithType(598.24040,-423.3888,17.620,"int_stock")
-- local int_stock5 = GetInteriorAtCoordsWithType(937.73070,-1474.606,23.043,"int_stock")
-- local int_stock6 = GetInteriorAtCoordsWithType(-1974.080,-228.9903,27.864,"int_stock")
-- local int_stock7 = GetInteriorAtCoordsWithType(-67.78810,-1291.193,23.791,"int_stock")
-- local int_stock8 = GetInteriorAtCoordsWithType(800.09170,-89.15701,74.917,"int_stock")
-- local int_stock9 = GetInteriorAtCoordsWithType(-147.7690,6303.5957,24.569,"int_stock")
-- local interiorHash0 = GetInteriorAtCoordsWithType(-41.5310,6453.3046,24.329,"int_stock")
-- local interiorHash1 = GetInteriorAtCoordsWithType(1397.311,-2092.379,45.499,"int_stock")
-- local interiorHash2 = GetInteriorAtCoordsWithType(2862.444,4456.0014,41.322,"int_stock")
-- local interiorHash3 = GetInteriorAtCoordsWithType(552.5862,2684.1770,35.043,"int_stock")
-- local interiorHash4 = GetInteriorAtCoordsWithType(963.7479,3632.5056,25.761,"int_stock")
-- local interiorHash5 = GetInteriorAtCoordsWithType(2536.508,4118.2700,31.460,"int_stock")
-- local interiorHash6 = GetInteriorAtCoordsWithType(436.5493,-1970.364,17.290,"int_stock")

--DisableInteriorProp
--EnableInteriorProp


local s1methba
local s1methup
local s1weedba
local s1weedup
local s1weedv1
local s1weedv2
local s1weedv3
local s1weedv4
local s1weedv5
local s1weedv6
local s1weedv7
local s1weedv8
local s1weedv9
local s1coke
local s1money
local s1weapon
local s1moneypr
Citizen.CreateThread(function()
    local armas1 = GetInteriorAtCoordsWithType(939.84500,-1492.575,30.085)  -- HELIPA ARMA 02
    EnableInteriorProp(armas1, "light_stock")
    EnableInteriorProp(armas1, "weapon_app")
    EnableInteriorProp(armas1, "weapon_staff_01")
    EnableInteriorProp(armas1, "weapon_stock")
    RefreshInterior(armas1)

    local armas2 = GetInteriorAtCoordsWithType(2520.8650,4125.2719,38.630)  -- CASINO ARMA 01 
    EnableInteriorProp(armas2, "light_stock")
    EnableInteriorProp(armas2, "weapon_app")
    EnableInteriorProp(armas2, "weapon_staff_01")
    EnableInteriorProp(armas2, "weapon_stock")
    RefreshInterior(armas2)

    local armas4 = GetInteriorAtCoordsWithType(-1974.35,-227.44,27.85)  -- CASINO ARMA 03
    EnableInteriorProp(armas4, "light_stock")
    EnableInteriorProp(armas4, "weapon_app")
    EnableInteriorProp(armas4, "weapon_staff_01")
    EnableInteriorProp(armas4, "weapon_stock")
    RefreshInterior(armas4)
     
    local armas3 = GetInteriorAtCoordsWithType(553.07,2682.31,35.05)      --  MUNIÇÃO 033
    EnableInteriorProp(armas3, "light_stock")
    EnableInteriorProp(armas3, "weapon_app")
    EnableInteriorProp(armas3, "weapon_staff_01")
    EnableInteriorProp(armas3, "weapon_stock")
    RefreshInterior(armas3)

    local lavagem3 = GetInteriorAtCoordsWithType(-307.58,-1353.9,24.31)   --  LAVAGEM 03
    EnableInteriorProp(lavagem3, "money_app")
    EnableInteriorProp(lavagem3, "money_staff_01")
    EnableInteriorProp(lavagem3, "money_staff_02")
    EnableInteriorProp(lavagem3, "money_stock")
    RefreshInterior(lavagem3)

    local municao1 = GetInteriorAtCoordsWithType(161.7,-1710.34,22.21)      -- SURENOS MUNIÇÃO 02
    EnableInteriorProp(municao1, "light_stock")
    EnableInteriorProp(municao1, "weapon_app")
    EnableInteriorProp(municao1, "weapon_staff_01")
    EnableInteriorProp(municao1, "weapon_stock")
    RefreshInterior(municao1)

    local meta4 = GetInteriorAtCoordsWithType(598.24040,-423.3888,17.620)  -- YAKUZA MUNIÇÃO 01
    EnableInteriorProp(meta4, "light_stock")
    EnableInteriorProp(meta4, "meth_app")
    EnableInteriorProp(meta4, "meth_staff_01")
    EnableInteriorProp(meta4, "meth_staff_02")
    EnableInteriorProp(meta4, "meth_update_lab_01")
    EnableInteriorProp(meta4, "meth_update_lab_02")
    EnableInteriorProp(meta4, "meth_update_lab_01_2")
    EnableInteriorProp(meta4, "meth_update_lab_02_2")
    EnableInteriorProp(meta4, "meth_stock")
    RefreshInterior(meta4)

    local municao3 = GetInteriorAtCoordsWithType(-42.68900,-1289.172,29.065)  -- YAKUZA MUNIÇÃO 01
    EnableInteriorProp(municao3, "light_stock")
    EnableInteriorProp(municao3, "weapon_app")
    EnableInteriorProp(municao3, "weapon_staff_01")
    EnableInteriorProp(municao3, "weapon_stock")
    RefreshInterior(municao3)

    local maconha1 = GetInteriorAtCoordsWithType(452.56200,-1981.740,23.185)  -- CRIPS DROGA 01
    EnableInteriorProp(maconha1, "weed_app")
    EnableInteriorProp(maconha1, "weed_staff_01")
    EnableInteriorProp(maconha1, "weed_staff_02")
    EnableInteriorProp(maconha1, "weed_update_lamp")
    EnableInteriorProp(maconha1, "weed_fan_update")
    EnableInteriorProp(maconha1, "weed_plant_v6")
    RefreshInterior(maconha1)

    local meta2 = GetInteriorAtCoordsWithType(-38.13,6456.2,24.33)  -- FAVELA ZANCUDO DROGA 03  
    EnableInteriorProp(meta2, "light_stock")
    EnableInteriorProp(meta2, "meth_app")
    EnableInteriorProp(meta2, "meth_staff_01")
    EnableInteriorProp(meta2, "meth_staff_02")
    EnableInteriorProp(meta2, "meth_update_lab_01")
    EnableInteriorProp(meta2, "meth_update_lab_02")
    EnableInteriorProp(meta2, "meth_update_lab_01_2")
    EnableInteriorProp(meta2, "meth_update_lab_02_2")
    EnableInteriorProp(meta2, "meth_stock")
    RefreshInterior(meta2)

    local meta3 = GetInteriorAtCoordsWithType(793.67700,-103.9858,82.031)  -- BLOODS DROGA 04 
    EnableInteriorProp(meta3, "light_stock")
    EnableInteriorProp(meta3, "meth_app")
    EnableInteriorProp(meta3, "meth_staff_01")
    EnableInteriorProp(meta3, "meth_staff_02")
    EnableInteriorProp(meta3, "meth_update_lab_01")
    EnableInteriorProp(meta3, "meth_update_lab_02")
    EnableInteriorProp(meta3, "meth_update_lab_01_2")
    EnableInteriorProp(meta3, "meth_update_lab_02_2")
    EnableInteriorProp(meta3, "meth_stock")
    RefreshInterior(meta3)

    local coca1 = GetInteriorAtCoordsWithType(2846.7390,4449.7680,48.516)  -- FAVELA BARRAGEM DROGA 02
    EnableInteriorProp(coca1, "coke_app")
    EnableInteriorProp(coca1, "coke_staff_01")
    EnableInteriorProp(coca1, "coke_staff_02")
    EnableInteriorProp(coca1, "coke_stock")
    RefreshInterior(coca1)


end)
RegisterCommand("meth_basic", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1methba then
            s1methba = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "light_stock")
            DisableInteriorProp(interiorHash, "meth_app")
            DisableInteriorProp(interiorHash, "meth_staff_01")
            DisableInteriorProp(interiorHash, "meth_staff_02")
            DisableInteriorProp(interiorHash, "meth_basic_lab_01")
            DisableInteriorProp(interiorHash, "meth_basic_lab_02")
            DisableInteriorProp(interiorHash, "meth_basic_lab_01_2")
            DisableInteriorProp(interiorHash, "meth_basic_lab_02_2")
            DisableInteriorProp(interiorHash, "meth_stock")
        else
            s1methba = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "light_stock")
            EnableInteriorProp(interiorHash, "meth_app")
            EnableInteriorProp(interiorHash, "meth_staff_01")
            EnableInteriorProp(interiorHash, "meth_staff_02")
            EnableInteriorProp(interiorHash, "meth_basic_lab_01")
            EnableInteriorProp(interiorHash, "meth_basic_lab_02")
            EnableInteriorProp(interiorHash, "meth_basic_lab_01_2")
            EnableInteriorProp(interiorHash, "meth_basic_lab_02_2")
            EnableInteriorProp(interiorHash, "meth_stock")
        end
    end
end, false)

RegisterCommand("meth_update", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1methup then
            s1methup = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "light_stock")
            DisableInteriorProp(interiorHash, "meth_app")
            DisableInteriorProp(interiorHash, "meth_staff_01")
            DisableInteriorProp(interiorHash, "meth_staff_02")
            DisableInteriorProp(interiorHash, "meth_update_lab_01")
            DisableInteriorProp(interiorHash, "meth_update_lab_02")
            DisableInteriorProp(interiorHash, "meth_update_lab_01_2")
            DisableInteriorProp(interiorHash, "meth_update_lab_02_2")
            DisableInteriorProp(interiorHash, "meth_stock")
        else
            s1methup = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "light_stock")
            EnableInteriorProp(interiorHash, "meth_app")
            EnableInteriorProp(interiorHash, "meth_staff_01")
            EnableInteriorProp(interiorHash, "meth_staff_02")
            EnableInteriorProp(interiorHash, "meth_update_lab_01")
            EnableInteriorProp(interiorHash, "meth_update_lab_02")
            EnableInteriorProp(interiorHash, "meth_update_lab_01_2")
            EnableInteriorProp(interiorHash, "meth_update_lab_02_2")
            EnableInteriorProp(interiorHash, "meth_stock")
        end
    end
end, false)

RegisterCommand("weed_basic", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedba then
            s1weedba = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_app")
            DisableInteriorProp(interiorHash, "weed_staff_01")
            DisableInteriorProp(interiorHash, "weed_staff_02")
            DisableInteriorProp(interiorHash, "weed_basic_lamp")
            DisableInteriorProp(interiorHash, "weed_fan_basick")
            DisableInteriorProp(interiorHash, "weed_stock")
        else
            s1weedba = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_app")
            EnableInteriorProp(interiorHash, "weed_staff_01")
            EnableInteriorProp(interiorHash, "weed_staff_02")
            EnableInteriorProp(interiorHash, "weed_basic_lamp")
            EnableInteriorProp(interiorHash, "weed_fan_basick")
            EnableInteriorProp(interiorHash, "weed_stock")
        end
    end
end, false)

RegisterCommand("weed_update", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedup then
            s1weedup = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_app")
            DisableInteriorProp(interiorHash, "weed_staff_01")
            DisableInteriorProp(interiorHash, "weed_staff_02")
            DisableInteriorProp(interiorHash, "weed_update_lamp")
            DisableInteriorProp(interiorHash, "weed_fan_update")
            DisableInteriorProp(interiorHash, "weed_stock")
        else
            s1weedup = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_app")
            EnableInteriorProp(interiorHash, "weed_staff_01")
            EnableInteriorProp(interiorHash, "weed_staff_02")
            EnableInteriorProp(interiorHash, "weed_update_lamp")
            EnableInteriorProp(interiorHash, "weed_fan_update")
            EnableInteriorProp(interiorHash, "weed_stock")
        end
    end
end, false)

RegisterCommand("weed_v1", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv1 then
            s1weedv1 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v1")
        else
            s1weedv1 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v1")
        end
    end
end, false)

RegisterCommand("weed_v2", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv2 then
            s1weedv2 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v2")
        else
            s1weedv2 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v2")
        end
    end
end, false)

RegisterCommand("weed_v3", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv3 then
            s1weedv3 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v3")
        else
            s1weedv3 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v3")
        end
    end
end, false)

RegisterCommand("weed_v4", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv4 then
            s1weedv4 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v4")
        else
            s1weedv4 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v4")
        end
    end
end, false)

RegisterCommand("weed_v5", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv5 then
            s1weedv5 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v5")
        else
            s1weedv5 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v5")
        end
    end
end, false)

RegisterCommand("weed_v6", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv6 then
            s1weedv6 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v6")
        else
            s1weedv6 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v6")
        end
    end
end, false)

RegisterCommand("weed_v7", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv7 then
            s1weedv7 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v7")
        else
            s1weedv7 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v7")
        end
    end
end, false)

RegisterCommand("weed_v8", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv8 then
            s1weedv8 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v8")
        else
            s1weedv8 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v8")
        end
    end
end, false)

RegisterCommand("weed_v9", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weedv9 then
            s1weedv9 = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "weed_plant_v9")
        else
            s1weedv9 = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "weed_plant_v9")
        end
    end
end, false)

RegisterCommand("coke", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1coke then
            s1coke = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "coke_app")
            DisableInteriorProp(interiorHash, "coke_staff_01")
            DisableInteriorProp(interiorHash, "coke_staff_02")
            DisableInteriorProp(interiorHash, "coke_stock")
        else
            s1coke = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "coke_app")
            EnableInteriorProp(interiorHash, "coke_staff_01")
            EnableInteriorProp(interiorHash, "coke_staff_02")
            EnableInteriorProp(interiorHash, "coke_stock")
        end
    end
end, false)

RegisterCommand("moneyobj", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1money then
            s1money = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "light_stock")
            DisableInteriorProp(interiorHash, "money_app")
            DisableInteriorProp(interiorHash, "money_staff_01")
            DisableInteriorProp(interiorHash, "money_stock")
        else
            s1money = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "light_stock")
            EnableInteriorProp(interiorHash, "money_app")
            EnableInteriorProp(interiorHash, "money_staff_01")
            EnableInteriorProp(interiorHash, "money_stock")
        end
    end
end, false)

RegisterCommand("money_pr", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1moneypr then
            s1moneypr = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "money_staff_01")
            DisableInteriorProp(interiorHash, "money_staff_02")
        else
            s1moneypr = true
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "money_staff_01")
            EnableInteriorProp(interiorHash, "money_staff_02")
        end
    end
end, false)

RegisterCommand("weapon", function(source, args, rawCommand)
    local ped = PlayerPedId()
    local interiorHash = GetInteriorFromEntity(ped)
    if func.checkPermission() then
        if s1weapon then
            s1weapon = false
            RefreshInterior(interiorHash)
            DisableInteriorProp(interiorHash, "light_stock")
            DisableInteriorProp(interiorHash, "weapon_app")
            DisableInteriorProp(interiorHash, "weapon_staff_01")
            DisableInteriorProp(interiorHash, "weapon_stock")
        else
            s1weapon = true
            RefreshInterior(interiorHash)
            EnableInteriorProp(interiorHash, "light_stock")
            EnableInteriorProp(interiorHash, "weapon_app")
            EnableInteriorProp(interiorHash, "weapon_staff_01")
            EnableInteriorProp(interiorHash, "weapon_stock")
        end
    end
end, false)



------------------------------- ALL IPL FOR DEV-----------------------------------------------
-- local ped = PlayerPedId()
-- local interiorHash = GetInteriorFromEntity(ped)
-- RefreshInterior(interiorHash)
-- DisableInteriorProp(interiorHash, "light_stock")
-- DisableInteriorProp(interiorHash, "meth_app")
-- DisableInteriorProp(interiorHash, "meth_staff_01")
-- DisableInteriorProp(interiorHash, "meth_staff_02")

-- DisableInteriorProp(interiorHash, "meth_basic_lab_01")
-- DisableInteriorProp(interiorHash, "meth_basic_lab_02")
-- DisableInteriorProp(interiorHash, "meth_basic_lab_01_2")
-- DisableInteriorProp(interiorHash, "meth_basic_lab_02_2")

-- DisableInteriorProp(interiorHash, "meth_update_lab_01")
-- DisableInteriorProp(interiorHash, "meth_update_lab_02")
-- DisableInteriorProp(interiorHash, "meth_update_lab_01_2")
-- DisableInteriorProp(interiorHash, "meth_update_lab_02_2")

-- DisableInteriorProp(interiorHash, "meth_stock")

-- DisableInteriorProp(interiorHash, "weed_app")
-- DisableInteriorProp(interiorHash, "weed_staff_01")
-- DisableInteriorProp(interiorHash, "weed_staff_02")

-- DisableInteriorProp(interiorHash, "weed_basic_lamp")
-- DisableInteriorProp(interiorHash, "weed_update_lamp")

-- DisableInteriorProp(interiorHash, "weed_fan_basick")
-- DisableInteriorProp(interiorHash, "weed_fan_update")

-- DisableInteriorProp(interiorHash, "weed_plant_v1")
-- DisableInteriorProp(interiorHash, "weed_plant_v2")
-- DisableInteriorProp(interiorHash, "weed_plant_v3")
-- DisableInteriorProp(interiorHash, "weed_plant_v4")
-- DisableInteriorProp(interiorHash, "weed_plant_v5")
-- DisableInteriorProp(interiorHash, "weed_plant_v6")
-- DisableInteriorProp(interiorHash, "weed_plant_v7")
-- DisableInteriorProp(interiorHash, "weed_plant_v8")
-- DisableInteriorProp(interiorHash, "weed_plant_v9")

-- DisableInteriorProp(interiorHash, "weed_stock")

-- DisableInteriorProp(interiorHash, "coke_app")
-- DisableInteriorProp(interiorHash, "coke_staff_01")
-- DisableInteriorProp(interiorHash, "coke_staff_02")
-- DisableInteriorProp(interiorHash, "coke_stock")

-- DisableInteriorProp(interiorHash, "money_app")
-- DisableInteriorProp(interiorHash, "money_staff_01")
-- DisableInteriorProp(interiorHash, "money_staff_02")
-- DisableInteriorProp(interiorHash, "money_stock")

-- DisableInteriorProp(interiorHash, "weapon_app")
-- DisableInteriorProp(interiorHash, "weapon_staff_01")
-- DisableInteriorProp(interiorHash, "weapon_stock")

--------------------------------------------------------------------------------------------------------------------------------------------
----- LOJAS LGBT
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local interior1 = GetInteriorAtCoords(5.263491,6513.293,30.69846)
    local interior2 = GetInteriorAtCoords(1693.459,4823.674,40.88372)
    local interior3 = GetInteriorAtCoords(1195.758,2709.895,37.04323)
    local interior4 = GetInteriorAtCoords(-1101.907,2709.708,17.92847)
    local interior5 = GetInteriorAtCoords(-823.0248,-1074.298,10.14872)
    local interior6 = GetInteriorAtCoords(425.2449,-805.3314,28.31175)
    local interior7 = GetInteriorAtCoords(75.70789,-1393.818,28.19675)
    local interior8 = GetInteriorAtCoords(1952.08,3766.12,32.59)

    EnableInteriorProp(interior1,"clotheslowhipster")
    EnableInteriorProp(interior2,"clotheslowhipster")
    EnableInteriorProp(interior3,"clotheslowhipster")
    EnableInteriorProp(interior4,"clotheslowhipster")
    EnableInteriorProp(interior5,"clotheslowhipster")
    EnableInteriorProp(interior6,"clotheslowhipster")
    EnableInteriorProp(interior7,"clotheslowhipster")
    EnableInteriorProp(interior8,"clotheslowhipster")

    RefreshInterior(interior1)
    RefreshInterior(interior2)
    RefreshInterior(interior3)
    RefreshInterior(interior4)
    RefreshInterior(interior5)
    RefreshInterior(interior6)
    RefreshInterior(interior7)
    RefreshInterior(interior8)
end)




local object = nil
local animDict = nil

RegisterNetEvent("bonecodonoe:use")
AddEventHandler("bonecodonoe:use", function()
    if object then 
        DeleteEntity(object)
    end
    if animDict then 
        RemoveAnimDict(animDict)
    end

    local model = "gndbonecodeneveanim"
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    object = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
    SetModelAsNoLongerNeeded(model)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 10706), -0.07, -0.01, -0.48, 0.0, 0.0, -161.03, true, true, false, true, 1, true)

    animDict = "clip@gndbonecodeneveanim"
    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        Citizen.Wait(10)
    end

    PlayEntityAnim(object, "gndbonecodeneveanim", animDict, 1000.0, true, true, true, 0.0, false)
end)
