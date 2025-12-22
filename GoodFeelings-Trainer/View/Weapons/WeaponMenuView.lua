local UI = require("UI")
local Buttons = UI.Buttons
local Inventory = require("Utils").Inventory
local Weapons = require("Features/Weapons")
local WeaponItemsMenu = require("View/Weapons/WeaponsItemView")

local ammoTypes = {
    { id = "Ammo.HandgunAmmo", label = L("weaponsmenu.ammoitems.types.handgun") },
    { id = "Ammo.ShotgunAmmo", label = L("weaponsmenu.ammoitems.types.shotgun") },
    { id = "Ammo.RifleAmmo", label = L("weaponsmenu.ammoitems.types.rifle") },
    { id = "Ammo.SniperRifleAmmo", label = L("weaponsmenu.ammoitems.types.sniper") },
    { id = "Ammo.Special", label = L("weaponsmenu.ammoitems.types.special") }
}

local addAmmoValues = {}
local removeAmmoValues = {}

for _, ammo in ipairs(ammoTypes) do
    addAmmoValues[ammo.id] = { step = 10, value = 50, min = 1, max = 999 }
    removeAmmoValues[ammo.id] = { step = 10, value = 10, min = 1, max = 999 }
end

local function AmmoItemsView()
    Buttons.Option(L("weaponsmenu.ammoitems.giveeach100.label"), tip("weaponsmenu.ammoitems.giveeach100.tip"), function()
        for _, ammo in ipairs(ammoTypes) do
            Inventory.GiveItem(ammo.id, 100)
        end
    end)
    Buttons.Option(L("weaponsmenu.ammoitems.removeeach25.label"), tip("weaponsmenu.ammoitems.removeeach25.tip"), function()
        for _, ammo in ipairs(ammoTypes) do
            Inventory.RemoveItem(ammo.id, 25)
        end
    end)
    Buttons.Break("", L("weaponsmenu.ammoitems.addammo"))
    for _, ammo in ipairs(ammoTypes) do
        Buttons.IntClick(ammo.label, addAmmoValues[ammo.id], tip("weaponsmenu.ammoitems.addtip", { ammo = ammo.label }), function()
            Inventory.GiveItem(ammo.id, addAmmoValues[ammo.id].value)
        end)
    end

    Buttons.Break("", L("weaponsmenu.ammoitems.removeammo"))
    for _, ammo in ipairs(ammoTypes) do
        Buttons.IntClick(ammo.label, removeAmmoValues[ammo.id], tip("weaponsmenu.ammoitems.removetip", { ammo = ammo.label }), function()
            Inventory.RemoveItem(ammo.id, removeAmmoValues[ammo.id].value)
        end)
    end
end
local ammoItemsSubmenu = { title = L("weaponsmenu.ammoitems.title"), view = AmmoItemsView }

