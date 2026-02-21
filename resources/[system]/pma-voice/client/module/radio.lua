local radioChannel = 0
local radioNames = {}

function syncRadioData(radioTable,localPlyRadioName)
	radioData = radioTable

	for tgt,enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt,enabled,"radio")
		end
	end

	radioNames[playerServerId] = localPlyRadioName
end

RegisterNetEvent("pma-voice:syncRadioData",syncRadioData)

function setTalkingOnRadio(plySource,enabled)
	toggleVoice(plySource,enabled,"radio")
	radioData[plySource] = enabled
end

RegisterNetEvent("pma-voice:setTalkingOnRadio",setTalkingOnRadio)

function addPlayerToRadio(plySource,plyRadioName)
	radioData[plySource] = false
	radioNames[plySource] = plyRadioName
	if radioPressed then
		playerTargets(radioData,MumbleIsPlayerTalking(PlayerId()) and callData or {})
	end
end

RegisterNetEvent("pma-voice:addPlayerToRadio",addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		for tgt,_ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt,false,"radio")
			end
		end

		radioNames = {}
		radioData = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		toggleVoice(plySource,false)

		if radioPressed then
			playerTargets(radioData,MumbleIsPlayerTalking(PlayerId()) and callData or {})
		end

		radioData[plySource] = nil
		radioNames[plySource] = nil
	end
end

RegisterNetEvent("pma-voice:removePlayerFromRadio",removePlayerFromRadio)

function setRadioChannel(channel)
	radioEnabled = true
	type_check({ channel,"number","string" })
	TriggerServerEvent("pma-voice:setPlayerRadio",channel)
	radioChannel = channel

	sendUIMessage({ radioChannel = channel, radioEnabled = radioEnabled })
end

exports("setRadioChannel",setRadioChannel)
exports("SetRadioChannel",setRadioChannel)

exports("removePlayerFromRadio",function()
	radioEnabled = false
	setRadioChannel(0)
end)

exports("addPlayerToRadio",function(_radio)
	local radio = tonumber(_radio) or _radio
	if radio then
		setRadioChannel(radio)
	end
end)

local radioPressed = false
local radioObject = nil
local radioEnabled = true

RegisterCommand("+radiotalk", function()
    local Ped = PlayerPedId()
    if IsPedSwimming(Ped) or LocalPlayer["state"]["Handcuff"] then
        return
    end

    if not radioPressed and radioEnabled then
        if radioChannel ~= 0 then
            playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
            TriggerServerEvent("pma-voice:setTalkingOnRadio", true)
            radioPressed = true
            playMicClicks(true)

            local animData = exports["radio"]:getSelectedAnimData()

            if animData and animData.dict then
                local ap = animData.animParams or {}
                local blendIn = ap.blendIn or 8.0
                local blendOut = ap.blendOut or 8.0
                local duration = ap.duration or -1
                local flag = ap.flag or 49
                local rate = ap.playbackRate or 1

                if LoadAnim(animData.dict) then
                    TaskPlayAnim(Ped, animData.dict, animData.anim, blendIn, blendOut, duration, flag, rate, false, false, false)
                end

                if animData.prop then
                    local propHash = GetHashKey(animData.prop.model)
                    RequestModel(propHash)
                    while not HasModelLoaded(propHash) do
                        Wait(1)
                    end
                    radioObject = CreateObject(propHash, 1.0, 1.0, 1.0, true, true, false)
                    AttachEntityToEntity(radioObject, Ped, GetPedBoneIndex(Ped, animData.prop.bone),
                        animData.prop.offset.x, animData.prop.offset.y, animData.prop.offset.z,
                        animData.prop.rotation.x, animData.prop.rotation.y, animData.prop.rotation.z,
                        true, false, false, false, 2, true)
                end
            else
                local coords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.0, -5.0)
                radioObject = CreateObject(GetHashKey('prop_cs_hand_radio'), coords.x, coords.y, coords.z, false, false, false)
                SetEntityCollision(radioObject, false, false)
                AttachEntityToEntity(radioObject, Ped, GetPedBoneIndex(Ped, 60309), 0.08, 0.05, 0.003, -50.0, 160.0, 0.0, true, true, false, true, 1, true)
                if LoadAnim("radioanimation") then
                    TaskPlayAnim(Ped, "radioanimation", "radio_clip", 8.0, 8.0, -1, 49, 1, 0, 0, 0)
                end
            end

            CreateThread(function()
                TriggerEvent("pma-voice:radioActive", true)

                while radioPressed do
                    Wait(0)
                    SetControlNormal(0, 249, 1.0)
                    SetControlNormal(1, 249, 1.0)
                    SetControlNormal(2, 249, 1.0)
                    DisablePlayerFiring(Ped, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 257, true)
                end
            end)
        end
    end
end, false)

RegisterCommand("-radiotalk", function()
    local Ped = PlayerPedId()
    if IsPedSwimming(Ped) or LocalPlayer["state"]["Handcuff"] then
        return
    end

    if (radioChannel ~= 0 or radioEnabled) and radioPressed then
        radioPressed = false
        MumbleClearVoiceTargetPlayers(voiceTarget)
        playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
        TriggerEvent("pma-voice:radioActive", false)
        playMicClicks(false)

        local animData = exports["radio"]:getSelectedAnimData()

        if animData and animData.dict then
            StopAnimTask(Ped, animData.dict, animData.anim, 8.0)
        else
            StopAnimTask(Ped, "radioanimation", "radio_clip", 8.0)
        end

        if DoesEntityExist(radioObject) then
            DeleteObject(radioObject)
            radioObject = nil
        else
            local Coords = GetEntityCoords(Ped)
            local RadioObject = GetClosestObjectOfType(Coords.x, Coords.y, Coords.z, 10.0, GetHashKey("prop_cs_hand_radio"))
            if RadioObject ~= 0 then
                DeleteObject(RadioObject)
            end
        end

        TriggerServerEvent("pma-voice:setTalkingOnRadio", false)
    end
end, false)


RegisterKeyMapping("+radiotalk","Dialogar no rádio.","keyboard","CAPITAL")

function syncRadio(_radioChannel)
	radioChannel = _radioChannel
end

RegisterNetEvent("pma-voice:clSetPlayerRadio",syncRadio)

local uiReady = promise.new()
function sendUIMessage(message)
	Citizen.Await(uiReady)
	SendNUIMessage(message)
end

RegisterNUICallback("uiReady",function(Data,Callback)
	uiReady:resolve(true)

	Callback("Ok")
end)
