Config = {
     lan               = "en",
     PedRenderDistance = 80.0,
     target            = true,
     eventPrefix       = "mhScripts"
}

Config.MHAdminSystem = GetResourceState("mate-admin") == "started"

Config.ApprovedLicenses = {
     "license:123",
     "fivem:123",
     "discord:123",
     "live:123",
     "steam:123",
     "xbl:123"
}

Config.Grid = {
     cellSize = 0.8
}

Config.WaterDecay = 2000 -- In every 2 secounds

Config.Props = {
     WateringCan = {
          model = "prop_wateringcan",
     }
}

Config.Animations = {
     Watering = {
           dict = "amb@world_human_gardener_leaf_blower@base",
           anim = "base"
     }
}

Loc = {}
