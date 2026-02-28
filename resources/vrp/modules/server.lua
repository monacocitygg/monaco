-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Sources = {}
Characters = {}
-- GlobalState["Players"] = {}
local Players = {}
GlobalState["UploadServer"] =
""
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERIES
-----------------------------------------------------------------------------------------------------------------------------------------
local Prepares = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Prepare(Name, Query)
    Prepares[Name] = Query
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Query(Name, Params)
    --    print(Name,json.encode(Params))
    return exports["oxmysql"]:query_async(Prepares[Name], Params)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITIES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Identities(source)
    local Result = false

    local Identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(Identifiers) do
        if string.find(v, BaseMode) then
            local SplitName = splitString(v, ":")
            Result = SplitName[2]
            break
        end
    end

    return Result
end

function vRP.GetSteamHex(source)
    local Result = false

    local Identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(Identifiers) do
        if string.find(v, "steam") then
            local SplitName = splitString(v, ":")
            Result = SplitName[2]
            break
        end
    end

    return Result
end

function SaveUserIds(source, user_identifier)
    local source = source
    if source ~= 0 then
        local tokens = GetPlayerTokens(source)
        for k, v in pairs(tokens) do
            vRP.Query("vRP/AddUserIds", { user_id = user_identifier, ids = v })
        end
    end
end

function vRP.GetUserTokens(user_id)
    local row = vRP.Query("vRP/GetUserIds", { user_id = user_id })
    if row then
        return row
    else
        return false
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Archive(Archive, Text)
    Archive = io.open(Archive, "a")
    if Archive then
        Archive.write(Archive, Text .. "\n")
    end

    Archive.close(Archive)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Banned(License)
    local Consult = vRP.Query("banneds/GetBanned", { license = License })
    if Consult[1] then
        if Consult[1]["time"] <= os.time() then
            vRP.Query("banneds/RemoveBanned", { license = License })
            return false
        end

        local timeRemaining = Consult[1]["time"] - os.time()
        local daysRemaining = math.floor(timeRemaining / (24 * 60 * 60))
        local hoursRemaining = math.floor((timeRemaining % (24 * 60 * 60)) / (60 * 60))

        return { banned = true, days = daysRemaining, hours = hoursRemaining }
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTOKEN
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckToken(source, License)
    local Token = GetPlayerTokens(source)
    for k, v in pairs(Token) do
        local Consult = vRP.Query("banneds/GetToken", { token = v })
        if Consult[1] then
            return false
        end

        vRP.Query("banneds/InsertToken", { token = v, License = License })
    end

    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Account(License)
    local Consult = vRP.Query("accounts/Account", { license = License })
    return Consult[1] or false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserData(Passport, Key)
    local Consult = vRP.Query("playerdata/GetData", { Passport = Passport, dkey = Key })
    if Consult[1] then
        return json.decode(Consult[1]["dvalue"])
    else
        return {}
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- INSIDEPROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InsidePropertys(Passport, Coords)
    local Datatable = vRP.Datatable(Passport)
    if Datatable then
        Datatable["Pos"] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]) }
    end
end

