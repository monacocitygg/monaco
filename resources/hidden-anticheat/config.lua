Config = {}

-- General Settings
Config.Debug = true -- Enable debug logs
Config.BanSystem = true -- Enable bans
Config.KickSystem = true -- Enable kicks
Config.LogWebhook = "https://discord.com/api/webhooks/1475931958059204669/pkOXfYEPnrsD7-YDAlNPyNMHE6oIHau8x0t8VK2LRWmAHtyxEOKEFBNy64F9Sf2rGpML"

-- Detection Thresholds
Config.Movement = {
    MaxSpeedOnFoot = 12.0, -- Maximum speed while walking/running (m/s)
    MaxSpeedVehicle = 150.0, -- Maximum speed in vehicle (m/s) - adjust per vehicle handling ideally
    MaxZChange = 10.0, -- Max vertical change per second without falling
    NoclipCheckInterval = 1000, -- Check every 1s
}

Config.Combat = {
    MaxHeadshotRatio = 0.85, -- 85% headshots is suspicious
    MinHeadshotSamples = 10, -- Minimum hits before checking ratio
    MaxSnapSpeed = 45.0, -- Degrees per frame change (impossible for humans)
    RecoilRecoveryTime = 0.05, -- Minimum time to recover from recoil
    SilentAimAngleDiff = 25.0, -- Max angle difference between camera and hit direction
    DetectionLockMs = 200,
    MagicBullet = {
        Enabled = true,
        CancelDamage = true, -- Cancel damage if wallbang detected
        IgnoreGlass = true, -- Ignore glass materials
        MaxWallbangDistance = 0.0, -- 0.0 = No wallbang allowed
    },
}

Config.Weapon = {
    BlacklistedWeapons = {
        "WEAPON_RPG",
        "WEAPON_MINIGUN",
        "WEAPON_RAILGUN"
    },
    DamageMultiplierLimit = 1.5, -- Max damage multiplier allowed
}

Config.Exploits = {
    ResourceStopCheck = true, -- Check if client stops resource
    CommandSpamLimit = 10, -- Commands per second
    SpectateCheck = true,
}
