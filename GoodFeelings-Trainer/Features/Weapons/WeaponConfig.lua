local ConfigManager = require("Config/OptionConfig")
local Weapons = require("Features/Weapons")

local function RegisterAllWeaponOptions()

    ConfigManager.Register("toggle.weapon.infiniteammo", Weapons.InfiniteAmmo.enabled, false)
    ConfigManager.Register("toggle.weapon.forcegun", Weapons.ForceGun.enabled, false)
    ConfigManager.Register("toggle.weapon.flyingthundergod", Weapons.FlyingThunderGod.enabled, false)
    ConfigManager.Register("toggle.weapon.gravitygun", Weapons.GravityGun.enabled, false)
    ConfigManager.Register("toggle.weapon.smartbladereturn", Weapons.SmartBlade.enabled, false)
    ConfigManager.Register("toggle.weapon.teleygun", Weapons.TeleportShot.enabled, false)
    ConfigManager.Register("toggle.weapon.explosivebullets", Weapons.ExplosiveBullets.enabled, false)

    ConfigManager.Register("toggle.weapon.noreload", Weapons.StatModifiers.NoReloading.toggleNoReloading, false)
    ConfigManager.Register("toggle.weapon.speedcola", Weapons.StatModifiers.FastReload.toggleFastReload, false)
    ConfigManager.Register("toggle.weapon.norecoil", Weapons.StatModifiers.NoRecoil.toggleNoRecoil, false)
    ConfigManager.Register("toggle.weapon.rapidfire", Weapons.StatModifiers.RapidFire.toggleRapidFire, false)
    ConfigManager.Register("toggle.weapon.shotgunspray", Weapons.StatModifiers.ShotgunSpray.toggleShotgunSpray, false)

    ConfigManager.Register("toggle.weapon.alwayscrit", Weapons.StatModifiers.AlwaysCrit.toggleAlwaysCrit, false)
    ConfigManager.Register("toggle.weapon.insanecritdmg", Weapons.StatModifiers.InsaneCritDmg.toggleInsaneCritDmg, false)

    ConfigManager.Register("toggle.weapon.melee_highblock", Weapons.StatModifiers.HighBlock.toggleHighBlock, false)
    ConfigManager.Register("toggle.weapon.melee_lowstamina", Weapons.StatModifiers.LowStaminaCost.toggleLowStaminaCost, false)
    ConfigManager.Register("toggle.weapon.melee_bladecarnage", Weapons.StatModifiers.BladeCarnage.toggleBladeCarnage, false)
    ConfigManager.Register("toggle.weapon.melee_infinitecombo", Weapons.StatModifiers.InfiniteCombo.toggleInfiniteCombo, false)

    ConfigManager.Register("toggle.weapon.smart_fastlock", Weapons.StatModifiers.SmartFastLock.toggleFastLock, false)
    ConfigManager.Register("toggle.weapon.smart_widelock", Weapons.StatModifiers.SmartWideLock.toggleWideLock, false)
    ConfigManager.Register("toggle.weapon.smart_extratargets", Weapons.StatModifiers.SmartExtraTargets.toggleExtraTargets, false)
    ConfigManager.Register("toggle.weapon.smart_perfectacc", Weapons.StatModifiers.SmartPerfectAcc.togglePerfectAcc, false)

    ConfigManager.Register("toggle.weapon.unlimitedrange", Weapons.StatModifiers.UnlimitedRange.toggleUnlimitedRange, false)
    ConfigManager.Register("toggle.weapon.penetrationrounds", Weapons.StatModifiers.PenetrationRounds.togglePenetrationRounds, false)
    ConfigManager.Register("toggle.weapon.hipfireaccuracy", Weapons.StatModifiers.HipfireAccuracy.toggleHipfireAccuracy, false)
    ConfigManager.Register("toggle.weapon.adsaccuracy", Weapons.StatModifiers.AdsAccuracy.toggleAdsAccuracy, false)
end

return RegisterAllWeaponOptions