local function WeaponsViewFunction()
    Buttons.Submenu(L("weaponsmenu.weaponitems.label"), WeaponItemsMenu, tip("weaponsmenu.weaponitems.tip"))
    Buttons.Submenu(L("weaponsmenu.ammomanager.label"), ammoItemsSubmenu, tip("weaponsmenu.ammomanager.tip"))

    
    Buttons.Toggle(L("weaponsmenu.explosivebullets.label"), Weapons.ExplosiveBullets.enabled, tip("weaponsmenu.explosivebullets.tip"))
    Buttons.Toggle(L("weaponsmenu.infiniteammo.label"), Weapons.InfiniteAmmo.enabled, tip("weaponsmenu.infiniteammo.tip"))
    Buttons.Toggle(L("weaponsmenu.norecoil.label"), Weapons.StatModifiers.NoRecoil.toggleNoRecoil, tip("weaponsmenu.norecoil.tip"))
    Buttons.Toggle(L("weaponsmenu.speedcola.label"), Weapons.StatModifiers.FastReload.toggleFastReload, tip("weaponsmenu.speedcola.tip"))
    Buttons.Toggle(L("weaponsmenu.noreload.label"), Weapons.StatModifiers.NoReloading.toggleNoReloading, tip("weaponsmenu.noreload.tip"))
    Buttons.Toggle(L("weaponsmenu.rapidfire.label"), Weapons.StatModifiers.RapidFire.toggleRapidFire, tip("weaponsmenu.rapidfire.tip"))

    Buttons.Break(L("weaponsmenu.weaponmanagement.label"))
    Buttons.Option(L("weaponsmenu.giveallwallweapons.label"), tip("weaponsmenu.giveallwallweapons.tip"), Weapons.WeaponActions.GiveAllWallWeapons)
    Buttons.Option(L("weaponsmenu.givealliconicweapons.label"), tip("weaponsmenu.givealliconicweapons.tip"), Weapons.WeaponActions.GiveAllIconicWeapons)
    Buttons.Option(L("weaponsmenu.removeallweapons.label"), tip("weaponsmenu.removeallweapons.tip"), Weapons.WeaponActions.RemoveAllWeapons)


    Buttons.Break(L("weaponsmenu.critandspray.label"))
    Buttons.Toggle(L("weaponsmenu.alwayscrit.label"), Weapons.StatModifiers.AlwaysCrit.toggleAlwaysCrit, tip("weaponsmenu.alwayscrit.tip"))
    Buttons.Toggle(L("weaponsmenu.insanecritdmg.label"), Weapons.StatModifiers.InsaneCritDmg.toggleInsaneCritDmg, tip("weaponsmenu.insanecritdmg.tip"))
    Buttons.Toggle(L("weaponsmenu.shotgunspray.label"), Weapons.StatModifiers.ShotgunSpray.toggleShotgunSpray, tip("weaponsmenu.shotgunspray.tip"))

    Buttons.Break(L("weaponsmenu.accuracyrange.label"))
    Buttons.Toggle(L("weaponsmenu.unlimitedrange.label"), Weapons.StatModifiers.UnlimitedRange.toggleUnlimitedRange, tip("weaponsmenu.unlimitedrange.tip"))
    Buttons.Toggle(L("weaponsmenu.penetrationrounds.label"), Weapons.StatModifiers.PenetrationRounds.togglePenetrationRounds, tip("weaponsmenu.penetrationrounds.tip"))
    Buttons.Toggle(L("weaponsmenu.hipfireaccuracy.label"), Weapons.StatModifiers.HipfireAccuracy.toggleHipfireAccuracy, tip("weaponsmenu.hipfireaccuracy.tip"))
    Buttons.Toggle(L("weaponsmenu.adsaccuracy.label"), Weapons.StatModifiers.AdsAccuracy.toggleAdsAccuracy, tip("weaponsmenu.adsaccuracy.tip"))

    Buttons.Break(L("weaponsmenu.specialweapons.label"))
    Buttons.Toggle(L("weaponsmenu.forcegun.label"), Weapons.ForceGun.enabled, tip("weaponsmenu.forcegun.tip"))
    Buttons.Toggle(L("weaponsmenu.gravitygun.label"), Weapons.GravityGun.enabled, tip("weaponsmenu.gravitygun.tip"))
    Buttons.Toggle(L("weaponsmenu.flyingthundergod.label"), Weapons.FlyingThunderGod.enabled, tip("weaponsmenu.flyingthundergod.tip"))
    Buttons.Toggle(L("weaponsmenu.smartbladereturn.label"), Weapons.SmartBlade.enabled, tip("weaponsmenu.smartbladereturn.tip"))
    Buttons.Toggle(L("weaponsmenu.teleygun.label"), Weapons.TeleportShot.enabled, tip("weaponsmenu.teleygun.tip"))

    Buttons.Break(L("weaponsmenu.melee.label"))
    Buttons.Toggle(L("weaponsmenu.melee_highblock.label"), Weapons.StatModifiers.HighBlock.toggleHighBlock, tip("weaponsmenu.melee_highblock.tip"))
    Buttons.Toggle(L("weaponsmenu.melee_lowstamina.label"), Weapons.StatModifiers.LowStaminaCost.toggleLowStaminaCost, tip("weaponsmenu.melee_lowstamina.tip"))
    Buttons.Toggle(L("weaponsmenu.melee_bladecarnage.label"), Weapons.StatModifiers.BladeCarnage.toggleBladeCarnage, tip("weaponsmenu.melee_bladecarnage.tip"))
    Buttons.Toggle(L("weaponsmenu.melee_infinitecombo.label"), Weapons.StatModifiers.InfiniteCombo.toggleInfiniteCombo, tip("weaponsmenu.melee_infinitecombo.tip"))
    Buttons.Toggle(L("weaponsmenu.explosiveknives.label"), Weapons.ExplosiveKnives.enabled, tip("weaponsmenu.explosiveknives.tip"))

    Buttons.Break(L("weaponsmenu.smartweapons.label"))
    Buttons.Toggle(L("weaponsmenu.smart_fastlock.label"), Weapons.StatModifiers.SmartFastLock.toggleFastLock, tip("weaponsmenu.smart_fastlock.tip"))
    Buttons.Toggle(L("weaponsmenu.smart_widelock.label"), Weapons.StatModifiers.SmartWideLock.toggleWideLock, tip("weaponsmenu.smart_widelock.tip"))
    Buttons.Toggle(L("weaponsmenu.smart_extratargets.label"), Weapons.StatModifiers.SmartExtraTargets.toggleExtraTargets, tip("weaponsmenu.smart_extratargets.tip"))
    Buttons.Toggle(L("weaponsmenu.smart_perfectacc.label"), Weapons.StatModifiers.SmartPerfectAcc.togglePerfectAcc, tip("weaponsmenu.smart_perfectacc.tip"))
end


local WeaponsView = { title = L("weaponsmenu.title"), view = WeaponsViewFunction }

return WeaponsView
