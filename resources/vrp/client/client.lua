-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]:set("Route",0,false)
LocalPlayer["state"]:set("Name","",false)
LocalPlayer["state"]:set("Passport",0,false)
LocalPlayer["state"]:set("Rope",false,false)
LocalPlayer["state"]:set("Cancel",false,true)
LocalPlayer["state"]:set("Active",false,false)
LocalPlayer["state"]:set("Handcuff",false,true)
LocalPlayer["state"]:set("Commands",false,true)
LocalPlayer["state"]:set("Spectate",false,false)
LocalPlayer["state"]:set("Invisible",false,false)
LocalPlayer["state"]:set("Invincible",false,false)
LocalPlayer["state"]:set("usingPhone",false,false)
LocalPlayer["state"]:set("Player",GetPlayerServerId(PlayerId()),false)

LocalPlayer["state"]:set("Admin",false,false)
LocalPlayer["state"]:set("Policia",false,false)
LocalPlayer["state"]:set("Paramedico",false,false)
LocalPlayer["state"]:set("Mecanico",false,false)
LocalPlayer["state"]:set("PizzaThis",false,false)
LocalPlayer["state"]:set("UwuCoffee",false,false)
LocalPlayer["state"]:set("BeanMachine",false,false)
LocalPlayer["state"]:set("Ballas",false,false)
LocalPlayer["state"]:set("Vagos",false,false)
LocalPlayer["state"]:set("Famillies",false,false)
LocalPlayer["state"]:set("Aztecas",false,false)
--FAVELAS
LocalPlayer["state"]:set("Favela01",false,false)
LocalPlayer["state"]:set("Favela02",false,false)
LocalPlayer["state"]:set("Favela03",false,false)
LocalPlayer["state"]:set("Favela04",false,false)
LocalPlayer["state"]:set("Favela05",false,false)
LocalPlayer["state"]:set("Favela06",false,false)
LocalPlayer["state"]:set("Favela07",false,false)
LocalPlayer["state"]:set("Favela08",false,false)
--Attachs 
LocalPlayer["state"]:set("Muni01",false,false)
--------lavagem
LocalPlayer["state"]:set("lavagem01",false,false)

LocalPlayer["state"]:set("Altruists",false,false)
LocalPlayer["state"]:set("Triads",false,false)
LocalPlayer["state"]:set("Razors",false,false)

LocalPlayer["state"]:set("Buttons",false,true)
LocalPlayer["state"]:set("Cassino",false,false)
LocalPlayer["state"]:set("Race",false,false)
LocalPlayer["state"]:set("Target",false,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
    SetDiscordAppId(1397347070104305674)
    SetDiscordRichPresenceAsset("logo")
    SetRichPresence("-"..Passport.." "..Name)
    SetDiscordRichPresenceAssetSmall("logo2")
    SetDiscordRichPresenceAssetText("After Ato 1")
    SetDiscordRichPresenceAssetSmallText("After City")
    SetDiscordRichPresenceAction(0, "DISCORD", "https://discord.gg/monacogg")
    SetDiscordRichPresenceAction(1, "LOJA", "https://monaco.centralcart.com.br/")
end)