Config = {}

Config.Debug = false

Config.ClothingCost = 100
Config.BarberCost = 100
Config.TattooCost = 100
Config.SurgeonCost = 100

Config.UseTarget = GetConvar("UseTarget", "false") == "true"
Config.UseRadialMenu = false

Config.EnablePedsForShops = true
Config.EnablePedsForClothingRooms = true
Config.EnablePedsForPlayerOutfitRooms = true

Config.EnablePedMenu = true
Config.PedMenuGroup = "admin"

Config.AlwaysKeepProps = false

Config.PersistUniforms = false -- Keeps Job / Gang Outfits on player reconnects / logout

Config.OnDutyOnlyClothingRooms = false -- Set to `true` to make the clothing rooms accessible only to players who are On Duty

-- ACE Permissions Config
Config.EnableACEPermissions = false
Config.ACEResetCooldown = 5000
Config.ACEListCooldown = 60 * 60 * 1000 -- 1 Hour

Config.DisableComponents = {
    Masks = false,
    UpperBody = false,
    LowerBody = false,
    Bags = false,
    Shoes = false,
    ScarfAndChains = false,
    BodyArmor = false,
    Shirts = false,
    Decals = false,
    Jackets = false
}

Config.DisableProps = {
    Hats = false,
    Glasses = false,
    Ear = false,
    Watches = false,
    Bracelets = false
}

Config.Blips = {
    ["clothing"] = {
        Show = true,
        Sprite = 366,
        Color = 47,
        Scale = 0.7,
        Name = "Clothing Store",
    },
    ["barber"] = {
        Show = true,
        Sprite = 71,
        Color = 0,
        Scale = 0.7,
        Name = "Barber",
    },
    ["tattoo"] = {
        Show = true,
        Sprite = 75,
        Color = 4,
        Scale = 0.7,
        Name = "Tattoo Shop",
    },
    ["surgeon"] = {
        Show = true,
        Sprite = 102,
        Color = 4,
        Scale = 0.7,
        Name = "Plastic Surgeon",
    }
}

Config.TargetConfig = {
    ["clothing"] = {
        model = "s_f_m_shop_high",
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        icon = "fas fa-tshirt",
        label = "Open Clothing Store",
        distance = 3
    },
    ["barber"] = {
        model = "s_m_m_hairdress_01",
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        icon = "fas fa-scissors",
        label = "Open Barber Shop",
        distance = 3
    },
    ["tattoo"] = {
        model = "u_m_y_tattoo_01",
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        icon = "fas fa-pen",
        label = "Open Tattoo Shop",
        distance = 3
    },
    ["surgeon"] = {
        model = "s_m_m_doctor_01",
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        icon = "fas fa-scalpel",
        label = "Open Surgeon",
        distance = 3
    },
    ["clothingroom"] = {
        model = "mp_g_m_pros_01",
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        icon = "fas fa-sign-in-alt",
        label = "Open Job / Gang Clothes Menu",
        distance = 3
    },
    ["playeroutfitroom"] = {
        model = "mp_g_m_pros_01",
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        icon = "fas fa-sign-in-alt",
        label = "Open Outfits Menu",
        distance = 3
    },
}

