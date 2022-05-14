Config = {}

Config.Debug = false

Config.ped = true

Config.ClothingCost = 100
Config.BarberCost = 100
Config.TattooCost = 100
Config.SurgeonCost = 100

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.EnablePedMenu = true
Config.PedMenuGroup = 'admin'

Config.AlwaysKeepProps = false

Config.Blips = {
    ['clothing'] = {
        Show = true,
        Sprite = 366,
        Color = 47,
        Scale = 0.7,
        Name = "Clothing Store",
    },
    ['barber'] = {
        Show = true,
        Sprite = 71,
        Color = 0,
        Scale = 0.7,
        Name = "Barber",
    },
    ['tattoo'] = {
        Show = true,
        Sprite = 75,
        Color = 4,
        Scale = 0.7,
        Name = "Tattoo Shop",
    },
    ['surgeon'] = {
        Show = true,
        Sprite = 102,
        Color = 4,
        Scale = 0.7,
        Name = "Plastic Surgeon",
    }
}

Config.Stores = {
    [1] = {shopType = 'clothing', coords = vector4(1693.92, 4830.82, 42.07, 240), width = 4, length = 4, showBlip = true}, -- showBlip overrides the blip visibilty configured above for the group
    [2] = {shopType = 'clothing', coords = vector4(-713.13, -153.44, 36.95, 250), width = 4, length = 4},
    [3] = {shopType = 'clothing', coords = vector4(-1192.25, -772.26, 18.54,250), width = 4, length = 5},
    [4] = {shopType = 'clothing', coords = vector4(425.91, -801.03, 29.49,250), width = 4, length = 4},
    [5] = {shopType = 'clothing', coords = vector4(-161.02, -305.14, 41.26,250), width = 4, length = 4},
    [6] = {shopType = 'clothing', coords = vector4(74.35, -1400.78, 29.38,250), width = 4, length = 4},
    [7] = {shopType = 'clothing', coords = vector4(-827.39, -1075.93, 11.33,250), width = 4, length = 4},
    [8] = {shopType = 'clothing', coords = vector4(-1452.52, -234.81, 49.8,250), width = 4, length = 4},
    [9] = {shopType = 'clothing', coords = vector4(11.0, 6517.29, 31.88,250), width = 4, length = 4},
    [10] = {shopType = 'clothing', coords = vector4(617.65, 2761.19, 42.09,250), width = 4, length = 4},
    [11] = {shopType = 'clothing', coords = vector4(1188.76, 2710.7, 38.22,250), width = 4, length = 4},
    [12] = {shopType = 'clothing', coords = vector4(-3171.32, 1043.56, 20.86,250), width = 4, length = 4},
    [13] = {shopType = 'clothing', coords = vector4(-1105.52, 2707.79, 19.11,250), width = 4, length = 4},
    [14] = {shopType = 'clothing', coords = vector4(-1207.65, -1456.89, 4.37,250), width = 4, length = 4},
    [15] = {shopType = 'clothing', coords = vector4(124.82, -224.36, 54.56,250), width = 2, length = 2},
    [16] = {shopType = 'barber', coords = vector4(-814.3, -183.8, 36.6,250), width = 2, length = 2},
    [17] = {shopType = 'barber', coords = vector4(136.8, -1708.4, 28.3,250), width = 2, length = 2},
    [18] = {shopType = 'barber', coords = vector4(-1282.6, -1116.8, 6.0,250), width = 2, length = 2},
    [19] = {shopType = 'barber', coords = vector4(1931.5, 3729.7, 31.8,250), width = 2, length = 2},
    [20] = {shopType = 'barber', coords = vector4(1212.8, -472.9, 65.2,250), width = 2, length = 2},
    [21] = {shopType = 'barber', coords = vector4(-32.9, -152.3, 56.1,250), width = 2, length = 2},
    [22] = {shopType = 'barber', coords = vector4(-278.1, 6228.5, 30.7,250), width = 2, length = 2},
    [23] = {shopType = 'tattoo', coords = vector4(1322.6, -1651.9, 51.2,250), width = 2, length = 2},
    [24] = {shopType = 'tattoo', coords = vector4(-1153.6, -1425.6, 4.9,250), width = 2, length = 2},
    [25] = {shopType = 'tattoo', coords = vector4(322.1, 180.4, 103.5,250), width = 2, length = 2},
    [26] = {shopType = 'tattoo', coords = vector4(-3170.0, 1075.0, 20.8,250), width = 2, length = 2},
    [27] = {shopType = 'tattoo', coords = vector4(1864.6, 3747.7, 33.0,250), width = 2, length = 2},
    [28] = {shopType = 'tattoo', coords = vector4(-293.7, 6200.0, 31.4,250), width = 2, length = 2},
    [29] = {shopType = 'surgeon', coords = vector4(311.33, -570.48, 42.28,250),width = 2, length = 2},
}

