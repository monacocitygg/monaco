-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Discords = {
	["Connect"] = "https://discord.com/api/webhooks/1262560509685923900/nnN5-wzmyE1t7oF6I61obYG8pVsbAdCrgHPwGPLJPhesteizRiy7KkDPssZE_oWgnYOe",
	["Disconnect"] = "https://discord.com/api/webhooks/1262560567114338408/hejk_sHAcZGj7lDtkw4wKHyqBCa2SLDrmagUp3cFXsGbcgOw4CmeC5t43nTUW_4gyyd2",
	["Airport"] = "https://discord.com/api/webhooks/1262561183928549407/y6bliCp9HUz5KCGP4py_udbM9hRV2cLTM4_C0olEXRPE-8MnO_tsO7_O53DWAyoOToUh",
	["Deaths"] = "https://discord.com/api/webhooks/1262561491530289153/GLsnDnClv0mLUvPQaTVGUZ2PzARZ_vVYdeJYEas-Xy2QNfh3CEHoHuKNjMqAaIBd_HzK",
	["Police"] = "https://discord.com/api/webhooks/1262561554000384041/CHIExUI46GlRYRmfOAZvqPLXnyVGy95_aLQ0vl_aAQOF5iO9xkK5ENRiPBQNyH3PLrq7",
	["Paramedic"] = "https://discord.com/api/webhooks/1262560621375782963/hAHM4un86x1dN4ZcmbpOM-ygx9w2Jg85zDlhSzCqiTrR7qh4P0EDDaHS3fD6PYcBqMwk",
	["Gemstone"] = "https://discord.com/api/webhooks/1262561665258360883/3E8SrKAI8-b88tspJpC-G5MNILuaKEXY2JBZnO6m3DmA39WIkVwwXRwTAvIjLaaXCeXi",
	["Login"] = "https://discord.com/api/webhooks/1262561718186278962/jSmeEmI-A9hLS2KtmA-lF65mnBW_BsjnvVcCtmd5OdvyoqdWIoIj7aUA3zWtK9LCCxjc",
	["Connect"] = "",
	["Disconnect"] = "",
	["Airport"] = "",
	["Deaths"] = "",
	-- Garages
	["GaragesVenda"] = "",
	["GaragesCar"] = "",
	["GaragesDv"] = "",
	-- Propertys
	["Bau-Casas"] = "",
	["Bau-Hotel"] = "",
	-- Chest
	["Chest"] = "",
	-- Robberys

	-- Notify
	["Aviso-policia"] = "",
	["Aviso-paramedic"] = "",
	["Aviso-bombeiro"] = "",
	["Aviso-mecanica"] = "",
	["Aviso-admin"] = "",
	-- Inventory
	["InventoryDrops"] = "",
	["InventoryPegou"] = "",
	["InventoryEnviou"] = "",
	["InventoryLixo"] = "",
	-- Inspect
	["RevistaPolicial"] = "",
	["RevistaJogadores"] = "",
	["Saquear"] = "",
	-- Crafting
	["Craftou"] = "",
	-- Luckywheel
	["Cassino"] = "",
	-- Pause
	["LojaPause"] = "",
	["LojaBoxesPause"] = "",
	["WonBoxesPauseStore"] = "",
	["ReedemItemRolepass"] = "",
	["BuyRolepass"] = "",
	-- Painel
	["Convite"] = "",
	["Contratado"] = "",
	["Demitido"] = "",
	["PainelDeposito"] = "",
	["PainelSaque"] = "",
	["Premium"] = "",
	-- Bank
	["BankDeposito"] = "",
	["BankSaque"] = "",
	-- PDM
	["BuyRentalVehicle"] = "",
	["BuyVehicle"] = "",
	-- Shops
	["LojaPolicia"] = "",
	["LojaVip"] = "",
	["LojasGerais"] = "",
	["LojasVendas"] = "",
	-- Trunkchest
	["Trunkchest"] = "",
	-- Helicrash
	["Helicrash"] = "",
	-- Police
	["Prender"] = "",
	["Multar"] = "",
	["Procurados"] = "",
	["Portes"] = "",
	["Boletins"] = "",
	-- Admin
	["Tpto"] = "",
	["Tptome"] = "",
	["Tpway"] = "",
	["Tpcds"] = "",
	["cds"] = "",
	["Spectate"] = "",
	["Fix"] = "",
	["Blips"] = "",
	["God"] = "",
	["Kill"] = "",
	["Ban"] = "",
	["Unban"] = "",
	["Kick"] = "",
	["KickAll"] = "",
	["Item"] = "",
	["Itemall"] = "",
	["Item2"] = "",
	["Group"] = "",
	["Ungroup"] = "",
	["Clearchest"] = "",
	["Clearinv"] = "",
	["Gemstone"] = "",
	["SetBank"] = "",
	["RemoveBank"] = "",
	["Addcar"] = "",
	["Remcar"] = "",
	["DeleteAll"] = "",
	["LimparArea"] = "",
	["Mundo"] = "",
	["Addback"] = "",
	["Remback"] = "",
	["Algemar"] = "",
	["wl"] = "",
	["unwl"] = "",
	["Noclip"] = "",
	["Tuning"] = "",
	-- Extras
	["Wall"] = ""
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Discord",function(Hook,Message,Color)
	PerformHttpRequest(Discords[Hook],function(err,text,headers) end,"POST",json.encode({
		username = ServerName,
		embeds = { { color = Color, description = Message } }
	}),{ ["Content-Type"] = "application/json" })
end)