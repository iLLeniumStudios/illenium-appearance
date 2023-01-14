if not Framework.ESX() then return end

local function tofloat(num)
    return num + 0.0
end

local function convertSkinToNewFormat(oldSkin, gender)
    local skin = {
        components = Framework.ConvertComponents(oldSkin),
        eyeColor = oldSkin.eye_color,
        faceFeatures = {
            chinBoneLenght = tofloat(oldSkin.chin_2 / 10),
            noseBoneTwist = tofloat(oldSkin.nose_6 / 10),
            nosePeakHigh = tofloat(oldSkin.nose_2 / 10),
            jawBoneWidth = tofloat(oldSkin.jaw_1 / 10),
            cheeksWidth = tofloat(oldSkin.cheeks_3 / 10),
            eyeBrownHigh = tofloat(oldSkin.eyebrows_5 / 10),
            chinHole = tofloat(oldSkin.chin_4 / 10),
            jawBoneBackSize = tofloat(oldSkin.jaw_2 / 10),
            eyesOpening = tofloat(oldSkin.eye_squint / 10),
            lipsThickness = tofloat(oldSkin.lip_thickness / 10),
            nosePeakSize = tofloat(oldSkin.nose_3 / 10),
            eyeBrownForward = tofloat(oldSkin.eyebrows_6 / 10),
            neckThickness = tofloat(oldSkin.neck_thickness / 10),
            chinBoneSize = tofloat(oldSkin.chin_3 / 10),
            chinBoneLowering = tofloat(oldSkin.chin_1 / 10),
            cheeksBoneWidth = tofloat(oldSkin.cheeks_2 / 10),
            nosePeakLowering = tofloat(oldSkin.nose_5 / 10),
            noseBoneHigh = tofloat(oldSkin.nose_4 / 10),
            cheeksBoneHigh = tofloat(oldSkin.cheeks_1 / 10),
            noseWidth = tofloat(oldSkin.nose_1 / 10)
        },
        hair = {
            highlight = oldSkin.hair_color_2,
            texture = oldSkin.hair_2,
            style = oldSkin.hair_1,
            color = oldSkin.hair_color_1
        },
        headBlend = {
            thirdMix = 0,
            skinSecond = oldSkin.dad,
            skinMix = tofloat(oldSkin.skin_md_weight / 100),
            skinThird = 0,
            shapeFirst = oldSkin.mom,
            shapeThird = 0,
            shapeMix = tofloat(oldSkin.face_md_weight / 100),
            shapeSecond = oldSkin.dad,
            skinFirst = oldSkin.mom
        },
        headOverlays = {
            complexion = {
                opacity = tofloat(oldSkin.complexion_2 / 10),
                color = 0,
                style = oldSkin.complexion_1,
                secondColor = 0
            },
            lipstick = {
                opacity = tofloat(oldSkin.lipstick_2 / 10),
                color = oldSkin.lipstick_3,
                style = oldSkin.lipstick_1,
                secondColor = oldSkin.lipstick_4
            },
            eyebrows = {
                opacity = tofloat(oldSkin.eyebrows_2 / 10),
                color = oldSkin.eyebrows_3,
                style = oldSkin.eyebrows_1,
                secondColor = oldSkin.eyebrows_4
            },
            beard = {
                opacity = tofloat(oldSkin.beard_2 / 10),
                color = oldSkin.beard_3,
                style = oldSkin.beard_1,
                secondColor = oldSkin.beard_4
            },
            blush = {
                opacity = tofloat(oldSkin.blush_2 / 10),
                color = oldSkin.blush_3,
                style = oldSkin.blush_1,
                secondColor = oldSkin.blush_4
            },
            ageing = {
                opacity = tofloat(oldSkin.age_2 / 10),
                color = 0,
                style = oldSkin.age_1,
                secondColor = 0
            },
            blemishes = {
                opacity = tofloat(oldSkin.blemishes_2 / 10),
                color = 0,
                style = oldSkin.blemishes_1,
                secondColor = 0
            },
            chestHair = {
                opacity = tofloat(oldSkin.chest_2 / 10),
                color = oldSkin.chest_3,
                style = oldSkin.chest_1,
                secondColor = 0
            },
            bodyBlemishes = {
                opacity = tofloat(oldSkin.bodyb_2 / 10),
                color = oldSkin.bodyb_3,
                style = oldSkin.bodyb_1,
                secondColor = oldSkin.bodyb_4
            },
            moleAndFreckles = {
                opacity = tofloat(oldSkin.moles_2 / 10),
                color = 0,
                style = oldSkin.moles_1,
                secondColor = 0
            },
            sunDamage = {
                opacity = tofloat(oldSkin.sun_2 / 10),
                color = 0,
                style = oldSkin.sun_1,
                secondColor = 0
            },
            makeUp = {
                opacity = tofloat(oldSkin.makeup_2 / 10),
                color = oldSkin.makeup_3,
                style = oldSkin.makeup_1,
                secondColor = oldSkin.makeup_4
            }
        },
        model = gender == 0 and "mp_m_freemode_01" or "mp_m_freemode_01",
        props = Framework.ConvertProps(oldSkin),
        tattoos = {}
    }

    return skin
end


lib.addCommand("admin", "migrateskins", function(source)
    local users = Database.Users.GetAll()
    local convertedSkins = 0
    if users then
        for i = 1, #users do
            local user = users[i]
            if user.skin then
                local oldSkin = json.decode(user.skin)
                if oldSkin.mom then -- Convert only if its an old skin
                    local skin = json.encode(convertSkinToNewFormat(oldSkin, user.gender))
                    local affectedRows = Database.Users.UpdateSkinForUser(user.identifier, skin)
                    if affectedRows then
                        convertedSkins += 1
                    end
                end
            end
        end
    end
    lib.notify(source, {
        title = "Success",
        description = "Migration finished. " .. tostring(convertedSkins) .. " skins migrated",
        type = "success",
        position = Config.NotifyOptions.position
    })
end, nil, "Migrate skins to illenium-appearance")