Config.Stores = {
    {
        shopType = "clothing",
        coords = vector4(1693.2, 4828.11, 42.07, 188.66),
        width = 4,
        length = 4,
        showBlip = true, -- showBlip overrides the blip visibilty configured above for the group
        zone = {
            shape = {
                vector2(1686.9018554688, 4829.8330078125),
                vector2(1698.8566894531, 4831.4604492188),
                vector2(1700.2448730469, 4817.7734375),
                vector2(1688.3682861328, 4816.2954101562)
            },
            minZ = 42.07 - 1.5,
            maxZ = 42.07 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-705.5, -149.22, 37.42, 122),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-719.86212158203, -147.83151245117),
                vector2(-709.10491943359, -141.53076171875),
                vector2(-699.94342041016, -157.44494628906),
                vector2(-710.68774414062, -163.64665222168)
            },
            minZ = 37.42 - 1.5,
            maxZ = 37.42 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-1192.61, -768.4, 17.32, 216.6),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-1206.9552001953, -775.06304931641),
                vector2(-1190.6080322266, -764.03198242188),
                vector2(-1184.5672607422, -772.16949462891),
                vector2(-1199.24609375, -783.07928466797)
            },
            minZ = 17.32 - 1.5,
            maxZ = 17.32 + 1.5,
        }
    },

    {
        shopType = "clothing",
        coords = vector4(425.91, -801.03, 29.49, 177.79),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(419.55020141602, -798.36547851562),
                vector2(431.61773681641, -798.31909179688),
                vector2(431.19784545898, -812.07122802734),
                vector2(419.140625, -812.03594970703)
            },
            minZ = 29.49 - 1.5,
            maxZ = 29.49 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-168.73, -301.41, 39.73, 238.67),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-160.82145690918, -313.85919189453),
                vector2(-172.56513977051, -309.82858276367),
                vector2(-166.5775604248, -292.48077392578),
                vector2(-154.84906005859, -296.51647949219)
            },
            minZ = 39.73 - 1.5,
            maxZ = 39.73 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(75.39, -1398.28, 29.38, 6.73),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(81.406135559082, -1400.7791748047),
                vector2(69.335029602051, -1400.8251953125),
                vector2(69.754981994629, -1387.078125),
                vector2(81.500122070312, -1387.3002929688)
            },
            minZ = 29.38 - 1.5,
            maxZ = 29.38 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-827.39, -1075.93, 11.33, 294.31),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-826.26251220703, -1082.6293945312),
                vector2(-832.27856445312, -1072.2819824219),
                vector2(-820.16442871094, -1065.7727050781),
                vector2(-814.08953857422, -1076.1878662109)
            },
            minZ = 11.33 - 1.5,
            maxZ = 11.33 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-1445.86, -240.78, 49.82, 36.17),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-1448.4829101562, -226.39401245117),
                vector2(-1439.2475585938, -234.70428466797),
                vector2(-1451.5389404297, -248.33193969727),
                vector2(-1460.7554931641, -240.02815246582)
            },
            minZ = 49.82 - 1.5,
            maxZ = 49.82 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(9.22, 6515.74, 31.88, 131.27),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(6.4955291748047, 6522.205078125),
                vector2(14.737417221069, 6513.3872070312),
                vector2(4.3691010475159, 6504.3452148438),
                vector2(-3.5187695026398, 6513.1538085938)
            },
            minZ = 31.88 - 1.5,
            maxZ = 31.88 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(615.35, 2762.72, 42.09, 170.51),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(612.58312988281, 2747.2814941406),
                vector2(612.26214599609, 2767.0520019531),
                vector2(622.37548828125, 2767.7614746094),
                vector2(623.66833496094, 2749.5180664062)
            },
            minZ = 42.09 - 1.5,
            maxZ = 42.09 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(1191.61, 2710.91, 38.22, 269.96),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(1188.7923583984, 2704.2021484375),
                vector2(1188.7498779297, 2716.2661132812),
                vector2(1202.4979248047, 2715.8479003906),
                vector2(1202.3558349609, 2703.9294433594)
            },
            minZ = 38.22 - 1.5,
            maxZ = 38.22 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-3171.32, 1043.56, 20.86, 334.3),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-3162.0075683594, 1056.7303466797),
                vector2(-3170.8247070312, 1039.0412597656),
                vector2(-3180.0979003906, 1043.1201171875),
                vector2(-3172.7292480469, 1059.8623046875)
            },
            minZ = 20.86 - 1.5,
            maxZ = 20.86 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-1105.52, 2707.79, 19.11, 317.19),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-1103.3004150391, 2700.8195800781),
                vector2(-1111.3771972656, 2709.884765625),
                vector2(-1100.8548583984, 2718.638671875),
                vector2(-1093.1976318359, 2709.7365722656)
            },
            minZ = 19.11 - 1.5,
            maxZ = 19.11 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(-1207.65, -1456.89, 4.37, 38.59),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(-1205.6013183594, -1458.033203125),
                vector2(-1206.1661376953, -1458.4085693359),
                vector2(-1207.8792724609, -1459.1596679688),
                vector2(-1207.5522460938, -1457.9649658203),
                vector2(-1206.0816650391, -1457.181640625)
            },
            minZ = 4.37 - 1.5,
            maxZ = 4.37 + 1.5,
        }
    },
    {
        shopType = "clothing",
        coords = vector4(124.82, -224.36, 54.56, 335.41),
        width = 4,
        length = 4,
        zone = {
            shape = {
                vector2(133.60948181152, -210.31390380859),
                vector2(125.8349609375, -228.48097229004),
                vector2(116.3140335083, -225.02020263672),
                vector2(122.56930541992, -207.83396911621)
            },
            minZ = 54.56 - 1.5,
            maxZ = 54.56 + 1.5,
        }
    },
    {
        shopType = "barber",
        coords = vector4(-814.22, -183.7, 37.57, 116.91),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(-825.06127929688, -182.67497253418),
                vector2(-808.82415771484, -179.19134521484),
                vector2(-808.55261230469, -184.9720916748),
                vector2(-819.77899169922, -191.81831359863)
            },
            minZ = 37.57 - 1.5,
            maxZ = 37.57 + 1.5,
        }
    },
    {
        shopType = "barber",
        coords = vector4(136.78, -1708.4, 29.29, 144.19),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(132.57008361816, -1710.5053710938),
                vector2(138.77899169922, -1702.6778564453),
                vector2(142.73052978516, -1705.6853027344),
                vector2(135.49719238281, -1712.9750976562)
            },
            minZ = 29.29 - 1.5,
            maxZ = 29.29 + 1.5,
        }
    },
    {
        shopType = "barber",
        coords = vector4(-1282.57, -1116.84, 6.99, 89.25),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(-1287.4735107422, -1115.4364013672),
                vector2(-1277.5638427734, -1115.1229248047),
                vector2(-1277.2469482422, -1120.1147460938),
                vector2(-1287.4561767578, -1119.2506103516)
            },
            minZ = 6.9 - 1.5,
            maxZ = 6.9 + 1.5,
        }
    },
    {
        shopType = "barber",
        coords = vector4(1931.41, 3729.73, 32.84, 212.08),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(1932.4931640625, 3725.3374023438),
                vector2(1927.2720947266, 3733.7663574219),
                vector2(1931.4379882812, 3736.5327148438),
                vector2(1936.0697021484, 3727.2839355469)
            },
            minZ = 32.8 - 1.5,
            maxZ = 32.8 + 1.5,
        }
    },
    {
        shopType = "barber",
        coords = vector4(1212.8, -472.9, 65.2, 60.94),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(1208.3327636719, -469.84338378906),
                vector2(1217.9066162109, -472.40216064453),
                vector2(1216.9870605469, -477.00939941406),
                vector2(1206.1077880859, -473.83499145508)
            },
            minZ = 65.2 - 1.5,
            maxZ = 65.2 + 1.5,
        }
    },
    {
        shopType = "barber",
        coords = vector4(-32.9, -152.3, 56.1, 335.22),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(-29.730783462524, -148.67495727539),
                vector2(-32.919719696045, -158.04254150391),
                vector2(-37.612594604492, -156.62759399414),
                vector2(-33.30192565918, -147.31649780273)
            },
            minZ = 56.1 - 1.5,
            maxZ = 56.1 + 1.5,
        }
    },
    {
        shopType = "barber",
        coords = vector4(-278.1, 6228.5, 30.7, 49.32),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(-280.29818725586, 6232.7265625),
                vector2(-273.06427001953, 6225.9692382812),
                vector2(-276.25280761719, 6222.4013671875),
                vector2(-282.98211669922, 6230.015625)
            },
            minZ = 30.7 - 1.5,
            maxZ = 30.7 + 1.5,
        }
    },
    {
        shopType = "tattoo",
        coords = vector4(1322.6, -1651.9, 51.2, 42.47),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(1323.9360351562, -1649.2370605469),
                vector2(1328.0186767578, -1654.3087158203),
                vector2(1322.5780029297, -1657.7045898438),
                vector2(1319.2043457031, -1653.0885009766)
            },
            minZ = 51.2 - 1.5,
            maxZ = 51.2 + 1.5,
        }
    },
    {
        shopType = "tattoo",
        coords = vector4(-1154.01, -1425.31, 4.95, 23.21),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(-1152.7110595703, -1422.8382568359),
                vector2(-1149.0043945312, -1428.1975097656),
                vector2(-1154.6730957031, -1431.1898193359),
                vector2(-1157.7064208984, -1426.3433837891)
            },
            minZ = 4.95 - 1.5,
            maxZ = 4.95 + 1.5,
        }
    },
    {
        shopType = "tattoo",
        coords = vector4(322.62, 180.34, 103.59, 156.2),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(319.28741455078, 179.9383392334),
                vector2(321.537109375, 186.04516601562),
                vector2(327.24526977539, 183.12303161621),
                vector2(325.01351928711, 177.8542175293)
            },
            minZ = 103.5 - 1.5,
            maxZ = 103.5 + 1.5,
        }
    },
    {
        shopType = "tattoo",
        coords = vector4(-3169.52, 1074.86, 20.83, 253.29),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(-3169.5861816406, 1072.3740234375),
                vector2(-3175.4802246094, 1075.0703125),
                vector2(-3172.2041015625, 1080.5860595703),
                vector2(-3167.076171875, 1078.0391845703)
            },
            minZ = 20.83 - 1.5,
            maxZ = 20.83 + 1.5,
        }
    },
    {
        shopType = "tattoo",
        coords = vector4(1864.1, 3747.91, 33.03, 17.23),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(1860.2752685547, 3750.1608886719),
                vector2(1866.390625, 3752.8081054688),
                vector2(1868.6164550781, 3747.3562011719),
                vector2(1863.65234375, 3744.5034179688)
            },
            minZ = 33.03 - 1.5,
            maxZ = 33.03 + 1.5,
        }
    },
    {
        shopType = "tattoo",
        coords = vector4(-294.24, 6200.12, 31.49, 195.72),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(-289.42239379883, 6198.68359375),
                vector2(-294.69515991211, 6194.5366210938),
                vector2(-298.23013305664, 6199.2451171875),
                vector2(-294.1501159668, 6203.2700195312)
            },
            minZ = 31.49 - 1.5,
            maxZ = 31.49 + 1.5,
        }
    },
    {
        shopType = "surgeon",
        coords = vector4(298.78, -572.81, 43.26, 114.27),
        width = 2,
        length = 2,
        zone = {
            shape = {
                vector2(298.84417724609, -572.92205810547),
                vector2(296.39556884766, -575.65942382812),
                vector2(293.56317138672, -572.60675048828),
                vector2(296.28656005859, -570.330078125)
            },
            minZ = 43.26 - 1.5,
            maxZ = 43.26 + 1.5,
        }
    }
}

