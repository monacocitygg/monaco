-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Groups()
    return Groups
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATAGROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DataGroups(Permission)
    return vRP.GetSrvData("Permissions:"..Permission)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER HIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserHierarchy(Passport, Permission)
    local permission = vRP.GetSrvData("Permissions:"..Permission)
    if permission[tostring(Passport)] then
        return permission[tostring(Passport)]
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetUserType(Passport,Type)
    for k,v in pairs(Groups) do
        local Datatable = vRP.GetSrvData("Permissions:"..k)
        if Groups[k]["Type"] and Groups[k]["Type"] == Type and Datatable[tostring(Passport)] then
            return k
        end
    end
    return
end

function vRP.GetGroupType(Permission)
    if Groups[Permission] and Groups[Permission]["Type"] then
        return Groups[Permission]["Type"] or 'None'
    end
    return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIERARCHY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Hierarchy(Permission)
    if Groups[Permission] and Groups[Permission]["Hierarchy"] then
        return Groups[Permission]["Hierarchy"]
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.NumPermission2(Permission)
    local Services = {}
    local Amount = 0

    for i,v in pairs(vRP.Players()) do
        local Passport = vRP.Passport(v)

        if vRP.HasGroup(Passport,Permission) then
            Amount = Amount + 1
            Services[Passport] = v
        end
    end

    return Services,Amount

end

function vRP.NumPermission(Permission)
    local Services = {}
    local Amount = 0

    for i,v in pairs(vRP.Players()) do
        local Passport = vRP.Passport(v)

        if vRP.HasGroup(Passport,Permission) and vRP.HasService(Passport,Permission) then
            Amount = Amount + 1
            Services[Passport] = v
        end
    end

    return Services,Amount

