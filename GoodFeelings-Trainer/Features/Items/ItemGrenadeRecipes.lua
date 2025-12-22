local Inventory = require("Utils").Inventory

local ItemGrenadeRecipes = {}

function ItemGrenadeRecipes.GiveAllGrenadeRecipes()
    local ids = {
        "RecipeGrenadeIncendiaryRegular",
        "RecipeGrenadeIncendiarySticky",
        "RecipeGrenadeIncendiaryHoming",
        "RecipeGrenadeEMPRegular",
        "RecipeGrenadeEMPSticky",
        "RecipeGrenadeEMPHoming",
        "RecipeGrenadeFragRegular",
        "RecipeGrenadeFragSticky",
        "RecipeGrenadeFragHoming",
        "RecipeGrenadeCuttingRegular",
        "RecipeGrenadeBiohazardRegular",
        "RecipeGrenadeBiohazardHoming",
        "RecipeGrenadeOzobsNose",
        "RecipeGrenadeReconRegular",
        "RecipeGrenadeReconSticky",
        "RecipeGrenadeFlashRegular",
        "RecipeGrenadeFlashHoming",
        "RecipeGrenadeIncendiaryRare",
        "RecipeGrenadeEMPRare",
        "RecipeGrenadeReconRare",
        "RecipeGrenadeSmokeRare",
        "RecipeGrenadeEMPUncommon",
        "RecipeGrenadeFragUncommon",
        "RecipeGrenadeSmokeRegular",
        "RecipeGrenadeFlashUncommon",
        "RecipeGrenadeFragEpic",
        "RecipeGrenadeSmokeEpic",
        "RecipeGrenadeFlashEpic",
        "RecipeGrenadeIncendiaryLegendary",
        "RecipeGrenadeEMPLegendary",
        "RecipeGrenadeBiohazardLegendary",
        "RecipeGrenadeReconLegendary",
        "RecipeGrenadeSmokeLegendary",
        "RecipeGrenadeFlashLegendary"
    }

    for _, v in ipairs(ids) do
        Inventory.GiveItem("Items." .. v, 1)
    end
end

return ItemGrenadeRecipes
