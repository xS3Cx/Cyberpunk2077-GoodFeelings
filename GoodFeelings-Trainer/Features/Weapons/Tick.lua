local Weapons = require("Features/Weapons")
local WeaponTick = {}

function WeaponTick.TickHandler(deltaTime)
    Weapons.GravityGun.Tick()
    Weapons.TeleportShot.Tick()
    Weapons.InfiniteAmmo.Tick()
    Weapons.ForceGun.Tick(deltaTime)
    Weapons.ExplosiveBullets.Tick()
    Weapons.StatModifiers.NoReloading.Tick(deltaTime)
    Weapons.StatModifiers.FastReload.Tick(deltaTime)
    Weapons.StatModifiers.NoRecoil.Tick(deltaTime)
    Weapons.StatModifiers.RapidFire.Tick(deltaTime)
    Weapons.StatModifiers.ShotgunSpray.Tick(deltaTime)
    Weapons.StatModifiers.AlwaysCrit.Tick(deltaTime)
    Weapons.StatModifiers.InsaneCritDmg.Tick(deltaTime)
    Weapons.StatModifiers.HighBlock.Tick(deltaTime)
    Weapons.StatModifiers.LowStaminaCost.Tick(deltaTime)
    Weapons.StatModifiers.BladeCarnage.Tick(deltaTime)
    Weapons.StatModifiers.InfiniteCombo.Tick(deltaTime)
    Weapons.StatModifiers.SmartFastLock.Tick(deltaTime)
    Weapons.StatModifiers.SmartWideLock.Tick(deltaTime)
    Weapons.StatModifiers.SmartExtraTargets.Tick(deltaTime)
    Weapons.StatModifiers.SmartPerfectAcc.Tick(deltaTime)
    Weapons.StatModifiers.UnlimitedRange.Tick(deltaTime)
    Weapons.StatModifiers.PenetrationRounds.Tick(deltaTime)
    Weapons.StatModifiers.HipfireAccuracy.Tick(deltaTime)
    Weapons.StatModifiers.AdsAccuracy.Tick(deltaTime)
end

function WeaponTick.HandleProjectileHit(self, eventData)
    Weapons.FlyingThunderGod.Tick(eventData)
    Weapons.ExplosiveKnives.Tick(eventData)
    Weapons.SmartBlade.Tick(self)
end

return WeaponTick
