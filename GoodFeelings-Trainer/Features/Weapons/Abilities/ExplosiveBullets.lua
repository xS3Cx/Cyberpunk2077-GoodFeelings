local Weapon = require("Utils").Weapon
local Explosion = require("Utils/Explosion")
local Logger = require("Core/Logger")
local UI = require("UI")

local ExplosiveBullets = {}
local cooldown = 0.1
local lastExplosionTime = 0

ExplosiveBullets.enabled = { value = false }

-- User Curated Quick Sets
ExplosiveBullets.quickSets = {
    "Attacks.AndroidDeathExplosion", "Attacks.BiotechGrenade", "Attacks.BiotechHerculesExplosion",
    "Attacks.BiotechHerculesPoison", "Attacks.BulletExplosion", "Attacks.BulletExplosionPanzer",
    "Attacks.BulletLightExplosion", "Attacks.BulletMediumExplosion", "Attacks.CWMalfunctionEMPExplosion",
    "Attacks.ChemicalProjectile", "Attacks.ChemicalProjectileCharged", "Attacks.ChemicalProjectileGigaChadRelicCharged",
    "Attacks.EMPProjectile", "Attacks.EMPProjectileCharged", "Attacks.EMPProjectileGigaChadRelicCharged",
    "Attacks.ExplodingBulletLightEffect", "Attacks.ExplodingBulletMediumEffect", "Attacks.ExplosionEnormous",
    "Attacks.FragGrenade", "Attacks.FragGrenadeUnderwaterDeep", "Attacks.FragGrenadeUnderwaterShallow",
    "Attacks.FragmentationGrenadeLethal", "Attacks.FragmentationGrenadeNonLethal", "Attacks.HerculesHipBulletExplosion",
    "Attacks.IncendiaryGrenade", "Attacks.MissileProjectile", "Attacks.RareBiotechGrenade",
    "Attacks.ThermalProjectile", "Attacks.ThermalProjectileCharged", "Attacks.ThermalProjectileGigaChadRelicCharged",
    "Attacks.TranquilizerProjectile", "Attacks.TranquilizerProjectileCharged", "Attacks.TranquilizerProjectileGigaChadRelicCharged",
    "Attacks.ZhuoBulletHighExplosion", "Attacks.ChimeraMineMissileBulletEffect", "Attacks.ChimeraPowerMod_BulletLightExplosion",
    "Attacks.ChimeraPowerMod_ExplodingBulletLightEffect", "Attacks.ContagionBurnComboBounce4", "Attacks.BreachEMPExplosion",
    "Attacks.ElectricAbility", "Attacks.ElectroshockMechanismExplosionEpic", "Attacks.FlashbangGrenadeCommon",
    "Attacks.OdaSmokeBomb", "Attacks.RoyceProjectileExplosion", "Attacks.SmasherSplashExplosion",
    "Attacks.MaskExplosion", "Attacks.OzobGrenade"
}

