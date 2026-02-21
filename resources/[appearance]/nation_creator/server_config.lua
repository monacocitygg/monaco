local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_creator")
func = {}
Tunnel.bindInterface("nation_creator", func)
vHUD = Tunnel.getInterface("hud")

multiCharacter = true

---------------------------------------------------------------------------
-----------------------VERIFICAÇÃO DE PERMISSÃO--------------------------
---------------------------------------------------------------------------
if multiCharacter then
    vRP._Prepare("nation_creator/createAgeColumn",
        "ALTER TABLE characters ADD IF NOT EXISTS age INT(11) NOT NULL DEFAULT 20")
    vRP._Prepare("nation_creator/update_user_first_spawn",
        "UPDATE characters SET name2 = @firstname, name = @name, age = @age, sex = @sex WHERE id = @user_id")
    vRP._Prepare("nation_creator/create_characters",
        "INSERT INTO characters(license,name,name2,phone,blood) VALUES(@steam,@name,@name2,@phone,@blood)")
    vRP._Prepare("nation_creator/remove_characters", "UPDATE characters SET deleted = 1 WHERE id = @id")
    vRP._Prepare("nation_creator/get_characters", "SELECT * FROM characters WHERE license = @steam and deleted = 0")
    vRP._Prepare("nation_creator/get_character",
        "SELECT * FROM characters WHERE license = @steam and deleted = 0 and id = @user_id")
    vRP._Prepare("nation_creator/get_bank",
        "SELECT * FROM bank WHERE Passport = @user_id AND mode = 'Private' AND owner = 1")
    CreateThread(function() vRP.Query("nation_creator/createAgeColumn") end) -- criar coluna idade na db
else
    vRP._Prepare("nation_creator/update_user_first_spawn",
        "UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")
end

function func.checkPermission(permission, src)
    local source = src or source
    local user_id = vRP.getUserId(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.HasPermission(user_id, perm) then
                return true
            end
        end
        return false
    end
    return vRP.HasPermission(user_id, permission)
end

function func.saveChar(name, lastName, age, char, id)
    local source = source
    local user_id = id or vRP.getUserId(source)
    if char then
        vRP.setUData(user_id, "nation_char", json.encode(char, { indent = false }))
    end
    local sex = "M"
    if name and lastName and age then
        if GetEntityModel(GetPlayerPed(source)) == GetHashKey("mp_f_freemode_01") then
            sex = "F"
        end
        vRP.Query("nation_creator/update_user_first_spawn",
            { user_id = user_id, firstname = lastName, name = name, age = age, sex = sex })
    end
    TriggerClientEvent("nation_barbershop:init", source, char)
    local skin = "mp_m_freemode_01"
    if sex == "F" then
        skin = "mp_f_freemode_01"
    end
    vRP.SkinCharacter(user_id, skin)
    vRP.playerDropped(source, "Atualizando Personagem.")
    vRP.CharacterChosen(source, user_id, nil)
    Player(source).state.name = name .. ' ' .. lastName
    return true
end

function getUserChar(user_id, source, nation)
    local char
    local data = vRP.getUData(user_id, "nation_char")
    if data and data.hair then
        char = data
        char.gender = getGender(user_id) or char.gender
    end
    return char
end

local userlogin = {}
function playerSpawn(user_id, source, first_spawn)
    if first_spawn then
        Wait(5000)
        processSpawnController(source, getUserChar(user_id, source), user_id)
    end
end

AddEventHandler("vRP:playerSpawn", playerSpawn)

function processSpawnController(source, char, user_id)
    getUserLastPosition(source, user_id)
    local source = source
    if char then
        if not userlogin[user_id] then
            userlogin[user_id] = true
            fclient._spawnPlayer(source, false)
        else
            fclient._spawnPlayer(source, true)
        end
        fclient.setPlayerChar(source, char, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, user_id)
        fclient._setClothing(source, getUserClothes(user_id))

        TriggerClientEvent("freezePlayer", source, true)
        SetTimeout(5000, function()
            TriggerClientEvent("freezePlayer", source, false)
        end)
    else
        userlogin[user_id] = true
        fclient._startCreator(source)
    end
end

RegisterNetEvent('freezePlayer')
AddEventHandler('freezePlayer', function(source, freeze)
    local playerPed = GetPlayerPed(source)
    FreezeEntityPosition(playerPed, freeze)
    if freeze then
        SetEntityCollision(playerPed, false, true)
    else
        SetEntityCollision(playerPed, true, true)
    end
end)

function setPlayerTattoos(source, user_id)
    TriggerClientEvent("tattoos:Apply", source, vRP.UserData(user_id, "Tatuagens"))
    TriggerClientEvent("target:Debug", source)
end

function func.setPlayerTattoos(id)
    local source = source
    local user_id = id or vRP.getUserId(source)
    if user_id then
        setPlayerTattoos(source, user_id)
    end
end

function getUserLastPosition(source, user_id)
    local coords = { 402.76, -996.28, -99.00 }
    local datatable = vRP.getUserDataTable(user_id)
    if datatable and datatable.Pos then
        local p = datatable.Pos
        coords = { p.x, p.y, p.z }
    else
        local data = vRP.getUData(user_id, "Datatable")
        if data and data.Pos then
            local p = data.Pos
            coords = { p.x, p.y, p.z }
        end
    end
    fclient._setPlayerLastCoords(source, coords)
    return coords
end

function func.getUserLastPosition()
    local source = source
    local user_id = vRP.getUserId(source)
    getUserLastPosition(source, user_id)
end

function format(n)
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1.'):reverse()) .. right
end

function func.changeSession(session)
    local source = source
    SetPlayerRoutingBucket(source, session)
end

function func.updateLogin()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        userlogin[user_id] = true
        local char = getUserChar(user_id, source)
        if char then
            TriggerClientEvent("nation_barbershop:init", source, char)
            setPlayerTattoos(source, user_id)
        end
    end
end

function func.getCharsInfo()
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_characters", { steam = steam })
    local info = { chars = {} }
    for k, v in ipairs(data) do
        local char = getUserChar(v.id, source) or {}
        local clothes = getUserClothes(v.id)
        local gender = "masculino"
        if char.gender and char.gender == "female" then
            gender = "feminino"
        elseif char.gender ~= "male" then
            gender = "outros"
        end
        --[[ local data = vRP.Query("nation_creator/get_bank",{ user_id = v.id })
        local bank = 0
        if data and data[1] then
            bank = data[1].dvalue
        end ]]
        info.chars[k] = {
            name = v.name .. " " .. v.name2,
            age = v.age .. " anos",
            bank = "$ " .. format(v.bank),
            clothes = clothes,
            registration = Sanguine(v.blood),
            phone = v.phone,
            user_id = v.id,
            id = "#" .. v.id,
            gender = gender,
            char = char
        }
    end
    info.maxChars = getUserMaxChars(source)
    return info
end

function getUserMaxChars(source)
    local steam = getPlayerSteam(source)
    local Account = vRP.Account(steam)
    local amountCharacters = parseInt(Account["chars"])
    --[[ if vRP.LicensePremium(steam) then
        amountCharacters = amountCharacters + 2
    end ]]
    return amountCharacters
end

function getUserClothes(user_id)
    local data = vRP.getUData(user_id, "Clothings")
    if data and not isEmpty(data) then
        return data
    end
    return {}
end

function getUserTattoos(user_id)
    local data = vRP.getUData(user_id, "Tatuagens")
    if data and not isEmpty(data) then
        local custom = data
        return custom or {}
    end
    data = vRP.getUData(user_id, "Tattoos")
    if data and not isEmpty(data) then
        local custom = data
        return custom or {}
    end
    return {}
end

function isEmpty(t)
    if type(t) == "string" and t ~= "" then
        return false
    end
    for k, v in pairs(t) do
        if v then
            return false
        end
    end
    return true
end

function getGender(user_id)
    local datatable = vRP.Datatable(user_id) or vRP.getUData(user_id, "Datatable") or {}
    if type(datatable) == "table" then
        local model = datatable.Skin or datatable.customization
        if model then
            if type(model) == "table" then
                model = model.modelhash or model.model
            end
            if model == GetHashKey("mp_m_freemode_01") or model == "mp_m_freemode_01" then
                return "male"
            elseif model == GetHashKey("mp_f_freemode_01") or model == "mp_f_freemode_01" then
                return "female"
            else
                return model
            end
        end
    end
end

function func.getOverlay()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local char = getUserChar(user_id, source, true)
        if char and char.overlay then
            return char.overlay
        end
    end
    return 0
end

function func.playChar(info)
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_character", { steam = steam, user_id = info.user_id })
    if #data > 0 then
        -- TriggerEvent("baseModule:idLoaded",source,info.user_id,nil)
        vRP.CharacterChosen(source, info.user_id, nil)
        --print(vRP.getUserId(source), vRP.Passport(source))
        local user_id = vRP.Passport(source)
        local ip = GetPlayerEP(source) or '0.0.0.0'
        vRP.sendLog('joins',
            '[ID]: ' ..
            user_id ..
            ' \n[IP]: ' .. ip .. ' \n[======ENTROU NO SERVIDOR======]' .. os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),
            true)
        playerSpawn(info.user_id, source, true)
    end
