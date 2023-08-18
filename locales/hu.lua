Locales["hu"] = {
    UI = {
        modal = {
            save = {
                title = "Változtatás Mentése",
                description = "Csúnya maradtál"
            },
            exit = {
                title = "Kilépés a testreszabásból",
                description = "Nincs változtatás elmentve"
            },
            accept = "Igen",
            decline = "Nem"
        },
        ped = {
            title = "Ped",
            model = "Model"
        },
        headBlend = {
            title = "Öröklődés",
            shape = {
                title = "Arc",
                firstOption = "Apa",
                secondOption = "Anya",
                mix = "Vegyes"
            },
            skin = {
                title = "Bőrszín",
                firstOption = "Apa",
                secondOption = "Anya",
                mix = "Vegyes"
            },
            race = {
                title = "Rassz",
                shape = "Alak",
                skin = "Bőrszín",
                mix = "Vegyes"
            }
        },
        faceFeatures = {
            title = "Arci Jellemzők",
            nose = {
                title = "Orr",
                width = "Szélesség",
                height = "Magasság",
                size = "Méret",
                boneHeight = "Magasság",
                boneTwist = "Csavarás",
                peakHeight = "Maximális Magasság"
            },
            eyebrows = {
                title = "Szemöldök",
                height = "Magasság",
                depth = "Mélység"
            },
            cheeks = {
                title = "Száj",
                boneHeight = "Magasság",
                boneWidth = "Szélesség",
                width = "Szélesség"
            },
            eyesAndMouth = {
                title = "Szemek és Száj",
                eyesOpening = "Szem Kinyitása",
                lipsThickness = "Száj Típusok"
            },
            jaw = {
                title = "Állkapocs",
                width = "Szélesség",
                size = "Méret"
            },
            chin = {
                title = "Áll",
                lowering = "Leeresztés",
                length = "Hosszúság",
                size = "Méret",
                hole = "Méret"
            },
            neck = {
                title = "Nyak",
                thickness = "Vastagság"
            }
        },
        headOverlays = {
            title = "Kinézet",
            hair = {
                title = "Haj",
                style = "Stílus",
                color = "Szín",
                highlight = "Kiemelt",
                texture = "Kinézet",
                fade = "Halvány"
            },
            opacity = "Átlátszóság",
            style = "Stílus",
            color = "Szín",
            secondColor = "Másodlagos Szín",
            blemishes = "Foltok",
            beard = "Szakáll",
            eyebrows = "Szemöldök",
            ageing = "Öregedés",
            makeUp = "Smink",
            blush = "Elpirulás",
            complexion = "Arcszín",
            sunDamage = "Napfény okozta bőröregedés",
            lipstick = "Rúzs",
            moleAndFreckles = "Anyajegyek és Szeplők",
            chestHair = "Mellszőrzet",
            bodyBlemishes = "Bőrhibák",
            eyeColor = "Szemszín"
        },
        components = {
            title = "Ruhák",
            drawable = "Rajzolható",
            texture = "Kinézet",
            mask = "Maszk",
            upperBody = "Kezek",
            lowerBody = "Lábak",
            bags = "Táskák és ejtőernyő",
            shoes = "Cipők",
            scarfAndChains = "Sál és Láncok",
            shirt = "Póló",
            bodyArmor = "Test páncél",
            decals = "Matricák",
            jackets = "Kabátok",
            head = "Fej"
        },
        props = {
            title = "Kellékek",
            drawable = "Rajzolható",
            texture = "Kinézet",
            hats = "Sapkák",
            glasses = "Szemüvegek",
            ear = "Fül",
            watches = "órák",
            bracelets = "Karkötők"
        },
        tattoos = {
            title = "Tetoválások",
            items = {
                ZONE_TORSO = "Törzs",
                ZONE_HEAD = "Fej",
                ZONE_LEFT_ARM = "Bal Kar",
                ZONE_RIGHT_ARM = "Jobb Kar",
                ZONE_LEFT_LEG = "Bal Láb",
                ZONE_RIGHT_LEG = "Jobb Láb"
            },
            apply = "Mentés",
            delete = "Törlés",
            deleteAll = "Összes tetkó törlése",
            opacity = "Átlátszóság"
        }
    },
    outfitManagement = {
        title = "Ruházat Kezelése",
        jobText = "Munkaruha Kezelése",
        gangText = "Bandaruha Kezelése"
    },
    cancelled = {
        title = "Testreszabás Visszavonva",
        description = "Testreszabás Nincs Mentve"
    },
    outfits = {
        import = {
            title = "Írd be az ruházat kódját",
            menuTitle = "Ruházat Berakása",
            description = "Ruházat importálása megosztási kóddal",
            name = {
                label = "Ruházat Elnevezése",
                placeholder = "Egy szép öltözet",
                default = "Berakot Ruházat"
            },
            code = {
                label = "Ruházat Kódja"
            },
            success = {
                title = "Ruházat Importálva",
                description = "Most át tudsz öltözni az ruházat menü használatával"
            },
            failure = {
                title = "Sikertelen Importálás",
                description = "Hibás ruházat kód"
            }
        },
        generate = {
            title = "Ruházat kód generálása",
            description = "Ruházat kód generálása megosztáshoz",
            failure = {
                title = "Hiba történt",
                description = "Nem sikerült kódot létrehozni az ruházathoz"
            },
            success = {
                title = "Ruházat kód legenerálva",
                description = "Itt az ruházat kódod"
            }
        },
        save = {
            menuTitle = "Ruha mentése",
            menuDescription = "Jelenlegi ruha mentése mint %s ruházat",
            description = "Jelenlegi ruházat lementve",
            title = "Ruházat elnevezése",
            managementTitle = "Ruházat részletek kezelése",
            name = {
                label = "Ruházat Neve",
                placeholder = "Nagyon szép ruházat"
            },
            gender = {
                label = "Nem",
                male = "Férfi",
                female = "Nő"
            },
            rank = {
                label = "Minimális Rang"
            },
            failure = {
                title = "Sikertelen Mentés",
                description = "Ezzel a nével már létezik ruházat"
            },
            success = {
                title = "Sikeres",
                description = "%s nevű ruházat mentve"
            }
        },
        update = {
            title = "Ruházat Frissítése",
            description = "Jelenlegi ruhák mentése egy meglévő ruházat helyére",
            failure = {
                title = "Frissités Sikertelen",
                description = "Ez a ruházat nem létezik"
            },
            success = {
                title = "Sikeres",
                description = "%s nevű ruházat frissítve"
            }
        },
        change = {
            title = "Ruházat Megváltoztatása",
            description = "Válasz a jelenlegi %s ruházatod közül",
            pDescription = "Válasz a jelenlegi ruházataid közül",
            failure = {
                title = "Hiba történt",
                description = "A ruházatnak, amibe próbálsz átöltözni, nincs alap megjelenítése",
            }
        },
        delete = {
            title = "Ruházat Törlése",
            description = "Egy mentett %s ruházat törlése",
            mDescription = "Egy mentett ruházatod törlése",
            item = {
                title = '"%s" törlése',
                description = "Model: %s%s"
            },
            success = {
                title = "Sikeres",
                description = "Ruházat Törölve"
            }
        },
        manage = {
            title = "👔 | %s Ruházatok Kezelése"
        }
    },
    jobOutfits = {
        title = "Munkaruhák",
        description = "Válasz egy munkaruhát"
    },
    menu = {
        returnTitle = "Vissza",
        title = "Ruhatár",
        outfitsTitle = "Játékos Ruházatok",
        clothingShopTitle = "Ruhabolt",
        barberShopTitle = "Fodrászat",
        tattooShopTitle = "Tetováló Szalon",
        surgeonShopTitle = "Sebészet"
    },
    clothing = {
        title = "Ruha Vásárlás - $%d",
        titleNoPrice = "Ruha Váltása",
        options = {
            title = "👔 | Ruhabolt Beállítások",
            description = "Válasszon a ruhák széles kínálatából"
        },
        outfits = {
            title = "👔 | Ruházat Beállítások",
            civilian = {
                title = "Civil Ruházat",
                description = "Ruházat felvétele"
            }
        }
    },
    commands = {
        reloadskin = {
            title = "Karakter újratöltése",
            failure = {
                title = "Hiba",
                description = "Ezt most nem használhatod"
            }
        },
        clearstuckprops = {
            title = "Eltávolítja az entitáshoz csatolt összes kelléket",
            failure = {
                title = "Hiba",
                description = "Ezt most nem használhatod"
            }
        },
        pedmenu = {
            title = "Ruházati Menü Megnyitása",
            failure = {
                title = "Hiba",
                description = "A játékos nem online"
            }
        },
        joboutfits = {
            title = "Munkaruházati menü megnyitása"
        },
        gangoutfits = {
            title = "Bandaruházati menü megnyitása"
        }
    },
    textUI = {
        clothing = "Ruhabolt - Ár: $%d",
        barber = "Fodrászat - Ár: $%d",
        tattoo = "Tetováló Szalon - Ár: $d",
        surgeon = "Sebészet - Ár: $%d",
        clothingRoom = "Ruhatár",
        playerOutfitRoom = "Ruházatok"
    },
    migrate = {
        success = {
            title = "Sikeres",
            description = "Áthelyezés sikeres. %s kinézet(ek) áthelyezve",
            descriptionSingle = "Kinézet áthelyezve"
        },
        skip = {
            title = "Információ",
            description = "Kinézet kihagyva"
        },
        typeError = {
            title = "Hiba",
            description = "Nem létező típus"
        }
    },
    purchase = {
        tattoo = {
            success = {
                title = "Sikeres",
                description = "Megvásárolt %s tetoválás ennyiért: $%s"
            },
            failure = {
                title = "Tetoválás alkalmazása sikertelen",
                description = "Nincs elég pénzed!"
            }
        },
        store = {
            success = {
                title = "Sikeres",
                description = "Ennyit fizettél: $%s" --"Gave $100 to clothing" doesn't really make sense, I just removed the second %s
            },
            failure = {
                title = "Hiba",
                description = "Nincs elég pénzed! Megpróbáltad kihasználni a rendszert!"
            }
        }
    }
}
