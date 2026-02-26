vRP.prepare("inventory/get_skins", "SELECT skins FROM skins WHERE identifier = @user_id")
vRP.Prepare("inventory/insert_skin_user","INSERT IGNORE INTO skins(identifier,skins,boxes,tokentrade) VALUES(@identifier,'[]',0,0)")

AddEventHandler("Connect",function(Passport,source)
    vRP.Execute("inventory/insert_skin_user",{ identifier = Passport })
end)

AddEventHandler("CharacterChosen",function(Passport,source)
    vRP.Execute("inventory/insert_skin_user",{ identifier = Passport })
end)

function Creative.requestSkins()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local skins = {}
        local mySkins = {}
        
        -- Get skins from DB
        local query = vRP.query("inventory/get_skins", { user_id = user_id })
        if query and query[1] and query[1].skins then
            local dbSkins = json.decode(query[1].skins)
            if dbSkins then
                for _,v in pairs(dbSkins) do
                    mySkins[v] = true
                end
            end
        end

        if Config and Config.itensRegister then
            for k,v in pairs(Config.itensRegister) do
                -- Only add if user owns it
                if mySkins[k] then
                    table.insert(skins, {
                        index = k,
                        name = v.name,
                        type = v.type,
                        image = v.image,
                        weapon = v.weapon
                    })
                end
            end
        end
        return { skins = skins }
    end
end

function Creative.equipSkin(data,currentWeapon,currentAmmo)
	print("DEBUG [SERVER]: equipSkin chamado")
	print("DEBUG [SERVER]: Dados da skin:", json.encode(data))
	print("DEBUG [SERVER]: Arma atual do jogador:", currentWeapon)
	print("DEBUG [SERVER]: Munição atual:", currentAmmo)

    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if Config and Config.itensRegister then
            local skinName = data.skin or data.index -- Ajuste para pegar o campo correto (skin ou index)
            print("DEBUG [SERVER]: Nome da skin buscada:", skinName)
            
            local skinConfig = Config.itensRegister[skinName]

            if skinConfig then
                print("DEBUG [SERVER]: Config da skin encontrada. Arma exigida:", skinConfig.weapon)
                
                if skinConfig.weapon == currentWeapon then
                	print("DEBUG [SERVER]: Arma corresponde! Equipando skin...")
                    
                    local Passport = vRP.Passport(source)
                    if Passport then
                        if not Skins[Passport] then Skins[Passport] = {} end
                        Skins[Passport][skinConfig.weapon] = skinName
                        print("DEBUG [SERVER]: Skin salva para persistência:", skinName)
                    end

                    TriggerClientEvent("inventory:CleanWeapons",source,false)
                    SetTimeout(100,function()
                        vCLIENT.putWeaponHands(source,skinName,currentAmmo)
                        TriggerClientEvent("Notify",source,"sucesso","Skin equipada com sucesso.")
                    end)
                else
                	print("DEBUG [SERVER]: Arma NÃO corresponde. Exigido:", skinConfig.weapon, "Atual:", currentWeapon)
                    TriggerClientEvent("Notify",source,"negado","Você precisa estar com a <b>"..vRP.itemName(skinConfig.weapon).."</b> em mãos.",5000)
                end
            else
            	print("DEBUG [SERVER]: Config da skin NÃO encontrada para:", skinName)
            end
        end
    end
end

function Creative.removeSkin(currentWeapon,currentAmmo)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local Passport = vRP.Passport(source)
        if Passport then
             if Config and Config.itensRegister and Config.itensRegister[currentWeapon] then
                local baseWeapon = Config.itensRegister[currentWeapon].weapon
                
                if Skins[Passport] and Skins[Passport][baseWeapon] then
                    Skins[Passport][baseWeapon] = nil
                end

                TriggerClientEvent("inventory:CleanWeapons",source,false)
                SetTimeout(100,function()
                    vCLIENT.putWeaponHands(source,baseWeapon,currentAmmo)
                    TriggerClientEvent("Notify",source,"sucesso","Skin removida com sucesso.")
                end)
             else
                TriggerClientEvent("Notify",source,"negado","Você não está usando uma skin.",5000)
             end
        end
    end
end
