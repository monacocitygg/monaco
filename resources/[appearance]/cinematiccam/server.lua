-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
--------------------------------------------------
---------------------- EVENTS --------------------
--------------------------------------------------

RegisterServerEvent('CinematicCam:requestPermissions')
AddEventHandler('CinematicCam:requestPermissions', function()

end)


function src.checkPermission(permission)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasGroup(Passport, 'Cam',1) or vRP.HasGroup(Passport, 'Admin',2)  then
            return true
        else
            return
        end
    end
end