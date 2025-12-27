local SelfFeatures = {}

SelfFeatures.GodMode = require("Features/Self/Abilities/GodMode")
SelfFeatures.Invisibility = require("Features/Self/Abilities/Invisibility")
SelfFeatures.SuperSpeed = require("Features/Self/Abilities/SuperSpeed")
SelfFeatures.AirThrusterBoots = require("Features/Self/Abilities/AirThrusterBoots")
SelfFeatures.AdvancedMobility = require("Features/Self/Abilities/AdvancedMobility")
SelfFeatures.WantedLevel = require("Features/Self/Abilities/WantedLevel")
SelfFeatures.NoClip = require("Features/Self/Abilities/NoClip")
SelfFeatures.InfiniteJumps = require("Features/Self/Abilities/InfiniteJumps")
SelfFeatures.InfiniteAirDash = require("Features/Self/Abilities/InfiniteAirDash")
SelfFeatures.Forcefield = require("Features/Self/Abilities/Forcefield")

SelfFeatures.StatModifiers = {
	Movement = require("Features/Self/StatModifiers/Movement"),
	Cooldown = require("Features/Self/StatModifiers/Cooldown"),
	Enhancements = require("Features/Self/StatModifiers/Enhancements"),
	Stealth = require("Features/Self/StatModifiers/Stealth"),
	Utility = require("Features/Self/StatModifiers/Utility")
}
return SelfFeatures
