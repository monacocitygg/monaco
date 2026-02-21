-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local localPeds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	{ -- DigitalDen Market
		Distance = 25,
		Coords = { -1271.55,-1411.49,4.36,124.73 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- DigitalDen Market
		Distance = 25,
		Coords = { -1232.05,-1439.69,4.36,218.27 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- DigitalDen Market 29.21,-1770.21,29.6,48.19
		Distance = 25,
		Coords = { -1207.87,-1502.59,4.36,127.56 },
		Model = "a_m_y_business_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- DigitalDen Market 
	Distance = 25,
	Coords = { 29.21,-1770.21,29.6,48.19 },
	Model = "a_m_y_business_02",
	anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    }, 
	{ -- Brewery Market
		Distance = 25,
		Coords = { 408.85,-1622.9,29.28,232.45 },
		Model = "a_f_y_business_04",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Brewery Market
		Distance = 25,
		Coords = { -1271.89,-1418.5,4.36,34.02 },
		Model = "a_f_y_business_04",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Brewery Market
		Distance = 25,
		Coords = { -1225.06,-1439.93,4.36,121.89 },
		Model = "a_f_y_business_04",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Brewery Market
		Distance = 25,
		Coords = { -1208.13,-1509.62,4.36,34.02 },
		Model = "a_f_y_business_04",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- PRO Bikes Market
		Distance = 25,
		Coords = { -1266.68,-1418.66,4.36,124.73 },
		Model = "a_m_y_cyclist_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- PRO Bikes Market
		Distance = 25,
		Coords = { -1225.04,-1434.83,4.36,221.11 },
		Model = "a_m_y_cyclist_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- PRO Bikes Market
		Distance = 25,
		Coords = { -1203.0,-1509.59,4.36,124.73 },
		Model = "a_m_y_cyclist_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Masquerade Market
		Distance = 25,
		Coords = { -1263.09,-1423.88,4.36,130.4 },
		Model = "u_m_m_streetart_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Masquerade Market
		Distance = 25,
		Coords = { -1219.72,-1431.09,4.36,221.11 },
		Model = "u_m_m_streetart_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Masquerade Market
		Distance = 25,
		Coords = { -1199.24,-1514.95,4.38,127.56 },
		Model = "u_m_m_streetart_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills Market
		Distance = 25,
		Coords = { -1253.68,-1437.09,4.36,124.73 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills Market
		Distance = 25,
		Coords = { -1255.58,-1434.39,4.36,124.73 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills Market
		Distance = 25,
		Coords = { -1195.99,-1458.47,4.38,34.02 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills Market
		Distance = 25,
		Coords = { -1198.76,-1460.3,4.36,36.86 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills Market
		Distance = 25,
		Coords = { -1225.6,-1477.02,4.36,127.56 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pop's Pills Market
		Distance = 25,
		Coords = { -1227.28,-1474.8,4.36,124.73 },
		Model = "u_m_y_baygor",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Truthorganic Market
		Distance = 25,
		Coords = { -1253.94,-1444.82,4.36,34.02 },
		Model = "s_m_m_cntrybar_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	}, 
	{ -- Truthorganic Market
		Distance = 25,
		Coords = { -1206.44,-1460.05,4.36,308.98 },
		Model = "s_m_m_cntrybar_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- munis publics
		Distance = 80,
		Coords = { -91.81,-2563.43,6.08,0.0 },
		Model = "s_m_m_cntrybar_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Truthorganic Market
		Distance = 25,
		Coords = { -1225.76,-1485.01,4.36,34.02 },
		Model = "s_m_m_cntrybar_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- LD Organies Market
		Distance = 25,
		Coords = { -1249.01,-1449.3,4.36,36.86 },
		Model = "ig_lamardavis",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- LD Organies Market
		Distance = 25,
		Coords = { -1211.01,-1464.93,4.36,308.98 },
		Model = "ig_lamardavis",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- LD Organies Market
		Distance = 25,
		Coords = { -1220.88,-1489.58,4.36,36.86 },
		Model = "ig_lamardavis",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Ilegal
	Distance = 25,
	Coords = { 884.92,-953.55,39.21,0.0 },
	Model = "ig_lamardavis",
	anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
},
	{ -- Cool Beans
		Distance = 25,
		Coords = { -1245.36,-1454.24,4.36,34.02 },
		Model = "a_f_m_ktown_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Cool Beans
		Distance = 25,
		Coords = { -1215.81,-1468.6,4.36,306.15 },
		Model = "a_f_m_ktown_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Cool Beans
		Distance = 25,
		Coords = { -1217.2,-1494.39,4.36,31.19 },
		Model = "a_f_m_ktown_02",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Caminhoneiro
		Distance = 100,
		Coords = { 1239.87,-3257.2,7.09,274.97 },
		Model = "s_m_m_trucker_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ballas
		Distance = 100,
		Coords = { 95.58,-1985.56,20.44,317.49 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	


	{ -- favela leitreiro ROTAS
		Distance = 100,
		Coords = { 1031.62,913.52,222.06,42.52 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},

	{ -- favela PENHA ROTAS
		Distance = 100,
		Coords = { 2995.27,2973.04,90.52,8.51 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- favela leitreiro BAU
	Distance = 100,
	Coords = { 1049.35,887.9,220.34,45.36 },
	Model = "ig_g",
	anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},

	{ -- favela PENHA BAU
	Distance = 100,
	Coords = { 2986.92,2962.61,91.38,42.52 },
	Model = "ig_g",
	anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},

	{ -- favela leitreiro craft
		Distance = 25,
		Coords = { 1050.74,891.41,220.34,130.4 },
		Model = "s_m_m_cntrybar_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},

	{ -- favela baragem craft
		Distance = 25,
		Coords = { 1355.64,-259.52,152.0,280.63 },
		Model = "s_m_m_cntrybar_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	
	{ -- Famillies
		Distance = 100,
		Coords = { -135.67,-1605.81,35.03 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Vagos
		Distance = 100,
		Coords = { 338.26,-1980.01,24.2,153.08 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	
	{ -- Marabuntas
		Distance = 100,
		Coords = { 1247.93,-1573.02,58.35,155.91 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Aztecas
		Distance = 100,
		Coords = { 512.29,-1803.52,28.51,246.62 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Bloods
		Distance = 100,
		Coords = { 230.55,-1753.35,28.98,232.45 },
		Model = "ig_g",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Cassino
		Distance = 25,
		Coords = { 988.37,43.06,71.3,170.08 },
		Model = "s_f_y_casino_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Concessionária
		Distance = 100,
		Coords = { 1224.78,2728.01,38.0,178.59 },
		Model = "ig_ramp_hic",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Concessionária
		Distance = 100,
		Coords = { -31.21,-1106.49,26.42,334.49 },
		Model = "ig_barry",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- TowDriver
		Distance = 30,
		Coords = { -193.23,-1162.39,23.67,274.97 },
		Model = "g_m_m_armboss_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Coveiro
		Distance = 100,
		Coords = { -1745.92,-204.83,57.39,320.32 },
		Model = "g_m_m_armboss_01",
		anim = { "timetable@trevor@smoking_meth@base","base" }
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2440.58,4736.35,34.29,317.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2432.5,4744.58,34.31,317.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2424.47,4752.37,34.31,317.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2416.28,4760.8,34.31,317.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2408.6,4768.88,34.31,317.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2400.32,4777.48,34.53,317.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2432.46,4802.66,34.83,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2440.62,4794.22,34.66,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2448.65,4786.57,34.64,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2456.88,4778.08,34.49,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2464.53,4770.04,34.37,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2473.38,4760.98,34.31,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2495.03,4762.77,34.37,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2503.13,4754.08,34.31,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2511.34,4746.04,34.31,137.50 },
		Model = "a_c_cow"
	},
	{ -- Leiteiro
		Distance = 100,
		Coords = { 2519.56,4737.35,34.29,137.50 },
		Model = "a_c_cow"
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2431.86,4967.66,42.34,133.23 },
		Model = "g_m_y_ballaeast_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2431.09,4970.72,42.34,42.52 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@prop_human_parking_meter@female@idle_a","idle_a_female" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2436.08,4965.39,42.34,226.78 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@prop_human_parking_meter@female@idle_a","idle_a_female" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2434.4,4963.8,42.34,229.61 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@prop_human_parking_meter@female@idle_a","idle_a_female" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2432.44,4964.06,42.34,178.59 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@world_human_bum_wash@male@high@base","base" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2431.57,4965.22,42.34,124.73 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@world_human_bum_wash@male@high@base","base" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2428.67,4969.51,42.34,133.23 },
		Model = "g_f_y_ballas_01",
		anim = { "anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2437.05,4967.61,42.34,317.49 },
		Model = "g_f_y_ballas_01",
		anim = { "anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2433.09,4971.51,42.34,320.32 },
		Model = "g_f_y_ballas_01",
		anim = { "anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2432.67,4970.29,42.34,226.78 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@prop_human_parking_meter@female@idle_a","idle_a_female" }
	},
	{ -- Black Market
		Distance = 20,
		Coords = { 2435.28,4969.27,42.34,317.49 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@prop_human_parking_meter@female@idle_a","idle_a_female" }
	},
	{ -- Taxi
		Distance = 50,
		Coords = { -1039.34,-2730.8,20.2,235.28 },
		Model = "a_m_y_stlat_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Weeds
		Distance = 100,
		Coords = { -1174.54,-1571.4,4.35,124.73 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 301.4,-195.29,61.57,158.75 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 169.28,-1536.23,29.25,311.82 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 487.56,-1456.11,29.28,272.13 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 154.66,-1472.9,29.35,325.99 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 389.69,-942.1,29.42,175.75 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 475.1,3555.28,33.23,263.63 },
		Model = "g_f_y_ballas_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { -2192.86,-402.22,10.38,136.07 },
		Model = "g_m_y_ballaeast_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 2013.95,4990.88,41.21,133.23 },
		Model = "g_m_y_ballasout_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { 186.9,6374.75,32.33,206.93 },
		Model = "g_m_y_famca_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Ilegal
		Distance = 100,
		Coords = { -653.2,-1502.18,5.24,201.26 },
		Model = "g_m_y_famdnf_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	
	{ -- Ilegal compras
		Distance = 100,
		Coords = {-1207.63,-1771.35,3.91,51.03 },
		Model = "g_m_y_famdnf_01",
		anim = { "amb@lo_res_idles@","world_human_lean_male_foot_up_lo_res_base" }
	},
	{ -- Police
		Distance = 100,
		Coords = { -2262.1,384.1,193.13,28.35 },
		Model = "s_f_y_cop_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Police
		Distance = 100,
		Coords = { -2320.86,369.93,174.6,31.19 },
		Model = "s_f_y_cop_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Paramedic
		Distance = 100,
		Coords = { -271.7,6321.75,32.42,0.0 },
		Model = "s_m_m_paramedic_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Paramedic
		Distance = 100,
		Coords = { -253.92,6339.42,32.42,5.67 },
		Model = "s_m_m_paramedic_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Paramedic
		Distance = 100,
		Coords = { 338.19,-586.91,74.16,252.29 },
		Model = "s_m_m_paramedic_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- npc-farmacia
		Distance = 100,
		Coords = { 1147.85,-1552.4,35.38,45.36 },
		Model = "s_m_m_paramedic_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Paramedic
		Distance = 100,
		Coords = { 340.08,-576.19,28.8,73.71 },
		Model = "s_m_m_paramedic_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 24.36,-1346.58,29.49,272.13 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 2556.53,380.66,108.61,0.0 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 1164.82,-323.65,69.2,96.38 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -706.15,-914.53,19.21,85.04 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -47.38,-1758.68,29.42,42.52 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 372.52,326.89,103.56,257.96 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -3242.86,999.95,12.82,357.17 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 1728.0,6415.69,35.03,243.78 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 1959.76,3740.35,32.33,303.31 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 2677.84,3279.34,55.23,340.16 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 1697.31,4923.49,42.06,325.99 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -1819.52,793.48,138.08,127.56 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 1391.69,3605.97,34.98,198.43 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -2966.41,391.55,15.05,85.04 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -3039.29,584.27,7.9,17.01 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 1134.33,-983.11,46.4,274.97 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 1165.28,2710.77,38.15,175.75 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -1486.72,-377.55,40.15,130.4 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { -1221.45,-907.92,12.32,31.19 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Departament Store
		Distance = 15,
		Coords = { 549.28,2670.59,42.16,85.04 },
		Model = "mp_m_shopkeep_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { 1695.22,3761.03,34.69,133.23 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { 251.45,-51.79,69.94,343.0 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { 840.35,-1032.83,28.19,269.3 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { -328.24,6084.49,31.44,133.23 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { -660.27,-936.25,21.82,73.71 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { -1307.09,-396.01,36.68,334.49 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { -1115.67,2699.15,18.55,124.73 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { 2565.93,295.11,108.73,269.3 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { -3170.29,1089.16,20.84,144.57 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { 22.49,-1111.01,29.79,56.7 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { 808.25,-2156.33,29.62,263.63 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ammu-Nation Store
		Distance = 15,
		Coords = { 814.84,-2155.14,29.62,357.17 },
		Model = "ig_dale",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Life Invader
		Distance = 20,
		Coords = { -1083.15,-245.88,37.76,209.77 },
		Model = "ig_barry",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	}, 
	{ -- Recycling Sell
		Distance = 50,
		Coords = { -428.54,-1728.29,19.78,70.87 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling Sell
		Distance = 50,
		Coords = { 180.07,2793.29,45.65,283.47 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling Sell
		Distance = 50,
		Coords = { -195.42,6264.62,31.49,42.52 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Jewelry
		Distance = 15,
		Coords = { -628.79,-238.7,38.05,311.82 },
		Model = "cs_gurk",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Oxy Store
		Distance = 30,
		Coords = { -1636.74,-1092.17,13.08,320.32 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Transporter
		Distance = 20,
		Coords = { 239.6,225.37,97.11,249.45},
		Model = "ig_casey",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lenhador
		Distance = 50,
		Coords = { 2433.45,5013.46,46.99,314.65 },
		Model = "a_m_o_ktown_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pescador
		Distance = 50,
		Coords = { 1509.64,3788.7,33.51,266.46 },
		Model = "a_f_y_beach_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Motorista
		Distance = 30,
		Coords = { 452.97,-607.75,28.59,266.46 },
		Model = "u_m_m_edtoh",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lixeiro
		Distance = 50,
		Coords = { 82.98,-1553.55,29.59,51.03 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lixeiro
		Distance = 50,
		Coords = { 287.77,2843.9,44.7,121.89 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lixeiro
		Distance = 50,
		Coords = { -413.97,6171.58,31.48,320.32 },
		Model = "s_m_y_garbage",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { 79.03,-1387.78,29.37,189.93 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -708.34,-152.9,37.41,113.39 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -164.47,-301.63,39.73,249.45 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -816.17,-1074.01,11.32,119.06 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -1194.63,-767.57,17.3,221.11 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -1449.45,-238.74,49.81,45.36 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -1.52,6511.59,31.88,317.49 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { 1691.06,4817.16,42.06,2.84 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { 127.22,-223.47,54.56,62.37 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { 613.07,2761.81,42.09,269.3 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { 1201.84,2706.53,38.22,82.21 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -3169.04,1044.11,20.86,68.04 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { -1095.23,2711.33,19.11,121.89 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Roupas
		Distance = 20,
		Coords = { 422.1,-811.46,29.49,0.0 },
		Model = "a_f_y_epsilon_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		Distance = 10,
		Coords = { 1324.44,-1650.0,52.27,124.73 },
		Model = "a_f_y_hippie_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		Distance = 10,
		Coords = { -1152.17,-1423.8,4.95,116.23 },
		Model = "a_f_y_hippie_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		Distance = 10,
		Coords = { 319.68,180.72,103.58,246.62 },
		Model = "a_f_y_hippie_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		Distance = 10,
		Coords = { -3170.41,1072.92,20.83,334.49 },
		Model = "a_f_y_hippie_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		Distance = 10,
		Coords = { 1862.52,3748.5,33.03,19.85 },
		Model = "a_f_y_hippie_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Loja de Tatuagem
		Distance = 10,
		Coords = { -292.02,6199.8,31.48,232.45 },
		Model = "a_f_y_hippie_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Taxista
		Distance = 30,
		Coords = { 894.9,-179.15,74.7,240.95 },
		Model = "a_m_y_stlat_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Taxista
		Distance = 30,
		Coords = { 1696.19,4785.25,42.02,93.55 },
		Model = "a_m_y_stlat_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Caçador
		Distance = 10,
		Coords = { -679.13,5839.52,17.32,226.78 },
		Model = "ig_hunter",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Caçador
		Distance = 30,
		Coords = { -695.56,5802.12,17.32,65.2 },
		Model = "a_m_o_ktown_01",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pescador
		Distance = 30,
		Coords = { -1816.64,-1193.73,14.31,334.49 },
		Model = "a_f_y_eastsa_03",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Pescador
		Distance = 30,
		Coords = { 1522.88,3783.63,34.47,218.27 },
		Model = "a_f_y_eastsa_03",
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLIST
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number = 1,#List do
			local Distance = #(Coords - vec3(List[Number]["Coords"][1],List[Number]["Coords"][2],List[Number]["Coords"][3]))
			if Distance <= List[Number]["Distance"] then
				if not localPeds[Number] and LocalPlayer["state"]["Route"] < 900000 then
					if LoadModel(List[Number]["Model"]) then
						localPeds[Number] = CreatePed(4,List[Number]["Model"],List[Number]["Coords"][1],List[Number]["Coords"][2],List[Number]["Coords"][3] - 1,List[Number]["Coords"][4],false,false)
						SetPedArmour(localPeds[Number],99)
						SetEntityInvincible(localPeds[Number],true)
						FreezeEntityPosition(localPeds[Number],true)
						SetBlockingOfNonTemporaryEvents(localPeds[Number],true)

						SetModelAsNoLongerNeeded(List[Number]["Model"])

						if List[Number]["Model"] == "s_f_y_casino_01" then
							SetPedDefaultComponentVariation(localPeds[Number])
							SetPedComponentVariation(localPeds[Number],0,3,0,0)
							SetPedComponentVariation(localPeds[Number],1,0,0,0)
							SetPedComponentVariation(localPeds[Number],2,3,0,0)
							SetPedComponentVariation(localPeds[Number],3,0,1,0)
							SetPedComponentVariation(localPeds[Number],4,1,0,0)
							SetPedComponentVariation(localPeds[Number],6,1,0,0)
							SetPedComponentVariation(localPeds[Number],7,1,0,0)
							SetPedComponentVariation(localPeds[Number],8,0,0,0)
							SetPedComponentVariation(localPeds[Number],10,0,0,0)
							SetPedComponentVariation(localPeds[Number],11,0,0,0)
							SetPedPropIndex(localPeds[Number],1,0,0,false)
						end

						if List[Number]["anim"] ~= nil then
							if LoadAnim(List[Number]["anim"][1]) then
								TaskPlayAnim(localPeds[Number],List[Number]["anim"][1],List[Number]["anim"][2],8.0,8.0,-1,1,0,0,0,0)
							end
						end
					end
				end
			else
				if localPeds[Number] then
					if DoesEntityExist(localPeds[Number]) then
						DeleteEntity(localPeds[Number])
					end

					localPeds[Number] = nil
				end
			end
		end

		Wait(1000)
	end
end)