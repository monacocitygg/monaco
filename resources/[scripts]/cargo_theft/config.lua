Config = {}

Config.TruckModel = "rallytruck"
Config.DriverModel = "s_m_m_security_01"

-- Configuração da Escolta
Config.Escort = {
	enabled = true,
	model = "fbi2", 
	driver = "s_m_y_swat_01", 
	weapon = "WEAPON_CARBINERIFLE", 
	amount = 2 
}

-- Rotas
Config.Routes = {
	[1] = {
		spawn = vector4(1766.56,3381.22,39.34,209.77), -- Aeroporto
		destination = vector3(1964.0,3134.19,46.96), -- Sandy Shores
		cratetype = "mat"
	}
}

Config.CaixasRewards = {
	["mat"] = {
		{ item = "sheetmetal", amount = 500 },
		{ item = "copper", amount = 500 },
		{ item = "plastic", amount = 500 },
		{ item = "rubber", amount = 500 },
		{ item = "glass", amount = 500 }
	},
	["weapons"] = {
		{ item = "wammo_pistol", amount = 50 },
		{ item = "wammo_smg", amount = 100 },
		{ item = "wammo_rifle", amount = 100 }
	}
}


Config.Speed = 20.0

Config.DrivingStyle = 1074528293

Config.PolicePermission = "Police"

Config.ResetTime = 30
