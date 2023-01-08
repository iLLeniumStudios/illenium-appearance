if not Framework.ESX() then return end

function Framework.ConvertComponents(oldSkin, components)
    return {
        {
            component_id = 0,
            drawable = (components and components[1].drawable) or 0,
            texture = (components and components[1].texture) or 0
        },
        {
            component_id = 1,
            drawable = oldSkin.mask_1 or (components and components[2].drawable) or 0,
            texture = oldSkin.mask_2 or (components and components[2].texture) or 0
        },
        {
            component_id = 2,
            drawable = (components and components[3].drawable) or 0,
            texture = (components and components[3].texture) or 0
        },
        {
            component_id = 3,
            drawable = oldSkin.arms or (components and components[4].drawable) or 0,
            texture = oldSkin.arms_2 or (components and components[4].texture) or 0,
        },
        {
            component_id = 4,
            drawable = oldSkin.pants_1 or (components and components[5].drawable) or 0,
            texture = oldSkin.pants_2 or (components and components[5].texture) or 0
        },
        {
            component_id = 5,
            drawable = oldSkin.bags_1 or (components and components[6].drawable) or 0,
            texture = oldSkin.bags_2 or (components and components[6].texture) or 0
        },
        {
            component_id = 6,
            drawable = oldSkin.shoes_1 or (components and components[7].drawable) or 0,
            texture = oldSkin.shoes_2 or (components and components[7].texture) or 0
        },
        {
            component_id = 7,
            drawable = oldSkin.chain_1 or (components and components[8].drawable) or 0,
            texture = oldSkin.chain_2 or (components and components[8].texture) or 0
        },
        {
            component_id = 8,
            drawable = oldSkin.tshirt_1 or (components and components[9].drawable) or 0,
            texture = oldSkin.tshirt_2 or (components and components[9].texture) or 0
        },
        {
            component_id = 9,
            drawable = oldSkin.bproof_1 or (components and components[10].drawable) or 0,
            texture = oldSkin.bproof_2 or (components and components[10].texture) or 0
        },
        {
            component_id = 10,
            drawable = oldSkin.decals_1 or (components and components[11].drawable) or 0,
            texture = oldSkin.decals_2 or (components and components[11].texture) or 0
        },
        {
            component_id = 11,
            drawable = oldSkin.torso_1 or (components and components[12].drawable) or 0,
            texture = oldSkin.torso_2 or (components and components[12].texture) or 0
        }
    }
end

function Framework.ConvertProps(oldSkin, props)
    return {
        {
            texture = oldSkin.helmet_2 or (props and props[1].texture) or -1,
            drawable = oldSkin.helmet_1 or (props and props[1].drawable) or -1,
            prop_id = 0
        },
        {
            texture = oldSkin.glasses_2 or (props and props[2].texture) or -1,
            drawable = oldSkin.glasses_1 or (props and props[2].drawable) or -1,
            prop_id = 1
        },
        {
            texture = oldSkin.ears_2 or (props and props[3].texture) or -1,
            drawable = oldSkin.ears_1 or (props and props[3].drawable) or -1,
            prop_id = 2
        },
        {
            texture = oldSkin.watches_2 or (props and props[4].texture) or -1,
            drawable = oldSkin.watches_1 or (props and props[4].drawable) or -1,
            prop_id = 6
        },
        {
            texture = oldSkin.bracelets_2 or (props and props[5].texture) or -1,
            drawable = oldSkin.bracelets_1 or (props and props[5].drawable) or -1,
            prop_id = 7
        }
    }
end
