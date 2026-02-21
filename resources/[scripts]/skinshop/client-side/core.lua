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
Tunnel.bindInterface("skinshop",Creative)
vSERVER = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Lasted = {}
local Init = "hat"
local Camera = nil
local Default = nil
local Skinshop = {}
local Animation = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATASET
-----------------------------------------------------------------------------------------------------------------------------------------
local Dataset = {
	["pants"] = { item = 0, texture = 0 },
	["arms"] = { item = 0, texture = 0 },
	["tshirt"] = { item = 1, texture = 0 },
	["torso"] = { item = 0, texture = 0 },
	["vest"] = { item = 0, texture = 0 },
	["shoes"] = { item = 0, texture = 0 },
	["mask"] = { item = 0, texture = 0 },
	["backpack"] = { item = 0, texture = 0 },
	["hat"] = { item = -1, texture = 0 },
	["glass"] = { item = 0, texture = 0 },
	["ear"] = { item = -1, texture = 0 },
	["watch"] = { item = -1, texture = 0 },
	["bracelet"] = { item = -1, texture = 0 },
	["accessory"] = { item = 0, texture = 0 },
	["decals"] = { item = 0, texture = 0 }
}

RegisterNetEvent("skinshop:Apply")
AddEventHandler("skinshop:Apply", function(Table, Save)
	for Index, v in pairs(Dataset) do
		if not Table[Index] then
			Table[Index] = v
		end
	end

	Skinshop = Table
	exports["skinshop"]:Apply()

	if not Save then
		vSERVER.Update(Skinshop)
	end
end)

RegisterNetEvent("updateRoupas")
AddEventHandler("updateRoupas", function(Table)
	for Index, v in pairs(Dataset) do
		if not Table[Index] then
			Table[Index] = v
		end
	end

	TriggerEvent("skinshop:Apply", Table, false)
end)