end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICETOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceToggle(Source,Passport,Permission,Silenced)
    local Perm = splitString(Permission,"-")
    if (Characters[Source] and Groups[Perm[1]]) and Groups[Perm[1]]["Service"] then
        if Groups[Perm[1]]["Service"][tostring(Passport)] == Source then
            vRP.ServiceLeave(Source,tostring(Passport),Perm[1],Silenced)
        else
            if vRP.HasGroup(tostring(Passport),Perm[1]) and not Groups[Perm[1]]["Service"][tostring(Passport)] then
                vRP.ServiceEnter(Source,tostring(Passport),Perm[1],Silenced)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICEENTER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceEnter(Source, Passport, Permission, Silenced)
    if Characters[Source] then
        if ClientState[Permission] then
            Player(Source).state[Permission] = true
            TriggerClientEvent("service:Label", Source, Permission, "Sair de Serviço")
        end
        if GroupBlips[Permission] then
            exports.markers:Enter(Source, Permission)
        end
        if Groups[Permission] and Groups[Permission].Salary then
            TriggerEvent("Salary:Add", tostring(Passport), Permission)
        end
        Groups[Permission].Service[tostring(Passport)] = Source
        exports.vrp:Embed("Services", "**Passaporte:** " .. Passport .. "\n**Entrou na permissão:** " .. Permission,
            3042892)
        if not Silenced then
            TriggerClientEvent("Notify", Source, "verde", "Entrou em serviço.", false, 5000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICELEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ServiceLeave(Source, Passport, Permission, Silenced)
    if Characters[Source] then
        if ClientState[Permission] then
            Player(Source).state[Permission] = false
            TriggerClientEvent("service:Label", Source, Permission, "Entrar em Serviço")
        end
        if GroupBlips[Permission] then
            exports.markers:Exit(Source)
            TriggerClientEvent("radio:RadioClean", Source)
        end
        if Groups[Permission] and Groups[Permission].Salary then
            TriggerEvent("Salary:Remove", tostring(Passport), Permission)
        end
        if Groups[Permission].Service and Groups[Permission].Service[tostring(Passport)] then
            Groups[Permission].Service[tostring(Passport)] = nil
        end
        exports.vrp:Embed("Services", "**Passaporte:** " .. Passport .. "\n**Saiu da permissão:** " .. Permission,
            3042892)
        if not Silenced then
            TriggerClientEvent("Notify", Source, "verde", "Saiu de serviço.", false, 5000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
local BlockedGroups = {
    ["Police"] = true,
    ["Paramedic"] = true,
    ["Juridico"] = true,
    ["OffParamedic"] = true,

}

function vRP.SetPermission(Passport, Permission, Level, Mode)
    local Datatable = vRP.GetSrvData("Permissions:" .. Permission)
    local source = vRP.Source(Passport)

    if Groups[Permission] then
        local HasIlegal = vRP.GetUserType(Passport, "Ilegal")

        if BlockedGroups[Permission] and HasIlegal then
            if not vRP.HasGroup(Passport, "Clevel") then
                TriggerClientEvent("Notify", source, "vermelho", "Você não pode entrar nesse grupo enquanto estiver em uma facção ilegal.", 5000)
                return false
            end
        end

        if Groups[Permission]["Type"] and Groups[Permission]["Type"] == "Ilegal" then
            for k, v in pairs(BlockedGroups) do
                if vRP.HasGroup(Passport, k) and not vRP.HasGroup(Passport, "Clevel") then
                    TriggerClientEvent("Notify", source, "vermelho", "Você não pode entrar em uma facção ilegal enquanto estiver no grupo " .. k .. ".", 5000)
                    return false
                end
            end
        end

        if Mode then
            if "Demote" == Mode then
                Datatable[tostring(Passport)] = Datatable[tostring(Passport)] + 1
                Level = Datatable[tostring(Passport)]

                if Datatable[tostring(Passport)] > #Groups[Permission]["Hierarchy"] then
                    Datatable[tostring(Passport)] = #Groups[Permission]["Hierarchy"]
                end
            else
                Datatable[tostring(Passport)] = Datatable[tostring(Passport)] - 1
                Level = Datatable[tostring(Passport)]

                if Datatable[tostring(Passport)] > #Groups[Permission]["Hierarchy"] then
                    Datatable[tostring(Passport)] = #Groups[Permission]["Hierarchy"]
                end
            end
        else
            if Level then
                Level = parseInt(Level)
                if #Groups[Permission]["Hierarchy"] < Level then
                    Level = #Groups[Permission]["Hierarchy"]
                    Datatable[tostring(Passport)] = Level
                else
                    Datatable[tostring(Passport)] = Level
                end
            end
            if not Level then
                Datatable[tostring(Passport)] = #Groups[Permission]["Hierarchy"]
            end
        end

        vRP.ServiceEnter(source, tostring(Passport), Permission, true)
        vRP.Query("entitydata/SetData", { dkey = "Permissions:" .. Permission, dvalue = json.encode(Datatable) })
        TriggerEvent("vrp/updateGroups", Passport, source)
        TriggerEvent('vRP:playerJoinGroup', Passport, Permission, Level, Mode)

        return true
    end

    TriggerClientEvent("Notify", source, "vermelho", "Erro: O grupo solicitado não existe.", 5000)
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemovePermission(Passport, Permission)
    local Datatable = vRP.GetSrvData("Permissions:" .. Permission)
    local source = vRP.Source(Passport)
    if Groups[Permission] then
        if Groups[Permission].Service and Groups[Permission].Service[tostring(Passport)] then
            Groups[Permission].Service[tostring(Passport)] = nil
        end

        if Datatable[tostring(Passport)] then
            Datatable[tostring(Passport)] = nil

            vRP.ServiceLeave(source, tostring(Passport), Permission, true)
            vRP.Query("entitydata/SetData", { dkey = "Permissions:" .. Permission, dvalue = json.encode(Datatable) })
        end

        if Permission == "Police" then
            local Data = vRP.Query("entitydata/GetData", { dkey = "Police_Allowlist" }) or {}
            local PoliceList = {}

            if parseInt(#Data) > 0 then
                PoliceList = json.decode(Data[1]["dvalue"])
            end

            if PoliceList[tostring(Passport)] then
                if os.time() < PoliceList[tostring(Passport)] and not vRP.HasPermission(Passport, "Access") then
                    local License = vRP.Identity(Passport)["license"]
                    local Account = vRP.Account(License)

                    vRP.Query("accounts/WhitelistEdit", { id = Account["id"], whitelist = 0 })

                    local logMessage = string.format("**Passaporte:** %s\n**Perdeu whitelist por sair da policia antes do tempo.", Passport)
                    exports["vrp"]:Embed("WLPolice", logMessage, 0xa3c846)
                end
            end
        elseif Permission == "ALParamedic" then
            local Data = vRP.Query("entitydata/GetData", { dkey = "Paramedic_Allowlist" }) or {}
            local ParamedicList = {}

            if parseInt(#Data) > 0 then
                ParamedicList = json.decode(Data[1]["dvalue"])
            end

            if ParamedicList[tostring(Passport)] then
                if os.time() < ParamedicList[tostring(Passport)] and not vRP.HasPermission(Passport, "Access") then
                    local License = vRP.Identity(Passport)["license"]
                    local Account = vRP.Account(License)

                    vRP.Query("accounts/WhitelistEdit", { id = Account["id"], whitelist = 0 })

                    local logMessage = string.format("**Passaporte:** %s\n**Perdeu whitelist por sair da paramedico antes do tempo.", Passport)
                    exports["vrp"]:Embed("WLParamedic", logMessage, 0xa3c846)
                end
            end
        end

        TriggerEvent("vRP:playerLeaveGroup", Passport, Permission)
        TriggerEvent("vrp/updateGroups", Passport, source)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasPermission(Passport,Permission,Level)
    local Datatable = vRP.GetSrvData("Permissions:"..Permission)
    if Datatable[tostring(Passport)] then
        if not Level or not (Datatable[tostring(Passport)] > Level) then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasGroup(Passport,Permission,Level)
    if Groups[Permission] then
        for k, v in pairs(Groups[Permission].Parent) do
            local Datatable = vRP.GetSrvData("Permissions:"..k)
            if Datatable[tostring(Passport)] then
                if not Level or not (Datatable[tostring(Passport)] > Level) then
                    return true
                end
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.HasService(Passport,Permission)
    if Groups[Permission] then
        for k, v in pairs(Groups[Permission].Parent) do
            if Groups[k]["Service"][tostring(Passport)] then
                return true
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport, Source)
    for k,v in pairs(Groups) do
        if vRP.HasPermission(tostring(Passport), k) then
            vRP.ServiceEnter(Source,tostring(Passport),k,true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport,Source)
    for k, v in pairs(Groups) do
        if Groups[k]["Service"][tostring(Passport)] then
            if GroupBlips[k] then
                exports.markers:Exit(Source)
            end
            Groups[k]["Service"][tostring(Passport)] = false
        end
        if Groups[k] and Groups[k]["Salary"] then
            TriggerEvent("Salary:Remove",tostring(Passport),k)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "vrp" == Resource then
        Wait(3000)
    end
end)

function vRP.getUsersByPermission(perm)
    local tableList = {}

    for user_id,source in pairs(vRP.userList()) do
        if vRP.hasPermission(user_id, perm) then
            table.insert(tableList, user_id)
        end
    end

    return tableList
end