Config.ClothingRooms = {
    {
        job = "police",
        coords = vector4(454.91, -990.89, 30.69, 193.4),
        width = 3,
        length = 3,
        zone = {
            shape = {
                vector2(460.41918945312, -993.11444091797),
                vector2(449.39508056641, -993.60614013672),
                vector2(449.88696289062, -990.23779296875),
                vector2(450.97882080078, -989.71411132812),
                vector2(451.0325012207, -987.89904785156),
                vector2(453.47863769531, -987.76928710938),
                vector2(454.35513305664, -988.46459960938),
                vector2(460.4231262207, -987.94573974609)
            },
            minZ = 30.69 - 1.5,
            maxZ = 30.69 + 1.5,
        }
    }
}


Config.PlayerOutfitRooms = {
    -- Sample outfit room config
--[[
    {
        coords = vector4(287.28, -573.41, 43.16, 79.61),
        width = 3,
        length = 3,
        citizenIDs = {
            "BHH65156",
        }
    },
    ]]--
}

Config.Outfits = {
    ["police"] = {
        ["male"] = {
            {
                outfitLabel = "Short Sleeve",
                outfitData = {
                    ["pants"] = {item = 24, texture = 0}, -- Pants
                    ["arms"] = {item = 19, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 58, texture = 0}, -- T Shirt
                    ["vest"] = {item = 0, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 55, texture = 0}, -- Jacket
                    ["shoes"] = {item = 51, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = -1, texture = -1}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            {
                outfitLabel = "Trooper Tan",
                outfitData = {
                    ["pants"] = {item = 24, texture = 0}, -- Pants
                    ["arms"] = {item = 20, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 58, texture = 0}, -- T Shirt
                    ["vest"] = {item = 0, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 317, texture = 3}, -- Jacket
                    ["shoes"] = {item = 51, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = 58, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            {
                outfitLabel = "Long Sleeve",
                outfitData = {
                    ["pants"] = {item = 24, texture = 0}, -- Pants
                    ["arms"] = {item = 20, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 58, texture = 0}, -- T Shirt
                    ["vest"] = {item = 0, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 317, texture = 0}, -- Jacket
                    ["shoes"] = {item = 51, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = -1, texture = -1}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {1, 2, 3, 4},
            },
            {
                outfitLabel = "Trooper Black",
                outfitData = {
                    ["pants"] = {item = 24, texture = 0}, -- Pants
                    ["arms"] = {item = 20, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 58, texture = 0}, -- T Shirt
                    ["vest"] = {item = 0, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 317, texture = 8}, -- Jacket
                    ["shoes"] = {item = 51, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = 58, texture = 3}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {2, 3, 4},
            },
            {
                outfitLabel = "SWAT",
                outfitData = {
                    ["pants"] = {item = 130, texture = 1}, -- Pants
                    ["arms"] = {item = 172, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 15, texture = 0}, -- T Shirt
                    ["vest"] = {item = 15, texture = 2}, -- Body Vest
                    ["torso2"] = {item = 336, texture = 3}, -- Jacket
                    ["shoes"] = {item = 24, texture = 0}, -- Shoes
                    ["accessory"] = {item = 133, texture = 0}, -- Neck Accessory
                    ["hat"] = {item = 150, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 52, texture = 0} -- Mask
                },
                grades = {3, 4},
            }
        },
        ["female"] = {
            {
                outfitLabel = "Short Sleeve",
                outfitData = {
                    ["pants"] = {item = 133, texture = 0}, -- Pants
                    ["arms"] = {item = 31, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 35, texture = 0}, -- T Shirt
                    ["vest"] = {item = 34, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 48, texture = 0}, -- Jacket
                    ["shoes"] = {item = 52, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = 0, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            {
                outfitLabel = "Trooper Tan",
                outfitData = {
                    ["pants"] = {item = 133, texture = 0}, -- Pants
                    ["arms"] = {item = 31, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 35, texture = 0}, -- T Shirt
                    ["vest"] = {item = 34, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 327, texture = 3}, -- Jacket
                    ["shoes"] = {item = 52, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = 0, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            {
                outfitLabel = "Long Sleeve",
                outfitData = {
                    ["pants"] = {item = 133, texture = 0}, -- Pants
                    ["arms"] = {item = 31, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 35, texture = 0}, -- T Shirt
                    ["vest"] = {item = 34, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 327, texture = 0}, -- Jacket
                    ["shoes"] = {item = 52, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = 0, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {1, 2, 3, 4},
            },
            {
                outfitLabel = "Trooper Black",
                outfitData = {
                    ["pants"] = {item = 133, texture = 0}, -- Pants
                    ["arms"] = {item = 31, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 35, texture = 0}, -- T Shirt
                    ["vest"] = {item = 34, texture = 0}, -- Body Vest
                    ["torso2"] = {item = 327, texture = 8}, -- Jacket
                    ["shoes"] = {item = 52, texture = 0}, -- Shoes
                    ["accessory"] = {item = 0, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = 0, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 0, texture = 0} -- Mask
                },
                grades = {2, 3, 4},
            },
            {
                outfitLabel = "SWAT",
                outfitData = {
                    ["pants"] = {item = 135, texture = 1}, -- Pants
                    ["arms"] = {item = 213, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 0, texture = 0}, -- T Shirt
                    ["vest"] = {item = 17, texture = 2}, -- Body Vest
                    ["torso2"] = {item = 327, texture = 8}, -- Jacket
                    ["shoes"] = {item = 52, texture = 0}, -- Shoes
                    ["accessory"] = {item = 102, texture = 0}, -- Neck Accessory
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["hat"] = {item = 149, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["mask"] = {item = 35, texture = 0} -- Mask
                },
                grades = {3, 4},
            }
        }
    },
    ["realestate"] = {
        ["male"] = {
            {
                -- Outfits
                outfitLabel = "Worker",
                outfitData = {
                    ["pants"]       = { item = 28, texture = 0},  -- Pants
                    ["arms"]        = { item = 1, texture = 0},  -- Arms
                    ["t-shirt"]     = { item = 31, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 294, texture = 0},  -- Jacket
                    ["shoes"]       = { item = 10, texture = 0},  -- Shoes
                    ["accessory"]   = { item = 0, texture = 0},  -- Neck Accessory
                    ["bag"]         = { item = 0, texture = 0},  -- Bag
                    ["hat"]         = { item = 12, texture = -1},  -- Hat
                    ["glass"]       = { item = 0, texture = 0},  -- Glasses
                    ["mask"]        = { item = 0, texture = 0},  -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            }
        },
        ["female"] = {
            {
                outfitLabel = "Worker",
                outfitData = {
                    ["pants"]       = { item = 57, texture = 2},  -- Pants
                    ["arms"]        = { item = 0, texture = 0},  -- Arms
                    ["t-shirt"]     = { item = 34, texture = 0},  -- T Shirt
                    ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                    ["torso2"]      = { item = 105, texture = 7},  -- Jacket
                    ["shoes"]       = { item = 8, texture = 5},  -- Shoes
                    ["accessory"]   = { item = 11, texture = 3},  -- Neck Accessory
                    ["bag"]         = { item = 0, texture = 0},  -- Bag
                    ["hat"]         = { item = -1, texture = -1},  -- Hat
                    ["glass"]       = { item = 0, texture = 0},  -- Glasses
                    ["mask"]        = { item = 0, texture = 0},  -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            }
        }
    },
    ["ambulance"] = {
        ["male"] = {
            {
                outfitLabel = "T-Shirt",
                outfitData = {
                    ["arms"] = {item = 85, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 129, texture = 0}, -- T-Shirt
                    ["torso2"] = {item = 250, texture = 0}, -- Jackets
                    ["vest"] = {item = 0, texture = 0}, -- Vest
                    ["decals"] = {item = 58, texture = 0}, -- Decals
                    ["accessory"] = {item = 127, texture = 0}, -- Neck
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["pants"] = {item = 96, texture = 0}, -- Pants
                    ["shoes"] = {item = 54, texture = 0}, -- Shoes
                    ["mask"] = {item = 121, texture = 0}, -- Mask
                    ["hat"] = {item = 122, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["ear"] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {0, 1, 2, 3, 4},
            },
            {
                outfitLabel = "Polo",
                outfitData = {
                    ["arms"] = {item = 90, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 15, texture = 0}, -- T-Shirt
                    ["torso2"] = {item = 249, texture = 0}, -- Jackets
                    ["vest"] = {item = 0, texture = 0}, -- Vest
                    ["decals"] = {item = 57, texture = 0}, -- Decals
                    ["accessory"] = {item = 126, texture = 0}, -- Neck
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["pants"] = {item = 96, texture = 0}, -- Pants
                    ["shoes"] = {item = 54, texture = 0}, -- Shoes
                    ["mask"] = {item = 121, texture = 0}, -- Mask
                    ["hat"] = {item = 122, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["ear"] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {2, 3, 4},
            },
            {
                outfitLabel = "Doctor",
                outfitData = {
                    ["arms"] = {item = 93, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 32, texture = 3}, -- T-Shirt
                    ["torso2"] = {item = 31, texture = 7}, -- Jackets
                    ["vest"] = {item = 0, texture = 0}, -- Vest
                    ["decals"] = {item = 0, texture = 0}, -- Decals
                    ["accessory"] = {item = 126, texture = 0}, -- Neck
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["pants"] = {item = 28, texture = 0}, -- Pants
                    ["shoes"] = {item = 10, texture = 0}, -- Shoes
                    ["mask"] = {item = 0, texture = 0}, -- Mask
                    ["hat"] = {item = -1, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["ear"] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {3, 4},
            }
        },
        ["female"] = {
            {
                outfitLabel = "T-Shirt",
                outfitData = {
                    ["arms"] = {item = 109, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 159, texture = 0}, -- T-Shirt
                    ["torso2"] = {item = 258, texture = 0}, -- Jackets
                    ["vest"] = {item = 0, texture = 0}, -- Vest
                    ["decals"] = {item = 66, texture = 0}, -- Decals
                    ["accessory"] = {item = 97, texture = 0}, -- Neck
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["pants"] = {item = 99, texture = 0}, -- Pants
                    ["shoes"] = {item = 55, texture = 0}, -- Shoes
                    ["mask"] = {item = 121, texture = 0}, -- Mask
                    ["hat"] = {item = 121, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["ear"] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {0, 1, 2, 3, 4},
            },
            {
                outfitLabel = "Polo",
                outfitData = {
                    ["arms"] = {item = 105, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 13, texture = 0}, -- T-Shirt
                    ["torso2"] = {item = 257, texture = 0}, -- Jackets
                    ["vest"] = {item = 0, texture = 0}, -- Vest
                    ["decals"] = {item = 65, texture = 0}, -- Decals
                    ["accessory"] = {item = 96, texture = 0}, -- Neck
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["pants"] = {item = 99, texture = 0}, -- Pants
                    ["shoes"] = {item = 55, texture = 0}, -- Shoes
                    ["mask"] = {item = 121, texture = 0}, -- Mask
                    ["hat"] = {item = 121, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["ear"] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {2, 3, 4},
            },
            {
                outfitLabel = "Doctor",
                outfitData = {
                    ["arms"] = {item = 105, texture = 0}, -- Arms
                    ["t-shirt"] = {item = 39, texture = 3}, -- T-Shirt
                    ["torso2"] = {item = 7, texture = 1}, -- Jackets
                    ["vest"] = {item = 0, texture = 0}, -- Vest
                    ["decals"] = {item = 0, texture = 0}, -- Decals
                    ["accessory"] = {item = 96, texture = 0}, -- Neck
                    ["bag"] = {item = 0, texture = 0}, -- Bag
                    ["pants"] = {item = 34, texture = 0}, -- Pants
                    ["shoes"] = {item = 29, texture = 0}, -- Shoes
                    ["mask"] = {item = 0, texture = 0}, -- Mask
                    ["hat"] = {item = -1, texture = 0}, -- Hat
                    ["glass"] = {item = 0, texture = 0}, -- Glasses
                    ["ear"] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {3, 4},
            }
        }
    }
}

Config.InitialPlayerClothes = {
    Male = {
        Components = {
            {
                component_id = 0, -- Face
                drawable = 0,
                texture = 0
            },
            {
                component_id = 1, -- Mask
                drawable = 0,
                texture = 0
            },
            {
                component_id = 2, -- Hair
                drawable = 0,
                texture = 0
            },
            {
                component_id = 3, -- Upper Body
                drawable = 0,
                texture = 0
            },
            {
                component_id = 4, -- Lower Body
                drawable = 0,
                texture = 0
            },
            {
                component_id = 5, -- Bag
                drawable = 0,
                texture = 0
            },
            {
                component_id = 6, -- Shoes
                drawable = 0,
                texture = 0
            },
            {
                component_id = 7, -- Scarf & Chains
                drawable = 0,
                texture = 0
            },
            {
                component_id = 8, -- Shirt
                drawable = 0,
                texture = 0
            },
            {
                component_id = 9, -- Body Armor
                drawable = 0,
                texture = 0
            },
            {
                component_id = 10, -- Decals
                drawable = 0,
                texture = 0
            },
            {
                component_id = 11, -- Jacket
                drawable = 0,
                texture = 0
            }
        },
        Props = {
            {
                prop_id = 0, -- Hat
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 1, -- Glasses
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 2, -- Ear
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 6, -- Watch
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 7, -- Bracelet
                drawable = -1,
                texture = -1
            }
        },
        Hair = {
            color = 0,
            highlight = 0,
            style = 0,
            texture = 0
        }
    },
    Female = {
        Components = {
            {
                component_id = 0, -- Face
                drawable = 0,
                texture = 0
            },
            {
                component_id = 1, -- Mask
                drawable = 0,
                texture = 0
            },
            {
                component_id = 2, -- Hair
                drawable = 0,
                texture = 0
            },
            {
                component_id = 3, -- Upper Body
                drawable = 0,
                texture = 0
            },
            {
                component_id = 4, -- Lower Body
                drawable = 0,
                texture = 0
            },
            {
                component_id = 5, -- Bag
                drawable = 0,
                texture = 0
            },
            {
                component_id = 6, -- Shoes
                drawable = 0,
                texture = 0
            },
            {
                component_id = 7, -- Scarf & Chains
                drawable = 0,
                texture = 0
            },
            {
                component_id = 8, -- Shirt
                drawable = 0,
                texture = 0
            },
            {
                component_id = 9, -- Body Armor
                drawable = 0,
                texture = 0
            },
            {
                component_id = 10, -- Decals
                drawable = 0,
                texture = 0
            },
            {
                component_id = 11, -- Jacket
                drawable = 0,
                texture = 0
            }
        },
        Props = {
            {
                prop_id = 0, -- Hat
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 1, -- Glasses
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 2, -- Ear
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 6, -- Watch
                drawable = -1,
                texture = -1
            },
            {
                prop_id = 7, -- Bracelet
                drawable = -1,
                texture = -1
            }
        },
        Hair = {
            color = 0,
            highlight = 0,
            style = 0,
            texture = 0
        }
    }
}