end

function func.tryDeleteChar(info)
    local source = source
    local steam = getPlayerSteam(source)
    -- local data = vRP.Query("nation_creator/get_character",{ steam = steam, user_id = info.user_id })
    -- if #data > 0 then
    --     vRP._Execute("nation_creator/remove_characters",{ id = info.user_id })
    --     return true, ""
    -- end
    return false, "error"
end

function func.tryCreateChar()
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_characters", { steam = steam })
    if #data < getUserMaxChars(source) then -- limite de personagens
        vRP.Query("nation_creator/create_characters",
            { steam = steam, name = "", name2 = "", phone = vRP.GeneratePhone(), blood = math.random(4) })
        local myChars = vRP.Query("nation_creator/get_characters", { steam = steam })
        local user_id = myChars[#myChars].id
        --vRP.Query("bank/newAccount",{ Passport = user_id, dvalue = 2000, mode = "Private", owner = 1 })
        vRP.CharacterChosen(source, user_id, "mp_m_freemode_01")
        --print("CRIANDO ID "..user_id)
        --TriggerEvent("baseModule:idLoaded",source,user_id,"mp_m_freemode_01")
        return true
    end
end

function getPlayerSteam(source)
    --[[ local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,5) == "steam" then
			return splitString(v,":")[2]
		end
	end ]]
    return vRP.Identities(source)
end

RegisterCommand('resetchar', function(source, args) -- COMANDO DE ADMIN PARA RESETAR PERSONAGEM
    if func.checkPermission({ "Admin" }, source) then
        if args[1] then
            local id = tonumber(args[1])
            if id then
                local src = vRP.getUserSource(id)
                if src and vRP.Request(source, "Deseja resetar o id " .. id .. " ?", 30) then
                    fclient._startCreator(src)
                end
            end
        elseif vRP.Request(source, "Deseja resetar seu personagem ?", 30) then
            fclient._startCreator(source)
        end
    end
end)
