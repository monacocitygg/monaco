-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Discords = {
	-- Framework
["tz"] = "https://discord.com/api/webhooks/1408620456050692177/3SBaGx3CWnnIbTcDpeFK2KkG9H0LCZm61knyK7dl74koByDYDXv3IRH1N6rhnhHAsF_H",


}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMBED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Embed",function(Hook,Message,Color)
	if Webhook then
		PerformHttpRequest(Discords[Hook],function(err,text,headers) end,"POST",json.encode({
			username = ServerName,
			embeds = { { color = Color, description = Message } }
		}),{ ["Content-Type"] = "application/json" })
	end
end)