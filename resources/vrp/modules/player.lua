local Global = {}
Objects = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
isSelectingCharacter = false
AddEventHandler("CharacterChosen", function(Passport, source)
    isSelectingCharacter = true
    local Datatable = vRP.Datatable(Passport)
    local Identity = vRP.Identity(Passport)
    if Datatable and Identity then
        if Datatable.Pos then
            if not (Datatable.Pos.x and Datatable.Pos.y and Datatable.Pos.z) then
                Datatable.Pos = { x = SpawnCoords.x, y = SpawnCoords.y, z = SpawnCoords.z }
            end
        else
            Datatable.Pos = { x = SpawnCoords.x, y = SpawnCoords.y, z = SpawnCoords.z }
        end
        if not Datatable.Skin then
            Datatable.Skin = "mp_m_freemode_01"
        end
        if not Datatable.Inventory then
            Datatable.Inventory = {}
        end
        if not Datatable.Health or Datatable.Health <= 0 then
            Datatable.Health = 200
        end
        if not Datatable.Armour then
            Datatable.Armour = 0
        end
        if not Datatable.Stress then
            Datatable.Stress = 0
        end
        if not Datatable.Hunger or Datatable.Hunger <= 0 then
            Datatable.Hunger = 100
        end
        if not Datatable.Thirst or Datatable.Thirst <= 0 then
            Datatable.Thirst = 100
        end
        if not Datatable.Weight then
            Datatable.Weight = BackpackWeightDefault
        end

        SetPlayerRoutingBucket(source, 0)

        vRPC.Skin(source, Datatable.Skin)
        vRP.Teleport(source, Datatable.Pos.x, Datatable.Pos.y, Datatable.Pos.z)
        TriggerClientEvent("barbershop:Apply", source, vRP.UserData(Passport, "Barbershop"))
        TriggerClientEvent("skinshop:Apply", source, vRP.UserData(Passport, "Clothings"))
        TriggerClientEvent("tattoos:Apply", source, vRP.UserData(Passport, "Tatuagens"))

        TriggerClientEvent("hud:Thirst", source, Datatable.Thirst)
        TriggerClientEvent("hud:Hunger", source, Datatable.Hunger)
        TriggerClientEvent("hud:Stress", source, Datatable.Stress)

        TriggerClientEvent("vRP:Active", source, Passport, Identity.name .. " " .. Identity.name2)
        if GetResourceMetadata("vrp", "creator") == "yes" then
            if vRP.UserData(Passport, "Creator") == 1 then
                if Global[Passport] then
                    TriggerClientEvent("spawn:Finish", source, false, false)
                else
                    TriggerClientEvent("spawn:Finish", source, true,
                        vec3(Datatable.Pos.x, Datatable.Pos.y, Datatable.Pos.z))
                end
            else
                vRP.Query("playerdata/SetData",
                    { Passport = Passport, dkey = "Creator", dvalue = json.encode(1), lastupdate = os.time() })
                TriggerClientEvent("spawn:Finish", source, false, true)
            end
        elseif Global[Passport] then
            TriggerClientEvent("spawn:Finish", source, false, false)
        else
            TriggerClientEvent("spawn:Finish", source, true, vec3(Datatable.Pos.x, Datatable.Pos.y, Datatable.Pos.z))
        end

        local Identity = vRP.Identity(Passport)
        local WebHook =
        "https://discord.com/api/webhooks/1204584393478250538/kdso3w7OedVzqEs180QTZCv1H4UuqjG4EltH98inJ301BihGN4DSOH8GbibFnceVnSFX"

        if Identity then
            local Query = exports["oxmysql"]:query_async("SELECT * FROM accounts WHERE license = @license",
                { license = Identity["license"] })

            if Query[1] ~= nil then
                SendWebhookMessage(WebHook,
                    Query[1]["discord"] .. " " .. Passport .. " " .. Identity["name"] .. " " .. Identity["name2"])
            end
        end

        local Ped = GetPlayerPed(source)
        Entity(Ped)["state"]:set("Character:Passport", Passport, true)
        Entity(Ped)["state"]:set("Character:Name", Identity["name"] .. " " .. Identity["name2"], true)

        TriggerEvent("Connect", Passport, source, Global[Passport] == nil)

        vRP.SetArmour(source, Datatable.Armour)
        vRPC.SetHealth(source, Datatable.Health)

        Global[Passport] = true
    end
    isSelectingCharacter = false
end)