Config.ClothingRooms = {
    [1] = {requiredJob = "police", isGang = false, coords = vector3(463.43, -999.07, 30.69), width = 3, length = 3},
    --[2] = {requiredJob = "police", isGang = false, coords = vector3(454.43, -988.85, 30.69), width = 2, length = 2},
    [2] = {requiredJob = "police", isGang = false, coords = vector3(301.3, -599.04, 43.28), width = 3, length = 3}, -- Right double door in Hospital Map that is on QBCore GitHub
    --[3] = {requiredJob = "police", coords = vector3(314.76, 671.78, 14.73)},
    --[3] = {requiredJob = "ambulance", coords = vector3(338.70, 659.61, 14.71)},    
    --[4] = {requiredJob = "ambulance", coords = vector3(-1098.45, 1751.71, 23.35)},    
    --[6] = {requiredJob = "police", coords = vector3(-77.59, -129.17, 5.03)},
}


Config.PlayerOutfitRooms = {
    -- Sample outfit room config
--[[
    [1] = {
        coords = vector3(287.29, -573.41, 43.17),
        width = 3,
        length = 3,
        citizenIDs = {
            "BHH65156",
        }
    },
    ]]--
}

Config.Outfits = {
    ['police'] = {
        ['male'] = {
            [1] = {
                outfitLabel = 'Short Sleeve',
                outfitData = {
                    ['pants'] = {item = 24, texture = 0}, -- Pants
                    ['arms'] = {item = 19, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 58, texture = 0}, -- T Shirt
                    ['vest'] = {item = 0, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 55, texture = 0}, -- Jacket
                    ['shoes'] = {item = 51, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = -1, texture = -1}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            [2] = {
                outfitLabel = 'Trooper Tan',
                outfitData = {
                    ['pants'] = {item = 24, texture = 0}, -- Pants
                    ['arms'] = {item = 20, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 58, texture = 0}, -- T Shirt
                    ['vest'] = {item = 0, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 317, texture = 3}, -- Jacket
                    ['shoes'] = {item = 51, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = 58, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            [3] = {
                outfitLabel = 'Long Sleeve',
                outfitData = {
                    ['pants'] = {item = 24, texture = 0}, -- Pants
                    ['arms'] = {item = 20, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 58, texture = 0}, -- T Shirt
                    ['vest'] = {item = 0, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 317, texture = 0}, -- Jacket
                    ['shoes'] = {item = 51, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = -1, texture = -1}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {1, 2, 3, 4},
            },
            [4] = {
                outfitLabel = 'Trooper Black',
                outfitData = {
                    ['pants'] = {item = 24, texture = 0}, -- Pants
                    ['arms'] = {item = 20, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 58, texture = 0}, -- T Shirt
                    ['vest'] = {item = 0, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 317, texture = 8}, -- Jacket
                    ['shoes'] = {item = 51, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = 58, texture = 3}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {2, 3, 4},
            },
            [5] = {
                outfitLabel = 'SWAT',
                outfitData = {
                    ['pants'] = {item = 130, texture = 1}, -- Pants
                    ['arms'] = {item = 172, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 15, texture = 0}, -- T Shirt
                    ['vest'] = {item = 15, texture = 2}, -- Body Vest
                    ['torso2'] = {item = 336, texture = 3}, -- Jacket
                    ['shoes'] = {item = 24, texture = 0}, -- Shoes
                    ['accessory'] = {item = 133, texture = 0}, -- Neck Accessory
                    ['hat'] = {item = 150, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 52, texture = 0} -- Mask
                },
                grades = {3, 4},
            }
        },
        ['female'] = {
            [1] = {
                outfitLabel = 'Short Sleeve',
                outfitData = {
                    ['pants'] = {item = 133, texture = 0}, -- Pants
                    ['arms'] = {item = 31, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 35, texture = 0}, -- T Shirt
                    ['vest'] = {item = 34, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 48, texture = 0}, -- Jacket
                    ['shoes'] = {item = 52, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = 0, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            [2] = {
                outfitLabel = 'Trooper Tan',
                outfitData = {
                    ['pants'] = {item = 133, texture = 0}, -- Pants
                    ['arms'] = {item = 31, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 35, texture = 0}, -- T Shirt
                    ['vest'] = {item = 34, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 327, texture = 3}, -- Jacket
                    ['shoes'] = {item = 52, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = 0, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {0, 1, 2, 3, 4},
            },
            [3] = {
                outfitLabel = 'Long Sleeve',
                outfitData = {
                    ['pants'] = {item = 133, texture = 0}, -- Pants
                    ['arms'] = {item = 31, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 35, texture = 0}, -- T Shirt
                    ['vest'] = {item = 34, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 327, texture = 0}, -- Jacket
                    ['shoes'] = {item = 52, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = 0, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {1, 2, 3, 4},
            },
            [4] = {
                outfitLabel = 'Trooper Black',
                outfitData = {
                    ['pants'] = {item = 133, texture = 0}, -- Pants
                    ['arms'] = {item = 31, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 35, texture = 0}, -- T Shirt
                    ['vest'] = {item = 34, texture = 0}, -- Body Vest
                    ['torso2'] = {item = 327, texture = 8}, -- Jacket
                    ['shoes'] = {item = 52, texture = 0}, -- Shoes
                    ['accessory'] = {item = 0, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = 0, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 0, texture = 0} -- Mask
                },
                grades = {2, 3, 4},
            },
            [5] = {
                outfitLabel = 'SWAT',
                outfitData = {
                    ['pants'] = {item = 135, texture = 1}, -- Pants
                    ['arms'] = {item = 213, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 0, texture = 0}, -- T Shirt
                    ['vest'] = {item = 17, texture = 2}, -- Body Vest
                    ['torso2'] = {item = 327, texture = 8}, -- Jacket
                    ['shoes'] = {item = 52, texture = 0}, -- Shoes
                    ['accessory'] = {item = 102, texture = 0}, -- Neck Accessory
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['hat'] = {item = 149, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['mask'] = {item = 35, texture = 0} -- Mask
                },
                grades = {3, 4},
            }
        }
    },
    ['realestate'] = {
        ['male'] = {
            [1] = {
                -- Outfits
                outfitLabel = 'Worker',
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
        ['female'] = {
            [1] = {
                outfitLabel = 'Worker',
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
    ['ambulance'] = {
        ['male'] = {
            [1] = {
                outfitLabel = 'T-Shirt',
                outfitData = {
                    ['arms'] = {item = 85, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 129, texture = 0}, -- T-Shirt
                    ['torso2'] = {item = 250, texture = 0}, -- Jackets
                    ['vest'] = {item = 0, texture = 0}, -- Vest
                    ['decals'] = {item = 58, texture = 0}, -- Decals
                    ['accessory'] = {item = 127, texture = 0}, -- Neck
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['pants'] = {item = 96, texture = 0}, -- Pants
                    ['shoes'] = {item = 54, texture = 0}, -- Shoes
                    ['mask'] = {item = 121, texture = 0}, -- Mask
                    ['hat'] = {item = 122, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['ear'] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {0, 1, 2, 3, 4},
            },
            [2] = {
                outfitLabel = 'Polo',
                outfitData = {
                    ['arms'] = {item = 90, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 15, texture = 0}, -- T-Shirt
                    ['torso2'] = {item = 249, texture = 0}, -- Jackets
                    ['vest'] = {item = 0, texture = 0}, -- Vest
                    ['decals'] = {item = 57, texture = 0}, -- Decals
                    ['accessory'] = {item = 126, texture = 0}, -- Neck
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['pants'] = {item = 96, texture = 0}, -- Pants
                    ['shoes'] = {item = 54, texture = 0}, -- Shoes
                    ['mask'] = {item = 121, texture = 0}, -- Mask
                    ['hat'] = {item = 122, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['ear'] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {2, 3, 4},
            },
            [3] = {
                outfitLabel = 'Doctor',
                outfitData = {
                    ['arms'] = {item = 93, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 32, texture = 3}, -- T-Shirt
                    ['torso2'] = {item = 31, texture = 7}, -- Jackets
                    ['vest'] = {item = 0, texture = 0}, -- Vest
                    ['decals'] = {item = 0, texture = 0}, -- Decals
                    ['accessory'] = {item = 126, texture = 0}, -- Neck
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['pants'] = {item = 28, texture = 0}, -- Pants
                    ['shoes'] = {item = 10, texture = 0}, -- Shoes
                    ['mask'] = {item = 0, texture = 0}, -- Mask
                    ['hat'] = {item = -1, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['ear'] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {3, 4},
            }
        },
        ['female'] = {
            [1] = {
                outfitLabel = 'T-Shirt',
                outfitData = {
                    ['arms'] = {item = 109, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 159, texture = 0}, -- T-Shirt
                    ['torso2'] = {item = 258, texture = 0}, -- Jackets
                    ['vest'] = {item = 0, texture = 0}, -- Vest
                    ['decals'] = {item = 66, texture = 0}, -- Decals
                    ['accessory'] = {item = 97, texture = 0}, -- Neck
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['pants'] = {item = 99, texture = 0}, -- Pants
                    ['shoes'] = {item = 55, texture = 0}, -- Shoes
                    ['mask'] = {item = 121, texture = 0}, -- Mask
                    ['hat'] = {item = 121, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['ear'] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {0, 1, 2, 3, 4},
            },
            [2] = {
                outfitLabel = 'Polo',
                outfitData = {
                    ['arms'] = {item = 105, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 13, texture = 0}, -- T-Shirt
                    ['torso2'] = {item = 257, texture = 0}, -- Jackets
                    ['vest'] = {item = 0, texture = 0}, -- Vest
                    ['decals'] = {item = 65, texture = 0}, -- Decals
                    ['accessory'] = {item = 96, texture = 0}, -- Neck
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['pants'] = {item = 99, texture = 0}, -- Pants
                    ['shoes'] = {item = 55, texture = 0}, -- Shoes
                    ['mask'] = {item = 121, texture = 0}, -- Mask
                    ['hat'] = {item = 121, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['ear'] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {2, 3, 4},
            },
            [3] = {
                outfitLabel = 'Doctor',
                outfitData = {
                    ['arms'] = {item = 105, texture = 0}, -- Arms
                    ['t-shirt'] = {item = 39, texture = 3}, -- T-Shirt
                    ['torso2'] = {item = 7, texture = 1}, -- Jackets
                    ['vest'] = {item = 0, texture = 0}, -- Vest
                    ['decals'] = {item = 0, texture = 0}, -- Decals
                    ['accessory'] = {item = 96, texture = 0}, -- Neck
                    ['bag'] = {item = 0, texture = 0}, -- Bag
                    ['pants'] = {item = 34, texture = 0}, -- Pants
                    ['shoes'] = {item = 29, texture = 0}, -- Shoes
                    ['mask'] = {item = 0, texture = 0}, -- Mask
                    ['hat'] = {item = -1, texture = 0}, -- Hat
                    ['glass'] = {item = 0, texture = 0}, -- Glasses
                    ['ear'] = {item = 0, texture = 0} -- Ear accessories
                },
                grades = {3, 4},
            }
        }
    }
}