-- Explosion categories configuration
ExplosiveBullets.categories = {
    {
        name = "Basic & Frag",
        items = {
            "Attacks.FragGrenade", "Attacks.LegendaryFragGrenade", "Attacks.IncendiaryGrenade", "Attacks.Explosion",
            "Attacks.ExplosionEnormous", "Attacks.ExplosionLarge", "Attacks.ExplosionMedium", "Attacks.ExplosionSmall",
            "Attacks.ExplosionLargeKill", "Attacks.CommonFragGrenade", "Attacks.UncommonFragGrenade",
            "Attacks.EpicFragGrenade", "Attacks.RareFragGrenade", "Attacks.FragGrenadeHE", "Attacks.FragGrenadeLethal",
            "Attacks.FragGrenadeKnockdown", "Attacks.FragGrenadeHack", "Attacks.FragGrenadeUnderwaterDeep",
            "Attacks.FragGrenadeUnderwaterShallow", "Attacks.FragmentationGrenadeLethal", "Attacks.FragmentationGrenadeNonLethal"
        }
    },
    {
        name = "Biotech & Android",
        items = {
            "Attacks.AndroidDeathExplosion", "Attacks.BiotechGrenade", "Attacks.BiotechGrenadeV2", "Attacks.BiotechHerculesExplosion",
            "Attacks.BiotechHerculesPoison", "Attacks.EpicBiotechGrenade", "Attacks.EpicPlusBiotechGrenade", "Attacks.LegendaryBiotechGrenade",
            "Attacks.LegendaryPlusBiotechGrenade", "Attacks.RareBiotechGrenade", "Attacks.LightBiotechGrenadeHack", "Attacks.YashaBiotechGrenade"
        }
    },
    {
        name = "Blackwall & Cyberware",
        items = {
            "Attacks.BlackWallAttack", "Attacks.BlackWallMechanical", "Attacks.BlackwallHackAttack", "Attacks.CyberwareExplosion",
            "Attacks.CyberwareMalfunctionAttack", "Attacks.CyberwareMalfunctionQuickHackAttackLevel3", "Attacks.CWMalfunctionEMPExplosion",
            "Attacks.BacklashAttack"
        }
    },
    {
        name = "Bullets & Projectiles",
        items = {
            "Attacks.BulletExplosion", "Attacks.BulletExplosionPanzer", "Attacks.BulletExplosionSmall", "Attacks.BulletLightExplosion",
            "Attacks.BulletMediumExplosion", "Attacks.BulletSasquatchExplosion", "Attacks.BaseBulletExplosion", "Attacks.ExplosiveBulletEffect",
            "Attacks.ExplodingBulletLightEffect", "Attacks.ExplodingBulletMediumEffect", "Attacks.BurningBulletEffect", "Attacks.ChemicalBulletEffect",
            "Attacks.ElectricBulletEffect", "Attacks.BleedingBulletEffect", "Attacks.PoisonBulletEffect", "Attacks.ThermalProjectile",
            "Attacks.ThermalProjectileCharged", "Attacks.ThermalProjectileGigaChadRelicCharged", "Attacks.ChemicalProjectile",
            "Attacks.ChemicalProjectileCharged", "Attacks.ChemicalProjectileGigaChadRelicCharged", "Attacks.EMPGrenadeProjectile",
            "Attacks.EMPProjectile", "Attacks.EMPProjectileCharged", "Attacks.EMPProjectileGigaChadRelicCharged", "Attacks.TranquilizerProjectile",
            "Attacks.TranquilizerProjectileCharged", "Attacks.TranquilizerProjectileGigaChadRelicCharged", "Attacks.Missile",
            "Attacks.MissileProjectile", "Attacks.MissileProjectileCharged", "Attacks.MissileProjectileGigaChadRelicCharged",
            "Attacks.BulletSmartBulletHighExplosion", "Attacks.Bullet_GameEffect", "Attacks.ZhuoBulletHighExplosion",
            "Attacks.HerculesHipBulletExplosion"
        }
    },
    {
        name = "Chimera Special",
        items = {
            "Attacks.ChimeraLaserBeam", "Attacks.ChimeraLaserBeamTop", "Attacks.ChimeraMetalstormBulletEffect",
            "Attacks.ChimeraMetalstormExplodingBulletEffect", "Attacks.ChimeraMetalstormRaiseSequenceEffect",
            "Attacks.ChimeraMineMissileBulletEffect", "Attacks.ChimeraPowerMod_BulletExplosion",
            "Attacks.ChimeraPowerMod_BulletLightExplosion", "Attacks.ChimeraPowerMod_ExplodingBulletLightEffect",
            "Attacks.ChimeraPowerMod_ExplosiveBulletEffect", "Attacks.ChimeraRainMissileBulletEffect",
            "Attacks.ChimeraSelfMissileBulletEffect", "Attacks.ChimeraTrackMissileBulletEffect", "Attacks.Chimera_Bullet_GameEffect",
            "Attacks.Chimera_Exploding_Bullet_GameEffect", "Attacks.BulletChimeraExplosion"
        }
    },
    {
        name = "Contagion & Poison",
        items = {
            "Attacks.ContagionBurnCombo", "Attacks.ContagionBurnComboBounce2", "Attacks.ContagionBurnComboBounce3",
            "Attacks.ContagionBurnComboBounce4", "Attacks.ContagionPoisonAttack", "Attacks.ContagionPoisonAttackBounce2",
            "Attacks.ContagionPoisonAttackBounce3", "Attacks.ContagionPoisonAttackBounce4", "Attacks.ContagionPoisonAttackLvl2",
            "Attacks.ContagionPoisonAttackLvl3", "Attacks.ContagionPoisonAttackLvl4", "Attacks.BiotechHerculesPoison",
            "Attacks.ChemicalDamageOverTime", "Attacks.BaseChemicalDamageOverTime", "Attacks.HighChemicalDamageOverTime",
            "Attacks.LowChemicalDamageOverTime", "Attacks.VeryLowChemicalDamageOverTime", "Attacks.PoisonBulletEffect",
            "Attacks.ToxicGas"
        }
    },
    {
        name = "Drones & Robots",
        items = {
            "Attacks.DroneBombusDeathExplosion", "Attacks.DroneGriffinDeathExplosion", "Attacks.DroneOctantDeathExplosion",
            "Attacks.DroneOctantDeathExplosionPlayerSafe", "Attacks.MinotaurDeathExplosion", "Attacks.MinotaurExplosion",
            "Attacks.MinotaurWeakspotExplosion", "Attacks.MinotaurWeakspotLeftExplosion", "Attacks.MinotaurWeakspotRightExplosion",
            "Attacks.BombusFlame", "Attacks.BombusFlameShort", "Attacks.AndroidDeathExplosion"
        }
    },
    {
        name = "Electrical & EMP",
        items = {
            "Attacks.Electric", "Attacks.ElectricAbility", "Attacks.ElectricDamageOverTime", "Attacks.ElectrifiedWaterElectricDamageOverTime",
            "Attacks.ElectroshockMechanismExplosionCommon", "Attacks.ElectroshockMechanismExplosionEpic",
            "Attacks.ElectroshockMechanismExplosionLegendary", "Attacks.ElectroshockMechanismExplosionRare",
            "Attacks.ElectroshockMechanismExplosionUncommon", "Attacks.EmpBlastStrongArms", "Attacks.EmpGrenadeEpicAdditional",
            "Attacks.EmpGrenadeJamWeaponChance", "Attacks.EmpGrenadeKnockdown", "Attacks.EmpGrenadeLegendaryAdditional",
            "Attacks.EmpGrenadeRareAdditional", "Attacks.EmpGrenadeUncommonAdditional", "Attacks.EMPGrenadeCommon", "Attacks.EMPGrenadeEpic",
            "Attacks.EMPGrenadeHack", "Attacks.EMPGrenadeLegendary", "Attacks.EMPGrenadeNPC", "Attacks.EMPGrenadeRare",
            "Attacks.EMPGrenadeUncommon", "Attacks.EMPPanzerGrenade", "Attacks.EMPBrick", "Attacks.FluffEMPExplosion",
            "Attacks.StrongArmsEMPExplosion", "Attacks.TechAbility_60_EMP_Boom", "Attacks.YinglongEMP", "Attacks.SmasherEMPExplosion",
            "Attacks.CWMalfunctionEMPExplosion", "Attacks.BreachEMPExplosion"
        }
    },
    {
        name = "Environmental & Traps",
        items = {
            "Attacks.EnvironmentalElectricDamageOverTime", "Attacks.EnvironmentalThermalDamageOverTime", "Attacks.EnvironmentalFireLarge",
            "Attacks.EnvironmentalFireMedium", "Attacks.EnvironmentalFireSmall", "Attacks.EnvironmentalElectricityLarge",
            "Attacks.EnvironmentalElectricityMedium", "Attacks.EnvironmentalElectricitySmall", "Attacks.FatalEnvironmentalElectricDamageOverTime",
            "Attacks.ExplosiveDeviceAttackBase", "Attacks.DeviceAttack", "Attacks.Trap_Attack_Base", "Attacks.Trap_Car_Lift",
            "Attacks.Trap_Catwalk_Segment", "Attacks.Trap_Crate_Falling", "Attacks.Trap_Crates_Wall", "Attacks.Trap_Industrial_Arm_Poke",
            "Attacks.Trap_Magnet_Attack", "Attacks.FireExtinguisherBlind", "Attacks.E3MallDestruction_ExplosionMediumKill",
            "Attacks.LadderDrop", "Attacks.FanBlades", "Attacks.HelicopterRotorBlades"
        }
    },
    {
        name = "Flashbang & Recon",
        items = {
            "Attacks.FlashbangGrenadeCommon", "Attacks.FlashbangGrenadeCommonPlus", "Attacks.FlashbangGrenadeEpic", "Attacks.FlashbangGrenadeEpicPlus",
            "Attacks.FlashbangGrenadeLegendary", "Attacks.FlashbangGrenadeLegendaryPlus", "Attacks.FlashbangGrenadeRare", "Attacks.FlashbangGrenadeRarePlus",
            "Attacks.FlashbangGrenadeUncommon", "Attacks.FlashbangGrenadeUncommonPlus", "Attacks.FlashbangGrenadeWithConfusion",
            "Attacks.FlashbangGrenadeWithWounded", "Attacks.FlashbangMinorFlash", "Attacks.ReconGrenade", "Attacks.ReconGrenadeBeams",
            "Attacks.ReconGrenadeHack", "Attacks.ReconGrenadeXRay", "Attacks.EpicReconXRay", "Attacks.RareReconXRay", "Attacks.LegendaryReconXRay",
            "Attacks.EpicPlusReconXRay", "Attacks.LegendaryPlusReconXRay", "Attacks.UncommonReconXRay"
        }
    },
    {
        name = "Special Bosses",
        items = {
            "AdamSmasher.AdamSmasherStealthDotDamage", "Attacks.SmasherMinigunBulletEffect", "Attacks.SmasherRainMissileBulletEffect",
            "Attacks.SmasherRunMissileBulletEffect", "Attacks.SmasherShotgunBulletEffect", "Attacks.SmasherSplashExplosion",
            "Attacks.OdaExplosion", "Attacks.OdaSmartRifleBulletEffect", "Attacks.OdaSmokeBomb", "Attacks.RoyceExplosion",
            "Attacks.RoyceLaserSight", "Attacks.RoyceProjectileExplosion", "Attacks.RoyceProjectileExplosionWeak",
            "Attacks.RoyceSplashExplosion", "Attacks.RoyceWeakSpotExplosion", "Attacks.SasquatchWeakSpotExplosion",
            "Attacks.BossBlackwallAttack", "Attacks.BossCuttingGrenadeAttack", "Attacks.BossForceSuicideGunAttack",
            "Attacks.ReedLaserSight", "Attacks.ReedSniperAttack", "Attacks.Kurt_Knife_Impact", "Attacks.Kurt_Knife_TakedownImpact"
        }
    },
    {
        name = "Quickhacks & Hacks",
        items = {
            "Attacks.OverheatQuickHackAttack", "Attacks.OverheatQuickHackAttackLevel1", "Attacks.OverheatQuickHackAttackLevel2",
            "Attacks.OverheatQuickHackAttackLevel3", "Attacks.OverheatQuickHackAttackLevel4", "Attacks.OverheatQuickHackGrisGris",
            "Attacks.OverloadQuickHackAttack", "Attacks.OverloadQuickHackAttackLevel1", "Attacks.OverloadQuickHackAttackLevel2",
            "Attacks.OverloadQuickHackAttackLevel3", "Attacks.OverloadQuickHackAttackLevel4", "Attacks.OverloadQuickHackAttackLevel4PlusPlus",
            "Attacks.OverloadQuickHackAttackGrisGris", "Attacks.BrainMeltHackAttackLevel2", "Attacks.BrainMeltHackAttackLevel3",
            "Attacks.BrainMeltHackAttackLevel4", "Attacks.BrainMeltHackAttackLevel4PlusPlus", "Attacks.BrainMeltHackAttackQuestForceKill",
            "Attacks.QuickHackAttack", "Attacks.QuickHackTwitchAttack", "Attacks.QuickHackWeakspotSelfDestruct",
            "Attacks.WeaponMalfunctionBlowWeaponHackAttack", "Attacks.WeaponMalfunctionBlowWeaponHackAttackManMassive",
            "Attacks.ForceSuicideGunAttack", "Attacks.ForceSuicideMeleeAttack", "Attacks.SuicideBulletEffect"
        }
    },
    {
        name = "Vehicles",
        items = {
            "Attacks.CarExplosionKill", "Attacks.CarMediumKill", "Attacks.CarHitPlayer", "Attacks.DriverKill", "Attacks.PanzerMissileEffect",
            "Attacks.VehicleCollision", "Attacks.VehicleBump", "Attacks.VehicleImpact", "Attacks.VehicleBaseDamageOverTime",
            "Attacks.VehicleHighDamageOverTime", "Attacks.PlayerCarInCollision", "Attacks.NPCCarInCollision", "Attacks.DelamainMissileEffect",
            "Attacks.VehicleMissileLauncherMissileEffect"
        }
    },
    {
        name = "Other Specials",
        items = {
            "Attacks.OzobGrenade", "Attacks.OzobGrenadeImpactOnNPC", "Attacks.ChainLightning", "Attacks.ChainLightningTech55",
            "Attacks.ScavChainLightning", "Attacks.ScavChainLightningTech55", "Attacks.JurijMineExplosion", "Attacks.MaskExplosion",
            "Attacks.VBAxeEMP", "Attacks.OutOfOxygenDamageOverTime", "Attacks.SandstormDamageOverTime", "Attacks.SelfKill",
            "Attacks.ForwardPush", "Attacks.TesteraExplosionAttack", "Attacks.Testera_Nicolas_ThermalDamageOverTime",
            "Attacks.MicroGeneratorExplosion2", "Attacks.MicroGeneratorExplosionCommon", "Attacks.MicroGeneratorExplosionEpic",
            "Attacks.MicroGeneratorExplosionLegendary", "Attacks.MicroGeneratorExplosionRare", "Attacks.MicroGeneratorExplosionUncommon"
        }
    }
}