function SendWebhookMessage(webhook, message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ content = message }),
            { ['Content-Type'] = 'application/json' })
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- JUSTOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:justObjects")
AddEventHandler("vRP:justObjects", function()
    local source = source
    local Passport = vRP.Passport(source)
    local Inventory = vRP.Inventory(Passport)
    if Passport then
        for i = 1, 5 do
            if Inventory[tostring(i)] and "Armamento" == itemType(Inventory[tostring(i)].item) then
                TriggerClientEvent("inventory:CreateWeapon", source, Inventory[tostring(i)].item)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BACKPACKWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:BackpackWeight")
AddEventHandler("vRP:BackpackWeight", function(value)
    local source = source
    local Passport = vRP.Passport(source)
    local Datatable = vRP.Datatable(Passport)
    if Passport then
        if value then
            if not Global[Passport] then
                Datatable.Weight = Datatable.Weight + 50
                Global[Passport] = true
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DeleteObject")
AddEventHandler("DeleteObject", function(index, value)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if value and Objects[Passport] and Objects[Passport][value] then
            index = Objects[Passport][value]
            Objects[Passport][value] = nil
        end
    end
    TriggerEvent("DeleteObjectServer", index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEOBJECTSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("DeleteObjectServer", function(entIndex)
    local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId(entIndex)
    if DoesEntityExist(NetworkGetEntityFromNetworkId) and not IsPedAPlayer(NetworkGetEntityFromNetworkId) and 3 == GetEntityType(NetworkGetEntityFromNetworkId) then
        DeleteEntity(NetworkGetEntityFromNetworkId)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DeletePed")
AddEventHandler("DeletePed", function(entIndex)
    local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId(entIndex)
    if DoesEntityExist(NetworkGetEntityFromNetworkId) and not IsPedAPlayer(NetworkGetEntityFromNetworkId) and 1 == GetEntityType(NetworkGetEntityFromNetworkId) then
        DeleteEntity(NetworkGetEntityFromNetworkId)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("DebugObjects", function(value)
    if Objects[value] then
        for k, v in pairs(Objects[value]) do
            Objects[value][k] = nil
            TriggerEvent("DeleteObjectServer", k)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("DebugWeapons", function(value)
    if Objects[value] then
        for k, v in pairs(Objects[value]) do
            TriggerEvent("DeleteObjectServer", v)
            Objects[value] = nil
        end
        Objects[value] = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GG
-----------------------------------------------------------------------------------------------------------------------------------------

local perm_mochila = {
    "Admin",
    "doadorleste",
    "doadoradvanced",
    "DoadorNatal24",
    "DoadorDiversao",
    'halloween25',
    'halloween25small',
    "DoadorDeuses",
    "DoadorMNS",
    "DoadorArc",
    "DoadorPascoa24",
    "doadorknd",
    'doadoFurious',
    "DoadorHalloween24",
    "doadorruby",
    "voltaaulas",
    "Police",
    "doadoresmeralda",
    "doadorlestemais",
    "doadorouro",
    "Ouromais",
    "Esmeraldamais",
    "Bronzemais",
    "vippatrao",
    "vipfechamento",
    "Halloween",
    "viprespeito",
    "viprolezinho",
    "vipfimeza",
    "Delas",
    "pacotenatal25",
    "casalzao",
    "inverno",
    'vipartico',
    'vipcongelado',
    'vipneve',
    "VipDemogorgon",
    "doadorazul",
    'doadorcarnaval',
    'Cupula',
    'doadorrainha',
    'feriaspremium',
    "Gachiakuta",
    "PacoteHunter",
    'feriassupremo',
    'doadorlove',
    'doadorsquidgame',
    'doadorunico',
    'doadorIntocavel',
    'doadorduquesa',
    "doadoroutono",
    'doadorohana',
    'doadorquarteto',
    'doadorpascoa',
    'doadorpascoakids',
    'doadorohanasmall',
    'Streamer3',
    'FullHouse',
    'Poke',
    'House',
    'Number',
    'Bruxo',
    'Magia',
    'levelup',
    'jokker',
    'legendary',
    'doadorset'

}

function Cehck_lose_backpack(user_id)
    for k, v in pairs(perm_mochila) do
        if vRP.HasPermission(user_id, v) then
            return false
        end
    end
    return true
end

local RespawnGroups = {
    ["PF"] = vec3(-1028.13,-2743.23,20.17),
    ["GPI"] = vec3(479.73, -1022.07, 27.99),
    ["CIVIL"] = vec3(479.73, -1022.07, 27.99),
    ["COT"] = vec3(-405.24,-2805.11,6.0),
    ["BOPE"] = vec3(-405.24,-2805.11,6.0),
    ["GARRA"] = vec3(-405.24,-2805.11,6.0),
    ["GATE"] = vec3(-405.24,-2805.11,6.0),
    ["GTM"] = vec3(-405.24,-2805.11,6.0),
    ["RPS"] = vec3(-405.24,-2805.11,6.0),
    ["Departament"] = vec3(-1028.13,-2743.23,20.17),
    ["RPN"] = vec3(-474.47,7075.11,22.16),
    ["PENAL"] = vec3(-1028.13,-2743.23,20.17),
    ["Police2"] = vec3(435.43,-974.51,30.72),
    ["EB"] = vec3(-2223.78,3168.16,32.81)
}

--[[RegisterCommand("gg", function(source)
    local source = source
    local Passport = vRP.Passport(source)
    if GetPlayerRoutingBucket(source) < 900000 and Passport and SURVIVAL.CheckDeath(source) then
        if vRP.UserPremium(Passport) then
            if ClearInventoryPremium then
                vRP.ClearInventory(Passport)
            end
        elseif CleanDeathInventory then
            vRP.ClearInventory(Passport)
        end

        local Datatable = vRP.Datatable(Passport)
        if WipeBackpackDeath and Datatable and Datatable.Weight then
           if Cehck_lose_backpack(Passport) then
                Datatable.Weight = BackpackWeightDefault
           end
        end

        vRP.UpgradeThirst(Passport, 100)
        vRP.UpgradeHunger(Passport, 100)
        vRP.DowngradeStress(Passport, 100)
        exports["vrp"]:Embed( "Airport", "**Source:** " .. source .. [[ **Passaporte:** ]]
--[[ .. Passport .. [[ **Address:** ]]
--[[.. GetPlayerEndpoint(source), 3092790)
        vRP.Query("playerdata/SetData",{ Passport = tonumber(Passport), dkey = "zo:attachs", dvalue = json.encode({}) })

        local PlayerGroup = nil

        for Permission, _ in pairs(RespawnGroups) do
            local Data = vRP.DataGroups(Permission)
            if Data[tostring(Passport)] then
                PlayerGroup = Permission
                break
            end
        end

        if PlayerGroup then
            SURVIVAL.Respawn(source, RespawnGroups[PlayerGroup])
        else
            SURVIVAL.Respawn(source)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
-- function vRP.ClearInventory(Passport)
--     local source = vRP.Source(Passport)
--     local Datatable = vRP.Datatable(Passport)
--     if source and Datatable and Datatable.Inventory then
--         exports.inventory:CleanWeapons(parseInt(Passport), true)
--         TriggerEvent("DebugObjects", parseInt(Passport))
--         TriggerEvent("DebugWeapons", parseInt(Passport))
--         Datatable.Inventory = {}
--     end
-- end--]]
RegisterCommand("gg", function(source)
    local source = source
    local Passport = vRP.Passport(source)
    
    local playerBucket = GetPlayerRoutingBucket(source)
    print("Player Bucket: ", playerBucket)  -- Debug: Verifica o bucket do jogador

    local isRobberyActive = false
    if GetResourceState("trig_home_robbery") == "started" then
        local success, result = pcall(function()
            return exports.trig_home_robbery:isRobberyActive(source)
        end)
        if success then
            isRobberyActive = result
        end
    end

    if (playerBucket < 900000 or not isRobberyActive) and Passport and SURVIVAL.CheckDeath(source) then
        local InventoryLog = vRP.GetInventoryLog(Passport)

        if vRP.UserPremium(Passport) then
            if ClearInventoryPremium then
                vRP.ClearInventory(Passport, InventoryLog)
            end
        elseif CleanDeathInventory then
            vRP.ClearInventory(Passport, InventoryLog)
        end

        local Datatable = vRP.Datatable(Passport)
        if WipeBackpackDeath and Datatable and Datatable.Weight then
            if Cehck_lose_backpack(Passport) then
                Datatable.Weight = BackpackWeightDefault
            end
        end

        vRP.UpgradeThirst(Passport, 100)
        vRP.UpgradeHunger(Passport, 100)
        vRP.DowngradeStress(Passport, 100)

        if InventoryLog == "" then
            InventoryLog = "Nenhum item no inventário."
        end

        local webhookMessage = "**Source:** " .. source ..
            "\n**Passaporte:** " .. Passport ..
            "\n**IP:** " .. GetPlayerEndpoint(source) ..
            "\n**Itens Removidos:**\n" .. InventoryLog

        exports["vrp"]:Embed("GG", webhookMessage, 3092790)

        vRP.Query("playerdata/SetData",
            { Passport = tonumber(Passport), dkey = "zo:attachs", dvalue = json.encode({}), lastupdate = os.time() })

        local PlayerGroup = nil

        for Permission, _ in pairs(RespawnGroups) do
            local Data = vRP.DataGroups(Permission)
            if Data[tostring(Passport)] then
                PlayerGroup = Permission
                break
            end
        end

        if PlayerGroup then
            SURVIVAL.Respawn(source, RespawnGroups[PlayerGroup])
        else
            SURVIVAL.Respawn(source)
        end
        exports.inventory:setSurvivalClothes(source)
    end
end)

exports("ForceDeath", function(source)
    local Passport = vRP.Passport(source)
    if vRP.GetHealth(source) <= 101 and GetPlayerRoutingBucket(source) < 900000 and Passport then
        local InventoryLog = vRP.GetInventoryLog(Passport)

        if vRP.UserPremium(Passport) then
            if ClearInventoryPremium then
                vRP.ClearInventory(Passport, InventoryLog)
            end
        elseif CleanDeathInventory then
            vRP.ClearInventory(Passport, InventoryLog)
        end

        local Datatable = vRP.Datatable(Passport)
        if WipeBackpackDeath and Datatable and Datatable.Weight then
            if Cehck_lose_backpack(Passport) then
                Datatable.Weight = BackpackWeightDefault
            end
        end

        vRP.UpgradeThirst(Passport, 100)
        vRP.UpgradeHunger(Passport, 100)
        vRP.DowngradeStress(Passport, 100)

        if InventoryLog == "" then
            InventoryLog = "Nenhum item no inventário."
        end

        local webhookMessage = "**Source:** " .. source ..
            "\n**Passaporte:** " .. Passport ..
            "\n**IP:** " .. GetPlayerEndpoint(source) ..
            "\n**Itens Removidos:**\n" .. InventoryLog

        exports["vrp"]:Embed("GG", webhookMessage, 3092790)

        vRP.Query("playerdata/SetData",
            { Passport = tonumber(Passport), dkey = "zo:attachs", dvalue = json.encode({}), lastupdate = os.time() })

        local PlayerGroup = nil

        for Permission, _ in pairs(RespawnGroups) do
            local Data = vRP.DataGroups(Permission)
            if Data[tostring(Passport)] then
                PlayerGroup = Permission
                break
            end
        end

        if PlayerGroup then
            SURVIVAL.Respawn(source, RespawnGroups[PlayerGroup])
        else
            SURVIVAL.Respawn(source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
-- Lista de itens protegidos que não serão perdidos ao dar gg
local ProtectedItems = {
    "ctroca",
    "resetchar"
}

-- Função auxiliar para verificar se um item é protegido (considera durabilidade/changes)
local function IsProtectedItem(itemName)
    if not itemName then
        return false
    end
    
    for _, protectedItem in pairs(ProtectedItems) do
        -- Verifica se o item começa com o nome protegido (pode ter sufixos como "-timestamp" ou "-charges")
        if itemName == protectedItem or string.find(itemName, "^" .. protectedItem .. "-") then
            return true
        end
    end
    
    return false
end

function vRP.ClearInventory(Passport, InventoryLog)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    --   print("ZZ ", Passport, " xx: ", InventoryLog)
    if source and Datatable and Datatable.Inventory then
        exports.inventory:CleanWeapons(parseInt(Passport), true)
        TriggerEvent("DebugObjects", parseInt(Passport))
        TriggerEvent("DebugWeapons", parseInt(Passport))
        -- Salvar itens protegidos antes de limpar o inventário
        local ProtectedItemsBackup = {}
        local InventoryData = Datatable.Inventory
        
        -- Verificar se o inventário tem estrutura 'itens' ou é direto
        if InventoryData.itens then
            -- Estrutura com 'itens'
            for k, v in pairs(InventoryData.itens) do
                if v and v["item"] and IsProtectedItem(v["item"]) then
                    ProtectedItemsBackup[k] = {
                        item = v["item"],
                        amount = v["amount"] or 1
                    }
                end
            end
        else
            -- Estrutura direta (slots como chaves)
            for k, v in pairs(InventoryData) do
                if type(v) == "table" and v["item"] and IsProtectedItem(v["item"]) then
                    ProtectedItemsBackup[k] = {
                        item = v["item"],
                        amount = v["amount"] or 1
                    }
                end
            end
        end
        if InventoryLog ~= "" then
            --SendWebhookMessage("```prolog\n[ID]: " .. Passport .. " \n[PERDEU]:\n" .. InventoryLog .. os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. " \r```")
        end
        -- Limpar o inventário
        Datatable.Inventory = {}
        
        -- Restaurar itens protegidos
        if next(ProtectedItemsBackup) ~= nil then
            -- Verificar se precisa criar estrutura 'itens' ou usar estrutura direta
            if InventoryData.itens then
                -- Se tinha estrutura 'itens', restaurar nela
                if not Datatable.Inventory.itens then
                    Datatable.Inventory.itens = {}
                end
                for k, v in pairs(ProtectedItemsBackup) do
                    Datatable.Inventory.itens[k] = {
                        item = v.item,
                        amount = v.amount
                    }
                end
            else
                -- Estrutura direta (slots)
                for k, v in pairs(ProtectedItemsBackup) do
                    Datatable.Inventory[k] = {
                        item = v.item,
                        amount = v.amount
                    }
                end
            end
        end
    end
end

function vRP.GetInventoryLog(Passport)
    local Datatable = vRP.Datatable(Passport)
    local InventoryLog = ""
    if Datatable and Datatable.Inventory then
        local InventoryData = Datatable.Inventory
        
        -- Verificar estrutura 'itens' ou direta
        local itemsToCheck = {}
        if InventoryData.itens then
            itemsToCheck = InventoryData.itens
        else
            itemsToCheck = InventoryData
        end
        
        for k, v in pairs(itemsToCheck) do
            if v and type(v) == "table" and v["amount"] and v["item"] then
                -- Só adicionar ao log se não for um item protegido
                if not IsProtectedItem(v["item"]) then
                    InventoryLog = InventoryLog .. v["amount"] .. "x " .. v["item"] .. "\n"
                end
            end
        end
    end
    return InventoryLog
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeThirst(Passport, Amount)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and source then
        if not Datatable.Thirst then
            Datatable.Thirst = 0
        end
        Datatable.Thirst = Datatable.Thirst + parseInt(Amount)
        if Datatable.Thirst > 100 then
            Datatable.Thirst = 100
        end
        TriggerClientEvent("hud:Thirst", source, Datatable.Thirst)
        --                       TriggerClientEvent("hud:Thirst",userSource,dataTable["thirst"])
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeHunger(Passport, Amount)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and source then
        if not Datatable.Hunger then
            Datatable.Hunger = 0
        end
        Datatable.Hunger = Datatable.Hunger + parseInt(Amount)
        if Datatable.Hunger > 100 then
            Datatable.Hunger = 100
        end
        TriggerClientEvent("hud:Hunger", source, Datatable.Hunger)
        --        TriggerClientEvent("hud:Hunger",userSource,dataTable["hunger"])
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeStress(Passport, Amount)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and source then
        if not Datatable.Stress then
            Datatable.Stress = 0
        end
        Datatable.Stress = Datatable.Stress + parseInt(Amount)
        if Datatable.Stress > 100 then
            Datatable.Stress = 0 --100
        end
        TriggerClientEvent("hud:Stress", source, Datatable.Stress)
        --               TriggerClientEvent("hud:Stress",userSource,dataTable["stress"])
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeThirst(Passport, Amount)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and source then
        if not Datatable.Thirst then
            Datatable.Thirst = 100
        end
        Datatable.Thirst = Datatable.Thirst - parseInt(Amount)
        if Datatable.Thirst < 0 then
            Datatable.Thirst = 0
        end
        TriggerClientEvent("hud:Thirst", source, Datatable.Thirst)
        --                       TriggerClientEvent("hud:Thirst",userSource,dataTable["thirst"])
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeHunger(Passport, Amount)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and source then
        if not Datatable.Hunger then
            Datatable.Hunger = 100
        end
        Datatable.Hunger = Datatable.Hunger - parseInt(Amount)
        if Datatable.Hunger < 0 then
            Datatable.Hunger = 0
        end
        TriggerClientEvent("hud:Hunger", source, Datatable.Hunger)
        --        TriggerClientEvent("hud:Hunger",userSource,dataTable["hunger"])
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeStress(Passport, Amount)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and source then
        if not Datatable.Stress then
            Datatable.Stress = 0
        end
        Datatable.Stress = Datatable.Stress - parseInt(Amount)
        if Datatable.Stress < 0 then
            Datatable.Stress = 0
        end
        TriggerClientEvent("hud:Stress", source, Datatable.Stress)
        --               TriggerClientEvent("hud:Stress",userSource,dataTable["stress"])
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FOODS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.Foods()
    local source = source
    local Passport = vRP.Passport(source)
    local Datatable = vRP.Datatable(Passport)
    if source and Datatable then
        if not Datatable.Thirst then
            Datatable.Thirst = 100
        end
        if not Datatable.Hunger then
            Datatable.Hunger = 100
        end
        Datatable.Hunger = Datatable.Hunger - 1
        Datatable.Thirst = Datatable.Thirst - 1
        if Datatable.Thirst < 0 then
            Datatable.Thirst = 0
        end
        if Datatable.Hunger < 0 then
            Datatable.Hunger = 0
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetHealth(source)
    local GetPlayerPed = GetPlayerPed(source)
    return GetEntityHealth(GetPlayerPed)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ModelPlayer(source)
    local GetPlayerPed = GetPlayerPed(source)
    if GetEntityModel(GetPlayerPed) == GetHashKey("mp_f_freemode_01") then
        return "mp_f_freemode_01"
    elseif GetEntityModel(GetPlayerPed) == GetHashKey("mp_m_freemode_01") then
        return "mp_m_freemode_01"
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetExperience(Passport, Work)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and not Datatable[Work] then
        Datatable[Work] = 0
    end
    return Datatable[Work] or 0
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PutExperience(Passport, Work, Number)
    local Datatable = vRP.Datatable(Passport)
    if Datatable then
        if not Datatable[Work] then
            Datatable[Work] = 0
        end

        Datatable[Work] = Datatable[Work] + Number

        local source = vRP.Source(Passport)
        if source then
            if Work == "Fishing" then
                TriggerClientEvent("fishing/updateLevel", source, Datatable[Work])
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetArmour(source, Amount)
    local GetPlayerPed = GetPlayerPed(source)
    if GetPedArmour(GetPlayerPed) + Amount > 100 then
        Amount = 100 - GetPedArmour(GetPlayerPed)
    end
    SetPedArmour(GetPlayerPed, GetPedArmour(GetPlayerPed) + Amount)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Teleport(source, x, y, z)
    local GetPlayerPed = GetPlayerPed(source)
    if not DoesEntityExist(GetPlayerPed) then
        return
    end

    if Player(source).state.Noclip then
        vRPC.Teleport(source, x + 1.0E-4, y + 1.0E-4, z + 1.0E-4)
    else
        SetEntityCoords(GetPlayerPed, x + 1.0E-4, y + 1.0E-4, z + 1.0E-4, false, false, false, false)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETENTITYCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetEntityCoords(source)
    local GetPlayerPed = GetPlayerPed(source)
    return GetEntityCoords(GetPlayerPed)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- INSIDEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InsideVehicle(source)
    local Ped = GetPlayerPed(source)
    if GetVehiclePedIsIn(Ped, false) ~= 0 then
        return true
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEPED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.CreatePed(Model, x, y, z, heading, typ)
    local SpawnPed = 0
    local Hash = GetHashKey(Model)
    local Ped = CreatePed(typ, Hash, x, y, z, heading, true, false)
    if DoesEntityExist(Ped) then
        return true, NetworkGetNetworkIdFromEntity(Ped)
    end
    while true do
        if not DoesEntityExist(Ped) and SpawnPed <= 1000 then
            SpawnPed = SpawnPed + 1
            Wait(1)
        end
    end
    -- return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.CreateObject(Model, x, y, z, Weapon)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local SpawnObjects = 0
        local Hash = GetHashKey(Model)
        local Object = CreateObject(Hash, x, y, z, true, true, false)

        -- Loop de espera até a entidade existir ou limite de tentativas
        while not DoesEntityExist(Object) and SpawnObjects <= 100 do
            SpawnObjects = SpawnObjects + 1
            Wait(1)
        end

        -- Verifica se a entidade foi criada corretamente
        if not DoesEntityExist(Object) then
            print(string.format("^1[ERRO]^7 Falha ao criar objeto | Model: %s | Coords: %.2f, %.2f, %.2f | Weapon: %s | Passport: %s | Tentativas: %d", 
                Model or "nil", 
                x or 0, 
                y or 0, 
                z or 0, 
                Weapon or "nil", 
                Passport or "nil",
                SpawnObjects
            ))
            return false
        end

        local NetId = NetworkGetNetworkIdFromEntity(Object)
        if NetId then
            -- Adiciona o objeto à lista associada ao passaporte
            if not Objects[Passport] then
                Objects[Passport] = {}
            end

            if Weapon then
                Objects[Passport][Weapon] = NetId
            else
                Objects[Passport][NetId] = true
            end
            return true, NetId
        else
            -- Caso não consiga pegar o Network ID, limpa a entidade
            DeleteEntity(Object)
            print("Erro: Falha ao obter Network ID do objeto.")
        end
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        for k, v in pairs(Sources) do
            vRP.DowngradeHunger(k, ConsumeHunger)
            vRP.DowngradeThirst(k, ConsumeThirst)
        end
        Wait(CooldownHungerThrist)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKETCLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:BucketClient")
AddEventHandler("vRP:BucketClient", function(value)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if value == "Enter" then
            Player(source).state.Route = Passport
            SetPlayerRoutingBucket(source, Passport)
        else
            Player(source).state.Route = 0
            SetPlayerRoutingBucket(source, 0)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKETSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:BucketServer")
AddEventHandler("vRP:BucketServer", function(source, value, bucket)
    if value == "Enter" then
        Player(source).state.Route = bucket
        SetPlayerRoutingBucket(source, bucket)
        if bucket > 0 then
            SetRoutingBucketEntityLockdownMode(bucket, "inactive")
            -- SetRoutingBucketEntityLockdownMode(bucket, "relaxed")
            SetRoutingBucketPopulationEnabled(bucket, false)
        end
    else
        Player(source).state.Route = 0
        SetPlayerRoutingBucket(source, 0)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
    TriggerEvent("DebugObjects", Passport)
    TriggerEvent("DebugWeapons", Passport)
end)

function vRPC.VehicleName(source)
    local Vehicle, Network, Plate, vehName = vRPC.VehicleList(source, 8)
    return vehName
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, Source)
    local group_title = nil
    local Ped = GetPlayerPed(Source)

    for identifier, data in pairs(Groups) do
        if data and data.Type == "Ilegal" and vRP.HasGroup(Passport, identifier) then
            group_title = data.RealName or identifier
            break
        end
    end

    if not group_title then
        for identifier, data in pairs(Groups) do
            if data and data.Type == "Work" and vRP.HasGroup(Passport, identifier) then
                group_title = data.RealName or identifier
                break
            end
        end
    end

    local Streamers = { "Streamer1", "Streamer2", "Streamer3" }
    for _, v in pairs(Streamers) do
        if vRP.HasGroup(Passport, v) then
            local Identity = vRP.Identity(Passport)
            if Ped then
                Entity(Ped)["state"]:set("Character:Name", "~p~" .. Identity["name"] .. " " .. Identity["name2"] .. "~w~",
                    true)
            end

            break
        end
    end

    Entity(Ped)["state"]:set("Character:Group", group_title, true)
end)

AddEventHandler("vrp/updateGroups", function(Passport, Source)
    local group_title = nil

    for identifier, data in pairs(Groups) do
        if data and data.Type == "Ilegal" and vRP.HasGroup(Passport, identifier) then
            group_title = data.RealName or identifier
            break
        end
    end

    if not group_title then
        for identifier, data in pairs(Groups) do
            if data and data.Type == "Work" and vRP.HasGroup(Passport, identifier) then
                group_title = data.RealName or identifier
                break
            end
        end
    end

    if Source then
        local Ped = GetPlayerPed(Source)
        if DoesEntityExist(Ped) then
            Entity(Ped)["state"]:set("Character:Group", group_title, true)
        end
    end
end)
