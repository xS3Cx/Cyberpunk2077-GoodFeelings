local FactFlags = {
    RomanceFlags = {
        { id = "judy_romanceable", name = "Judy Romanceable", desc = "Enables romance option with Judy" },
        { id = "sq030_judy_lover", name = "Judy Lover", desc = "Sets Judy as V's lover" },
        { id = "panam_romanceable", name = "Panam Romanceable", desc = "Enables romance option with Panam" },
        { id = "sq027_panam_lover", name = "Panam Lover", desc = "Sets Panam as V's lover" },
        { id = "river_romanceable", name = "River Romanceable", desc = "Enables romance option with River" },
        { id = "sq029_river_lover", name = "River Lover", desc = "Sets River as V's lover" },
        { id = "kerry_romanceable", name = "Kerry Romanceable", desc = "Enables romance option with Kerry" },
        { id = "sq028_kerry_lover", name = "Kerry Lover", desc = "Sets Kerry as V's lover" }
    },

    StoryOutcomeFlags = {
        { id = "q105_fingers_beaten", name = "Fingers Beaten", desc = "Marks Fingers as beaten during The Space In Between" },
        { id = "q105_fingers_dead", name = "Fingers Dead", desc = "Marks Fingers as dead" },
        { id = "q005_jackie_stay_notell", name = "Jackie Stay (No Tell)", desc = "Jackie's body stays at Arasaka, Delamain doesn't tell Mama Welles" },
        { id = "q005_jackie_to_hospital", name = "Jackie to Hospital", desc = "Jackie's body sent to hospital" },
        { id = "q005_jackie_to_mama", name = "Jackie to Mama Welles", desc = "Jackie's body sent to Mama Welles" },
        { id = "q112_takemura_dead", name = "Takemura Dead", desc = "Marks Takemura as dead (not saved during Search and Destroy)" },
        { id = "sq032_johnny_friend", name = "Johnny Friend", desc = "Marks Johnny as V's friend" }
    },

    SmartWeaponStates = {
        { id = "mq007_skippy_aim_at_head", name = "Skippy: Headshot Mode", desc = "Forces Skippy to aim at heads" },
        { id = "mq007_skippy_goes_emo", name = "Skippy: Emo Mode", desc = "Skippy becomes emotional/annoying" }
    },

    GameplayToggles = {
        { id = "holo_delamain_deep_vehicle_talk", name = "Delamain Deep Talk", desc = "Enables deep conversation with Delamain in vehicle" },
        { id = "q101_enable_side_content", name = "Enable Side Content", desc = "Unlocks side content early" }
    },

    LifePathFlags = {
        { id = "q000_street_kid_background", name = "Street Kid Background", desc = "Sets lifepath to Street Kid" },
        { id = "q000_corpo_background", name = "Corpo Background", desc = "Sets lifepath to Corpo" },
        { id = "q000_nomad_background", name = "Nomad Background", desc = "Sets lifepath to Nomad" }
    },

    WorldEventFlags = {
        { id = "warden_amazon_airdropped", name = "Warden Airdropped", desc = "Warden weapon has been airdropped" },
        { id = "ajax_amazon_airdropped", name = "Ajax Airdropped", desc = "Ajax weapon has been airdropped" },
        { id = "crusher_amazon_airdropped", name = "Crusher Airdropped", desc = "Crusher weapon has been airdropped" },
        { id = "kyubi_amazon_airdropped", name = "Kyubi Airdropped", desc = "Kyubi weapon has been airdropped" },
        { id = "grit_amazon_airdropped", name = "Grit Airdropped", desc = "Grit weapon has been airdropped" },
        { id = "nekomata_amazon_airdropped", name = "Nekomata Airdropped", desc = "Nekomata weapon has been airdropped" },
        { id = "mws_wat_02_egg_placed", name = "Iguana Egg Placed", desc = "Iguana egg has been placed in apartment" },
        { id = "mws_wat_02_iguana_hatched", name = "Iguana Hatched", desc = "Iguana has hatched from egg" }
    },

    CensorshipFlags = {
        { id = "chensorship_drugs", name = "Censorship: Drugs", desc = "Censors drug-related content" },
        { id = "chensorship_gore", name = "Censorship: Gore", desc = "Censors gore and violence" },
        { id = "chensorship_homosexuality", name = "Censorship: Homosexuality", desc = "Censors homosexual content" },
        { id = "chensorship_nudity", name = "Censorship: Nudity", desc = "Censors nudity" },
        { id = "chensorship_oversexualized", name = "Censorship: Oversexualized", desc = "Censors oversexualized content" },
        { id = "chensorship_religion", name = "Censorship: Religion", desc = "Censors religious content" },
        { id = "chensorship_suggestive", name = "Censorship: Suggestive", desc = "Censors suggestive content" }
    }
}

local RelationshipTrackingFacts = { -- I wish I was in a relationship :(
    { id = "judy_relationship", name = "Judy Relationship" },
    { id = "panam_relationship", name = "Panam Relationship" },
    { id = "river_relationship", name = "River Relationship" },
    { id = "sq028_kerry_relationship", name = "Kerry Relationship" }
}

return {
    FactFlags = FactFlags,
    RelationshipTrackingFacts = RelationshipTrackingFacts
}
