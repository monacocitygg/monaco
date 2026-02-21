local config = {}

config.IPItems    = "nui://vrp/config/inventory/"
config.IPVehicles = "http://45.149.153.3/veiculos/"
config.UserImage  = "./img/user.png"

config.permissions = {
    ["Admin"] = {
        ["players"]       = true,
        ["groups"]        = true,
        ["punishments"]   = true,
        ["messages"]      = true,
        ["spawnitems"]    = true,
        ["spawnvehicles"] = true,
        ["addvehicles"]   = true,
    }
}

config.commands = {
    opentablet = "painelstaff",
    openchat   = "chatstaff"
}

config.webhooks = {
    addgroup          = "",
    remgroup          = "",
    addban            = "",
    addwarning        = "",
    editban           = "",
    deletewarning     = "",
    sendmessage       = "",
    sendmessageplayer = "",
    spawnitem         = "",
    spawnvehicle      = "",
    addvehicle        = "",
    webhookimage      = "",
    webhooktext       = "NIGHT - ",
    webhookcolor      = 16431885
}

config.starttablet = function()
    vRP.CreateObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,60309)
end

config.stoptablet = function()
	vRP.Destroy()
end

return config