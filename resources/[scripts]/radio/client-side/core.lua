-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Frequency = 0
local Object = nil
local Timer = GetGameTimer()
local CurrentAnim = "anim_1"
local AnimPlaying = false
local UseProp = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMATION FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetAnimConfig(animId)
	for _, v in ipairs(Config.Animations) do
		if v.id == animId then
			return v
		end
	end
	return nil
end

local function StopRadioAnim()
	local Ped = PlayerPedId()

	if DoesEntityExist(Object) then
		DeleteEntity(Object)
		Object = nil
	end

	ClearPedTasks(Ped)

	AnimPlaying = false
end

local function PlayRadioAnim(animId)
	local Ped = PlayerPedId()

	-- Remove prop se existir
	if DoesEntityExist(Object) then
		DeleteEntity(Object)
		Object = nil
	end

	local animData = GetAnimConfig(animId)
	if not animData or not animData.dict or IsPedInAnyVehicle(Ped) then
		return
	end

	RequestAnimDict(animData.dict)
	while not HasAnimDictLoaded(animData.dict) do
		Citizen.Wait(100)
	end

	if animData.prop and UseProp then
		local PropModel = GetHashKey(animData.prop.model)
		RequestModel(PropModel)
		while not HasModelLoaded(PropModel) do
			Citizen.Wait(100)
		end

		TaskPlayAnim(Ped, animData.dict, animData.anim, 8.0, -8.0, -1, 49, 0, false, false, false)

		local BoneIndex = GetPedBoneIndex(Ped, animData.prop.bone)
		Object = CreateObject(PropModel, 1.0, 1.0, 1.0, true, true, false)
		AttachEntityToEntity(Object, Ped, BoneIndex,
			animData.prop.offset.x, animData.prop.offset.y, animData.prop.offset.z,
			animData.prop.rotation.x, animData.prop.rotation.y, animData.prop.rotation.z,
			true, true, false, true, 1, true)
	else
		TaskPlayAnim(Ped, animData.dict, animData.anim, 8.0, -8.0, -1, 49, 0, false, false, false)
	end

	AnimPlaying = true
end

local function GetAnimListForNUI()
	local list = {}
	for _, v in ipairs(Config.Animations) do
		table.insert(list, { id = v.id, label = v.label, icon = v.icon, image = v.image })
	end
	return list
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("getSelectedAnim", function()
	return CurrentAnim
end)

exports("getSelectedAnimData", function()
	return GetAnimConfig(CurrentAnim)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO TALK ANIM EVENTS (chamados pelo pma-voice)
-----------------------------------------------------------------------------------------------------------------------------------------
local TalkObject = nil

AddEventHandler("radio:playTalkAnim", function()
	local Ped = PlayerPedId()
	local animData = GetAnimConfig(CurrentAnim)

	if not animData or not animData.dict or IsPedInAnyVehicle(Ped) then
		return
	end

	RequestAnimDict(animData.dict)
	while not HasAnimDictLoaded(animData.dict) do
		Citizen.Wait(100)
	end

	local p = animData.animParams or {}
	local blendIn = p.blendIn or 8.0
	local blendOut = p.blendOut or 2.0
	local duration = p.duration or -1
	local flag = p.flag or 50
	local playbackRate = p.playbackRate or 2.0

	TaskPlayAnim(Ped, animData.dict, animData.anim, blendIn, blendOut, duration, flag, playbackRate, false, false, false)

	if animData.prop and UseProp then
		local PropModel = GetHashKey(animData.prop.model)
		RequestModel(PropModel)
		while not HasModelLoaded(PropModel) do
			Citizen.Wait(100)
		end

		if DoesEntityExist(TalkObject) then
			DeleteEntity(TalkObject)
			TalkObject = nil
		end

		TalkObject = CreateObject(PropModel, 1.0, 1.0, 1.0, true, true, false)
		AttachEntityToEntity(TalkObject, Ped, GetPedBoneIndex(Ped, animData.prop.bone),
			animData.prop.offset.x, animData.prop.offset.y, animData.prop.offset.z,
			animData.prop.rotation.x, animData.prop.rotation.y, animData.prop.rotation.z,
			true, true, false, true, 1, true)
	end
end)

AddEventHandler("radio:stopTalkAnim", function()
	local Ped = PlayerPedId()

	ClearPedTasks(Ped)

	if DoesEntityExist(TalkObject) then
		DeleteEntity(TalkObject)
		TalkObject = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:RADIONUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:RadioNui")
AddEventHandler("radio:RadioNui",function()
	local Permission = vSERVER.Permission()
	SetNuiFocus(true,true)
	SetCursorLocation(0.9,0.9)
	SendNUIMessage({ Action = "Radio", Show = true, Permission = Permission, Animations = GetAnimListForNUI(), CurrentAnim = CurrentAnim, UseProp = UseProp })

	if CurrentAnim ~= "none" and not IsPedInAnyVehicle(PlayerPedId()) then
		PlayRadioAnim(CurrentAnim)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioClose",function(Data,Callback)
	SetCursorLocation(0.5,0.5)
	SetNuiFocus(false,false)

	StopRadioAnim()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioActive",function(Data,Callback)
	if Frequency ~= Data["Frequency"] then
		if vSERVER.Frequency(Data["Frequency"]) then
			if Frequency ~= 0 then
				exports["pma-voice"]:removePlayerFromRadio()
			end

			exports["pma-voice"]:setRadioChannel(Data["Frequency"])
			TriggerEvent("hud:Radio",Data["Frequency"])
			TriggerEvent("Notify","verde","Você entrou na rádio <b>"..Data["Frequency"].."</b>.",5000)
			PlaySoundFrontend(-1,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET",true)
			Frequency = Data["Frequency"]
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOVOLUME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioVolume",function(Data,Callback)
	if Data["Volume"] then
		exports["pma-voice"]:setRadioVolume(Data["Volume"])
		TriggerEvent("Notify","verde","Volume ajustado para <b>"..Data["Volume"].."%</b>.",5000)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOANIMATION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioAnimation",function(Data,Callback)
	if Data["Animation"] then
		CurrentAnim = Data["Animation"]
		PlayRadioAnim(CurrentAnim)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOPROP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioProp",function(Data,Callback)
	if Data["UseProp"] ~= nil then
		UseProp = Data["UseProp"]

		-- Remove prop existente se desativado
		if not UseProp then
			if DoesEntityExist(Object) then
				DeleteEntity(Object)
				Object = nil
			end
			if DoesEntityExist(TalkObject) then
				DeleteEntity(TalkObject)
				TalkObject = nil
			end
		else
			-- Re-cria o prop se ativado e animação está rodando
			if AnimPlaying then
				PlayRadioAnim(CurrentAnim)
			end
		end
	
		TriggerEvent("Notify","verde","Prop do rádio <b>"..(UseProp and "ativado" or "desativado").."</b>.",3000)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOINATIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioInative",function(Data,Callback)
	TriggerEvent("radio:RadioClean")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:RADIOCLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:RadioClean")
AddEventHandler("radio:RadioClean",function()
	if Frequency ~= 0 then
		exports["pma-voice"]:removePlayerFromRadio()
		TriggerEvent("hud:Radio","Offline")
		StopRadioAnim()
		Frequency = 0
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRADIOEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if GetGameTimer() >= Timer and Frequency ~= 0 and LocalPlayer["state"]["Route"] < 900000 then
			Timer = GetGameTimer() + 60000

			local Ped = PlayerPedId()
			if vSERVER.CheckRadio() or IsPedSwimming(Ped) then
				TriggerEvent("radio:RadioClean")
			end
		end

		Wait(10000)
	end
end)