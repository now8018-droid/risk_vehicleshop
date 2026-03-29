Config = {

    Debug = false,
    Language = "en",
    UseOxmysql = true,
    HideHudEvent = "",
    PreloadModels = true,
    SpeedUnit = "KM/H",
    WeightUnit = "KG",
    SpawnVehicleOnPurchase = true,
    SaveVehicleToDatabase = true,
    SpawnClean = true,
    SpawnFullFuel = true,
    CustomPlateText = "RISKSHOP",
    PlateOptions = {

        useCustomPlateText = false,
        customPlateText = "RISKSHOP",
        prefix = "RS",
        letters = 2,
        numbers = 3
    },
    MaxStats = {

        Speed = 200,
        Weight = 3000,
        Braking = 100,
        Seats = 4
    },
    GiveKey = {

        enabled = false,
        give = function(plate, vehicle, model, netId, serverId)

            exports['wasabi_carlock']:GiveKey(serverId, plate)

        end,

        remove = function(plate, vehicle, model, netId, serverId)

            exports['wasabi_carlock']:RemoveKey(serverId, plate)

        end

    },

    UseCustomNotify = false,

    UseCustomHelpNotify = false,

    Functions = {

        notify = function(ntype, title, text, time)

            exports['risk-notify']:Notify({

                type = ntype,

                title = title,

                message = text,

                duration = time or 8000

            })

        end,

        helpnotify = function(key, text)

            exports['risk-notify']:HelpNotify(key, text)

        end

    },

    Shops = {{

        label = "Police Shop",
        coords = vector4(459.0816, -1017.2405, 28.1510, 81.7479),
        jobs = {"police"},
        useMarker = true,
        markerType = 2,
        markerScale = {

            x = 0.3,

            y = 0.3,

            z = 0.3

        },
        markerColor = {

            r = 0,

            g = 0,

            b = 255,

            a = 150

        },
        useNPC = true,
        npcModel = "s_m_y_cop_01",
        useBlip = true,
        blip = {

            sprite = 225,

            scale = 0.8,

            color = 38

        },
        previewCoords = vector4(449.7559, -981.1694, 43.0635, 91.2737),
        cameraCoords = vector3(449.2968, -992.4048, 45.6916),
        cameraRot = vector3(-10.0, 0.0, 2.0),
        testDriveCoords = vector4(-1827.59, -2818.12, 13.31, 149.78),
        returnCoords = vector4(455.9341, -1016.9967, 28.4024, 267.5273),
        purchaseSpawnCoords = vector4(463.0, -1015.0, 28.15, 90.0),
        defaultZoomDistance = 7.0,
        minZoomDistance = 5.0,
        maxZoomDistance = 25.0,
        categories = {{

            name = "PATROL (0-2)",
            gradeRange = {0, 2},
            vehicles = {{

                spawnName = "police",

                displayName = "Police Cruiser",

                price = 100,

                image = "police.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "police2",

                displayName = "Police Buffalo",

                price = 150,

                image = "police2.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "police3",

                displayName = "Police Interceptor",

                price = 200,

                image = "police3.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "policeold1",

                displayName = "Old Cruiser",

                price = 80,

                image = "policeold1.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "SPECIAL (3-5)",
            gradeRange = {3, 5},

            vehicles = {{

                spawnName = "fbi",

                displayName = "FIB SUV",

                price = 300,

                image = "fbi.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "fbi2",

                displayName = "FIB Granger",

                price = 350,

                image = "fbi2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "sheriff",

                displayName = "Sheriff Stanier",

                price = 250,

                image = "sheriff.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "policeb",

                displayName = "Police Bike",

                price = 180,

                image = "policeb.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "ELITE (6-10)",
            gradeRange = {6, 10},

            vehicles = {{

                spawnName = "riot",

                displayName = "Police Riot",

                price = 500,

                image = "riot.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "polmav",

                displayName = "Police Maverick",

                price = 600,

                image = "polmav.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "pranger",

                displayName = "Park Ranger SUV",

                price = 400,

                image = "pranger.png",

                isElectric = false,

                livery = 3

            }, {

                spawnName = "policeold2",

                displayName = "Old Sheriff",

                price = 220,

                image = "policeold2.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "AIR SUPPORT (8-10)",
            gradeRange = {8, 10},

            vehicles = {{

                spawnName = "hunter",

                displayName = "Police Hunter",

                price = 650,

                image = "hunter.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "valkyrie",

                displayName = "Police Valkyrie",

                price = 700,

                image = "valkyrie.png",

                isElectric = false,

                livery = 2

            }}

        }}

    }, {

        label = "Medic Shop",
        coords = vector4(333.9448, -561.7303, 28.7438, 339.8541),

        jobs = {"ambulance"},
        useMarker = true,

        markerType = 2,

        markerScale = {

            x = 0.3,

            y = 0.3,

            z = 0.3

        },

        markerColor = {

            r = 255,

            g = 0,

            b = 0,

            a = 150

        },

        useNPC = true,

        npcModel = "s_m_m_doctor_01",

        useBlip = true,

        blip = {

            sprite = 225,

            scale = 0.8,

            color = 1

        },

        previewCoords = vector4(321.8786, -544.9203, 28.1216, 215.4363),

        cameraCoords = vector3(339.0863, -547.4875, 32.7438),

        cameraRot = vector3(-6.0, 0.0, 83.19),

        testDriveCoords = vector4(-1827.59, -2818.12, 13.31, 149.78),

        returnCoords = vector4(335.2610, -557.8964, 28.7438, 160.5802),

        purchaseSpawnCoords = vector4(338.0, -563.0, 28.74, 340.0),

        defaultZoomDistance = 8.5,

        minZoomDistance = 5.0,

        maxZoomDistance = 25.0,

        categories = {{

            name = "BASIC EMS (0-1)",

            gradeRange = {0, 1},

            vehicles = {{

                spawnName = "ambulance",

                displayName = "Ambulance",

                price = 100,

                image = "ambulance.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "FIRE & RESCUE (2-3)",

            gradeRange = {2, 3},

            vehicles = {{

                spawnName = "firetruk",

                displayName = "Fire Truck",

                price = 500,

                image = "firetruk.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "ambulance",

                displayName = "Ambu Backup",

                price = 200,

                image = "ambulance.png",

                isElectric = false,

                livery = 2

            }}

        }, {

            name = "HELICOPTER (4-5)",

            gradeRange = {4, 5},

            vehicles = {{

                spawnName = "frogger",

                displayName = "EMS Chopper",

                price = 600,

                image = "frogger.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "polmav",

                displayName = "Medi Copter",

                price = 620,

                image = "polmav.png",

                isElectric = false,

                livery = 1

            }}

        }, {

            name = "EMT ARMORED (3-5)",

            gradeRange = {3, 5},

            vehicles = {{

                spawnName = "apc",

                displayName = "Heavy Ambulance",

                price = 800,

                image = "apc.png",

                isElectric = false,

                livery = 0

            }}

        }}

    }, {

        label = "Public Car Shop",
        coords = vector4(-56.71, -1096.68, 26.42, 26.0),

        jobs = {"all"},
        useMarker = true,

        markerType = 2,

        markerScale = {

            x = 0.3,

            y = 0.3,

            z = 0.3

        },

        markerColor = {

            r = 255,

            g = 255,

            b = 255,

            a = 150

        },

        useNPC = true,

        npcModel = "a_m_m_business_01",

        useBlip = true,

        blip = {

            sprite = 225,

            scale = 0.8,

            color = 4

        },

        previewCoords = vector4(-3.7499, -1058.8297, 37.5240, 195.1120),

        cameraCoords = vector3(8.1411, -1063.2042, 40.1521),

        cameraRot = vector3(-10.0, 0.0, 70.0),

        testDriveCoords = vector4(-1827.59, -2818.12, 13.31, 149.78),

        returnCoords = vector4(-58.37, -1094.59, 26.42, 206.38),

        purchaseSpawnCoords = vector4(-68.7094, -1098.8937, 26.3073, 339.4155),

        defaultZoomDistance = 6.5,

        minZoomDistance = 5.0,

        maxZoomDistance = 25.0,

        categories = {{

            name = "SPORTS",

            gradeRange = nil,

            vehicles = {{

                spawnName = "mxls",

                displayName = "mxls",

                price = 150000,

                image = "comet2.png",

                isElectric = false,

                livery = 0

             }, {

                spawnName = "jester",

                displayName = "Jester",

                price = 200000,

                image = "jester.png",

                isElectric = false,

                livery = 0

			 }, {

                spawnName = "vstr",

                displayName = "VSTR",

                price = 2,

                image = "jester.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "banshee2",

                displayName = "Banshee",

                price = 220000,

                image = "banshee2.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "massacro",

                displayName = "Massacro",

                price = 210000,

                image = "massacro.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "coquette",

                displayName = "Coquette",

                price = 180000,

                image = "coquette.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "pariah",

                displayName = "Pariah",

                price = 280000,

                image = "pariah.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "rapidgt",

                displayName = "Rapid GT",

                price = 160000,

                image = "rapidgt.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "sultan",

                displayName = "Sultan",

                price = 90000,

                image = "sultan.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "schafter3",

                displayName = "Schafter V12",

                price = 140000,

                image = "schafter3.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "surano",

                displayName = "Surano",

                price = 190000,

                image = "surano.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "alpha",

                displayName = "Alpha",

                price = 170000,

                image = "alpha.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "furoregt",

                displayName = "Furore GT",

                price = 155000,

                image = "furoregt.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "SUPER",

            gradeRange = nil,

            vehicles = {{

                spawnName = "t20",

                displayName = "T20",

                price = 150000,

                image = "t20.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "seven70",

                displayName = "Seven-70",

                price = 230000,

                image = "seven70.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "italigtb",

                displayName = "Itali GTB",

                price = 250000,

                image = "italigtb.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "nero",

                displayName = "Nero",

                price = 270000,

                image = "nero.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "reaper",

                displayName = "Reaper",

                price = 290000,

                image = "reaper.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "entityxf",

                displayName = "Entity XF",

                price = 310000,

                image = "entityxf.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "bullet",

                displayName = "Bullet",

                price = 200000,

                image = "bullet.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "osiris",

                displayName = "Osiris",

                price = 340000,

                image = "osiris.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "pfister811",

                displayName = "Pfister 811",

                price = 350000,

                image = "pfister811.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "cyclone",

                displayName = "Cyclone",

                price = 400000,

                image = "cyclone.png",

                isElectric = true,

                livery = 0

            }, {

                spawnName = "vacca",

                displayName = "Vacca",

                price = 190000,

                image = "vacca.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "SEDANS",

            gradeRange = nil,

            vehicles = {{

                spawnName = "tailgater",

                displayName = "Tailgater",

                price = 30000,

                image = "tailgater.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "premier",

                displayName = "Premier",

                price = 12000,

                image = "premier.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "primo",

                displayName = "Primo",

                price = 10000,

                image = "primo.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "intruder",

                displayName = "Intruder",

                price = 20000,

                image = "intruder.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "fugitive",

                displayName = "Fugitive",

                price = 18000,

                image = "fugitive.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "stanier",

                displayName = "Stanier",

                price = 14000,

                image = "stanier.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "surge",

                displayName = "Surge",

                price = 16000,

                image = "surge.png",

                isElectric = true,

                livery = 0

            }, {

                spawnName = "stafford",

                displayName = "Stafford",

                price = 32000,

                image = "stafford.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "glendale",

                displayName = "Glendale",

                price = 15000,

                image = "glendale.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "asterope",

                displayName = "Asterope",

                price = 13000,

                image = "asterope.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "warrener",

                displayName = "Warrener",

                price = 14000,

                image = "warrener.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "habanero",

                displayName = "Habanero",

                price = 20000,

                image = "habanero.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "LUXURY",

            gradeRange = nil,

            vehicles = {{

                spawnName = "washington",

                displayName = "Washington",

                price = 25000,

                image = "washington.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "asea",

                displayName = "Asea",

                price = 8000,

                image = "asea.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "cog55",

                displayName = "Cognoscenti",

                price = 45000,

                image = "cog55.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "emperor",

                displayName = "Emperor",

                price = 5000,

                image = "emperor.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "felon",

                displayName = "Felon",

                price = 25000,

                image = "felon.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "superd",

                displayName = "Super Diamond",

                price = 60000,

                image = "superd.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "windsor",

                displayName = "Windsor",

                price = 55000,

                image = "windsor.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "windsor2",

                displayName = "Windsor Drop",

                price = 58000,

                image = "windsor2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "tailgater2",

                displayName = "Tailgater S",

                price = 35000,

                image = "tailgater2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "cognoscenti",

                displayName = "Cognoscenti 55",

                price = 68000,

                image = "cognoscenti.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "FAMILY",

            gradeRange = nil,

            vehicles = {{

                spawnName = "baller",

                displayName = "Baller",

                price = 35000,

                image = "baller.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "fq2",

                displayName = "FQ2",

                price = 28000,

                image = "fq2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "seminole",

                displayName = "Seminole",

                price = 25000,

                image = "seminole.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "cavalcade2",

                displayName = "Cavalcade",

                price = 32000,

                image = "cavalcade2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "minivan",

                displayName = "Minivan",

                price = 12000,

                image = "minivan.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "stratum",

                displayName = "Stratum",

                price = 15000,

                image = "stratum.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "landstalker",

                displayName = "Landstalker",

                price = 20000,

                image = "landstalker.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "regina",

                displayName = "Regina",

                price = 8000,

                image = "regina.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "asterope",

                displayName = "Asterope",

                price = 14000,

                image = "asterope.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "washington",

                displayName = "Washington",

                price = 26000,

                image = "washington.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "intruder",

                displayName = "Intruder",

                price = 22000,

                image = "intruder.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "SUVS",

            gradeRange = nil,

            vehicles = {{

                spawnName = "granger",

                displayName = "Granger",

                price = 32000,

                image = "granger.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "xls",

                displayName = "XLS",

                price = 34000,

                image = "xls.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "dubsta",

                displayName = "Dubsta",

                price = 36000,

                image = "dubsta.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "patriot",

                displayName = "Patriot",

                price = 38000,

                image = "patriot.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "serrano",

                displayName = "Serrano",

                price = 30000,

                image = "serrano.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "gresley",

                displayName = "Gresley",

                price = 32000,

                image = "gresley.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "bjxl",

                displayName = "BeeJay XL",

                price = 28000,

                image = "bjxl.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "rebla",

                displayName = "Rebla",

                price = 35000,

                image = "rebla.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "novak",

                displayName = "Novak",

                price = 40000,

                image = "novak.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "toros",

                displayName = "Toros",

                price = 45000,

                image = "toros.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "baller2",

                displayName = "Baller LE",

                price = 38000,

                image = "baller2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "landstalker2",

                displayName = "Landstalker XL",

                price = 39000,

                image = "landstalker2.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "CLASSIC MUSCLE",

            gradeRange = nil,

            vehicles = {{

                spawnName = "dominator",

                displayName = "Dominator",

                price = 40000,

                image = "dominator.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "gauntlet",

                displayName = "Gauntlet",

                price = 45000,

                image = "gauntlet.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "ruiner",

                displayName = "Ruiner",

                price = 30000,

                image = "ruiner.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "dukes",

                displayName = "Dukes",

                price = 42000,

                image = "dukes.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "blade",

                displayName = "Blade",

                price = 35000,

                image = "blade.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "vigero",

                displayName = "Vigero",

                price = 28000,

                image = "vigero.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "hotknife",

                displayName = "Hotknife",

                price = 45000,

                image = "hotknife.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "phoenix",

                displayName = "Phoenix",

                price = 38000,

                image = "phoenix.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "sabregt",

                displayName = "Sabre GT",

                price = 33000,

                image = "sabregt.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "tampa",

                displayName = "Tampa",

                price = 31000,

                image = "tampa.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "stalion",

                displayName = "Stallion",

                price = 34000,

                image = "stalion.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "buccaneer",

                displayName = "Buccaneer",

                price = 29000,

                image = "buccaneer.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "chino",

                displayName = "Chino",

                price = 25000,

                image = "chino.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "coquette3",

                displayName = "Coquette BlackFin",

                price = 50000,

                image = "coquette3.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "ellie",

                displayName = "Ellie",

                price = 42000,

                image = "ellie.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "deviant",

                displayName = "Deviant",

                price = 38000,

                image = "deviant.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "OFF-ROAD",

            gradeRange = nil,

            vehicles = {{

                spawnName = "bfinjection",

                displayName = "Bifta",

                price = 20000,

                image = "bfinjection.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "rebel2",

                displayName = "Rebel",

                price = 18000,

                image = "rebel2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "sandking",

                displayName = "Sandking",

                price = 35000,

                image = "sandking.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "brawler",

                displayName = "Brawler",

                price = 40000,

                image = "brawler.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "dloader",

                displayName = "DLoader",

                price = 16000,

                image = "dloader.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "bodhi2",

                displayName = "Bodhi",

                price = 22000,

                image = "bodhi2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "blazer",

                displayName = "Blazer Quad",

                price = 10000,

                image = "blazer.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "trophytruck",

                displayName = "TrophyTruck",

                price = 45000,

                image = "trophytruck.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "caracara2",

                displayName = "Caracara 4x4",

                price = 42000,

                image = "caracara2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "everon",

                displayName = "Everon",

                price = 43000,

                image = "everon.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "hellion",

                displayName = "Hellion",

                price = 28000,

                image = "hellion.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "kamacho",

                displayName = "Kamacho",

                price = 36000,

                image = "kamacho.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "outlaw",

                displayName = "Outlaw",

                price = 27000,

                image = "outlaw.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "vagrant",

                displayName = "Vagrant",

                price = 39000,

                image = "vagrant.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "freecrawler",

                displayName = "Freecrawler",

                price = 34000,

                image = "freecrawler.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "winky",

                displayName = "Winky",

                price = 20000,

                image = "winky.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "BIKES",

            gradeRange = nil,

            vehicles = {{

                spawnName = "bati",

                displayName = "Bati 801",

                price = 15000,

                image = "bati.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "double",

                displayName = "Double T",

                price = 17000,

                image = "double.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "hexer",

                displayName = "Hexer",

                price = 12000,

                image = "hexer.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "pcj",

                displayName = "PCJ 600",

                price = 9000,

                image = "pcj.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "daemon",

                displayName = "Daemon",

                price = 13000,

                image = "daemon.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "faggio3",

                displayName = "Faggio Mod",

                price = 4000,

                image = "faggio3.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "hakuchou",

                displayName = "Hakuchou",

                price = 22000,

                image = "hakuchou.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "vader",

                displayName = "Vader",

                price = 10000,

                image = "vader.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "bf400",

                displayName = "BF400",

                price = 14000,

                image = "bf400.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "manchez",

                displayName = "Manchez",

                price = 16000,

                image = "manchez.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "zombiea",

                displayName = "Zombie A",

                price = 18000,

                image = "zombiea.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "bagger",

                displayName = "Bagger",

                price = 8000,

                image = "bagger.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "carbonrs",

                displayName = "Carbon RS",

                price = 20000,

                image = "carbonrs.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "vortex",

                displayName = "Vortex",

                price = 16000,

                image = "vortex.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "daemon2",

                displayName = "Daemon Custom",

                price = 15000,

                image = "daemon2.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "sanctus",

                displayName = "Sanctus",

                price = 25000,

                image = "sanctus.png",

                isElectric = false,

                livery = 0

            }}

        }}

    }, {

        label = "Boat Shop",
        coords = vector4(-789.6367, -1490.8499, 1.5952, 287.3399),
        jobs = {"all"},
        useMarker = true,

        markerType = 2,

        markerScale = {

            x = 0.5,

            y = 0.5,

            z = 0.5

        },

        markerColor = {

            r = 0,

            g = 100,

            b = 200,

            a = 150

        },

        useNPC = true,

        npcModel = "cs_fbisuit_01",

        useBlip = true,

        blip = {

            sprite = 455,

            scale = 0.8,

            color = 3

        },

        previewCoords = vector4(-835.1741, -1508.1755, 0.2907, 165.9771),

        cameraCoords = vector3(-807.7882, -1497.2708, 6.595),

        cameraRot = vector3(-10.0, 0.0, 112.0),

        testDriveCoords = vector4(-2081.5188, -1933.0048, 0.6666, 21.8150),

        returnCoords = vector4(-786.7281, -1489.7549, 1.5952, 102.4762),

        purchaseSpawnCoords = vector4(-792.6367, -1495.8499, 1.5952, 280.0),

        defaultZoomDistance = 10.0,

        minZoomDistance = 5.0,

        maxZoomDistance = 25.0,

        categories = {{

            name = "SMALL BOATS",

            gradeRange = nil,

            vehicles = {{

                spawnName = "dinghy",

                displayName = "Dinghy",

                price = 50000,

                image = "dinghy.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "seashark",

                displayName = "Seashark",

                price = 18000,

                image = "seashark.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "suntrap",

                displayName = "Suntrap",

                price = 30000,

                image = "suntrap.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "speeder",

                displayName = "Speeder",

                price = 90000,

                image = "speeder.png",

                isElectric = false,

                livery = 1

            }}

        }, {

            name = "LARGE BOATS",

            gradeRange = nil,

            vehicles = {{

                spawnName = "tropic",

                displayName = "Tropic",

                price = 60000,

                image = "tropic.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "jetmax",

                displayName = "Jetmax",

                price = 75000,

                image = "jetmax.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "marquis",

                displayName = "Marquis",

                price = 80000,

                image = "marquis.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "squalo",

                displayName = "Squalo",

                price = 85000,

                image = "squalo.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "LUXURY BOATS",

            gradeRange = nil,

            vehicles = {{

                spawnName = "predator",

                displayName = "Predator",

                price = 100000,

                image = "predator.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "longfin",

                displayName = "Longfin",

                price = 120000,

                image = "longfin.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "tug",

                displayName = "Tug Boat",

                price = 140000,

                image = "tug.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "FISHING & WORK",

            gradeRange = nil,

            vehicles = {{

                spawnName = "dinghy2",

                displayName = "Fishing Dinghy",

                price = 60000,

                image = "dinghy2.png",

                isElectric = false,

                livery = 0

            }}

        }}

    }, {

        label = "Airplane Shop",
        coords = vector4(-1280.0770, -3341.0818, 13.9451, 236.7062),
        jobs = {"all"},

        useMarker = true,

        markerType = 2,

        markerScale = {

            x = 0.5,

            y = 0.5,

            z = 0.5

        },

        markerColor = {

            r = 255,

            g = 255,

            b = 0,

            a = 150

        },

        useNPC = true,

        npcModel = "cs_pilot",

        useBlip = true,

        blip = {

            sprite = 307,

            scale = 0.8,

            color = 5

        },

        previewCoords = vector4(-1275.4939, -3387.6646, 13.9401, 233.7215),

        cameraCoords = vector3(-1267.3279, -3373.4155, 18.9401),

        cameraRot = vector3(-10.0, 0.0, 155.0),

        testDriveCoords = vector4(-964.2260, -3357.7920, 13.3162, 59.9048),

        returnCoords = vector4(-1276.0045, -3342.1973, 13.9450, 72.6738),

        purchaseSpawnCoords = vector4(-1285.0770, -3345.0818, 13.9451, 230.0),

        defaultZoomDistance = 11.0,

        minZoomDistance = 5.0,

        maxZoomDistance = 25.0,

        categories = {{

            name = "PLANES",

            gradeRange = nil,

            vehicles = {{

                spawnName = "duster",

                displayName = "Duster",

                price = 100000,

                image = "duster.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "mammatus",

                displayName = "Mammatus",

                price = 120000,

                image = "mammatus.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "velum",

                displayName = "Velum",

                price = 180000,

                image = "velum.png",

                isElectric = false,

                livery = 1

            }, {

                spawnName = "luxor",

                displayName = "Luxor",

                price = 400000,

                image = "luxor.png",

                isElectric = false,

                livery = 2

            }, {

                spawnName = "stunt",

                displayName = "Stunt Plane",

                price = 220000,

                image = "stunt.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "HELICOPTERS",

            gradeRange = nil,

            vehicles = {{

                spawnName = "buzzard",

                displayName = "Buzzard",

                price = 350000,

                image = "buzzard.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "frogger",

                displayName = "Frogger",

                price = 300000,

                image = "frogger.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "maverick",

                displayName = "Maverick",

                price = 280000,

                image = "maverick.png",

                isElectric = false,

                livery = 3

            }, {

                spawnName = "swift",

                displayName = "Swift",

                price = 320000,

                image = "swift.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "HEAVY DUTY",

            gradeRange = nil,

            vehicles = {{

                spawnName = "titan",

                displayName = "Titan",

                price = 600000,

                image = "titan.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "cargoplane",

                displayName = "Cargo Plane",

                price = 800000,

                image = "cargoplane.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "avenger",

                displayName = "Avenger",

                price = 950000,

                image = "avenger.png",

                isElectric = false,

                livery = 0

            }}

        }, {

            name = "MILITARY (restricted)",

            gradeRange = nil,

            vehicles = {{

                spawnName = "jet",

                displayName = "Fighter Jet",

                price = 1500000,

                image = "jet.png",

                isElectric = false,

                livery = 0

            }, {

                spawnName = "hydra",

                displayName = "Hydra Jet",

                price = 1800000,

                image = "hydra.png",

                isElectric = false,

                livery = 0

            }}

        }}

    }}
}