-- Flattened list for logic
ExplosiveBullets.explosionTypes = {}
for _, category in ipairs(ExplosiveBullets.categories) do
    for _, item in ipairs(category.items) do
        table.insert(ExplosiveBullets.explosionTypes, item)
    end
end

ExplosiveBullets.explosionTypeIndex = { index = 1, expanded = false }
ExplosiveBullets.explosionRadius = { value = 3.0, min = 1.0, max = 15.0, step = 0.5 }

ExplosiveBullets.explosionTypeIndex = { index = 1, expanded = false }
ExplosiveBullets.explosionRadius = { value = 3.0, min = 1.0, max = 15.0, step = 0.5 }

-- Helper for UI selection
function ExplosiveBullets.SelectType(fullId)
    for idx, id in ipairs(ExplosiveBullets.explosionTypes) do
        if id == fullId then
            ExplosiveBullets.explosionTypeIndex.index = idx
            return
        end
    end
end

-- Prepare category UI objects for SubmenuManager
for _, category in ipairs(ExplosiveBullets.categories) do
    category.title = category.name
    category.view = function()
        -- Buttons is required here or passed? WeaponMenuView has it.
        -- We'll just define the logic, WeaponMenuView will handle the actual button calls
        -- Actually, it's better to keep the view logic in WeaponMenuView for consistency with rest of the mod.
    end
end

function ExplosiveBullets.Tick()
    if not ExplosiveBullets.enabled.value then return end
    if not Weapon.IsShootingRanged() then return end

    local currentTime = os.clock()
    if currentTime - lastExplosionTime < cooldown then return end

    local player = Game.GetPlayer()
    local targetingSystem = Game.GetTargetingSystem()
    if not player or not targetingSystem then return end

    local lookAt = targetingSystem:GetLookAtPosition(player, true, false)
    if not lookAt then return end

    -- Get selected explosion type
    local explosionType = ExplosiveBullets.explosionTypes[ExplosiveBullets.explosionTypeIndex.index]
    local radius = ExplosiveBullets.explosionRadius.value

    Explosion.SpawnAtPos(lookAt, explosionType, player, player, nil, radius)

    lastExplosionTime = currentTime
end

return ExplosiveBullets
