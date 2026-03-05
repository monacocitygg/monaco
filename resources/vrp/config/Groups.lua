-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	["Admin"] = {
		["Parent"] = {
			["Admin"] = true
		},
		-- Admin 1 = Coordenacao | Admin 2 = Head Staff | Admin 3 = Staff | Admin 4 = Suporte
		["Hierarchy"] = { "Administrador","HeadStaff","Staff","Suporte" },
		["Service"] = {}
	},

	["Administrador"] = {
		["Parent"] = {
			["Administrador"] = true
		},
		["Hierarchy"] = { "Administrador","HeadStaff","Staff","Suporte" },
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
		["Salary"] = { 500 },
		["Service"] = {}
	},

	----------

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
	----Policia
	["Police"] = {
		["Parent"] = {
			["Police"] = true
		},
		["Hierarchy"] = { "Comando Geral","Coronel","Capitão","Tenente","Sargento","Cabo","Soldado","Recruta" },
		["Salary"] = { 10000,8000,5000,4000,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Gtm"] = {
		["Parent"] = {
			["Gtm"] = true
		},
		["Hierarchy"] = { "Comando","Sub Comando","Coordenador","Piloto Elite","Piloto Oficial","Piloto Teste" },
		["Salary"] = { 10000,8000,5000,4000,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Graer"] = {
		["Parent"] = {
			["Graer"] = true
		},
        ["Hierarchy"] = { "Comando","Sub Comando","Coordenador","Piloto Elite","Piloto Oficial","Piloto Teste" },
		["Salary"] = { 10000,8000,5000,4000,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Speed"] = {
		["Parent"] = {
			["Speed"] = true
		},
        ["Hierarchy"] = { "Comando","Sub Comando","Coordenador","Piloto Elite","Piloto Oficial","Piloto Teste" },
		["Salary"] = { 10000,8000,5000,4000,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Core"] = {
		["Parent"] = {
			["Core"] = true
		},
		["Hierarchy"] = { "Comando","Sub Comando","Coordenador","Supervisor","Executor","Operador","Probatório" },
		["Salary"] = { 10000,8000,5000,4000,3000,2500,2000 },
		["Service"] = {},
		["Type"] = "Work"
	},

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
	["Flawless"] = {
		["Parent"] = {
			["Flawless"] = true
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
	["Peixes"] = {
		["Parent"] = {
			["Peixes"] = true
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
	["Vipmonaco"] = {
		["Parent"] = {
			["Vipmonaco"] = true
		},
		["Hierarchy"] = { "Vipmonaco" },
		["Salary"] = { 5000 },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Vippolice"] = {
		["Parent"] = {
			["Vippolice"] = true
		},
		["Hierarchy"] = { "Vippolice" },
		["Salary"] = { 2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
---------------------fim  vips
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
