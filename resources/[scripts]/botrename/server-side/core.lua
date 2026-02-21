-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
function discordPlayer(source)
	local result = false
    local identifiers = GetPlayerIdentifiers(source)
    if identifiers then
        for k,v in pairs(identifiers)do
            if string.find(v,"discord") then
                local splitName = splitString(v,":")
                result = splitName[2]
                break
            end
        end
    end
    return result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOKCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, source)
    local webhook = "https://discord.com/api/webhooks/1467785389036277998/keVwNT_o37M5ueCFZan0pJnHPHYhe5HFDeg5Riuzl4jzi3qEQNPtiB_Cye7UGvY0o2q_"
    local Account = vRP.Account(vRP.Identities(source))
    local Character = vRP.Query("characters/Person",{ id = Passport })
    local playerDiscord = Account["discord"]
    local discordId = discordPlayer(source);

    if (playerDiscord == 0 or playerDiscord == nil) then
        if discordId then
            if discordId ~= nil then
                playerDiscord = discordId
                vRP.execute("accounts/discord", { dc = discordId, id = Account["id"] })
            else
                playerDiscord = "Não sincronizado com o bot, tente novamente."
            end
        else 
            playerDiscord = "Não sincronizado com o bot, tente novamente."
        end
    end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWEBHOOKINFOS
-----------------------------------------------------------------------------------------------------------------------------------------
local message = playerDiscord .. " " .. Passport .. " " .. Character[1]["name"] .. " " .. Character[1]["name2"]
    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode({ content = message })
    , { ['Content-Type'] = 'application/json' })
end)