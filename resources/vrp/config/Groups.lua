-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	["Admin"] = {
		["Parent"] = {
			["Admin"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},

	["Administrador"] = {
		["Parent"] = {
			["Administrador"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	
	["Staff"] = {
		["Parent"] = {
			["Staff"] = true
		},
		["Hierarchy"] = { "Staff"},
		["Service"] = {}
	},

	["Premium"] = {
		["Parent"] = {
			["Premium"] = true
		},
		["Hierarchy"] = { "Platina","Ouro","Prata","Bronze" },
		["Salary"] = { 2500,2250,2000,1750 },
		["Service"] = {}
	},
	["streamer"] = {
		["Parent"] = {
			["streamer"] = true
			
		},
		["Hierarchy"] = { "streamer" },
		["Salary"] = { 1500 },
		["Service"] = {}
	},
	["vipbronze"] = {
		["Parent"] = {
			["vipbronze"] = true
			
		},
		["Hierarchy"] = { "Bronze" },
		["Salary"] = { 1500 },
		["Service"] = {}
	},
	["vipprata"] = {
		["Parent"] = {
			["vipprata"] = true
			
		},
		["Hierarchy"] = { "Prata"},
		["Salary"] = { 3000 },
		["Service"] = {}
	},
	["vipouro"] = {
		["Parent"] = {
			["vipouro"] = true
			
		},
		["Hierarchy"] = { "Ouro" },
		["Salary"] = { 6000 },
		["Service"] = {}
	},
	["vipbuzios"] = {
		["Parent"] = {
			["vipbuzios"] = true
			
		},
		["Hierarchy"] = { vipbuzios },
		["Salary"] = { 15000 },
		["Service"] = {}
	},
	----------
	["Police"] = {
		["Parent"] = {
			["Police"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 10000,8000,5000,4000,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Paramedic"] = {
		["Parent"] = {
			["Paramedic"] = true
		},
		["Hierarchy"] = { "Diretor","ViceDiretor","Medico","Paramedico","Enfermeiro" },
		["Salary"] = { 10000,5500,4500,3500,1500 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Mechanic"] = {
		["Parent"] = {
			["Mechanic"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Salary"] = { 10000,3000,1000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["BurgerShot"] = {
		["Parent"] = {
			["BurgerShot"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Salary"] = { 2500,2250,1500 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["PizzaThis"] = {
		["Parent"] = {
			["PizzaThis"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["UwuCoffee"] = {
		["Parent"] = {
			["UwuCoffee"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {1000},
		["Type"] = "Work"
	},
	["BeanMachine"] = {
		["Parent"] = {
			["BeanMachine"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Cam"] = {
		["Parent"] = {
			["Cam"] = true
		},
		["Hierarchy"] = { "Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Bennys"] = {
		["Parent"] = {
			["Bennys"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Ballas"] = {
		["Parent"] = {
			["Ballas"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Vagos"] = {
		["Parent"] = {
			["Vagos"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Famillies"] = {
		["Parent"] = {
			["Famillies"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Marabuntas"] = {
		["Parent"] = {
			["Marabuntas"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Lester"] = {
		["Parent"] = {
			["Lester"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Arcade"] = {
		["Parent"] = {
			["Arcade"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Madrazzo"] = {
		["Parent"] = {
			["Madrazzo"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Playboy"] = {
		["Parent"] = {
			["Playboy"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Vineyard"] = {
		["Parent"] = {
			["Vineyard"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Gueto01"] = {
		["Parent"] = {
			["Gueto01"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Gueto02"] = {
		["Parent"] = {
			["Gueto02"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Gueto03"] = {
		["Parent"] = {
			["Gueto03"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Gueto04"] = {
		["Parent"] = {
			["Gueto04"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Vanilla"] = {
		["Parent"] = {
			["Vanilla"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	----outros

	["Spotify"] = {
		["Parent"] = {
			["Spotify"] = true
			
		},
		["Hierarchy"] = { "Ouvinte" },
		["Salary"] = {},
		["Service"] = {}
	},

	["Booster"] = {
		["Parent"] = {
			["Booster"] = true
			
		},
		["Hierarchy"] = { "Boostado" },
		["Salary"] = { 500 },
		["Service"] = {}
	},

	["Bolso"] = {
		["Parent"] = {
			["Bolso"] = true
			
		},
		["Hierarchy"] = { "BolsoEquipado" },
		["Salary"] = {},
		["Service"] = {}
	},

	["Attachs"] = {
		["Parent"] = {
			["Attachs"] = true
		},
		["Hierarchy"] = { "Attachs" },
		["Service"] = {},
		["Type"] = "Work"
	},

	---favelas 
	--barragem
	["Favela01"] = {
		["Parent"] = {
			["Favela01"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	--farol 
	["Favela02"] = {
		["Parent"] = {
			["Favela02"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Favela03"] = {
		["Parent"] = {
			["Favela03"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Favela04"] = {
		["Parent"] = {
			["Favela04"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	
	["Muni01"] = {
		["Parent"] = {
			["Muni01"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	["Lavagem01"] = {
		["Parent"] = {
			["Lavagem01"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Ilegal"
	},
	
---------------------- vips
	["Serendibite"] = {
		["Parent"] = {
			["Serendibite"] = true
		},
		["Hierarchy"] = { "Serendibite" },
		["Salary"] = { 1000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Painite"] = {
		["Parent"] = {
			["Painite"] = true
		},
		["Hierarchy"] = { "Painite" },
		["Salary"] = { 2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Ouro"] = {
		["Parent"] = {
			["Ouro"] = true
		},
		["Hierarchy"] = { "Ouro" },
		["Salary"] = { 8000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Vipmonaco"] = {
		["Parent"] = {
			["Vipmonaco"] = true
		},
		["Hierarchy"] = { "Vipmonaco" },
		["Salary"] = { 5000 },
		["Service"] = {},
		["Type"] = "Work"
	},
---------------------fim  vips
	["1x"] = {
		["Parent"] = {
			["1x"] = true
		},
		["Hierarchy"] = { "1x" },
		["Salary"] = { 900 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["2x"] = {
		["Parent"] = {
			["2x"] = true
		},
		["Hierarchy"] = { "2x" },
		["Salary"] = { 2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Emergency"] = {
		["Parent"] = {
			["Police"] = true,
			["Paramedic"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Restaurants"] = {
		["Parent"] = {
			["BurgerShot"] = true,
			["PizzaThis"] = true,
			["UwuCoffee"] = true,
			["BeanMachine"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Dancinhas"] = {
		["Parent"] = {
			["Dancinhas"] = true
		},
		["Hierarchy"] = { "Dançarino" },
		["Salary"] = {},
		["Service"] = {}
	}
}