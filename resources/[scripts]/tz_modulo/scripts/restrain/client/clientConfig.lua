
Restrain = {}

-- Lista de armas permitidas, attack caso seja true, sera liberado a opção de disparo com essa arma
local allowedWeapons = {
    [GetHashKey("WEAPON_PISTOL")]     = { attack = true },
    [GetHashKey("WEAPON_WRENCH")]     = { attack = false },
    [GetHashKey("WEAPON_FLASHLIGHT")]     = { attack = false },

}

function Restrain:isWeaponAllowed(weaponHash)
    local info = allowedWeapons[weaponHash]
    if info then
        return {attack = info.attack , push = true}
    else
        return {attack = false, push = false}
    end
end