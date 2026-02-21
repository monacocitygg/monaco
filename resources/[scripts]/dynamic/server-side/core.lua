-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Street = {}
Tunnel.bindInterface("dynamic", Street)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Animals = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Street.RegisterAnimal(objNet)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Animals[Passport] = objNet
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Street.ClearAnimal()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("DeletePed", Animals[Passport])
		Animals[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Street.Experience()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Experiences = {
			["Caçador"] = vRP.GetExperience(Passport, "Hunter"),
			["Lenhador"] = vRP.GetExperience(Passport, "Lumberman"),
			["Transportador"] = vRP.GetExperience(Passport, "Transporter"),
			["Caminhoneiro"] = vRP.GetExperience(Passport, "Trucker"),
			["Pescador"] = vRP.GetExperience(Passport, "Fisherman"),
			["Motorista"] = vRP.GetExperience(Passport, "Driver"),
			["Reboque"] = vRP.GetExperience(Passport, "Tows"),
			["Desmanche"] = vRP.GetExperience(Passport, "Dismantle"),
			["Entregador"] = vRP.GetExperience(Passport, "Delivery"),
			["Corredor"] = vRP.GetExperience(Passport, "Runner")
		}

		return Experiences
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TENCODES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tencodes = {
	[1] = {
		tag = "QTI",
		text = "Abordagem de trânsito",
		blip = 77
	},
	[2] = {
		tag = "QTH",
		text = "Localização",
		blip = 1
	},
	[3] = {
		tag = "QRR",
		text = "Apoio com prioridade",
		blip = 38
	},
	[4] = {
		tag = "QRT",
		text = "Oficial desmaiado/ferido",
		blip = 6
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:TENCODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:Tencode")
AddEventHandler("dynamic:Tencode",function(Code)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Identity = vRP.Identity(Passport)
		local Service = vRP.NumPermission("Police")
		for Passports,Sources in pairs(Service) do
			async(function()
				if Code ~= 4 then
					vRPC.PlaySound(Sources,"Event_Start_Text","GTAO_FM_Events_Soundset")
				end

				TriggerClientEvent("NotifyPush",Sources,{ code = Tencodes[parseInt(Code)]["tag"], title = Tencodes[parseInt(Code)]["text"], x = Coords["x"], y = Coords["y"], z = Coords["z"], name = Identity["name"].." "..Identity["name2"], time = "Recebido às "..os.date("%H:%M"), blipColor = Tencodes[parseInt(Code)]["blip"] })
				TriggerClientEvent("dynamic:PoliceNotify",Sources,{ code = Tencodes[parseInt(Code)]["tag"], title = Tencodes[parseInt(Code)]["text"], x = Coords["x"], y = Coords["y"], z = Coords["z"], name = Identity["name"].." "..Identity["name2"] })
			end)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:EMERGENCYANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("dynamic:EmergencyAnnounce")
AddEventHandler("dynamic:EmergencyAnnounce",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Identity = vRP.Identity(Passport)
		if vRP.HasGroup(Passport,"Police") or vRP.HasGroup(Passport,"Paramedic") then
			TriggerClientEvent("dynamic:closeSystem",source)
			local Keyboard = vKEYBOARD.keyDouble(source,"Mensagem:","Título:")
			if Keyboard then
				TriggerClientEvent("Notify",-1,"police"," "..Keyboard[1].."<br></br>Enviado Por: <b>"..Identity["name"].." "..Identity["name2"].."</b>",45000)
				TriggerEvent("Discord","Avisopm","**Aviso Policial F10**\n\n**Passaporte:** "..Passport.."\n**Mensagem do Anuncio:** "..Keyboard[1].."\n**Nome que Colocou:** "..Keyboard[2].."\n**Horário:** "..os.date("%H:%M:%S"),3553599)
			end
		end
	end
end)

RegisterServerEvent("dynamic:PoliceAnuncio")
AddEventHandler("dynamic:PoliceAnuncio", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Identity = vRP.Identity(Passport)
        if vRP.HasGroup(Passport, "Police") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Nome da Ação:")
			if Keyboard then
                local NomaAcao = Keyboard[1]
                local finalMessage = "A <b>POLÍCIA</b> informa que o: <br> "   ..NomaAcao.." está sendo assaltado, evitem passar próximo, risco de ser alvejado. Mantenham distância!!! <div style='font-size: 9px; margin-top: 5px; white-space: nowrap; color: #aaa;'>ENVIADA POR: "..Identity["name"].." "..Identity["name2"].."</div>"
                TriggerClientEvent("Notify", -1, "police", finalMessage.."</b>",30000)
            end
        end
    end
end)
RegisterServerEvent("dynamic:PoliceAnuncio2")
AddEventHandler("dynamic:PoliceAnuncio2", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Identity = vRP.Identity(Passport)
        if vRP.HasGroup(Passport, "Police") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Nome da Ação:")
			if Keyboard then
                local Nomeperimetro = Keyboard[1]
                local finalMessage = "A <b>POLÍCIA</b> informa perimetro: <br> "..Nomeperimetro.." está sob código 5, evitem passar próximo, risco de ser alvejado. Mantenham distância!!! <div style='font-size: 9px; margin-top: 5px; white-space: nowrap; color: #aaa;'>ENVIADA POR: "..Identity["name"].." "..Identity["name2"].."</div>"
                TriggerClientEvent("Notify", -1, "police", finalMessage.."</b>",30000)
            end
        end
    end
end)
RegisterServerEvent("dynamic:PoliceAnuncio3")
AddEventHandler("dynamic:PoliceAnuncio3", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Identity = vRP.Identity(Passport)
        if vRP.HasGroup(Passport, "Police") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Nome da Ação:")
			if Keyboard then
                local Nomeperimetro2 = Keyboard[1]
                local finalMessage = "A <b>POLÍCIA</b> informa perimetro: <br> "..Nomeperimetro2.." está aberto novamente para trafegar <div style='font-size: 9px; margin-top: 5px; white-space: nowrap; color: #aaa;'>ENVIADA POR: "..Identity["name"].." "..Identity["name2"].."</div>"
                TriggerClientEvent("Notify", -1, "police", finalMessage.."</b>",30000)
            end
        end
    end
end)

RegisterServerEvent("dynamic:EmergencyAnnounce2")
AddEventHandler("dynamic:EmergencyAnnounce2", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Identity = vRP.Identity(Passport)
        if vRP.HasGroup(Passport, "Police") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Mensagem:")
			if Keyboard then
                local originalMessage = Keyboard[1]
                local finalMessage = originalMessage .. "<div style='font-size: 9px; margin-top: 5px; white-space: nowrap; color: #aaa;'>ENVIADA POR: "..Identity["name"].." "..Identity["name2"].."</div>"
                TriggerClientEvent("Notify", -1, "police", finalMessage.."</b>",30000)
            end
        end
    end
end)

RegisterServerEvent("dynamic:AnnounceMec")
AddEventHandler("dynamic:AnnounceMec", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local identity = vRP.Identity(source)
        if vRP.HasGroup(Passport, "Mechanic") then
            TriggerClientEvent("dynamic:closeSystem", source)
            local Keyboard = vKEYBOARD.keyArea(source,"Mensagem:")
			if Keyboard then
                local playerName = vRP.FullName(Passport)
                local originalMessage = Keyboard[1]
                local finalMessage = originalMessage .. "<br></br>Enviada Por: Mecânica" 
                TriggerClientEvent("Notify", -1, "mecanico", finalMessage.."</b>",45000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
	if Animals[Passport] then
		TriggerEvent("DeletePed", Animals[Passport])
		Animals[Passport] = nil
	end
end)