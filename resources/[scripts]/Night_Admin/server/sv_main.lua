-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
local config = module(GetCurrentResourceName(),"config")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
NightRP = {}
Tunnel.bindInterface("Night_Admin",NightRP)
vCLIENT = Tunnel.getInterface("Night_Admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERYES
-----------------------------------------------------------------------------------------------------------------------------------------
DB.prepare("night_staff/get_warnings","SELECT * FROM night_staff_warnings WHERE user_id = @user_id")
DB.prepare("night_staff/get_warning","SELECT * FROM night_staff_warnings WHERE id = @id")
DB.prepare("night_staff/add_warnings","INSERT INTO night_staff_warnings (staff_user_id, user_id, reason, banned, banned_time, banned_real_time, created) VALUES (@staff_user_id, @user_id, @reason, @banned, @banned_time, @banned_real_time, @created)")
DB.prepare("night_staff/edit_warning","UPDATE night_staff_warnings SET banned = 1, banned_time = @banned_time, banned_real_time = @banned_real_time WHERE id = @id")
DB.prepare("night_staff/delete_warning","DELETE FROM night_staff_warnings WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local staffperms = {}
local chatactive = {}
local chats      = {}
local messages   = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- getStaffData
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getStaffData()
    local source  = source
    local user_id = vRP.Passport(source)
    local Identity = vRP.Identity(user_id)
    local data    = {}
    if user_id then
        data.name    = Identity["name"]
        data.user_id = user_id
        data.role    = vRP.Hierarchy("Admin")
        data.perms   = {}

        if staffperms[user_id] ~= nil then
            data.perms = staffperms[user_id]
        end
    end
    return data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- checkPermission
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.checkPermission()
    local source  = source
    local user_id = vRP.Passport(source)
    if user_id then
        for k, v in pairs(config.permissions) do
            if vRP.HasGroup(user_id,k,1) then
                staffperms[user_id] = v
                return true
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- checkChatOpen
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.checkChatOpen()
    local source  = source
    local user_id = vRP.Passport(source)
    if user_id then
        if chatactive[user_id] then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllUsers
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getAllUsers()
    local source  = source
    local user_id = vRP.Passport(source)

    if user_id then
        return getUsersList()
    end

    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getUser
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getUser(id)
    local source  = source
    local user_id = vRP.Passport(source)

    if user_id then
        local userdata = getUserInfo(tonumber(id))
        userdata.warnings = {}

        local warnings = DB.query("night_staff/get_warnings", { user_id = tonumber(id) })
        if #warnings > 0 then
            userdata.warnings = warnings
        end

        return userdata
    end

    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllGroups
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getAllGroups()
    local source  = source
    local user_id = vRP.Passport(source)

    if user_id then
        return getAllGroups()
    end

    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllVehicles
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getAllVehicles()
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        return getAllVehicles()
    end

    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getAllItems
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getAllItems()
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        return getAllItems()
    end

    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addGroup
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.addGroup(id, group)
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        local check = addUserGroup(tonumber(id), group)
        if check then
            PerformHttpRequest(config.webhooks.addgroup, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ADICIONAR GRUPO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.webhookimage
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID & GROUP: **",
                                value = "**"..tonumber(id).." no grupo: "..group.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- remGroup
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.remGroup(id, group)
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        vRP.RemovePermission(tonumber(id),group)
        PerformHttpRequest(config.webhooks.remgroup, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                { 
                    title = "REGISTRO DE REMOVER GRUPO:\n⠀",
                    thumbnail = {
                        url = config.webhooks.remgroup
                    }, 
                    fields = {
                        { 
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                        },
                        {
                            name = "**ID & GROUP: **",
                            value = "**"..tonumber(id).." no grupo: "..group.."**"
                        }
                    }, 
                    footer = { 
                        text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = config.webhooks.webhookimage
                    },
                    color = config.webhooks.webhookcolor
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addBan
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.addBan(id, time)
    local source  = source
    local user_id = vRP.Passport(source)
    local Identity = vRP.Identity(id)

    if user_id then
        if time ~= 0 then
            local origtime = os.time()
            local newtime  = time + 1 * 24 * tonumber(time) * 60
    
            DB.query("night_staff/add_warnings", {
                staff_user_id    = user_id,
                user_id          = tonumber(id),
                reason           = "",
                banned           = 1,
                banned_time      = time,
                banned_real_time = tonumber(time),
                created          = os.date("%Y-%m-%d %H:%I:%S"),
            })

            DB.query("banneds/InsertBanned",{ license = Identity["license"], time = time })
    
            PerformHttpRequest(config.webhooks.addban, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ADICIONAR BANIMENTO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**TEMPO: **",
                                value = "**"..tonumber(time).."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            local OtherSource = vRP.Source(id)
				if OtherSource then
					vRP.Kick(OtherSource,"Banido!")
				end
            return true
        else
            TriggerClientEvent("Notify",source,"vermelho","O tempo de banimento não pode ser Zero!",8000)
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addWarning
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.addWarning(id, reason)
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        DB.query("night_staff/add_warnings", {
            staff_user_id    = user_id,
            user_id          = tonumber(id),
            reason           = reason,
            banned           = 0,
            banned_time      = "",
            banned_real_time = "",
            created          = os.date("%Y-%m-%d %H:%I:%S"),
        })

        PerformHttpRequest(config.webhooks.addban, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                { 
                    title = "REGISTRO DE ADICIONAR ADVERTÊNCIA:\n⠀",
                    thumbnail = {
                        url = config.webhooks.remgroup
                    }, 
                    fields = {
                        { 
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                        },
                        {
                            name = "**ID: **",
                            value = "**"..tonumber(id).."**"
                        },
                        {
                            name = "**MOTIVO: **",
                            value = "**"..reason.."**"
                        }
                    }, 
                    footer = { 
                        text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = config.webhooks.webhookimage
                    },
                    color = config.webhooks.webhookcolor
                }
            }
        }), { ['Content-Type'] = 'application/json' })
        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- editBan
-----------------------------------------------------------------------------------------------------------------------------------------
DB.prepare("night_staff/editBanned","UPDATE banneds SET time = UNIX_TIMESTAMP() + 86400 * @time WHERE license = @license")
function NightRP.editBan(id,time)
    local source  = source
    local user_id = getUserId(source)
    local Identity = vRP.Identity(id)

    if user_id then

        local check = DB.query("night_staff/get_warning", { id = tonumber(id) })
        if #check > 0 then
            local origtime = os.time()
            local newtime  = time + 1 * 24 * tonumber(time) * 60

            DB.query("night_staff/edit_warning", {
                banned_time      = newtime,
                banned_real_time = tonumber(time),
                id               = tonumber(id),
            })

            DB.query("night_staff/editBanned",{ license = Identity["license"], time = time })

            PerformHttpRequest(config.webhooks.editban, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE EDITAR BANIMENTO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**TEMPO: **",
                                value = "**"..tonumber(time).."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- deleteWarning
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.deleteWarning(id)
    local source  = source
    local user_id = getUserId(source)
    local Identity = vRP.Identity(id)

    if user_id then

        local check = DB.query("night_staff/get_warning", { id = tonumber(id) })
        if #check > 0 then
            DB.query("night_staff/delete_warning", { id = tonumber(id) })
            -- DB.query("banneds/RemoveBanned",{ license = Identity["license"] })

            PerformHttpRequest(config.webhooks.deletewarning, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE APAGAR ADVERTÊNCIA/BANIMENTO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getMessages
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getMessages(id)
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if user_id then
        id = tonumber(id)
        if chatactive[id] then
            chatid = chats[id]
            data   = messages[chatid]
        end
    end

    return data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- sendMessage
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.sendMessage(id, message)
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        
        id = tonumber(id)

        local nsource = getUserSource(id)

        if nsource == nil then
            sendnotify(source, "negado", "O player está offline", 5000)
            return false
        end

        if chatactive[id] == nil or chatactive[id] == false then
            chatactive[id] = true

            local chatid = math.random(1,10000)
    
            if messages[chatid] ~= nil then
                repeat
                    chatid = math.random(1,10000)
                    Citizen.Wait(0)
                until messages[chatid] == nil
            end

            chats[id] = chatid
            messages[chatid] = {}

            local messagedata = {
                user_id = user_id,
                staff   = true,
                name    = getUserFullName(user_id),
                image   = getUserImage(user_id),
                message = message
            }

            table.insert(messages[chatid], messagedata)
            sendnotify(nsource, "aviso", "Você recebeu uma nova mensagem da staff, utilize <b>/"..config.commands.openchat.."</b> para responder", 10000)
            TriggerClientEvent("Night_Admin:updatechatplayer",nsource)

            PerformHttpRequest(config.webhooks.sendmessage, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ENVIAR MENSAGEM:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**MENSAGEM: **",
                                value = "**"..message.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
        else
            local chatid = chats[id]
            local messagedata = {
                user_id = user_id,
                staff   = true,
                name    = getUserFullName(user_id),
                image   = getUserImage(user_id),
                message = message
            }

            table.insert(messages[chatid], messagedata)
            sendnotify(nsource, "aviso", "Você recebeu uma nova mensagem da staff, utilize <b>/"..config.commands.openchat.."</b> para responder", 10000)
            TriggerClientEvent("Night_Admin:updatechatplayer",nsource)

            PerformHttpRequest(config.webhooks.sendmessage, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ENVIAR MENSAGEM:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**MENSAGEM: **",
                                value = "**"..message.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
        end

        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- getChatMessages
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.getChatMessages()
    local source  = source
    local user_id = getUserId(source)
    local data    = {}

    if user_id then
        if chatactive[user_id] then
            chatid = chats[user_id]
            data   = messages[chatid]
        end
    end

    return data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- sendMessagePlayer
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.sendMessagePlayer(message)
    local source  = source
    local user_id = getUserId(source)

    if user_id then
        if chatactive[user_id] then
            chatid = chats[user_id]

            local messagedata = {
                user_id = user_id,
                staff   = false,
                name    = getUserFullName(user_id),
                image   = getUserImage(user_id),
                message = message
            }
            
            local players = {}
            for k,v in pairs(messages[chatid]) do
                if v.staff then
                    if players[v.user_id] == nil then
                        table.insert(players, v.user_id)
                    end
                end
            end

            for k, v in pairs(players) do
                local nsource = getUserSource(v)
                if nsource then
                    TriggerClientEvent("Night_Admin:updatechat",nsource, user_id)
                end
            end

            table.insert(messages[chatid], messagedata)

            PerformHttpRequest(config.webhooks.sendmessageplayer, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE RESPONDER MENSAGEM:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**PLAYER:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**MENSAGEM: **",
                                value = "**"..message.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })
            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnItem
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.spawnItem(item, amount, id)
    local source  = source
    local user_id = getUserId(source)

    if user_id then

        if id == nil then
            id = user_id
        else
            id = tonumber(id)
        end

        local check = giveInventoryItem(id, item, tonumber(amount))
        if check then
            PerformHttpRequest(config.webhooks.spawnitem, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE SPAWN ITEM:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**ITEM: **",
                                value = "**"..item.."**"
                            },
                            {
                                name = "**QUANTIDADE: **",
                                value = "**"..tonumber(amount).."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.spawnVehicle(id, vehicle)
    local source  = source
    local user_id = getUserId(source)

    if user_id then

        if id == "" then
            id = user_id
        else
            id = tonumber(id)
        end
        local check = spawnVehicle(id, vehicle)
        if check then
            PerformHttpRequest(config.webhooks.spawnvehicle, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE SPAWN VEÍCULO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**VEÍCULO: **",
                                value = "**"..vehicle.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- addVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
function NightRP.addVehicle(id, vehicle)
    local source  = source
    local user_id = getUserId(source)

    if user_id then

        if id == "" then
            id = user_id
        else
            id = tonumber(id)
        end
        local check = addVehicle(id, vehicle)
        if check then
            PerformHttpRequest(config.webhooks.addvehicle, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    { 
                        title = "REGISTRO DE ADICIONAR VEÍCULO:\n⠀",
                        thumbnail = {
                            url = config.webhooks.remgroup
                        }, 
                        fields = {
                            { 
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**"..getUserFullName(user_id).."** [**"..user_id.."**]\n⠀"
                            },
                            {
                                name = "**ID: **",
                                value = "**"..tonumber(id).."**"
                            },
                            {
                                name = "**VEÍCULO: **",
                                value = "**"..vehicle.."**"
                            }
                        }, 
                        footer = { 
                            text = config.webhooks.webhooktext..os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = config.webhooks.webhookimage
                        },
                        color = config.webhooks.webhookcolor
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            return true
        end
    end

    return false
end