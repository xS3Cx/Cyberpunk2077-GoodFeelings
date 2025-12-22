local WeaponsFeatures = {}

WeaponsFeatures.FlyingThunderGod = require("Features/Weapons/Abilities/FlyingThunderGod")
WeaponsFeatures.GravityGun = require("Features/Weapons/Abilities/GravityGun")
WeaponsFeatures.TeleportShot = require("Features/Weapons/Abilities/TeleportShot")
WeaponsFeatures.SmartBlade = require("Features/Weapons/Abilities/SmartBlade")
WeaponsFeatures.InfiniteAmmo = require("Features/Weapons/Abilities/InfiniteAmmo")
WeaponsFeatures.ForceGun = require("Features/Weapons/Abilities/ForceGun")
WeaponsFeatures.ExplosiveBullets = require("Features/Weapons/Abilities/ExplosiveBullets")
WeaponsFeatures.WeaponActions = require("Features/Weapons/Abilities/WeaponActions")
WeaponsFeatures.ExplosiveKnives = require("Features/Weapons/Abilities/ExplosiveKnives")

WeaponsFeatures.StatModifiers = {
    NoReloading = require("Features/Weapons/StatModifiers/NoReloading"),
    FastReload = require("Features/Weapons/StatModifiers/FastReload"),
    NoRecoil = require("Features/Weapons/StatModifiers/NoRecoil"),
    RapidFire = require("Features/Weapons/StatModifiers/RapidFire"),
    ShotgunSpray = require("Features/Weapons/StatModifiers/ShotgunSpray"),
    AlwaysCrit = require("Features/Weapons/StatModifiers/AlwaysCrit"),
    InsaneCritDmg = require("Features/Weapons/StatModifiers/InsaneCritDmg"),
    HighBlock = require("Features/Weapons/StatModifiers/HighBlock"),
    LowStaminaCost = require("Features/Weapons/StatModifiers/LowStaminaCost"),
    BladeCarnage = require("Features/Weapons/StatModifiers/BladeCarnage"),
    InfiniteCombo = require("Features/Weapons/StatModifiers/InfiniteCombo"),
    SmartFastLock = require("Features/Weapons/StatModifiers/SmartFastLock"),
    SmartWideLock = require("Features/Weapons/StatModifiers/SmartWideLock"),
    SmartExtraTargets = require("Features/Weapons/StatModifiers/SmartExtraTargets"),
    SmartPerfectAcc = require("Features/Weapons/StatModifiers/SmartPerfectAcc"),
    UnlimitedRange = require("Features/Weapons/StatModifiers/UnlimitedRange"),
    PenetrationRounds = require("Features/Weapons/StatModifiers/PenetrationRounds"),
    HipfireAccuracy = require("Features/Weapons/StatModifiers/HipfireAccuracy"),
    AdsAccuracy = require("Features/Weapons/StatModifiers/AdsAccuracy")
}

return WeaponsFeatures
