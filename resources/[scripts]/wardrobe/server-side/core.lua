-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSKINSHOP = Tunnel.getInterface("skinshop")
Wardrobe = {}
Tunnel.bindInterface("wardrobe",Wardrobe)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local TemporaryWardrobe = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUXILIARY
-----------------------------------------------------------------------------------------------------------------------------------------
local function getMaxSlots(Passport)
	if vRP.HasGroup(Passport,"Painite") then
		return 3
	elseif vRP.HasGroup(Passport,"Serendibite") then
		return 2
	end
	return 1
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Wardrobe.getClothes(mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local consult = {}
		if mode == "temp" then
			if not TemporaryWardrobe[Passport] then TemporaryWardrobe[Passport] = {} end
			consult = TemporaryWardrobe[Passport]
		else
			consult = vRP.GetSrvData("Wardrobe:"..Passport,true)
		end
		
		local clothes = {}
		for name,v in pairs(consult) do
			table.insert(clothes,{ name = name })
		end

		table.sort(clothes, function(a,b) return a.name < b.name end)
		
		local maxSlots = getMaxSlots(Passport)
		
		return clothes, maxSlots
	end
	return {}, 1
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVECLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Wardrobe.saveClothes(name,mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local consult = {}
		if mode == "temp" then
			if not TemporaryWardrobe[Passport] then TemporaryWardrobe[Passport] = {} end
			consult = TemporaryWardrobe[Passport]
		else
			consult = vRP.GetSrvData("Wardrobe:"..Passport,true)
		end
		
		if consult[name] then
			return false,"Nome já existe."
		end

		local maxSlots = getMaxSlots(Passport)

		local count = 0
		for k,v in pairs(consult) do
			count = count + 1
		end

		if count >= maxSlots then
			return false,"Limite de slots atingido."
		end

		local custom = vSKINSHOP.Customization(source)
		if custom then
			consult[name] = custom
			
			if mode == "temp" then
				TemporaryWardrobe[Passport] = consult
			else
				vRP.SetSrvData("Wardrobe:"..Passport,consult,true)
			end
			
			return true,"Roupa salva com sucesso."
		end
	end
	return false,"Erro ao salvar."
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Wardrobe.updateClothes(name,mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local consult = {}
		if mode == "temp" then
			if not TemporaryWardrobe[Passport] then TemporaryWardrobe[Passport] = {} end
			consult = TemporaryWardrobe[Passport]
		else
			consult = vRP.GetSrvData("Wardrobe:"..Passport,true)
		end
		
		local custom = vSKINSHOP.Customization(source)
		if custom then
			consult[name] = custom
			
			if mode == "temp" then
				TemporaryWardrobe[Passport] = consult
			else
				vRP.SetSrvData("Wardrobe:"..Passport,consult,true)
			end
			
			return true,"Roupa atualizada com sucesso."
		end
	end
	return false,"Erro ao atualizar."
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETECLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Wardrobe.deleteClothes(name,mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local consult = {}
		if mode == "temp" then
			if not TemporaryWardrobe[Passport] then TemporaryWardrobe[Passport] = {} end
			consult = TemporaryWardrobe[Passport]
		else
			consult = vRP.GetSrvData("Wardrobe:"..Passport,true)
		end

		if consult[name] then
			consult[name] = nil
			
			if mode == "temp" then
				TemporaryWardrobe[Passport] = consult
			else
				vRP.SetSrvData("Wardrobe:"..Passport,consult,true)
			end
			
			return true,"Roupa removida com sucesso."
		end
	end
	return false,"Erro ao remover."
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EQUIPCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Wardrobe.equipClothes(name,mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local consult = {}
		if mode == "temp" then
			if not TemporaryWardrobe[Passport] then TemporaryWardrobe[Passport] = {} end
			consult = TemporaryWardrobe[Passport]
		else
			consult = vRP.GetSrvData("Wardrobe:"..Passport,true)
		end

		local maxSlots = getMaxSlots(Passport)

		local clothes = {}
		for k,v in pairs(consult) do
			table.insert(clothes,k)
		end
		table.sort(clothes)

		local allowed = false
		for i=1,#clothes do
			if clothes[i] == name then
				if i <= maxSlots then
					allowed = true
				end
				break
			end
		end

		if not allowed then
			return false,"Limite de slots excedido para esta roupa."
		end

		if consult[name] then
			TriggerClientEvent("skinshop:Apply",source,consult[name])
			return true,"Roupa aplicada com sucesso."
		end
	end
	return false,"Erro ao aplicar."
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if TemporaryWardrobe[Passport] then
		TemporaryWardrobe[Passport] = nil
	end
end)