RegisterNetEvent("setmascara")
AddEventHandler("setmascara", function(modelo, cor)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if modelo == nil then
			vRP.playAnim(true, {"mp_masks@standard_car@ds@", "put_on_mask"}, false)
			Wait(1100)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped, 1, 0, 0, 2)
			return
		end
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			vRP.playAnim(true, {"misscommon@van_put_on_masks", "put_on_mask_ps"}, false)
			Wait(1500)
			ClearPedTasks(ped)
			SetPedComponentVariation(ped, 1, parseInt(modelo), parseInt(cor), 2)
			
			Skinshop.mask = { item = parseInt(modelo), texture = parseInt(cor) }
			vSERVER.Update2(Skinshop)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local Locations = {
	vec3(71.29,-1398.68,29.37),
	vec3(-708.56,-160.5,37.41),
	vec3(-158.76,-296.94,39.73),
	vec3(-829.08,-1073.27,11.32),
	vec3(-1192.23,-771.74,17.32),
	vec3(-1456.98,-241.17,49.81),
	vec3(11.87,6513.59,31.88),
	vec3(1696.92,4829.24,42.06),
	vec3(122.93,-221.48,54.56),
	vec3(617.77,2761.81,42.09),
	vec3(1190.79,2714.29,38.22),
	vec3(-3173.28,1046.04,20.86),
	vec3(-1108.61,2709.59,19.11),
	vec3(429.67,-800.14,29.49),
	vec3(604.58,-6.35,87.92), -- Departamento Policial
	vec3(603.29,-9.65,87.89), -- Departamento Policial
	vec3(1140.2,-1539.59,35.03), -- Hospital Los Santos
	vec3(1244.23,-354.01,69.08), -- Hornys
	vec3(-586.48,-1049.9,22.34), -- UwuCoffee
	vec3(-2.5,-1821.67,29.54), -- Ballas
	vec3(-162.73,-1613.11,33.65), -- Families
	vec3(326.22,-1999.96,24.2), -- Vagos
	vec3(495.61,-1527.89,29.28), -- Aztecas
	vec3(1254.22,-1571.49,58.74), -- Marabunta
	vec3(-816.01,-717.83,28.05), -- Records
	vec3(908.1,-2110.94,31.22), -- Bobcats
	vec3(1396.07,1156.67,114.33), -- Madrazo
	vec3(966.62,18.3,71.46), -- Cassino
	vec3(1421.39,6329.15,23.86) -- Ranch
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Table = {}

	for _,v in pairs(Locations) do
		table.insert(Table,{ v[1],v[2],v[3],2,"E","Loja de Roupas","Pressione para abrir" })
	end

	TriggerEvent("hoverfy:Insert",Table)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        local Ped = PlayerPedId()
        if not IsPedInAnyVehicle(Ped) then
            local Coords = GetEntityCoords(Ped)

            for Number = 1, #Locations do
                if #(Coords - Locations[Number]) <= 2.0 then
                    TimeDistance = 1

                    if IsControlJustPressed(0,38) and vSERVER.Check() and not exports["hud"]:Wanted() and not exports["hud"]:Reposed() then
						OpenSkinshop()
                    end
                end
            end
        end

        Wait(TimeDistance)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:Open")
AddEventHandler("skinshop:Open",function()
	TriggerEvent("dynamic:closeSystem")

	if not exports["hud"]:Wanted() and not exports["hud"]:Reposed() then
		vSERVER.Check()
		OpenSkinshop()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXVALUES
-----------------------------------------------------------------------------------------------------------------------------------------
function MaxValues()
	local MaxValues = {
		["pants"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 4 },
		["arms"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 3 },
		["tshirt"] = { min = 1, item = 0, texture = 0, mode = "variation", id = 8 },
		["torso"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 11 },
		["vest"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 9 },
		["shoes"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 6 },
		["mask"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 1 },
		["backpack"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 5 },
		["hat"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 0 },
		["glass"] = { min = 0, item = 0, texture = 0, mode = "prop", id = 1 },
		["ear"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 2 },
		["watch"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 6 },
		["bracelet"] = { min = -1, item = 0, texture = 0, mode = "prop", id = 7 },
		["accessory"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 7 },
		["decals"] = { min = 0, item = 0, texture = 0, mode = "variation", id = 10 }
	}

	local Ped = PlayerPedId()
	for Index,v in pairs(MaxValues) do
		if v["mode"] == "variation" then
			v["item"] = GetNumberOfPedDrawableVariations(Ped,v["id"]) - 1
			v["texture"] = GetNumberOfPedTextureVariations(Ped,v["id"],GetPedDrawableVariation(Ped,v["id"])) - 1
		elseif v["mode"] == "prop" then
			v["item"] = GetNumberOfPedPropDrawableVariations(Ped,v["id"]) - 1
			v["texture"] = GetNumberOfPedPropTextureVariations(Ped,v["id"],GetPedPropIndex(Ped,v["id"])) - 1
		end

		if v["texture"] < 0 then
			v["texture"] = 0
		end
	end

	return MaxValues
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSKINSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenSkinshop()
	Lasted = Skinshop
	vRP.playAnim(true,{"mp_sleep","bind_pose_180"},true)
	SendNUIMessage({ name = "open", payload = { Current = Skinshop, Max = MaxValues() } })

	SetNuiFocus(true,true)
	CameraActive()
	TriggerEvent("hud:Active",false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAMERAACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function CameraActive()
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	local Ped = PlayerPedId()
	local Heading = GetEntityHeading(Ped)
	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.25,1.0,0.0)

	if Init == "hat" or Init == "mask" or Init == "glass" or Init == "ear" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.45)
	elseif Init == "shirt" or Init == "tshirt" or Init == "torso" or Init == "vest" or Init == "arms" or Init == "decals" or Init == "backpack" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.25)
	elseif Init == "pants" or Init == "shoes" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] - 0.45)
	elseif Init == "clock" or Init == "watch" or Init == "bracelet" or Init == "accessory" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.05)
	elseif Init == "all" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"])
	else
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"])
	end

	RenderScriptCams(true,true,100,true,true)
	SetCamRot(Camera,0.0,0.0,Heading + 180)
	SetEntityHeading(Ped,Heading)
	SetCamActive(Camera,true)
	Default = Coords["z"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Apply",function(Data,Ped)
	if not Ped then
		Ped = PlayerPedId()
	end

	if Data then
		Skinshop = Data
	end

	for Index,v in pairs(Dataset) do
		if not Skinshop[Index] then
			Skinshop[Index] = {
				["item"] = v["item"],
				["texture"] = v["texture"]
			}
		end
	end

	SetPedComponentVariation(Ped,4,Skinshop["pants"]["item"],Skinshop["pants"]["texture"],GetPedPaletteVariation(Ped,4))
	SetPedComponentVariation(Ped,3,Skinshop["arms"]["item"],Skinshop["arms"]["texture"],GetPedPaletteVariation(Ped,3))
	SetPedComponentVariation(Ped,5,Skinshop["backpack"]["item"],Skinshop["backpack"]["texture"],GetPedPaletteVariation(Ped,5))
	SetPedComponentVariation(Ped,8,Skinshop["tshirt"]["item"],Skinshop["tshirt"]["texture"],GetPedPaletteVariation(Ped,8))
	SetPedComponentVariation(Ped,9,Skinshop["vest"]["item"],Skinshop["vest"]["texture"],GetPedPaletteVariation(Ped,9))
	SetPedComponentVariation(Ped,11,Skinshop["torso"]["item"],Skinshop["torso"]["texture"],GetPedPaletteVariation(Ped,11))
	SetPedComponentVariation(Ped,6,Skinshop["shoes"]["item"],Skinshop["shoes"]["texture"],GetPedPaletteVariation(Ped,6))
	SetPedComponentVariation(Ped,1,Skinshop["mask"]["item"],Skinshop["mask"]["texture"],GetPedPaletteVariation(Ped,1))
	SetPedComponentVariation(Ped,10,Skinshop["decals"]["item"],Skinshop["decals"]["texture"],GetPedPaletteVariation(Ped,10))
	SetPedComponentVariation(Ped,7,Skinshop["accessory"]["item"],Skinshop["accessory"]["texture"],GetPedPaletteVariation(Ped,7))

	if Skinshop["hat"]["item"] ~= -1 and Skinshop["hat"]["item"] ~= 0 then
		SetPedPropIndex(Ped,0,Skinshop["hat"]["item"],Skinshop["hat"]["texture"],false)
	else
		ClearPedProp(Ped,0)
	end

	if Skinshop["glass"]["item"] ~= -1 and Skinshop["glass"]["item"] ~= 0 then
		SetPedPropIndex(Ped,1,Skinshop["glass"]["item"],Skinshop["glass"]["texture"],false)
	else
		ClearPedProp(Ped,1)
	end

	if Skinshop["ear"]["item"] ~= -1 and Skinshop["ear"]["item"] ~= 0 then
		SetPedPropIndex(Ped,2,Skinshop["ear"]["item"],Skinshop["ear"]["texture"],false)
	else
		ClearPedProp(Ped,2)
	end

	if Skinshop["watch"]["item"] ~= -1 and Skinshop["watch"]["item"] ~= 0 then
		SetPedPropIndex(Ped,6,Skinshop["watch"]["item"],Skinshop["watch"]["texture"],false)
	else
		ClearPedProp(Ped,6)
	end

	if Skinshop["bracelet"]["item"] ~= -1 and Skinshop["bracelet"]["item"] ~= 0 then
		SetPedPropIndex(Ped,7,Skinshop["bracelet"]["item"],Skinshop["bracelet"]["texture"],false)
	else
		ClearPedProp(Ped,7)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("update",function(Data,Callback)
	Skinshop = Data
	exports["skinshop"]:Apply()

	Callback(MaxValues())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Setup",function(Data,Callback)
	Init = Data["value"]
	local Ped = PlayerPedId()
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.25,1.0,0.0)

	if Init == "hat" or Init == "mask" or Init == "glass" or Init == "ear" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.45)
	elseif Init == "shirt" or Init == "tshirt" or Init == "torso" or Init == "vest" or Init == "arms" or Init == "decals" or Init == "backpack" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.25)
	elseif Init == "pants" or Init == "shoes" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] - 0.45)
	elseif Init == "clock" or Init == "watch" or Init == "bracelet" or Init == "accessory" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.05)
	elseif Init == "all" then
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"])
	else
		SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"])
	end

	SetCamRot(Camera,0.0,0.0,GetEntityHeading(Ped) + 180)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Save",function(Data,Callback)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	TriggerEvent("hud:Active",true)
	SetNuiFocus(false,false)
	vSERVER.Update(Skinshop)
	vRP.Destroy()
	vRP.stopAnim(true)
	vRP.stopAnim(false)
	ClearPedTasks(PlayerPedId())

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Reset",function(Data,Callback)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	exports["skinshop"]:Apply(Lasted)
	TriggerEvent("hud:Active",true)
	SetNuiFocus(false,false)
	Skinshop = Lasted
	vRP.Destroy()
	vRP.stopAnim(true)
	vRP.stopAnim(false)
	ClearPedTasks(PlayerPedId())
	Lasted = {}

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	local Ped = PlayerPedId()

	if Data == "Left" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) - 5)
	elseif Data == "Right" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) + 5)
	elseif Data == "Top" then
		local Coords = GetCamCoord(Camera)
		if Coords["z"] + 0.05 <= Default + 0.50 then
			SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.05)
		end
	elseif Data == "Bottom" then
		local Coords = GetCamCoord(Camera)
		if Coords["z"] - 0.05 >= Default - 0.50 then
			SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] - 0.05)
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMASK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setMask")
AddEventHandler("skinshop:setMask",function()
	local Ped = PlayerPedId()
	if GetPedDrawableVariation(Ped,1) == Skinshop["mask"]["item"] then
		SetPedComponentVariation(Ped,1,0,0,GetPedPaletteVariation(Ped,1))
	else
		SetPedComponentVariation(Ped,1,Skinshop["mask"]["item"],Skinshop["mask"]["texture"],GetPedPaletteVariation(Ped,1))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setHat")
AddEventHandler("skinshop:setHat",function()
	local Ped = PlayerPedId()
	if GetPedPropIndex(Ped,0) == Skinshop["hat"]["item"] then
		ClearPedProp(Ped,0)
	else
		SetPedPropIndex(Ped,0,Skinshop["hat"]["item"],Skinshop["hat"]["texture"],false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETGLASSES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setGlasses")
AddEventHandler("skinshop:setGlasses",function()
	local Ped = PlayerPedId()
	if GetPedPropIndex(Ped,1) == Skinshop["glass"]["item"] then
		ClearPedProp(Ped,1)
	else
		SetPedPropIndex(Ped,1,Skinshop["glass"]["item"],Skinshop["glass"]["texture"],false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPANTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setPants")
AddEventHandler("skinshop:setPants",function()
	local Ped = PlayerPedId()
	if GetPedDrawableVariation(Ped,4) == Skinshop["pants"]["item"] then
		if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(Ped,4,17,0,GetPedPaletteVariation(Ped,4))
		else
			SetPedComponentVariation(Ped,4,61,0,GetPedPaletteVariation(Ped,4))
		end
	else
		SetPedComponentVariation(Ped,4,Skinshop["pants"]["item"],Skinshop["pants"]["texture"],2)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSHIRT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setShirt")
AddEventHandler("skinshop:setShirt",function()
	local Ped = PlayerPedId()
	if GetPedDrawableVariation(Ped,8) == Skinshop["tshirt"]["item"] then
		if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(Ped,8,7,0,GetPedPaletteVariation(Ped,8))
		else
			SetPedComponentVariation(Ped,8,15,0,GetPedPaletteVariation(Ped,8))
		end
	else
		SetPedComponentVariation(Ped,8,Skinshop["tshirt"]["item"],Skinshop["tshirt"]["texture"],2)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETTORSO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setTorso")
AddEventHandler("skinshop:setTorso",function()
	local Ped = PlayerPedId()
	if GetPedDrawableVariation(Ped,11) == Skinshop["torso"]["item"] then
		if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(Ped,11,18,0,2)
		else
			SetPedComponentVariation(Ped,11,15,0,2)
		end
	else
		SetPedComponentVariation(Ped,11,Skinshop["torso"]["item"],Skinshop["torso"]["texture"],2)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETVEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setVest")
AddEventHandler("skinshop:setVest",function()
	local Ped = PlayerPedId()
	if GetPedDrawableVariation(Ped,9) == Skinshop["vest"]["item"] then
		SetPedComponentVariation(Ped,9,-1,0,GetPedPaletteVariation(Ped,9))
	else
		SetPedComponentVariation(Ped,9,Skinshop["vest"]["item"],Skinshop["vest"]["texture"],GetPedPaletteVariation(Ped,9))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setShoes")
AddEventHandler("skinshop:setShoes",function()
	local Ped = PlayerPedId()
	if GetPedDrawableVariation(Ped,6) == Skinshop["shoes"]["item"] then
		if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(Ped,6,35,0,GetPedPaletteVariation(Ped,6))
		else
			SetPedComponentVariation(Ped,6,34,0,GetPedPaletteVariation(Ped,6))
		end
	else
		SetPedComponentVariation(Ped,6,Skinshop["shoes"]["item"],Skinshop["shoes"]["texture"],2)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETARMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setArms")
AddEventHandler("skinshop:setArms",function()
	local Ped = PlayerPedId()
	if GetPedDrawableVariation(Ped,3) == Skinshop["arms"]["item"] then
		SetPedComponentVariation(Ped,3,15,0,GetPedPaletteVariation(Ped,3))
	else
		SetPedComponentVariation(Ped,3,Skinshop["arms"]["item"],Skinshop["arms"]["texture"],GetPedPaletteVariation(Ped,3))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkShoes()
	local Number = 34
	local Ped = PlayerPedId()
	if GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
		Number = 35
	end

	if Skinshop["shoes"]["item"] ~= Number then
		Skinshop["shoes"]["item"] = Number
		Skinshop["shoes"]["texture"] = 0
		SetPedComponentVariation(Ped,6,Skinshop["shoes"]["item"],Skinshop["shoes"]["texture"],GetPedPaletteVariation(Ped,6))

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Customization()
	return Skinshop
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDSUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("HandsUp",function(Data,Callback)
	local Ped = PlayerPedId()
	if IsEntityPlayingAnim(Ped,"random@mugging3","handsup_standing_base",3) then
		StopAnimTask(Ped,"random@mugging3","handsup_standing_base",8.0)
		vRP.AnimActive()
	else
		vRP.playAnim(true,{"random@mugging3","handsup_standing_base"},true)
	end

	Callback("Ok")
end)
