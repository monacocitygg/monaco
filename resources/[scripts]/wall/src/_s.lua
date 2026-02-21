GlobalState["Creative_wall"] = math.random(213444500,213445500)
GlobalState["svCreative"] = math.random(113444500,113445500)

Creative = {}
module("vrp","lib/Tunnel").bindInterface(GlobalState["svCreative"],Creative)
local chain = GlobalState["Creative_wall"]
vRP = module("vrp","lib/Proxy").getInterface("vRP")

local wall_infos = {}
function Creative.setWallInfos()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then 
		local identity = vRP.Identity(Passport)
        wall_infos[source] = {}
        wall_infos[source].Passport = Passport
        local name = identity.name.." "..identity.name2
        if name == nil or name == "" or name == -1 then
            name = "N/A"
        else
            wall_infos[source].name = name
        end
        wall_infos[source].wallstats = false
	end
end

RegisterCommand("wall",function(source,args)
	local Passport = vRP.Passport(source)
	if vRP.HasGroup(Passport, "Admin", 3) or vRP.HasGroup(Passport,"Moderador",1) or vRP.HasGroup(Passport,"Suporte",1) then
		if wall_infos[source].wallstats == true then
			wall_infos[source].wallstats = false
			TriggerClientEvent(chain..":wall",source,wall_infos[source].wallstats)
		else
			wall_infos[source].wallstats = true
			TriggerClientEvent(chain..":wall",source,wall_infos[source].wallstats)
		end
	end
end)

function Creative.getWallInfos()
	return wall_infos
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local source = source
	if Passport then 
		local identity = vRP.Identity(Passport)
        wall_infos[source] = {}
        wall_infos[source].Passport = Passport
		wall_infos[source].name = identity.name.." "..identity.name2
        wall_infos[source].wallstats = false
	end
end)