local function table_deepclone(tbl)
    tbl = table.clone(tbl)

    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            tbl[k] = table_deepclone(v)
        end
    end

    return tbl
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Inventory(Passport)
    local Datatable = vRP.Datatable(Passport)
    if Datatable then
        if not Datatable["Inventory"] then
            Datatable["Inventory"] = {
                itens = {},
                hotbar = {}
            }
        end


        if not Datatable["Inventory"].itens then
            local itens = table_deepclone(Datatable["Inventory"])
            Datatable["Inventory"].itens = itens
            Datatable["Inventory"].hotbar = {}
        end

        return Datatable["Inventory"].itens, Datatable["Inventory"].hotbar
    end

    return {}, {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVETEMPORARY
-------------------------------------- ---------------------------------------------------------------------------------------------------
function vRP.SaveTemporary(Passport, source, Route)
    local source = source
    local Datatable = vRP.Datatable(Passport)
    local Ped = GetPlayerPed(source)
    if not Prepares[Passport] and Datatable then
        Prepares[Passport] = {}
        Prepares[Passport]["Inventory"] = Datatable["Inventory"]
        Prepares[Passport]["Health"] = GetEntityHealth(Ped)
        Prepares[Passport]["Armour"] = GetPedArmour(Ped)
        Prepares[Passport]["Stress"] = Datatable["Stress"]
        Prepares[Passport]["Hunger"] = Datatable["Hunger"]
        Prepares[Passport]["Thirst"] = Datatable["Thirst"]
        Prepares[Passport]["route"] = Route

        vRPC._setArmour(source, 100)
        vRPC._SetHealth(source, 200)
        vRP.UpgradeHunger(Passport, 100)
        vRP.UpgradeThirst(Passport, 100)
        vRP.DowngradeStress(Passport, 100)

        TriggerEvent("inventory:saveTemporary", Passport)

        Datatable["Inventory"] = {}
        for Number, v in pairs(ArenaItens) do
            vRP.GenerateItem(Passport, Number, v, false)
        end

        TriggerEvent("vRP:BucketServer", source, "Enter", Route)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTEMPORARY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ApplyTemporary(Passport, source)
    local source = source
    local Datatable = vRP.Datatable(Passport)
    local Ped = GetPlayerPed(source)
    if Prepares[Passport] and Datatable then
        Datatable["Inventory"] = {}
        Datatable["Inventory"] = Prepares[Passport]["Inventory"]
        Datatable["Stress"] = Prepares[Passport]["Stress"]
        Datatable["Hunger"] = Prepares[Passport]["Hunger"]
        Datatable["Thirst"] = Prepares[Passport]["Thirst"]

        TriggerClientEvent("hud:Thirst", source, Datatable["Thirst"])
        TriggerClientEvent("hud:Hunger", source, Datatable["Hunger"])
        TriggerClientEvent("hud:Stress", source, Datatable["Stress"])

        vRPC._setArmour(source, Prepares[Passport]["Armour"])
        vRPC._SetHealth(source, Prepares[Passport]["Health"])
        TriggerEvent("inventory:applyTemporary", Passport)
        TriggerEvent("vRP:BucketServer", source, "Exit")
        Prepares[Passport] = nil
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVETEMPORARY
-------------------------------------- ---------------------------------------------------------------------------------------------------
function vRP.SaveTemporary2(Passport, source, Route)
    local source = source
    local Datatable = vRP.Datatable(Passport)
    local Ped = GetPlayerPed(source)
    if not Prepares[Passport] and Datatable then
        Prepares[Passport] = {}
        Prepares[Passport]["Inventory"] = Datatable["Inventory"]
        Prepares[Passport]["Health"] = GetEntityHealth(Ped)
        Prepares[Passport]["Armour"] = GetPedArmour(Ped)
        Prepares[Passport]["Stress"] = Datatable["Stress"]
        Prepares[Passport]["Hunger"] = Datatable["Hunger"]
        Prepares[Passport]["Thirst"] = Datatable["Thirst"]
        Prepares[Passport]["route"] = Route

        vRPC._setArmour(source, 100)
        vRPC._SetHealth(source, 200)
        vRP.UpgradeHunger(Passport, 100)
        vRP.UpgradeThirst(Passport, 100)
        vRP.DowngradeStress(Passport, 100)

        TriggerEvent("inventory:saveTemporary", Passport)

        Datatable["Inventory"] = {}


        TriggerEvent("vRP:BucketServer", source, "Enter", Route)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SkinCharacter(Passport, Hash)
    local Datatable = vRP.Datatable(Passport)
    if Datatable then
        Datatable["Skin"] = Hash
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Passport(source)
    if Characters[source] then
        return Characters[source]["id"]
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FULLNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.FullName(source)
    if Characters[source] then
        return Characters[source]["name"] .. " " .. Characters[source]["name2"]
    end

    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Players()
    return Sources
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Source(Passport)
    return Sources[parseInt(Passport)]
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Datatable(Passport)
    if Characters[Sources[parseInt(Passport)]] then
        return Characters[Sources[parseInt(Passport)]]["table"]
    end

    return false
end

exports('Datatable', vRP.Datatable)

--- Change the value of a key in the datatable for a specific passport.
--- @param Passport any
--- @param Key string
--- @param Value any
--- @return boolean|any
function vRP.setDatatable(Passport, Key, Value)
    local Datatable = Characters[Sources[parseInt(Passport)]]

    if Datatable and Datatable["table"] then
        Characters[Sources[parseInt(Passport)]]["table"][Key] = Value
        return Characters[Sources[parseInt(Passport)]]["table"][Key]
    end

    return false
end

exports('setDatatable', vRP.setDatatable)

-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Kick(source, Reason)
    DropPlayer(source, Reason)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped", function(Reason)
    local Ped = GetPlayerPed(source)
    local Health = GetEntityHealth(Ped)
    local Armour = GetPedArmour(Ped)
    local Coords = GetEntityCoords(Ped)
    if Characters[source] and DoesEntityExist(Ped) then
        Disconnect(source, Health, Armour, Coords, Reason)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Disconnect(source, Health, Armour, Coords, Reason)
    local source = source
    local Passport = vRP.Passport(source)
    local Datatable = vRP.Datatable(Passport)
    if Passport then
        TriggerEvent("Discord", "Disconnect",
            "**Source:** " ..
            source ..
            "\n**Passaporte:** " ..
            Passport ..
            "\n**Health:** " .. Health .. "\n**Armour:** " .. Armour .. "\n**Cds:** " .. Coords ..
            "\n**Motivo:** " .. Reason, 3092790)

        if Datatable then
            if Prepares[Passport] then
                Datatable["Stress"] = Prepares[Passport]["Stress"]
                Datatable["Hunger"] = Prepares[Passport]["Hunger"]
                Datatable["Thirst"] = Prepares[Passport]["Thirst"]
                Datatable["Armour"] = Prepares[Passport]["Armour"]
                Datatable["Health"] = Prepares[Passport]["Health"]
                Datatable["Inventory"] = Prepares[Passport]["Inventory"]
                Datatable["Pos"] = { x = BackArenaPos["x"], y = BackArenaPos["y"], z = BackArenaPos["z"] }
                TriggerEvent("arena:Players", "-", Prepares[Passport]["route"])
                Prepares[Passport] = nil
            else
                Datatable["Health"] = Health
                Datatable["Armour"] = Armour
                Datatable["Pos"] = {
                    x = mathLength(Coords["x"]),
                    y = mathLength(Coords["y"]),
                    z = mathLength(Coords["z"])
                }
            end

            local temporaryData = Player(source).state.temporaryDataHideAndSeek or Player(source).state.temporaryDataWar

            if temporaryData then
                Datatable["Health"] = temporaryData.health
                Datatable["Armour"] = temporaryData.armour
                Datatable["Pos"] = {
                    x = mathLength(temporaryData.coords["x"]),
                    y = mathLength(temporaryData.coords["y"]),
                    z = mathLength(temporaryData.coords["z"])
                }
            end

            TriggerEvent("Disconnect", Passport, source)
            vRP.Query("playerdata/SetData",
                { Passport = Passport, dkey = "Datatable", dvalue = json.encode(Datatable), lastupdate = os.time() })
            Characters[source] = nil
            Sources[Passport] = nil

            --[[ if GlobalState["Players"][source] then
                GlobalState["Players"][source] = nil
                GlobalState:set("Players", GlobalState["Players"],true)
            end ]]
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaveServer", function()
    for Number, v in pairs(Sources) do
        local Datatable = vRP.Datatable(Number)
        if Datatable then
            vRP.Query("playerdata/SetData",
                { Passport = Number, dkey = "Datatable", dvalue = json.encode(Datatable), lastupdate = os.time() })
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TX:ADMIN::EVENTS.SCHEDULEDRESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 300 then -- 5 minutos
        CreateThread(function()
            print('^3[vRP-CORE] - ^0System: Scheduled restart in 3 minutes ... ^2' .. os.date("%d/%m/%Y %H:%M:%S"))
            Maintenance = true
            MaintenanceText = "Servidor esta programado para reiniciar em 3 minutos."
        end)
    elseif eventData.secondsRemaining == 240 then
        CreateThread(function()
            print(
                '^3[vRP-CORE] - ^0System: Scheduled restart in 240 seconds and saving all players data to the database ... ^2' ..
                os.date("%d/%m/%Y %H:%M:%S"))

            local List = GetPlayers()

            for _, Source in pairs(List) do
                vRP.Kick(Source, "Desconectado, a cidade esta reiniciando.")
            end

            print(
                '^4[vRP-CORE] - ^0System: All players have been disconnected and their data saved to the database ... ^2' ..
                os.date("%d/%m/%Y %H:%M:%S"))
            TriggerEvent("SaveServer", false)
        end)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE:CONNECTING ANTIGA (CASO DE ERRO EM ALGO, VOLTAR ESSA!)
-----------------------------------------------------------------------------------------------------------------------------------------

--[[
AddEventHandler("Queue:Connecting", function(source, Identifiers, Deferrals)
    local source = source
    Deferrals.defer()
    SetPlayerRoutingBucket(source, source)

    local Identity = vRP.Identities(source)
    SaveUserIds(source, Identity)

    if Identity then
        local Account = vRP.Account(Identity)
        if not Account then
            vRP.Query("accounts/newAccount", { license = Identity })
        end

        if Maintenance then
            if MaintenanceLicenses[Identity] then
                Deferrals.done()
            else
                Deferrals.done(MaintenanceText)
            end
        else
            local banStatus = vRP.Banned(Identity)
            if banStatus and banStatus.banned then
                local banMessage = string.format("<b><span style='color:red;'>VOCÊ ESTÁ BANIDO!</span><br><span style='color:green;'>Faltam %d dias e %d horas para o fim do banimento.</span></b>", banStatus.days, banStatus.hours)
                Deferrals.done(banMessage)
            else
                if Whitelisted then
                    local Account = vRP.Account(Identity)
                    if Account["whitelist"] then
                        Deferrals.done()
                    else
                        Deferrals.done(ReleaseText .. ": " .. Account["id"])
                    end
                else
                    Deferrals.done()
                end
            end
        end
    else
        Deferrals.done("Conexão perdida 2.")
    end

    TriggerEvent("Queue:Remove", Identifiers)
end)
--]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE:CONNECTING NOVA!!!! ~~~~~~~~~~ CASO DE ERRO EM ALGO DA VRP, VOLTAR ACIMA
-----------------------------------------------------------------------------------------------------------------------------------------
---~~~~~~~~~~ CASO DE ERRO EM ALGO DA VRP, DESCOMENTAR ACIMA
---~~~~~~~~~~ CASO DE ERRO EM ALGO DA VRP, DESCOMENTAR ACIMA
---~~~~~~~~~~ CASO DE ERRO EM ALGO DA VRP, DESCOMENTAR ACIMA
---~~~~~~~~~~ CASO DE ERRO EM ALGO DA VRP, DESCOMENTAR ACIMA
---~~ BY: NOEZINHOS ~~
AddEventHandler("Queue:Connecting", function(source, Identifiers, Deferrals)
    local source = source
    Deferrals.defer()
    SetPlayerRoutingBucket(source, source)

    local Identity = vRP.Identities(source)
    SaveUserIds(source, Identity)

    if Identity then
        local Account = vRP.Account(Identity)
        if not Account then
            vRP.Query("accounts/newAccount", { license = Identity })
        end

        if Maintenance then
            if MaintenanceLicenses[Identity] then
                Deferrals.done()
            else
                Deferrals.done(MaintenanceText)
            end
        else
            local banStatus = vRP.Banned(Identity)
            if banStatus and banStatus.banned then
                Wait(50)
                Deferrals.presentCard([==[{
                    "type": "AdaptiveCard",
                    "body": [
                        {
                            "type": "TextBlock",
                            "size": "ExtraLarge",
                            "weight": "Bolder",
                            "color": "Attention",
                            "text": "🚫 VOCÊ ESTÁ BANIDO DA CIDADE 🚫",
                            "wrap": true,
                            "horizontalAlignment": "Center"
                        },
                        {
                            "type": "ColumnSet",
                            "columns": [
                                {
                                    "type": "Column",
                                    "width": "auto",
                                    "items": [
                                        {
                                            "type": "TextBlock",
                                            "size": "Medium",
                                            "weight": "Bolder",
                                            "text": "ID da conta:",
                                            "wrap": true
                                        },
                                        {
                                            "type": "TextBlock",
                                            "size": "Medium",
                                            "text": "]==] .. Account.id .. [==[",
                                            "wrap": true
                                        },
                                        {
                                            "type": "TextBlock",
                                            "size": "Medium",
                                            "weight": "Bolder",
                                            "text": "Tempo de banimento:",
                                            "wrap": true
                                        },
                                        {
                                            "type": "TextBlock",
                                            "size": "Medium",
                                            "text": "Faltam ]==] ..
                    banStatus.days .. [==[ dias e ]==] .. banStatus.hours .. [==[ horas",
                                            "wrap": true
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "type": "TextBlock",
                            "separator": true,
                            "text": "_____________________________________________________",
                            "wrap": true
                        },
                        {
                            "type": "TextBlock",
                            "text": "Caso tenha alguma dúvida sobre seu banimento, abra um ticket em SUPORTE.",
                            "wrap": true
                        },
                        {
                            "type": "ActionSet",
                            "actions": [
                                {
                                    "type": "Action.OpenUrl",
                                    "title": "Acesse o Discord",
                                    "url": "https://discord.gg/monaco",
                                    "iconUrl": "https://cdn.iconscout.com/icon/free/png-256/discord-2752210-2285027.png"
                                }
                            ]
                        }
                    ],
                    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                    "version": "1.5"
                }]==], function(data, rawData)
                    end)
            else
                if Whitelisted then
                    Account = vRP.Account(Identity)
                    if Account["whitelist"] then
                        Deferrals.done()
                    else
                        Deferrals.done(ReleaseText .. ": " .. Account["id"])
                    end
                else
                    Deferrals.done()
                end
            end
        end
    else
        Deferrals.done("Conexão perdida 2.")
    end

    TriggerEvent("Queue:Remove", Identifiers)
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CharacterChosen(source, Passport, Model)
    if source then
        local Consult = vRP.Query("characters/Person", { id = Passport })
        if not Consult or not Consult[1] then return end
        local Identity = vRP.Identities(source)
        local Account = vRP.Account(Identity)
        if not Account or type(Account) ~= "table" then
            Account = { gems = 0, rolepass = 0, premium = 0, discord = "", chars = 1, id = 0, whitelist = 0 }
        end
        Sources[Passport] = source
        if not Characters[source] then
            Characters[source] = {}
            Characters[source]["bank"] = Consult[1]["bank"]
            Characters[source]["id"] = Consult[1]["id"]
            Characters[source]["sex"] = Consult[1]["sex"]
            Characters[source]["blood"] = Consult[1]["blood"]
            Characters[source]["prison"] = Consult[1]["prison"]
            Characters[source]["fines"] = Consult[1]["fines"]
            Characters[source]["phone"] = Consult[1]["phone"]
            Characters[source]["name"] = Consult[1]["name"]
            Characters[source]["name2"] = Consult[1]["name2"]
            Characters[source]["license"] = Consult[1]["license"]
            Characters[source]["gems"] = Account["gems"]
            Characters[source]["rolepass"] = Account["rolepass"]
            Characters[source]["medicplan"] = Consult[1]["medicplan"]
            Characters[source]["premium"] = Account["premium"]
            Characters[source]["discord"] = Account["discord"]
            Characters[source]["chars"] = Account["chars"]
            Characters[source]["table"] = vRP.UserData(Passport, "Datatable")

            Players[source] = Passport
            --[[ GlobalState["Players"] = Players
            GlobalState:set("Players",GlobalState["Players"],true) ]]

            if Model then
                Characters[source]["table"]["Skin"] = Model
                Characters[source]["table"]["Inventory"] = {}

                for Number, v in pairs(CharacterItens) do
                    vRP.GenerateItem(Passport, Number, v, false)
                end

                vRP.SetWeight(Passport, BackpackWeightDefault)
                if NewItemIdentity then
                    vRP.GenerateItem(Passport, "identity-" .. Passport, 1, false)
                end

                vRP.Query("playerdata/SetData",
                    {
                        Passport = Passport,
                        dkey = "Barbershop",
                        dvalue = json.encode({ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }),
                        lastupdate =
                            os.time()
                    })
                vRP.Query("playerdata/SetData",
                    {
                        Passport = Passport,
                        dkey = "Clothings",
                        dvalue = json.encode(StartClothes[Model]),
                        lastupdate = os
                            .time()
                    })
                vRP.Query("playerdata/SetData",
                    {
                        Passport = Passport,
                        dkey = "Datatable",
                        dvalue = json.encode(Characters[source]["table"]),
                        lastupdate =
                            os.time()
                    })
            end

            if 0 < Account["gems"] then
                TriggerClientEvent("hud:AddGems", source, Account["gems"])
            end

            TriggerEvent("Discord", "Connect",
                "**Source:** " .. source .. "\n**Passaporte:** " .. Passport .. "\n**Ip:** " .. GetPlayerEndpoint(source),
                3092790)
        end

        TriggerEvent("CharacterChosen", Passport, source, true)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    SetMapName(ServerName)
    SetGameType(ServerName)
    SetRoutingBucketEntityLockdownMode(0, "inactive")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REWARDS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:Rewards", function(source)
    local source = source
    local Date = parseInt(os.date("%d"))
    if Characters[source] and Characters[source]["rolepass"] > 0 and Date > Characters[source]["rolepass"] and Rewards[Date] then
        vRP.GenerateItem(Characters[source]["id"], Rewards[Date].item, Rewards[Date].amount, false)
        TriggerClientEvent("inventory:Update", source, "Backpack")

        if Date >= 30 then
            vRP.UpdateRolepass(source, 0)
        else
            vRP.UpdateRolepass(source, Date)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:ActivePass", function(source)
    local source = source
    local Date = parseInt(os.date("%d"))
    if Characters[source] then
        for Number = 1, Date do
            if Rewards[Date] then
                vRP.GenerateItem(Characters[source]["id"], Rewards[Number].item, Rewards[Number].amount, false)
                TriggerClientEvent("inventory:Update", source, "Backpack")
            end
        end

        if Date >= 31 then
            vRP.UpdateRolepass(source, Date)
        elseif Date <= 30 then
            vRP.UpdateRolepass(source, Date)
        end
    end
end)

local save_pos_users = {}

RegisterNetEvent("vrp:disable_savePost", function(src, toggle)
    local source = src or source
    if source then
        save_pos_users[source] = toggle
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1000*60*10)
--         local players = GetPlayers()
--         for k,_sources in pairs(players) do
--             local source = tonumber(_sources)
--             local Passport = vRP.Passport(source)
--             local Datatable = vRP.Datatable(Passport)
--             if Passport then
--                 local ped = GetPlayerPed(source)
--                 if Datatable then
--                     if ped then
--                         local Coords = GetEntityCoords(ped)
--                         local Health = GetEntityHealth(ped)
--                         local Armour = GetPedArmour(ped)
--                         if Prepares[Passport] then
--                             Datatable["Stress"] = Prepares[Passport]["Stress"]
--                             Datatable["Hunger"] = Prepares[Passport]["Hunger"]
--                             Datatable["Thirst"] = Prepares[Passport]["Thirst"]
--                             Datatable["Armour"] = Prepares[Passport]["Armour"]
--                             Datatable["Health"] = Prepares[Passport]["Health"]
--                             Datatable["Inventory"] = Prepares[Passport]["Inventory"]
--                             if not save_pos_users[source] then
--                                 Datatable["Pos"] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]) }
--                             end
--                         else
--                             Datatable["Health"] = Health
--                             Datatable["Armour"] = Armour
--                             if not save_pos_users[source]  then
--                                 Datatable["Pos"] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]) }
--                             end
--                         end
--                         vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Datatable", dvalue = json.encode(Datatable) })
--                     end
--                 end
--             end
--         end
--     end
-- end)

RegisterCommand("addmanutencao", function(source, args)
    if source == 0 then
        if not args[1] then
            print("Usage: addmanutencao <[license]>")
            return
        end
        if Maintenance then
            MaintenanceLicenses[args[1]] = true
            print("[VRP] LICENSE DE ACESSO A MANUTENÇÃO ADICIONADA ^3" .. args[1])
        end
    end
end)
