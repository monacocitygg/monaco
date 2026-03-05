local mgRadiusBlip = nil
local mgCenterBlip = nil

RegisterNetEvent("monacogames:addBlip")
AddEventHandler("monacogames:addBlip", function(x, y, z)
    if mgRadiusBlip then
        RemoveBlip(mgRadiusBlip)
        mgRadiusBlip = nil
    end
    if mgCenterBlip then
        RemoveBlip(mgCenterBlip)
        mgCenterBlip = nil
    end

    mgRadiusBlip = AddBlipForRadius(x, y, z, 250.0)
    SetBlipColour(mgRadiusBlip, 27)
    SetBlipAlpha(mgRadiusBlip, 128)

    mgCenterBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(mgCenterBlip, 161)
    SetBlipColour(mgCenterBlip, 27)
    SetBlipScale(mgCenterBlip, 1.0)
    SetBlipAsShortRange(mgCenterBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Monaco Games")
    EndTextCommandSetBlipName(mgCenterBlip)
end)

RegisterNetEvent("monacogames:removeBlip")
AddEventHandler("monacogames:removeBlip", function()
    if mgRadiusBlip then
        RemoveBlip(mgRadiusBlip)
        mgRadiusBlip = nil
    end
    if mgCenterBlip then
        RemoveBlip(mgCenterBlip)
        mgCenterBlip = nil
    end
end)
