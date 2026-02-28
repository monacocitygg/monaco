-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages",Creative)
vSERVER = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DECOR
-----------------------------------------------------------------------------------------------------------------------------------------
DecorRegister("PlayerVehicle",3)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = ""
local Searched = nil
local Hotwired = false
local DeleteTime = GetGameTimer()
local Anim = "machinic_loop_mechandplayer"
local Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Garages = {
	["1"] = { x = 55.44, y = -876.17, z = 30.67,
		["1"] = { 60.44,-866.47,30.23,340.16 },
		["2"] = { 57.26,-865.35,30.25,340.16 },
		["3"] = { 54.03,-864.21,30.25,340.16 },
		["4"] = { 50.73,-863.01,30.26,340.16 },
		["5"] = { 60.52,-866.53,30.14,340.16 },
		["6"] = { 50.73,-873.28,30.11,158.75 },
		["7"] = { 47.36,-872.07,30.13,158.75 },
		["8"] = { 44.15,-870.9,30.13,158.75 }
	},
	["2"] = { x = 599.04, y = 2745.33, z = 42.04,
		["1"] = { 604.82,2738.27,41.64,187.09 },
		["2"] = { 601.75,2738.08,41.65,184.26 },
		["3"] = { 598.63,2737.85,41.69,184.26 },
		["4"] = { 595.59,2737.55,41.7,184.26 }
	},
	["3"] = { x = -136.8, y = 6356.84, z = 31.49,
		["1"] = { -133.72,6349.01,31.16,42.52 },
		["2"] = { -136.1,6346.53,31.16,42.52 }
	},
	["4"] = { x = 275.23, y = -345.56, z = 45.17,
		["1"] = { 266.06,-332.07,44.58,252.29 },
		["2"] = { 267.18,-328.9,44.58,252.29 },
		["3"] = { 268.32,-325.67,44.58,252.29 },
		["4"] = { 269.53,-322.4,44.58,252.29 },
		["5"] = { 270.77,-319.14,44.58,252.29 }
	},
	["5"] = { x = 596.43, y = 90.68, z = 93.13,
		["1"] = { 599.82,102.03,92.57,249.45 },
		["2"] = { 598.69,98.42,92.57,249.45 }
	},
	["6"] = { x = -340.57, y = 266.04, z = 85.68,
		["1"] = { -349.47,272.54,84.77,272.13 },
		["2"] = { -349.5,275.91,84.69,272.13 },
		["3"] = { -349.56,279.3,84.62,272.13 },
		["4"] = { -349.67,282.6,84.59,274.97 },
		["5"] = { -349.74,286.16,84.59,272.13 },
		["6"] = { -349.8,289.76,84.6,272.13 },
		["7"] = { -349.85,293.28,84.6,272.13 },
		["8"] = { -349.87,296.72,84.6,272.13 }
	},
	["7"] = { x = -2030.03, y = -465.99, z = 11.59,
		["1"] = { -2037.4,-461.02,11.07,138.9 },
		["2"] = { -2039.78,-459.07,11.07,138.9 },
		["3"] = { -2042.12,-457.1,11.07,138.9 },
		["4"] = { -2044.47,-455.11,11.07,138.9 },
		["5"] = { -2046.85,-453.09,11.07,138.9 },
		["6"] = { -2049.12,-451.17,11.07,138.9 },
		["7"] = { -2051.51,-449.23,11.07,138.9 }
	},
	["8"] = { x = -1184.94, y = -1509.99, z = 4.65,
		["1"] = { -1183.29,-1495.81,4.04,121.89 },
		["2"] = { -1185.23,-1493.28,4.04,121.89 },
		["3"] = { -1186.87,-1490.71,4.04,121.89 },
		["4"] = { -1188.69,-1488.27,4.04,121.89 }
	},
	["9"] = { x = 101.23, y = -1073.64, z = 29.37,
		["1"] = { 105.9,-1063.14,28.88,246.62 },
		["2"] = { 107.42,-1059.61,28.88,246.62 },
		["3"] = { 108.88,-1056.23,28.88,246.62 },
		["4"] = { 110.27,-1052.86,28.88,246.62 }
	},
	["10"] = { x = 213.97, y = -808.43, z = 31.0,
		["1"] = { 221.93,-804.11,30.35,249.45 },
		["2"] = { 222.9,-801.61,30.33,249.45 },
		["3"] = { 223.92,-799.2,30.33,249.45 },
		["4"] = { 224.85,-796.69,30.33,249.45 }
	},
	["11"] = { x = -348.89, y = -874.02, z = 31.31,
		["1"] = { -343.62,-875.51,30.75,167.25 },
		["2"] = { -339.98,-876.27,30.75,167.25 },
		["3"] = { -336.35,-876.98,30.75,167.25 },
		["4"] = { -332.72,-877.71,30.75,167.25 }
	},
	["12"] = { x = 67.72, y = 12.3, z = 69.22,
		["1"] = { 63.87,16.5,68.87,340.16 },
		["2"] = { 60.78,17.6,68.92,340.16 },
		["3"] = { 57.76,18.76,69.03,340.16 },
		["4"] = { 54.8,19.92,69.25,340.16 }
	},
	["13"] = { x = 361.96, y = 297.8, z = 103.88,
		["1"] = { 371.06,284.68,102.94,340.16 },
		["2"] = { 374.8,283.39,102.85,340.16 },
		["3"] = { 378.62,282.06,102.78,340.16 }
	},
	["14"] = { x = 1035.84, y = -763.87, z = 58.0,
		["1"] = { 1046.56,-774.55,57.69,90.71 },
		["2"] = { 1046.56,-778.24,57.68,90.71 },
		["3"] = { 1046.55,-782.0,57.68,90.71 },
		["4"] = { 1046.54,-785.65,57.66,90.71 }
	},
	["15"] = { x = -796.69, y = -2022.85, z = 9.17,
		["1"] = { -779.77,-2040.03,8.56,314.65 },
		["2"] = { -777.36,-2042.58,8.56,314.65 },
		["3"] = { -774.92,-2044.9,8.56,314.65 }
	},
	["16"] = { x = 453.28, y = -1146.77, z = 29.5,
		["1"] = { 467.33,-1151.89,28.96,85.04 },
		["2"] = { 467.16,-1154.75,28.96,85.04 },
		["3"] = { 467.1,-1157.73,28.96,87.88 }
	},
	["17"] = { x = 528.65, y = -146.25, z = 58.37,
		["1"] = { 540.99,-136.2,59.13,178.59 },
		["2"] = { 544.84,-136.25,59.01,178.59 },
		["3"] = { 548.83,-136.31,59.01,181.42 },
		["4"] = { 552.81,-136.41,58.99,178.59 }
	},
	["18"] = { x = -1159.56, y = -739.39, z = 19.88,
		["1"] = { -1144.95,-745.49,19.34,104.89 },
		["2"] = { -1142.76,-748.44,19.19,107.72 },
		["3"] = { -1140.18,-751.41,19.06,107.72 },
		["4"] = { -1137.99,-754.36,18.91,107.72 },
		["5"] = { -1135.43,-757.3,18.75,107.72 },
		["6"] = { -1133.12,-760.4,18.59,107.72 },
		["7"] = { -1130.59,-763.27,18.43,107.72 }
	},
	["19"] = { x = -791.48, y = 336.48, z = 85.7,
		["1"] = { -791.64,331.67,85.38,181.42 }
	},
	["20"] = { x = -800.45, y = 336.61, z = 85.7,
		["1"] = { -800.38,331.9,85.38,181.42 }
	},
	["21"] = { x = 935.95, y = 0.36, z = 78.76,
		["1"] = { 933.29,-3.74,78.44,147.41 }
	},
	["22"] = { x = 1725.21, y = 4711.77, z = 42.11,
		["1"] = { 1722.82,4700.38,42.28,87.88 }
	},
	["23"] = { x = 1624.05, y = 3566.14, z = 35.15,
		["1"] = { 1633.27,3563.91,34.91,303.31 }
	},
	["24"] = { x = 1143.8, y = 2667.46, z = 38.15,
		["1"] = { 1137.41,2674.26,37.83,0.0 }
	},
	["25"] = { x = -73.35, y = -2004.6, z = 18.27,
		["1"] = { -59.61,-1990.85,17.69,155.91 },
		["2"] = { -63.69,-1989.71,17.69,167.25 },
		["3"] = { -67.6,-1989.01,17.69,170.08 },
		["4"] = { -71.34,-1988.57,17.69,172.92 },
		["5"] = { -74.96,-1988.07,17.69,170.08 },
		["6"] = { -78.64,-1987.63,17.69,170.08 },
		["7"] = { -82.27,-1987.19,17.69,170.08 }
	},
	["26"] = { x = -497.84, y = -2202.97, z = 6.37,
		["1"] = { -497.96,-2197.48,5.86,45.36 },
		["2"] = { -496.02,-2194.6,6.15,48.19 }
},
	["41"] = { x = 340.08, y = -576.19, z = 28.8,
		["1"] = { 333.34,-574.76,28.48,340.16 }
	},
	["42"] = { x = 338.19, y = -586.91, z = 74.16,
		["1"] = { 351.76,-588.19,74.16,337.33 }
	},
	["43"] = { x = -253.92, y = 6339.42, z = 32.42,
		["1"] = { -258.47,6347.58,32.1,269.3 },
		["2"] = { -261.6,6344.21,32.1,269.3 },
		["3"] = { -264.97,6340.84,32.1,272.13 }
	},
	["44"] = { x = -271.7, y = 6321.75, z = 32.42,
		["1"] = { -273.13,6329.85,32.1,133.23 }
	},
	["45"] = { x = 1206.15, y = -1474.68, z = 34.85,
		["1"] = { 1196.58,-1468.52,34.93,0.0 },
		["2"] = { 1200.73,-1468.58,34.93,0.0 },
		["3"] = { 1204.83,-1468.62,34.93,0.0 }
	}, 
	["61"] = { x =-938.62, y =-2076.29, z = 9.3, 
	["1"] = { -941.65,-2078.36,9.03,226.78 },
	["2"] = { -943.01,-2081.4,9.03,223.94 }
}, 
	["62"] = { x = 463.15, y = -982.33, z = 43.69,
		["1"] = { 449.27,-981.34,43.69,87.88 }
	},
	["63"] = { x = 593.62, y = 3.01, z = 70.63,
		["1"] = { 593.13,0.4,70.43,252.29 },
		["2"] = { 592.17,-2.21,70.43,252.29 },
		["3"] = { 591.18,-4.74,70.43,252.29 }
	},
	["64"] = { x = 1844.42, y = 3707.33, z = 33.97,
		["1"] = { 1853.31,3706.24,33.97,28.35 }
	}, 
	["65"] = { x = -459.37, y = 6016.01, z = 31.49,
		["1"] = { -469.04,6038.77,31.0,226.78 },
		["2"] = { -472.45,6035.42,31.0,226.78 },
		["3"] = { -476.09,6031.71,31.0,226.78 },
		["4"] = { -479.61,6028.09,31.0,226.78 },
		["5"] = { -482.7,6024.95,31.0,226.78 }
	},
	["66"] = { x = -950.05, y = -2032.11, z = 11.49,  ----HELI DP2 SUL
		["1"] = { -950.96,-2021.1,11.32,226.78 }
	},
	["67"] = { x = 1853.45, y = 2538.35, z = 45.66,  -------presidio 257.96
		["1"] = { 1854.24,2541.68,45.66,272.13 }
	},
	["68"] = { x = 1840.79, y = 2538.28, z = 45.66,
		["1"] = { 1833.59,2542.09,45.54,272.13 }
	},
	["69"] = { x = 377.58, y = 791.66, z = 187.64,
		["1"] = { 374.46,796.86,187.03,178.59 }
	},

	["70"] = { x =  -764.7, y = -1316.69,  z = 5.14,      -- DP 1
		["1"] = { -752.07,-1321.84,4.57,51.03 },
		["2"] = { -753.99,-1324.02,4.57,48.19 },
		["3"] = { -755.89,-1326.19,4.57,48.19 },
		["4"] = { -758.49,-1329.03,4.57,48.19 },
		["5"] = { -760.33,-1331.27,4.57,48.19 } 
	},
	["153"] = { x =  -1066.08, y = -879.05,  z = 4.95,      -- DP PRAIA
		["1"] = { -1068.79,-879.56,4.16,31.19 },
		["2"] = { -1072.15,-881.56,4.08,25.52 },
		["3"] = { -1076.4,-882.47,3.98,28.35 }
},

	["71"] = { x = 366.2, y = -1593.73, z = 38.81, 
		["1"] = { 359.39,-1597.95,39.48,269.3 }
	},
	["72"] = { x = 1854.04, y = 2670.97, z = 45.66, --presidio  357.17
		["1"] = { 1856.1,2668.54,45.93,269.3 }
	},
	["91"] = { x = 84.47, y = -1972.8, z = 20.84,
		["1"] = { 88.7,-1967.4,20.51,323.15 }
	},
	["92"] = { x = -25.01, y = -1433.2, z = 30.65,
		["1"] = { -25.01,-1437.79,30.41,178.59 }
	},
	["93"] = { x = 337.43, y = -2036.08, z = 21.35,
		["1"] = { 332.6,-2031.48,20.98,138.9 }
	},
	["94"] = { x = 504.18, y = -1798.77, z = 28.49,
		["1"] = { 498.32,-1803.21,28.22,51.03 }
	},
	["95"] = { x = 232.26, y = -1757.15, z = 29.0,
		["1"] = { 238.84,-1760.94,28.78,320.32 }
	},
	["96"] = { x = -816.25, y = -726.19, z = 23.78,
		["1"] = { -816.3,-731.23,23.54,181.42 }
	},
	["97"] = { x = 496.3, y = -103.58, z = 61.33,
		["1"] = { 500.42,-105.01,61.81,252.29 }
	},
	["121"] = { x = -1728.06, y = -1050.69, z = 1.7,
		["1"] = { -1734.05,-1057.01,0.94,133.23 }
	},
	["122"] = { x = 1966.55, y = 3976.15, z = 31.49,
		["1"] = { 1971.66,3985.42,30.13,331.66 }
	},
	["123"] = { x = -776.63, y = -1494.93, z = 2.29,
		["1"] = { -786.5,-1498.89,-0.57,110.56 }
	},
	["124"] = { x = -895.04, y = 5687.46, z = 3.03,
		["1"] = { -907.5,5684.52,0.76,102.05 }
	},
	["125"] = { x = 1509.64, y = 3788.7, z = 33.51,
		["1"] = { 1493.4,3797.23,29.89,50.19 }
	},
	["126"] = { x = 4971.79, y = -5170.93, z = 2.27,
		["1"] = { 4952.76,-5163.61,-0.39,65.2 }
	},
	["141"] = { x = 2434.96, y = 5012.06, z = 46.84,
		["1"] = { 2441.6,5010.56,45.76,277.8 }
	},
	["142"] = { x = 453.74, y = -600.6, z = 28.59,
		["1"] = { 462.81,-606.03,28.49,212.6 },
		["2"] = { 461.54,-612.34,28.49,215.44 },
		["3"] = { 460.98,-619.81,28.49,215.44 }
	},
	["143"] = { x = -338.59, y = -1532.33, z = 27.72,
		["1"] = { -330.72,-1527.29,27.26,2.84 }

	},
	["144"] = { x = 355.15, y = 275.79, z = 103.15,
		["1"] = { 359.95,272.31,102.72,340.16 },
		["2"] = { 364.05,270.74,102.68,340.16 },
		["3"] = { 368.1,269.31,102.67,340.16 }
	},
	["145"] = { x = 905.6, y = -165.08, z = 74.11,
		["1"] = { 916.21,-170.61,74.04,99.22 },
		["2"] = { 918.35,-167.18,74.22,99.22 },
		["3"] = { 920.64,-163.54,74.43,99.22 }
	},
	["146"] = { x = -154.58, y = -1174.61, z = 23.99,
		["1"] = { -141.94,-1180.86,23.86,87.88 }
	},
	["147"] = { x = 83.86, y = -1550.82, z = 29.59, 
		["1"] = { 81.47,-1541.78,28.78,48.19 } 
	},
	["148"] = { x = -412.39, y = 6171.06, z = 31.48,
		["1"] = { -401.19,6167.31,31.24,317.49 }
	},
	["149"] = { x = 1695.55, y = 4787.69, z = 42.01,
		["1"] = { 1691.56,4782.3,41.52,87.88 },
		["2"] = { 1691.54,4778.38,41.53,87.88 },
		["3"] = { 1691.56,4774.37,41.53,87.88 },
		["4"] = { 1691.57,4770.32,41.53,87.88 },
		["5"] = { 1691.5,4766.35,41.53,87.88 },
		["6"] = { 1691.52,4762.46,41.52,87.88 }
	},
	["151"] = { x = 393.47, y = -1632.31, z = 29.28, --DIB
		["1"] = { 393.49,-1629.07,28.61,48.19 },
		["2"] = { 395.73,-1626.56,28.61,45.36 },
		["3"] = { 397.22,-1623.86,28.61,48.19 },
		["4"] = { 399.64,-1621.96,28.61,51.03 }
	},
	["152"] = { x = 842.97, y = -1356.14, z = 26.08, --CORE
		["1"] = { 844.17,-1352.24,25.41,246.62 },
		["2"] = { 843.35,-1346.14,25.39,246.62 },
		["3"] = { 843.35,-1340.26,25.38,246.62 },
		["4"] = { 843.86,-1334.69,25.43,246.62 }
},
	["150"] = { x = 1241.65, y = -3262.85, z = 5.53,
		["1"] = { 1271.56,-3287.96,6.10,91.00 },
		["2"] = { 1271.82,-3282.63,6.10,91.00 },
		["3"] = { 1271.95,-3271.04,6.10,91.00 },
		["4"] = { 1272.11,-3266.03,6.10,91.00 }
	},
	---------favelas
	---barragem 405.2,754.98,194.58,229.61
	["154"] = { x = 1317.34, y = -133.58, z = 115.76, 
		["1"] = { 1322.01,-137.07,114.98,277.8 }
	},
	---farol
	["155"] = { x =  3289.35, y = 5141.94, z = 19.9,
		["1"] = { 3291.05,5138.05,19.38,82.21 },
		["2"] = { 3291.21,5134.41,19.38,82.21 }
	},

	---------Attachs
	["156"] = { x = -587.53, y = 202.79, z = 71.54,
			["1"] = { }, 
			["2"] = { -589.09,194.29,71.36,90.71 }
		},
	---------Lavagem01 ,,52.6,226.78
	["157"] = { x = 95.94, y = -223.23, z = 54.63, 
		["1"] = { 94.53,-218.87,53.84,68.04 },
		["2"] = { 96.19,-216.02,53.95,68.04}
	},
	---------Lester 
	["158"] = { x = 1280.59, y = -1729.16, z = 52.6, 
		["1"] = { 1278.7,-1732.49,52.45,113.39 }
	},
	---------Ballas  
	["159"] = { x = -2.9, y = -1839.71, z = 24.84, 
		["1"] = { -2.51,-1843.96,24.06,232.45 }
	},
	---------Famillies 
	["160"] = { x = -176.47, y = -1632.05, z = 33.31, 
		["1"] = { -179.22,-1628.92,32.72,0.0}
	},
	---------Marabuntas ,,,124.73
	["161"] = { x = 1254.45, y = -1597.05, z = 52.94, 
		["1"] = { 1249.11,-1600.69,52.4,121.89}
	},
	---------Parque 
	["162"] = { x = 393.31, y = 783.8, z = 187.39,
			["1"] = { 395.39,782.37,187.52,130.4 }
		},
	---------mec  
	["163"] = { x = -2034.39, y = -483.05, z = 12.05,
		["1"] = { -2031.07,-481.84,11.44,323.15 },
		["2"] = { -2028.94,-483.66,11.44,320.32 }
	},
   	---------Vanilla
	["164"] = { x = 138.86, y = -1283.02, z = 29.35,
		["1"] = { 140.56,-1280.41,29.34,294.81 }
	},
	
	["165"] = { x =  1143.29, y =-1584.47, z = 35.38,
		["1"] = { 1140.33,-1588.48,35.17,184.26 },
		["2"] = { 1135.82,-1589.02,35.17,178.59 }
	}, 
    ---------Aeroporto
	["166"] = { x =  -1034.26, y =-2733.9, z = 20.17,
	["1"] = { -1030.95,-2730.47,20.14,240.95 },
	["2"] = { -1022.65,-2735.6,20.12,240.95 }
    },

	---------Favela04 ponte caio perigo
	["167"] = { x = 1466.52, y = -2420.95, z = 66.81,
			["1"] = { 1469.33,-2419.06,66.78,65.2 }
		},
	---------Favela05 praia2 
	["168"] = { x = -3068.8, y = 1653.3, z = 38.11, 
		["1"] = { -3069.21,1657.97,37.34,300.48 }
	},

	["169"] = { x = -2046.36, y = -473.24, z = 12.05, 
		["1"] = { -2044.64,-469.34,11.36,320.32 },
		["2"] = { -2046.85,-467.52,11.36,320.32 }
	},
 
	["170"] = { x = -578.7, y = -1098.34, z = 22.38, 
		["1"] = {-581.76,-1101.17,21.92,87.88},
		["2"] = { -582.47,-1104.73,21.92,90.71}
	},

	["171"] = { x = 1154.87, y = -1486.39, z = 34.85, 
		["1"] = {1156.51,-1482.87,34.42,87.88},
		["2"] = {1156.26,-1477.85,34.42,90.71}
	},
 
	["172"] = { x = -794.83, y = -91.68, z = 37.71, 
		["1"] = {-791.1,-93.15,36.99,195.6},
	}
	
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function VehicleMods(Vehicle,Customize)
	if Customize then
		SetVehicleModKit(Vehicle,0)

		if Customize["wheeltype"] ~= nil then
			SetVehicleWheelType(Vehicle,Customize["wheeltype"])
		end

		if Customize["mods"] then
			for i = 0,16 do
				if Customize["mods"][tostring(i)] ~= nil then
					SetVehicleMod(Vehicle,i,Customize["mods"][tostring(i)])
				end
			end

			for i = 17,22 do
				if Customize["mods"][tostring(i)] ~= nil then
					ToggleVehicleMod(Vehicle,i,Customize["mods"][tostring(i)])
				end
			end

			for i = 23,24 do
				if Customize["mods"][tostring(i)] ~= nil then
					if not Customize["var"] then
						Customize["var"] = {}
						Customize["var"][tostring(i)] = 0
					end

					SetVehicleMod(Vehicle,i,Customize["mods"][tostring(i)],Customize["var"][tostring(i)])
				end
			end

			for i = 25,48 do
				if Customize["mods"][tostring(i)] ~= nil then
					SetVehicleMod(Vehicle,i,Customize["mods"][tostring(i)])
				end
			end
		end

		if Customize["neon"] ~= nil then
			for i = 0,3 do
				SetVehicleNeonLightEnabled(Vehicle,i,Customize["neon"][tostring(i)])
			end
		end

		if Customize["extras"] ~= nil then
			for i = 1,12 do
				local onoff = tonumber(Customize["extras"][i])
				if onoff == 1 then
					SetVehicleExtra(Vehicle,i,0)
				else
					SetVehicleExtra(Vehicle,i,1)
				end
			end
		end

		if Customize["liverys"] ~= nil and Customize["liverys"] ~= 24  then
			SetVehicleLivery(Vehicle,Customize["liverys"])
		end

		if Customize["plateIndex"] ~= nil and Customize["plateIndex"] ~= 4 then
			SetVehicleNumberPlateTextIndex(Vehicle,Customize["plateIndex"])
		end

		SetVehicleXenonLightsColour(Vehicle,Customize["xenonColor"])
		SetVehicleColours(Vehicle,Customize["colors"][1],Customize["colors"][2])
		SetVehicleExtraColours(Vehicle,Customize["extracolors"][1],Customize["extracolors"][2])
		if Customize["customPcolor"] then
			local r = parseInt(Customize["customPcolor"][1] or Customize["customPcolor"]["1"])
			local g = parseInt(Customize["customPcolor"][2] or Customize["customPcolor"]["2"])
			local b = parseInt(Customize["customPcolor"][3] or Customize["customPcolor"]["3"])
			if r ~= nil and g ~= nil and b ~= nil then
				SetVehicleCustomPrimaryColour(Vehicle,r,g,b)
			end
		else
			ClearVehicleCustomPrimaryColour(Vehicle)
		end

		if Customize["customScolor"] then
			local r = parseInt(Customize["customScolor"][1] or Customize["customScolor"]["1"])
			local g = parseInt(Customize["customScolor"][2] or Customize["customScolor"]["2"])
			local b = parseInt(Customize["customScolor"][3] or Customize["customScolor"]["3"])
			if r ~= nil and g ~= nil and b ~= nil then
				SetVehicleCustomSecondaryColour(Vehicle,r,g,b)
			end
		else
			ClearVehicleCustomSecondaryColour(Vehicle)
		end
		SetVehicleNeonLightsColour(Vehicle,Customize["lights"][1],Customize["lights"][2],Customize["lights"][3])
		SetVehicleTyreSmokeColor(Vehicle,Customize["smokecolor"][1],Customize["smokecolor"][2],Customize["smokecolor"][3])

		if Customize["tint"] ~= nil then
			SetVehicleWindowTint(Vehicle,Customize["tint"])
		end

		if Customize["dashColour"] ~= nil then
			SetVehicleInteriorColour(Vehicle,Customize["dashColour"])
		end

		if Customize["interColour"] ~= nil then
			SetVehicleDashboardColour(Vehicle,Customize["interColour"])
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SpawnPosition(Select)
	local Slot = "0"
	local Checks = 0
	local Selected = {}
	local Position = nil

	repeat
		Checks = Checks + 1

		Slot = tostring(Checks)
		if Garages[Select][Slot] ~= nil then
			local _,Groundz = GetGroundZAndNormalFor_3dCoord(Garages[Select][Slot][1],Garages[Select][Slot][2],Garages[Select][Slot][3])
			Selected = { Garages[Select][Slot][1],Garages[Select][Slot][2],Groundz,Garages[Select][Slot][4] }
			Position = GetClosestVehicle(Selected[1],Selected[2],Selected[3],2.501,0,71)
		end
	until not DoesEntityExist(Position) or not Garages[Select][Slot]

	if not Garages[Select][tostring(Checks)] then
		TriggerEvent("Notify","amarelo","Vagas estão ocupadas.",5000)
		return false
	end

	return Selected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreateVehicle(Model,Network,Engine,Health,Customize,Windows,Tyres)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if Customize ~= nil then
				local Mods = json.decode(Customize)
				VehicleMods(Vehicle,Mods)
			end

			SetVehicleEngineHealth(Vehicle,Engine + 0.0)
			SetEntityHealth(Vehicle,Health)

			if Windows then
				local Windows = json.decode(Windows)
				if Windows ~= nil then
					for k,v in pairs(Windows) do
						if not v then
							RemoveVehicleWindow(Vehicle,parseInt(k))
						end
					end
				end
			end

			if Tyres then
				local Tyres = json.decode(Tyres)
				if Tyres ~= nil then
					for k,Burst in pairs(Tyres) do
						if Burst then
							SetVehicleTyreBurst(Vehicle,parseInt(k),true,1000.0)
						end
					end
				end
			end

			if Model == "maverick2" then
				if LocalPlayer["state"]["Police"] then
					SetVehicleLivery(Vehicle,0)
				elseif LocalPlayer["state"]["Paramedic"] then
					SetVehicleLivery(Vehicle,1)
				end
			end

			if not DecorExistOn(Vehicle,"PlayerVehicle") then
				DecorSetInt(Vehicle,"PlayerVehicle",-1)
			end

			SetModelAsNoLongerNeeded(Model)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Delete")
AddEventHandler("garages:Delete",function(Vehicle)
	if not Vehicle or Vehicle == "" then
		Vehicle = vRP.ClosestVehicle(15)
	end

	if IsEntityAVehicle(Vehicle) then
		local Tyres = {}
		local Doors = {}
		local Windows = {}

		for i = 0,5 do
			Doors[i] = IsVehicleDoorDamaged(Vehicle,i)
		end

		for i = 0,5 do
			Windows[i] = IsVehicleWindowIntact(Vehicle,i)
		end

		for i = 0,7 do
			local Status = false

			if GetTyreHealth(Vehicle,i) ~= 1000.0 then
				Status = true
			end

			Tyres[i] = Status
		end

		if DecorExistOn(Vehicle,"PlayerVehicle") then
			DecorRemove(Vehicle,"PlayerVehicle")
		end

		vSERVER.Delete(VehToNet(Vehicle),GetEntityHealth(Vehicle),GetVehicleEngineHealth(Vehicle),GetVehicleBodyHealth(Vehicle),GetVehicleFuelLevel(Vehicle),Doors,Windows,Tyres,GetVehicleNumberPlateText(Vehicle))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SearchBlip(Coords)
	if DoesBlipExist(Searched) then
		RemoveBlip(Searched)
		Searched = nil
	end

	Searched = AddBlipForCoord(Coords["x"],Coords["y"],Coords["z"])
	SetBlipSprite(Searched,225)
	SetBlipColour(Searched,2)
	SetBlipScale(Searched,0.6)
	SetBlipAsShortRange(Searched,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Veículo")
	EndTextCommandSetBlipName(Searched)

	SetTimeout(30000,function()
		RemoveBlip(Searched)
		Searched = nil
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StartHotwired()
	Hotwired = true

	if LoadAnim(Dict) then
		TaskPlayAnim(PlayerPedId(),Dict,Anim,8.0,8.0,-1,49,5.0,0,0,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StopHotwired(Vehicle)
	Hotwired = false

	if LoadAnim(Dict) then
		StopAnimTask(PlayerPedId(),Dict,Anim,8.0)
	end

	if Vehicle then
		SetEntityAsMissionEntity(Vehicle,true,false)
		SetVehicleHasBeenOwnedByPlayer(Vehicle,true)
		SetVehicleNeedsToBeHotwired(Vehicle,false)

		if not DecorExistOn(Vehicle,"PlayerVehicle") then
			DecorSetInt(Vehicle,"PlayerVehicle",-1)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdateHotwired(Status)
	Hotwired = Status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOPHOTWIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local cachedPlateValid = false
local cachedPlateText = ""

CreateThread(function()
	while true do
		if LocalPlayer["state"]["Route"] == 0 then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				local Plate = GetVehicleNumberPlateText(Vehicle)
				if Plate ~= cachedPlateText then
					cachedPlateText = Plate
					cachedPlateValid = vSERVER.CheckPlate(Plate) ~= nil
				else
					cachedPlateValid = vSERVER.CheckPlate(Plate) ~= nil
				end
			else
				cachedPlateValid = false
				cachedPlateText = ""
			end
		end
		Wait(2000)
	end
end)

CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] == 0 then
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if GetPedInVehicleSeat(Vehicle,-1) == Ped and not cachedPlateValid then
					SetVehicleEngineOn(Vehicle,false,true,true)
					DisablePlayerFiring(Ped,true)
					TimeDistance = 1
				end

				if Hotwired and Vehicle then
					DisableControlAction(1,75,true)
					DisableControlAction(1,20,true)
					TimeDistance = 1
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Impound")
AddEventHandler("garages:Impound",function()
	local Impound = vSERVER.Impound()
	if parseInt(#Impound) > 0 then
		for k,v in pairs(Impound) do
			exports["dynamic"]:AddButton(v["name"],"Clique para iniciar a liberação.","garages:Impound",v["Model"],false,true)
		end

		exports["dynamic"]:openMenu()
	else
		TriggerEvent("Notify","amarelo","Não possui veículos apreendidos.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Opened
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Opened(garageName)
	Opened = garageName
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "openNUI" })
	-- TriggerEvent("hud:Active",false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data,cb)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "closeNUI" })
	-- TriggerEvent("hud:Active",true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("myVehicles",function(data,cb)
	local vehicles = vSERVER.Vehicles(Opened)
	if vehicles then
		cb({ vehicles = vehicles })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawnVehicles",function(data)
	SetNuiFocus(false,false)	
	SendNUIMessage({ action = "closeNUI" })
	TriggerServerEvent("garages:Spawn",data["name"],Opened)
	-- TriggerEvent("hud:Active",true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("taxVehicles",function(data)
	SetNuiFocus(false,false)	
	SendNUIMessage({ action = "closeNUI" })
	TriggerServerEvent("garages:Tax",data["name"])
	-- TriggerEvent("hud:Active",true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sellVehicles",function(data)
	SetNuiFocus(false,false)	
	SendNUIMessage({ action = "closeNUI" })
	TriggerServerEvent("garages:Sell",data["name"])
	-- TriggerEvent("hud:Active",true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("transferVehicles",function(data)
	SetNuiFocus(false,false)	
	SendNUIMessage({ action = "closeNUI" })
	TriggerServerEvent("garages:Transfer",data["name"])
	-- TriggerEvent("hud:Active",true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("deleteVehicles",function(data)
	if GetGameTimer() > DeleteTime + 5000 then
		DeleteTime = GetGameTimer()
		TriggerEvent("garages:Delete")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for Number,v in pairs(Garages) do
					local Distance = #(Coords - vec3(v["x"],v["y"],v["z"]))
					if Distance <= 15 then
						TimeDistance = 1
						DrawMarker(36,v["x"],v["y"],v["z"]-0.3,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,123,44,191,150,0,0,0,1)

						if IsControlJustPressed(1,38) and Distance <= 1.25 then
							local Vehicles = vSERVER.Vehicles(Number)
							if Vehicles then
								Creative.Opened(Number)
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:Propertys")
AddEventHandler("garages:Propertys",function(Table)
	for Name,v in pairs(Table) do
		Garages[Name] = {
			["x"] = v["x"],
			["y"] = v["y"],
			["z"] = v["z"],
			["1"] = v["1"]
		}
	end
	
	UpdateHoverfy()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdateHoverfy()
	local Tables = {}
	for _,v in pairs(Garages) do
		Tables[#Tables + 1] = { v["x"],v["y"],v["z"],2.0,"E","Garagem","Acessar garagem" }
	end

	TriggerEvent("hoverfy:Insert",Tables)
end

CreateThread(function()
	Wait(1000)
	UpdateHoverfy()
end)
