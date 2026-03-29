-- CombatTimeTracker Data Model
-- Auto-generated from Blizzard DB tables (Map, DungeonEncounter)

CTT_Data = {
    expansions = {
        -- Classic
        {
            name = "Classic",
            raids = {
                {
                    name = "Onyxia's Lair",
                    mapID = 249,
                    bosses = {
                        { name = "Onyxia", encounterID = 1084 },
                    }
                },
                {
                    name = "Molten Core",
                    mapID = 409,
                    bosses = {
                        { name = "Lucifron",                 encounterID = 663 },
                        { name = "Magmadar",                 encounterID = 664 },
                        { name = "Gehennas",                 encounterID = 665 },
                        { name = "Garr",                     encounterID = 666 },
                        { name = "Shazzrah",                 encounterID = 667 },
                        { name = "Baron Geddon",             encounterID = 668 },
                        { name = "Sulfuron Harbinger",       encounterID = 669 },
                        { name = "Golemagg the Incinerator", encounterID = 670 },
                        { name = "Majordomo Executus",       encounterID = 671 },
                        { name = "Ragnaros",                 encounterID = 672 },
                    }
                },
                {
                    name = "Blackwing Lair",
                    mapID = 469,
                    bosses = {
                        { name = "Razorgore the Untamed",   encounterID = 610 },
                        { name = "Vaelastrasz the Corrupt", encounterID = 611 },
                        { name = "Broodlord Lashlayer",     encounterID = 612 },
                        { name = "Firemaw",                 encounterID = 613 },
                        { name = "Ebonroc",                 encounterID = 614 },
                        { name = "Flamegor",                encounterID = 615 },
                        { name = "Chromaggus",              encounterID = 616 },
                        { name = "Nefarian",                encounterID = 617 },
                    }
                },
                {
                    name = "Ruins of Ahn'Qiraj",
                    mapID = 509,
                    bosses = {
                        { name = "Kurinnaxx",              encounterID = 718 },
                        { name = "General Rajaxx",         encounterID = 719 },
                        { name = "Moam",                   encounterID = 720 },
                        { name = "Buru the Gorger",        encounterID = 721 },
                        { name = "Ayamiss the Hunter",     encounterID = 722 },
                        { name = "Ossirian the Unscarred", encounterID = 723 },
                    }
                },
                {
                    name = "Ahn'Qiraj Temple",
                    mapID = 531,
                    bosses = {
                        { name = "The Prophet Skeram",      encounterID = 709 },
                        { name = "Silithid Royalty",        encounterID = 710 },
                        { name = "Battleguard Sartura",     encounterID = 711 },
                        { name = "Fankriss the Unyielding", encounterID = 712 },
                        { name = "Viscidus",                encounterID = 713 },
                        { name = "Princess Huhuran",        encounterID = 714 },
                        { name = "Twin Emperors",           encounterID = 715 },
                        { name = "Ouro",                    encounterID = 716 },
                        { name = "C'Thun",                  encounterID = 717 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Shadowfang Keep",
                    mapID = 33,
                    bosses = {
                        { name = "Baron Ashbury",          encounterID = 1069 },
                        { name = "Baron Silverlaine",      encounterID = 1070 },
                        { name = "Commander Springvale",   encounterID = 1071 },
                        { name = "Lord Walden",            encounterID = 1073 },
                        { name = "Lord Godfrey",           encounterID = 1072 },
                        { name = "The Crown Chemical Co.", encounterID = 2879 },
                    }
                },
                {
                    name = "Stormwind Stockade",
                    mapID = 34,
                    bosses = {
                        { name = "Hogger",          encounterID = 1144 },
                        { name = "Lord Overheat",   encounterID = 1145 },
                        { name = "Randolph Moloch", encounterID = 1146 },
                    }
                },
                {
                    name = "Deadmines",
                    mapID = 36,
                    bosses = {
                        { name = "Glubtok",           encounterID = 2976 },
                        { name = "Helix Gearbreaker", encounterID = 2977 },
                        { name = "Glubtok",           encounterID = 2981 },
                        { name = "Rhahk'Zor",         encounterID = 2967 },
                        { name = "Helix Gearbreaker", encounterID = 2982 },
                        { name = "Foe Reaper 5000",   encounterID = 2975 },
                        { name = "Foe Reaper 5000",   encounterID = 2980 },
                        { name = "Admiral Ripsnarl",  encounterID = 2979 },
                        { name = "Admiral Ripsnarl",  encounterID = 2974 },
                        { name = "Sneed",             encounterID = 2968 },
                        { name = "Captain Cookie",    encounterID = 2978 },
                        { name = "Gilnid",            encounterID = 2969 },
                        { name = "Mr. Smite",         encounterID = 2970 },
                        { name = "Captain Cookie",    encounterID = 2973 },
                        { name = "Captain Greenskin", encounterID = 2971 },
                        { name = "Edwin VanCleef",    encounterID = 2972 },
                        { name = "Vanessa VanCleef",  encounterID = 1081 },
                        { name = "Cookie",            encounterID = 2986 },
                    }
                },
                {
                    name = "Wailing Caverns",
                    mapID = 43,
                    bosses = {
                        { name = "Lady Anacondra",        encounterID = 585 },
                        { name = "Lord Cobrahn",          encounterID = 586 },
                        { name = "Kresh",                 encounterID = 587 },
                        { name = "Lord Pythas",           encounterID = 588 },
                        { name = "Skum",                  encounterID = 589 },
                        { name = "Lord Serpentis",        encounterID = 590 },
                        { name = "Verdan the Everliving", encounterID = 591 },
                        { name = "Mutanus the Devourer",  encounterID = 592 },
                    }
                },
                {
                    name = "Razorfen Kraul",
                    mapID = 47,
                    bosses = {
                        { name = "Hunter Bonetusk",          encounterID = 1656 },
                        { name = "Roogug",                   encounterID = 438 },
                        { name = "Warlord Ramtusk",          encounterID = 1659 },
                        { name = "Groyat, the Blind Hunter", encounterID = 1660 },
                        { name = "Charlga Razorflank",       encounterID = 1661 },
                    }
                },
                {
                    name = "Blackfathom Deeps",
                    mapID = 48,
                    bosses = {
                        { name = "Ghamoo-ra",             encounterID = 1667 },
                        { name = "Domina",                encounterID = 1668 },
                        { name = "Subjugator Kor'ul",     encounterID = 1669 },
                        { name = "Thruk",                 encounterID = 1675 },
                        { name = "Guardian of the Deep",  encounterID = 1676 },
                        { name = "Executioner Gore",      encounterID = 1670 },
                        { name = "Twilight Lord Bathiel", encounterID = 1671 },
                        { name = "Aku'mai",               encounterID = 1672 },
                    }
                },
                {
                    name = "Uldaman",
                    mapID = 70,
                    bosses = {
                        { name = "Revelosh",             encounterID = 547 },
                        { name = "The Lost Dwarves",     encounterID = 548 },
                        { name = "Ironaya",              encounterID = 549 },
                        { name = "Ancient Stone Keeper", encounterID = 551 },
                        { name = "Galgann Firehammer",   encounterID = 552 },
                        { name = "Grimlok",              encounterID = 553 },
                        { name = "Archaedas",            encounterID = 554 },
                        { name = "Obsidian Sentinel",    encounterID = 1887 },
                    }
                },
                {
                    name = "Gnomeregan",
                    mapID = 90,
                    bosses = {
                        { name = "Grubbis",               encounterID = 379 },
                        { name = "Viscous Fallout",       encounterID = 378 },
                        { name = "Electrocutioner 6000",  encounterID = 380 },
                        { name = "Crowd Pummeler 9-60",   encounterID = 381 },
                        { name = "Mekgineer Thermaplugg", encounterID = 382 },
                    }
                },
                {
                    name = "Sunken Temple",
                    mapID = 109,
                    bosses = {
                        { name = "Avatar of Hakkar",      encounterID = 492 },
                        { name = "Jammal'an the Prophet", encounterID = 488 },
                        { name = "Dreamscythe",           encounterID = 486 },
                        { name = "Weaver",                encounterID = 487 },
                        { name = "Morphaz",               encounterID = 490 },
                        { name = "Hazzas",                encounterID = 491 },
                        { name = "Shade of Eranikus",     encounterID = 493 },
                    }
                },
                {
                    name = "Razorfen Downs",
                    mapID = 129,
                    bosses = {
                        { name = "Aaurx",                    encounterID = 1662 },
                        { name = "Mordresh Fire Eye",        encounterID = 1663 },
                        { name = "Mushlump",                 encounterID = 1664 },
                        { name = "Death Speaker Blackthorn", encounterID = 1665 },
                        { name = "Amnennar the Coldbringer", encounterID = 1666 },
                    }
                },
                {
                    name = "Scarlet Monastery of Old",
                    mapID = 189,
                    bosses = {
                        { name = "Interrogator Vishas",       encounterID = 444 },
                        { name = "Bloodmage Thalnos",         encounterID = 2818 },
                        { name = "Houndmaster Loksey",        encounterID = 446 },
                        { name = "Arcanist Doan",             encounterID = 447 },
                        { name = "Herod",                     encounterID = 448 },
                        { name = "High Inquisitor Fairbanks", encounterID = 449 },
                        { name = "High Inquisitor Whitemane", encounterID = 450 },
                    }
                },
                {
                    name = "Zul'Farrak",
                    mapID = 209,
                    bosses = {
                        { name = "Theka the Martyr",      encounterID = 596 },
                        { name = "Antu'sul",              encounterID = 595 },
                        { name = "Witch Doctor Zum'rah",  encounterID = 597 },
                        { name = "Hydromancer Velratha",  encounterID = 593 },
                        { name = "Ghaz'rilla",            encounterID = 594 },
                        { name = "Nekrum Gutchewer",      encounterID = 598 },
                        { name = "Shadowpriest Sezz'ziz", encounterID = 599 },
                        { name = "Chief Ukorz Sandscalp", encounterID = 600 },
                    }
                },
                {
                    name = "Lower Blackrock Spire",
                    mapID = 229,
                    bosses = {
                        { name = "Highlord Omokk",           encounterID = 267 },
                        { name = "Shadow Hunter Vosh'gajin", encounterID = 268 },
                        { name = "War Master Voone",         encounterID = 269 },
                        { name = "Mother Smolderweb",        encounterID = 270 },
                        { name = "Urok Doomhowl",            encounterID = 271 },
                        { name = "Quartermaster Zigris",     encounterID = 272 },
                        { name = "Halycon",                  encounterID = 274 },
                        { name = "Gizrul the Slavener",      encounterID = 273 },
                        { name = "Overlord Wyrmthalak",      encounterID = 275 },
                    }
                },
                {
                    name = "Blackrock Depths",
                    mapID = 230,
                    bosses = {
                        { name = "High Interrogator Gerstahn", encounterID = 227 },
                        { name = "Lord Roccor",                encounterID = 228 },
                        { name = "Houndmaster Grebmar",        encounterID = 229 },
                        { name = "Ring of Law",                encounterID = 230 },
                        { name = "Pyromancer Loregrain",       encounterID = 231 },
                        { name = "Lord Incendius",             encounterID = 232 },
                        { name = "Warder Stilgiss",            encounterID = 233 },
                        { name = "Fineous Darkvire",           encounterID = 234 },
                        { name = "Bael'Gar",                   encounterID = 235 },
                        { name = "General Angerforge",         encounterID = 236 },
                        { name = "Golem Lord Argelmach",       encounterID = 237 },
                        { name = "Hurley Blackbreath",         encounterID = 238 },
                        { name = "Phalanx",                    encounterID = 239 },
                        { name = "Ribbly Screwspigot",         encounterID = 240 },
                        { name = "Plugger Spazzring",          encounterID = 241 },
                        { name = "Ambassador Flamelash",       encounterID = 242 },
                        { name = "The Seven",                  encounterID = 243 },
                        { name = "Magmus",                     encounterID = 244 },
                        { name = "Emperor Dagran Thaurissan",  encounterID = 245 },
                    }
                },
                {
                    name = "Scholomance",
                    mapID = 289,
                    bosses = {
                        { name = "Kirtonos the Herald",      encounterID = 451 },
                        { name = "Jandice Barov",            encounterID = 452 },
                        { name = "Rattlegore",               encounterID = 453 },
                        { name = "Marduk Blackpool",         encounterID = 454 },
                        { name = "Vectus",                   encounterID = 455 },
                        { name = "Ras Frostwhisper",         encounterID = 456 },
                        { name = "Instructor Malicia",       encounterID = 457 },
                        { name = "Doctor Theolen Krastinov", encounterID = 458 },
                        { name = "Lorekeeper Polkelt",       encounterID = 459 },
                        { name = "The Ravenian",             encounterID = 460 },
                        { name = "Lord Alexei Barov",        encounterID = 461 },
                        { name = "Lady Illucia Barov",       encounterID = 462 },
                        { name = "Darkmaster Gandling",      encounterID = 463 },
                    }
                },
                {
                    name = "Ancient Zul'Gurub",
                    mapID = 309,
                    bosses = {
                        { name = "High Priestess Jeklik", encounterID = 785 },
                        { name = "High Priest Venoxis",   encounterID = 784 },
                        { name = "High Priestess Mar'li", encounterID = 786 },
                        { name = "Bloodlord Mandokir",    encounterID = 787 },
                        { name = "Edge of Madness",       encounterID = 788 },
                        { name = "High Priest Thekal",    encounterID = 789 },
                        { name = "Gahz'ranka",            encounterID = 790 },
                        { name = "High Priestess Arlokk", encounterID = 791 },
                        { name = "Jin'do the Hexxer",     encounterID = 792 },
                        { name = "Hakkar",                encounterID = 793 },
                    }
                },
                {
                    name = "Stratholme",
                    mapID = 329,
                    bosses = {
                        { name = "Hearthsinger Forresten", encounterID = 473 },
                        { name = "Postmaster Malown",      encounterID = 1885 },
                        { name = "Timmy the Cruel",        encounterID = 474 },
                        { name = "Commander Malor",        encounterID = 476 },
                        { name = "Willey Hopebreaker",     encounterID = 475 },
                        { name = "Instructor Galford",     encounterID = 477 },
                        { name = "Balnazzar",              encounterID = 478 },
                        { name = "The Unforgiven",         encounterID = 472 },
                        { name = "Baroness Anastari",      encounterID = 479 },
                        { name = "Nerub'enkan",            encounterID = 480 },
                        { name = "Maleki the Pallid",      encounterID = 481 },
                        { name = "Magistrate Barthilas",   encounterID = 482 },
                        { name = "Ramstein the Gorger",    encounterID = 483 },
                        { name = "Lord Aurius Rivendare",  encounterID = 484 },
                    }
                },
                {
                    name = "Maraudon",
                    mapID = 349,
                    bosses = {
                        { name = "Noxxion",             encounterID = 422 },
                        { name = "Razorlash",           encounterID = 423 },
                        { name = "Tinkerer Gizlock",    encounterID = 427 },
                        { name = "Lord Vyletongue",     encounterID = 424 },
                        { name = "Celebras the Cursed", encounterID = 425 },
                        { name = "Landslide",           encounterID = 426 },
                        { name = "Rotgrip",             encounterID = 428 },
                        { name = "Princess Theradras",  encounterID = 429 },
                    }
                },
                {
                    name = "Ragefire Chasm",
                    mapID = 389,
                    bosses = {
                        { name = "Adarogg",               encounterID = 1443 },
                        { name = "Dark Shaman Koranthal", encounterID = 1444 },
                        { name = "Slagmaw",               encounterID = 1445 },
                        { name = "Lava Guard Gordoth",    encounterID = 1446 },
                    }
                },
                {
                    name = "Dire Maul",
                    mapID = 429,
                    bosses = {
                        { name = "Lethtendris",           encounterID = 345 },
                        { name = "Hydrospawn",            encounterID = 344 },
                        { name = "Zevrim Thornhoof",      encounterID = 343 },
                        { name = "Alzzin the Wildshaper", encounterID = 346 },
                        { name = "Tendris Warpwood",      encounterID = 350 },
                        { name = "Illyanna Ravenoak",     encounterID = 347 },
                        { name = "Magister Kalendris",    encounterID = 348 },
                        { name = "Immol'thar",            encounterID = 349 },
                        { name = "Prince Tortheldrin",    encounterID = 361 },
                        { name = "Guard Mol'dar",         encounterID = 362 },
                        { name = "Stomper Kreeg",         encounterID = 363 },
                        { name = "Guard Fengus",          encounterID = 364 },
                        { name = "Guard Slip'kik",        encounterID = 365 },
                        { name = "Captain Kromcrush",     encounterID = 366 },
                        { name = "Cho'Rush the Observer", encounterID = 367 },
                        { name = "King Gordok",           encounterID = 368 },
                    }
                },
                {
                    name = "Scarlet Halls",
                    mapID = 1001,
                    bosses = {
                        { name = "Houndmaster Braun",   encounterID = 1422 },
                        { name = "Armsmaster Harlan",   encounterID = 1421 },
                        { name = "Flameweaver Koegler", encounterID = 1420 },
                    }
                },
                {
                    name = "Scarlet Monastery",
                    mapID = 1004,
                    bosses = {
                        { name = "The Headless Horseman",     encounterID = 2725 },
                        { name = "Thalnos the Soulrender",    encounterID = 1423 },
                        { name = "Brother Korloff",           encounterID = 1424 },
                        { name = "High Inquisitor Whitemane", encounterID = 1425 },
                    }
                },
                {
                    name = "Scholomance",
                    mapID = 1007,
                    bosses = {
                        { name = "Instructor Chillheart", encounterID = 1426 },
                        { name = "Jandice Barov",         encounterID = 1427 },
                        { name = "Rattlegore",            encounterID = 1428 },
                        { name = "Lilian Voss",           encounterID = 1429 },
                        { name = "Darkmaster Gandling",   encounterID = 1430 },
                    }
                },
            },
        },
        -- Burning Crusade
        {
            name = "Burning Crusade",
            raids = {
                {
                    name = "Karazhan",
                    mapID = 532,
                    bosses = {
                        { name = "Attumen the Huntsman", encounterID = 652 },
                        { name = "Moroes",               encounterID = 653 },
                        { name = "Maiden of Virtue",     encounterID = 654 },
                        { name = "Opera Hall",           encounterID = 655 },
                        { name = "The Curator",          encounterID = 656 },
                        { name = "Terestian Illhoof",    encounterID = 657 },
                        { name = "Shade of Aran",        encounterID = 658 },
                        { name = "Netherspite",          encounterID = 659 },
                        { name = "Chess Event",          encounterID = 660 },
                        { name = "Prince Malchezaar",    encounterID = 661 },
                        { name = "Nightbane",            encounterID = 662 },
                    }
                },
                {
                    name = "Gruul's Lair",
                    mapID = 565,
                    bosses = {
                        { name = "High King Maulgar",      encounterID = 649 },
                        { name = "Gruul the Dragonkiller", encounterID = 650 },
                    }
                },
                {
                    name = "Magtheridon's Lair",
                    mapID = 544,
                    bosses = {
                        { name = "Magtheridon", encounterID = 651 },
                    }
                },
                {
                    name = "Coilfang: Serpentshrine Cavern",
                    mapID = 548,
                    bosses = {
                        { name = "Hydross the Unstable",   encounterID = 623 },
                        { name = "The Lurker Below",       encounterID = 624 },
                        { name = "Leotheras the Blind",    encounterID = 625 },
                        { name = "Fathom-Lord Karathress", encounterID = 626 },
                        { name = "Morogrim Tidewalker",    encounterID = 627 },
                        { name = "Lady Vashj",             encounterID = 628 },
                    }
                },
                {
                    name = "Tempest Keep",
                    mapID = 550,
                    bosses = {
                        { name = "Al'ar",                     encounterID = 730 },
                        { name = "Void Reaver",               encounterID = 731 },
                        { name = "High Astromancer Solarian", encounterID = 732 },
                        { name = "Kael'thas Sunstrider",      encounterID = 733 },
                    }
                },
                {
                    name = "The Battle for Mount Hyjal",
                    mapID = 534,
                    bosses = {
                        { name = "Rage Winterchill", encounterID = 618 },
                        { name = "Anetheron",        encounterID = 619 },
                        { name = "Kaz'rogal",        encounterID = 620 },
                        { name = "Azgalor",          encounterID = 621 },
                        { name = "Archimonde",       encounterID = 622 },
                    }
                },
                {
                    name = "Black Temple",
                    mapID = 564,
                    bosses = {
                        { name = "High Warlord Naj'entus", encounterID = 601 },
                        { name = "Supremus",               encounterID = 602 },
                        { name = "Shade of Akama",         encounterID = 603 },
                        { name = "Teron Gorefiend",        encounterID = 604 },
                        { name = "Gurtogg Bloodboil",      encounterID = 605 },
                        { name = "Reliquary of Souls",     encounterID = 606 },
                        { name = "Mother Shahraz",         encounterID = 607 },
                        { name = "The Illidari Council",   encounterID = 608 },
                        { name = "Illidan Stormrage",      encounterID = 609 },
                    }
                },
                {
                    name = "The Sunwell",
                    mapID = 580,
                    bosses = {
                        { name = "Kalecgos",     encounterID = 724 },
                        { name = "Brutallus",    encounterID = 725 },
                        { name = "Felmyst",      encounterID = 726 },
                        { name = "Eredar Twins", encounterID = 727 },
                        { name = "M'uru",        encounterID = 728 },
                        { name = "Kil'jaeden",   encounterID = 729 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Opening of the Dark Portal",
                    mapID = 269,
                    bosses = {
                        { name = "Aeonus",           encounterID = 1919 },
                        { name = "Chrono Lord Deja", encounterID = 1920 },
                        { name = "Temporus",         encounterID = 1921 },
                    }
                },
                {
                    name = "Hellfire Citadel: The Shattered Halls",
                    mapID = 540,
                    bosses = {
                        { name = "Blood Guard Porung",         encounterID = 1935 },
                        { name = "Grand Warlock Nethekurse",   encounterID = 1936 },
                        { name = "Warbringer O'mrogg",         encounterID = 1937 },
                        { name = "Warchief Kargath Bladefist", encounterID = 1938 },
                    }
                },
                {
                    name = "Hellfire Citadel: The Blood Furnace",
                    mapID = 542,
                    bosses = {
                        { name = "The Maker",            encounterID = 1922 },
                        { name = "Keli'dan the Breaker", encounterID = 1923 },
                        { name = "Broggok",              encounterID = 1924 },
                    }
                },
                {
                    name = "Hellfire Citadel: Ramparts",
                    mapID = 543,
                    bosses = {
                        { name = "Omor the Unscarred",    encounterID = 1891 },
                        { name = "Vazruden the Herald",   encounterID = 1892 },
                        { name = "Watchkeeper Gargolmar", encounterID = 1893 },
                    }
                },
                {
                    name = "Coilfang: The Steamvault",
                    mapID = 545,
                    bosses = {
                        { name = "Hydromancer Thespia",   encounterID = 1942 },
                        { name = "Mekgineer Steamrigger", encounterID = 1943 },
                        { name = "Warlord Kalithresh",    encounterID = 1944 },
                    }
                },
                {
                    name = "Coilfang: The Underbog",
                    mapID = 546,
                    bosses = {
                        { name = "Ghaz'an",            encounterID = 1945 },
                        { name = "Hungarfen",          encounterID = 1946 },
                        { name = "Swamplord Musel'ek", encounterID = 1947 },
                        { name = "The Black Stalker",  encounterID = 1948 },
                    }
                },
                {
                    name = "Coilfang: The Slave Pens",
                    mapID = 547,
                    bosses = {
                        { name = "Mennu the Betrayer",  encounterID = 1939 },
                        { name = "Quagmirran",          encounterID = 1940 },
                        { name = "Rokmar the Crackler", encounterID = 1941 },
                        { name = "The Frost Lord",      encounterID = 3317 },
                    }
                },
                {
                    name = "Tempest Keep: The Arcatraz",
                    mapID = 552,
                    bosses = {
                        { name = "Dalliah the Doomsayer",     encounterID = 1913 },
                        { name = "Harbinger Skyriss",         encounterID = 1914 },
                        { name = "Wrath-Scryer Soccothrates", encounterID = 1915 },
                        { name = "Zereketh the Unbound",      encounterID = 1916 },
                    }
                },
                {
                    name = "Tempest Keep: The Botanica",
                    mapID = 553,
                    bosses = {
                        { name = "Commander Sarannis",     encounterID = 1925 },
                        { name = "High Botanist Freywinn", encounterID = 1926 },
                        { name = "Laj",                    encounterID = 1927 },
                        { name = "Thorngrin the Tender",   encounterID = 1928 },
                        { name = "Warp Splinter",          encounterID = 1929 },
                    }
                },
                {
                    name = "Tempest Keep: The Mechanar",
                    mapID = 554,
                    bosses = {
                        { name = "Nethermancer Sepethrea",   encounterID = 1930 },
                        { name = "Pathaleon the Calculator", encounterID = 1931 },
                        { name = "Mechano-Lord Capacitus",   encounterID = 1932 },
                        { name = "Gatewatcher Gyro-Kill",    encounterID = 1933 },
                        { name = "Gatewatcher Iron-Hand",    encounterID = 1934 },
                    }
                },
                {
                    name = "Auchindoun: Shadow Labyrinth",
                    mapID = 555,
                    bosses = {
                        { name = "Ambassador Hellmaw",     encounterID = 1908 },
                        { name = "Blackheart the Inciter", encounterID = 1909 },
                        { name = "Murmur",                 encounterID = 1910 },
                        { name = "Grandmaster Vorpil",     encounterID = 1911 },
                    }
                },
                {
                    name = "Auchindoun: Sethekk Halls",
                    mapID = 556,
                    bosses = {
                        { name = "Talon King Ikiss", encounterID = 1902 },
                        { name = "Darkweaver Syth",  encounterID = 1903 },
                        { name = "Anzu",             encounterID = 1904 },
                    }
                },
                {
                    name = "Auchindoun: Mana-Tombs",
                    mapID = 557,
                    bosses = {
                        { name = "Nexus-Prince Shaffar", encounterID = 1899 },
                        { name = "Pandemonius",          encounterID = 1900 },
                        { name = "Yor",                  encounterID = 250 },
                        { name = "Tavarok",              encounterID = 1901 },
                    }
                },
                {
                    name = "Auchindoun: Auchenai Crypts",
                    mapID = 558,
                    bosses = {
                        { name = "Exarch Maladaar",          encounterID = 1889 },
                        { name = "Shirrak the Dead Watcher", encounterID = 1890 },
                    }
                },
                {
                    name = "The Escape from Durnholde",
                    mapID = 560,
                    bosses = {
                        { name = "Lieutenant Drake", encounterID = 1905 },
                        { name = "Epoch Hunter",     encounterID = 1906 },
                        { name = "Captain Skarloc",  encounterID = 1907 },
                    }
                },
                {
                    name = "Magisters' Terrace",
                    mapID = 585,
                    bosses = {
                        { name = "Kael'thas Sunstrider", encounterID = 1894 },
                        { name = "Priestess Delrissa",   encounterID = 1895 },
                        { name = "Selin Fireheart",      encounterID = 1897 },
                        { name = "Vexallus",             encounterID = 1898 },
                    }
                },
            },
        },
        -- Wrath of the Lich King
        {
            name = "Wrath of the Lich King",
            raids = {
                {
                    name = "Naxxramas",
                    mapID = 533,
                    bosses = {
                        { name = "Anub'Rekhan",            encounterID = 1107 },
                        { name = "Grand Widow Faerlina",   encounterID = 1110 },
                        { name = "Maexxna",                encounterID = 1116 },
                        { name = "Noth the Plaguebringer", encounterID = 1117 },
                        { name = "Heigan the Unclean",     encounterID = 1112 },
                        { name = "Loatheb",                encounterID = 1115 },
                        { name = "Instructor Razuvious",   encounterID = 1113 },
                        { name = "Gothik the Harvester",   encounterID = 1109 },
                        { name = "The Four Horsemen",      encounterID = 1121 },
                        { name = "Patchwerk",              encounterID = 1118 },
                        { name = "Grobbulus",              encounterID = 1111 },
                        { name = "Gluth",                  encounterID = 1108 },
                        { name = "Thaddius",               encounterID = 1120 },
                        { name = "Sapphiron",              encounterID = 1119 },
                        { name = "Kel'Thuzad",             encounterID = 1114 },
                    }
                },
                {
                    name = "The Obsidian Sanctum",
                    mapID = 615,
                    bosses = {
                        { name = "Vesperon",   encounterID = 1093 },
                        { name = "Tenebron",   encounterID = 1092 },
                        { name = "Shadron",    encounterID = 1091 },
                        { name = "Sartharion", encounterID = 1090 },
                    }
                },
                {
                    name = "The Eye of Eternity",
                    mapID = 616,
                    bosses = {
                        { name = "Malygos", encounterID = 1094 },
                    }
                },
                {
                    name = "Vault of Archavon",
                    mapID = 624,
                    bosses = {
                        { name = "Archavon the Stone Watcher", encounterID = 1126 },
                        { name = "Emalon the Storm Watcher",   encounterID = 1127 },
                        { name = "Koralon the Flame Watcher",  encounterID = 1128 },
                        { name = "Toravon the Ice Watcher",    encounterID = 1129 },
                    }
                },
                {
                    name = "Ulduar",
                    mapID = 603,
                    bosses = {
                        { name = "Flame Leviathan",          encounterID = 1132 },
                        { name = "Ignis the Furnace Master", encounterID = 1136 },
                        { name = "Razorscale",               encounterID = 1139 },
                        { name = "XT-002 Deconstructor",     encounterID = 1142 },
                        { name = "The Assembly of Iron",     encounterID = 1140 },
                        { name = "Kologarn",                 encounterID = 1137 },
                        { name = "Auriaya",                  encounterID = 1131 },
                        { name = "Hodir",                    encounterID = 1135 },
                        { name = "Thorim",                   encounterID = 1141 },
                        { name = "Elder Brightleaf",         encounterID = 1164 },
                        { name = "Elder Ironbranch",         encounterID = 1165 },
                        { name = "Elder Stonebark",          encounterID = 1166 },
                        { name = "Freya",                    encounterID = 1133 },
                        { name = "Mimiron",                  encounterID = 1138 },
                        { name = "General Vezax",            encounterID = 1134 },
                        { name = "Yogg-Saron",               encounterID = 1143 },
                        { name = "Algalon the Observer",     encounterID = 1130 },
                    }
                },
                {
                    name = "Trial of the Crusader",
                    mapID = 649,
                    bosses = {
                        { name = "Northrend Beasts",  encounterID = 1088 },
                        { name = "Lord Jaraxxus",     encounterID = 1087 },
                        { name = "Faction Champions", encounterID = 1086 },
                        { name = "Val'kyr Twins",     encounterID = 1089 },
                        { name = "Anub'arak",         encounterID = 1085 },
                    }
                },
                {
                    name = "Icecrown Citadel",
                    mapID = 631,
                    bosses = {
                        { name = "Lord Marrowgar",          encounterID = 1101 },
                        { name = "Lady Deathwhisper",       encounterID = 1100 },
                        { name = "Icecrown Gunship Battle", encounterID = 1099 },
                        { name = "Deathbringer Saurfang",   encounterID = 1096 },
                        { name = "Rotface",                 encounterID = 1104 },
                        { name = "Festergut",               encounterID = 1097 },
                        { name = "Professor Putricide",     encounterID = 1102 },
                        { name = "Blood Council",           encounterID = 1095 },
                        { name = "Queen Lana'thel",         encounterID = 1103 },
                        { name = "Valithria Dreamwalker",   encounterID = 1098 },
                        { name = "Sindragosa",              encounterID = 1105 },
                        { name = "The Lich King",           encounterID = 1106 },
                    }
                },
                {
                    name = "The Ruby Sanctum",
                    mapID = 724,
                    bosses = {
                        { name = "Baltharus the Warborn", encounterID = 1147 },
                        { name = "Saviana Ragefire",      encounterID = 1149 },
                        { name = "General Zarithrian",    encounterID = 1148 },
                        { name = "Halion",                encounterID = 1150 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Utgarde Keep",
                    mapID = 574,
                    bosses = {
                        { name = "Prince Keleseth",      encounterID = 2026 },
                        { name = "Skarvold & Dalronn",   encounterID = 2024 },
                        { name = "Ingvar the Plunderer", encounterID = 2025 },
                    }
                },
                {
                    name = "Utgarde Pinnacle",
                    mapID = 575,
                    bosses = {
                        { name = "Svala Sorrowgrave",  encounterID = 2030 },
                        { name = "Gortok Palehoof",    encounterID = 2027 },
                        { name = "Skadi the Ruthless", encounterID = 2029 },
                        { name = "King Ymiron",        encounterID = 2028 },
                    }
                },
                {
                    name = "The Nexus",
                    mapID = 576,
                    bosses = {
                        { name = "Frozen Commander",        encounterID = 3017 },
                        { name = "Frozen Commander",        encounterID = 519 },
                        { name = "Anomalus",                encounterID = 2009 },
                        { name = "Grand Magus Telestra",    encounterID = 2010 },
                        { name = "Keristrasza",             encounterID = 2011 },
                        { name = "Ormorok the Tree-Shaper", encounterID = 2012 },
                    }
                },
                {
                    name = "The Oculus",
                    mapID = 578,
                    bosses = {
                        { name = "Drakos the Interrogator", encounterID = 528 },
                        { name = "Ley-Guardian Eregos",     encounterID = 2013 },
                        { name = "Drakos the Interrogator", encounterID = 529 },
                        { name = "Varos Cloudstrider",      encounterID = 530 },
                        { name = "Mage-Lord Urom",          encounterID = 2014 },
                        { name = "Varos Cloudstrider",      encounterID = 531 },
                        { name = "Mage-Lord Urom",          encounterID = 532 },
                        { name = "Varos Cloudstrider",      encounterID = 2015 },
                        { name = "Mage-Lord Urom",          encounterID = 533 },
                        { name = "Ley-Guardian Eregos",     encounterID = 534 },
                        { name = "Drakos the Interrogator", encounterID = 2016 },
                        { name = "Ley-Guardian Eregos",     encounterID = 535 },
                    }
                },
                {
                    name = "The Culling of Stratholme",
                    mapID = 595,
                    bosses = {
                        { name = "Meathook",                encounterID = 2002 },
                        { name = "Chrono-Lord Epoch",       encounterID = 2003 },
                        { name = "Salram the Fleshcrafter", encounterID = 2004 },
                        { name = "Mal'ganis",               encounterID = 2005 },
                    }
                },
                {
                    name = "Halls of Stone",
                    mapID = 599,
                    bosses = {
                        { name = "Krystallus",             encounterID = 1994 },
                        { name = "Maiden of Grief",        encounterID = 1996 },
                        { name = "Tribunal of Ages",       encounterID = 1995 },
                        { name = "Sjonnir the Ironshaper", encounterID = 1998 },
                    }
                },
                {
                    name = "Drak'Tharon Keep",
                    mapID = 600,
                    bosses = {
                        { name = "Trollgore",             encounterID = 1974 },
                        { name = "Novos the Summoner",    encounterID = 1976 },
                        { name = "King Dred",             encounterID = 1977 },
                        { name = "The Prophet Tharon'ja", encounterID = 1975 },
                    }
                },
                {
                    name = "Azjol-Nerub",
                    mapID = 601,
                    bosses = {
                        { name = "Krik'thir the Gatewatcher", encounterID = 1971 },
                        { name = "Hadronox",                  encounterID = 1972 },
                        { name = "Anub'arak",                 encounterID = 1973 },
                    }
                },
                {
                    name = "Halls of Lightning",
                    mapID = 602,
                    bosses = {
                        { name = "General Bjarngrim", encounterID = 1987 },
                        { name = "Volkhan",           encounterID = 1985 },
                        { name = "Ionar",             encounterID = 1984 },
                        { name = "Loken",             encounterID = 1986 },
                    }
                },
                {
                    name = "Gundrak",
                    mapID = 604,
                    bosses = {
                        { name = "Slad'ran",          encounterID = 1978 },
                        { name = "Drakkari Colossus", encounterID = 1983 },
                        { name = "Moorabi",           encounterID = 1980 },
                        { name = "Eck the Ferocious", encounterID = 1988 },
                        { name = "Gal'darah",         encounterID = 1981 },
                    }
                },
                {
                    name = "Violet Hold",
                    mapID = 608,
                    bosses = {
                        { name = "Second Prisoner", encounterID = 2018 },
                        { name = "First Prisoner",  encounterID = 2019 },
                        { name = "Cyanigosa",       encounterID = 2020 },
                    }
                },
                {
                    name = "Ahn'kahet: The Old Kingdom",
                    mapID = 619,
                    bosses = {
                        { name = "Elder Nadox",         encounterID = 1969 },
                        { name = "Prince Taldaram",     encounterID = 1966 },
                        { name = "Jedoga Shadowseeker", encounterID = 1967 },
                        { name = "Amanitar",            encounterID = 1989 },
                        { name = "Herald Volazj",       encounterID = 1968 },
                    }
                },
                {
                    name = "The Forge of Souls",
                    mapID = 632,
                    bosses = {
                        { name = "Bronjahm",          encounterID = 2006 },
                        { name = "Devourer of Souls", encounterID = 2007 },
                    }
                },
                {
                    name = "Trial of the Champion",
                    mapID = 650,
                    bosses = {
                        { name = "Grand Champions",  encounterID = 2022 },
                        { name = "Argent Champion",  encounterID = 2023 },
                        { name = "The Black Knight", encounterID = 2021 },
                    }
                },
                {
                    name = "Pit of Saron",
                    mapID = 658,
                    bosses = {
                        { name = "Forgemaster Garfrost", encounterID = 1999 },
                        { name = "Ick and Krick",        encounterID = 2001 },
                        { name = "Scourgelord Tyrannus", encounterID = 2000 },
                    }
                },
                {
                    name = "Halls of Reflection",
                    mapID = 668,
                    bosses = {
                        { name = "Falric",              encounterID = 1992 },
                        { name = "Marwyn",              encounterID = 1993 },
                        { name = "Escaped from Arthas", encounterID = 1990 },
                    }
                },
            },
        },
        -- Cataclysm
        {
            name = "Cataclysm",
            raids = {
                {
                    name = "Blackwing Descent",
                    mapID = 669,
                    bosses = {
                        { name = "Omnotron Defense System", encounterID = 1027 },
                        { name = "Magmaw",                  encounterID = 1024 },
                        { name = "Atramedes",               encounterID = 1022 },
                        { name = "Chimaeron",               encounterID = 1023 },
                        { name = "Maloriak",                encounterID = 1025 },
                        { name = "Nefarian's End",          encounterID = 1026 },
                    }
                },
                {
                    name = "Throne of the Four Winds",
                    mapID = 754,
                    bosses = {
                        { name = "Conclave of Wind", encounterID = 1035 },
                        { name = "Al'Akir",          encounterID = 1034 },
                    }
                },
                {
                    name = "The Bastion of Twilight",
                    mapID = 671,
                    bosses = {
                        { name = "Halfus Wyrmbreaker",    encounterID = 1030 },
                        { name = "Theralion and Valiona", encounterID = 1032 },
                        { name = "Ascendant Council",     encounterID = 1028 },
                        { name = "Cho'gall",              encounterID = 1029 },
                        { name = "Sinestra",              encounterID = 1082 },
                        { name = "Sinestra",              encounterID = 1083 },
                    }
                },
                {
                    name = "Baradin Hold",
                    mapID = 757,
                    bosses = {
                        { name = "Argaloth",  encounterID = 1033 },
                        { name = "Occu'thar", encounterID = 1250 },
                        { name = "Alizabal",  encounterID = 1332 },
                    }
                },
                {
                    name = "Firelands",
                    mapID = 720,
                    bosses = {
                        { name = "Beth'tilac",         encounterID = 1197 },
                        { name = "Lord Rhyolith",      encounterID = 1204 },
                        { name = "Shannox",            encounterID = 1205 },
                        { name = "Alysrazor",          encounterID = 1206 },
                        { name = "Baleroc",            encounterID = 1200 },
                        { name = "Majordomo Staghelm", encounterID = 1185 },
                        { name = "Ragnaros",           encounterID = 1203 },
                    }
                },
                {
                    name = "Dragon Soul",
                    mapID = 967,
                    bosses = {
                        { name = "Morchok",                 encounterID = 1292 },
                        { name = "Warlord Zon'ozz",         encounterID = 1294 },
                        { name = "Yor'sahj the Unsleeping", encounterID = 1295 },
                        { name = "Hagara",                  encounterID = 1296 },
                        { name = "Ultraxion",               encounterID = 1297 },
                        { name = "Warmaster Blackhorn",     encounterID = 1298 },
                        { name = "Spine of Deathwing",      encounterID = 1291 },
                        { name = "Madness of Deathwing",    encounterID = 1299 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Zul'Aman",
                    mapID = 568,
                    bosses = {
                        { name = "Akil'zon",           encounterID = 1189 },
                        { name = "Nalorakk",           encounterID = 1190 },
                        { name = "Jan'alai",           encounterID = 1191 },
                        { name = "Halazzi",            encounterID = 1192 },
                        { name = "Hex Lord Malacrass", encounterID = 1193 },
                        { name = "Daakara",            encounterID = 1194 },
                    }
                },
                {
                    name = "Throne of the Tides",
                    mapID = 643,
                    bosses = {
                        { name = "Lady Naz'jar",        encounterID = 1045 },
                        { name = "Commander Ulthok",    encounterID = 1044 },
                        { name = "Mindbender Ghur'sha", encounterID = 1046 },
                        { name = "Ozumat",              encounterID = 1047 },
                    }
                },
                {
                    name = "Halls of Origination",
                    mapID = 644,
                    bosses = {
                        { name = "Temple Guardian Anhuur", encounterID = 1080 },
                        { name = "Earthrager Ptah",        encounterID = 1076 },
                        { name = "Anraphet",               encounterID = 1075 },
                        { name = "Isiset",                 encounterID = 1077 },
                        { name = "Ammunae",                encounterID = 1074 },
                        { name = "Setesh",                 encounterID = 1079 },
                        { name = "Rajh",                   encounterID = 1078 },
                    }
                },
                {
                    name = "Blackrock Caverns",
                    mapID = 645,
                    bosses = {
                        { name = "Rom'ogg Bonecrusher",       encounterID = 1040 },
                        { name = "Corla, Herald of Twilight", encounterID = 1038 },
                        { name = "Karsh Steelbender",         encounterID = 1039 },
                        { name = "Beauty",                    encounterID = 1037 },
                        { name = "Ascendant Lord Obsidius",   encounterID = 1036 },
                    }
                },
                {
                    name = "The Vortex Pinnacle",
                    mapID = 657,
                    bosses = {
                        { name = "Grand Vizier Ertan", encounterID = 1043 },
                        { name = "Altairus",           encounterID = 1041 },
                        { name = "Asaad",              encounterID = 1042 },
                    }
                },
                {
                    name = "Grim Batol",
                    mapID = 670,
                    bosses = {
                        { name = "General Umbriss",      encounterID = 1051 },
                        { name = "Forgemaster Throngus", encounterID = 1050 },
                        { name = "Drahga Shadowburner",  encounterID = 1048 },
                        { name = "Erudax",               encounterID = 1049 },
                    }
                },
                {
                    name = "The Stonecore",
                    mapID = 725,
                    bosses = {
                        { name = "Corborus",            encounterID = 1056 },
                        { name = "Slabhide",            encounterID = 1059 },
                        { name = "Ozruk",               encounterID = 1058 },
                        { name = "High Priestess Azil", encounterID = 1057 },
                    }
                },
                {
                    name = "Lost City of the Tol'vir",
                    mapID = 755,
                    bosses = {
                        { name = "General Husam",      encounterID = 1052 },
                        { name = "High Prophet Barim", encounterID = 1053 },
                        { name = "Lockmaw",            encounterID = 1054 },
                        { name = "Siamat",             encounterID = 1055 },
                    }
                },
                {
                    name = "Zul'Gurub",
                    mapID = 859,
                    bosses = {
                        { name = "High Priest Venoxis",    encounterID = 1178 },
                        { name = "Bloodlord Mandokir",     encounterID = 1179 },
                        { name = "Cache of Madness",       encounterID = 1188 },
                        { name = "High Priestess Kilnara", encounterID = 1180 },
                        { name = "Zanzil",                 encounterID = 1181 },
                        { name = "Jin'do the Godbreaker",  encounterID = 1182 },
                    }
                },
                {
                    name = "End Time",
                    mapID = 938,
                    bosses = {
                        { name = "Echo of Baine",    encounterID = 1881 },
                        { name = "Echo of Sylvanas", encounterID = 1882 },
                        { name = "Echo of Jaina",    encounterID = 1883 },
                        { name = "Echo of Tyrande",  encounterID = 1884 },
                        { name = "Murozond",         encounterID = 1271 },
                    }
                },
                {
                    name = "Well of Eternity",
                    mapID = 939,
                    bosses = {
                        { name = "Peroth'arn",    encounterID = 1272 },
                        { name = "Queen Azshara", encounterID = 1273 },
                        { name = "Mannoroth",     encounterID = 1274 },
                    }
                },
                {
                    name = "Hour of Twilight",
                    mapID = 940,
                    bosses = {
                        { name = "Arcurion",              encounterID = 1337 },
                        { name = "Asira Dawnslayer",      encounterID = 1340 },
                        { name = "Archbishop Benedictus", encounterID = 1339 },
                    }
                },
            },
        },
        -- Mists of Pandaria
        {
            name = "Mists of Pandaria",
            raids = {
                {
                    name = "Mogu'shan Vaults",
                    mapID = 1008,
                    bosses = {
                        { name = "The Stone Guard",           encounterID = 1395 },
                        { name = "Feng the Accursed",         encounterID = 1390 },
                        { name = "Gara'jal the Spiritbinder", encounterID = 1434 },
                        { name = "The Spirit Kings",          encounterID = 1436 },
                        { name = "Elegon",                    encounterID = 1500 },
                        { name = "Will of the Emperor",       encounterID = 1407 },
                    }
                },
                {
                    name = "Heart of Fear",
                    mapID = 1009,
                    bosses = {
                        { name = "Imperial Vizier Zor'lok", encounterID = 1507 },
                        { name = "Blade Lord Ta'yak",       encounterID = 1504 },
                        { name = "Garalon",                 encounterID = 1463 },
                        { name = "Wind Lord Mel'jarak",     encounterID = 1498 },
                        { name = "Amber-Shaper Un'sok",     encounterID = 1499 },
                        { name = "Grand Empress Shek'zeer", encounterID = 1501 },
                    }
                },
                {
                    name = "Terrace of Endless Spring",
                    mapID = 996,
                    bosses = {
                        { name = "Protectors of the Endless", encounterID = 1409 },
                        { name = "Tsulong",                   encounterID = 1505 },
                        { name = "Lei Shi",                   encounterID = 1506 },
                        { name = "Sha of Fear",               encounterID = 1431 },
                    }
                },
                {
                    name = "Throne of Thunder",
                    mapID = 1098,
                    bosses = {
                        { name = "Jin'rokh the Breaker", encounterID = 1577 },
                        { name = "Horridon",             encounterID = 1575 },
                        { name = "Council of Elders",    encounterID = 1570 },
                        { name = "Tortos",               encounterID = 1565 },
                        { name = "Megaera",              encounterID = 1578 },
                        { name = "Ji-Kun",               encounterID = 1573 },
                        { name = "Durumu the Forgotten", encounterID = 1572 },
                        { name = "Primordius",           encounterID = 1574 },
                        { name = "Dark Animus",          encounterID = 1576 },
                        { name = "Iron Qon",             encounterID = 1559 },
                        { name = "Twin Empyreans",       encounterID = 1560 },
                        { name = "Lei Shen",             encounterID = 1579 },
                        { name = "Ra-den",               encounterID = 1580 },
                        { name = "Ra-den",               encounterID = 1581 },
                    }
                },
                {
                    name = "Siege of Orgrimmar",
                    mapID = 1136,
                    bosses = {
                        { name = "Immerseus",                                 encounterID = 1602 },
                        { name = "Fallen Protectors",                         encounterID = 1598 },
                        { name = "Norushen",                                  encounterID = 1624 },
                        { name = "Sha of Pride",                              encounterID = 1604 },
                        { name = "Galakras",                                  encounterID = 1622 },
                        { name = "Iron Juggernaut",                           encounterID = 1600 },
                        { name = "Kor'kron Dark Shaman",                      encounterID = 1606 },
                        { name = "General Nazgrim",                           encounterID = 1603 },
                        { name = "Malkorok",                                  encounterID = 1595 },
                        { name = "Spoils of Pandaria",                        encounterID = 1594 },
                        { name = "Thok the Bloodthirsty",                     encounterID = 1599 },
                        { name = "Siegecrafter Blackfuse",                    encounterID = 1601 },
                        { name = "Paragons of the Klaxxi",                    encounterID = 1593 },
                        { name = "Garrosh Hellscream",                        encounterID = 1623 },
                        { name = "Omar's Test Encounter (Cosmetic only) DNT", encounterID = 1605 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Shado-Pan Monastery",
                    mapID = 959,
                    bosses = {
                        { name = "Gu Cloudstrike",   encounterID = 1303 },
                        { name = "Master Snowdrift", encounterID = 1304 },
                        { name = "Sha of Violence",  encounterID = 1305 },
                        { name = "Taran Zhu",        encounterID = 1306 },
                    }
                },
                {
                    name = "Temple of the Jade Serpent",
                    mapID = 960,
                    bosses = {
                        { name = "Wise Mari",            encounterID = 1418 },
                        { name = "Lorewalker Stonestep", encounterID = 1417 },
                        { name = "Liu Flameheart",       encounterID = 1416 },
                        { name = "Sha of Doubt",         encounterID = 1439 },
                    }
                },
                {
                    name = "Stormstout Brewery",
                    mapID = 961,
                    bosses = {
                        { name = "Ook-Ook",              encounterID = 1412 },
                        { name = "Hoptallus",            encounterID = 1413 },
                        { name = "Yan-Zhu the Uncasked", encounterID = 1414 },
                    }
                },
                {
                    name = "Gate of the Setting Sun",
                    mapID = 962,
                    bosses = {
                        { name = "Saboteur Kip'tilak", encounterID = 1397 },
                        { name = "Striker Ga'dok",     encounterID = 1405 },
                        { name = "Commander Ri'mok",   encounterID = 1406 },
                        { name = "Raigonn",            encounterID = 1419 },
                    }
                },
                {
                    name = "Mogu'shan Palace",
                    mapID = 994,
                    bosses = {
                        { name = "Trial of the King",    encounterID = 1442 },
                        { name = "Gekkan",               encounterID = 2129 },
                        { name = "Xin the Weaponmaster", encounterID = 1441 },
                    }
                },
                {
                    name = "Siege of Niuzao Temple",
                    mapID = 1011,
                    bosses = {
                        { name = "Vizier Jin'bak",       encounterID = 1465 },
                        { name = "Commander Vo'jak",     encounterID = 1502 },
                        { name = "General Pa'valak",     encounterID = 1447 },
                        { name = "Wing Leader Ner'onok", encounterID = 1464 },
                    }
                },
            },
        },
        -- Warlords of Draenor
        {
            name = "Warlords of Draenor",
            raids = {
                {
                    name = "Highmaul",
                    mapID = 1228,
                    bosses = {
                        { name = "Kargath Bladefist",           encounterID = 1721 },
                        { name = "The Butcher",                 encounterID = 1706 },
                        { name = "Brackenspore",                encounterID = 1720 },
                        { name = "Tectus, The Living Mountain", encounterID = 1722 },
                        { name = "Twin Ogron",                  encounterID = 1719 },
                        { name = "Ko'ragh",                     encounterID = 1723 },
                        { name = "Imperator Mar'gok",           encounterID = 1705 },
                    }
                },
                {
                    name = "Blackrock Foundry",
                    mapID = 1205,
                    bosses = {
                        { name = "Oregorger the Devourer",         encounterID = 1696 },
                        { name = "Gruul",                          encounterID = 1691 },
                        { name = "Hans'gar & Franzok",             encounterID = 1693 },
                        { name = "Beastlord Darmac",               encounterID = 1694 },
                        { name = "Flamebender Ka'graz",            encounterID = 1689 },
                        { name = "Operator Thogar",                encounterID = 1692 },
                        { name = "Blast Furnace",                  encounterID = 1690 },
                        { name = "Kromog, Legend of the Mountain", encounterID = 1713 },
                        { name = "The Iron Maidens",               encounterID = 1695 },
                        { name = "Blackhand",                      encounterID = 1704 },
                    }
                },
                {
                    name = "Hellfire Citadel",
                    mapID = 1448,
                    bosses = {
                        { name = "Hellfire Assault",      encounterID = 1778 },
                        { name = "Iron Reaver",           encounterID = 1785 },
                        { name = "Kormrok",               encounterID = 1787 },
                        { name = "Hellfire High Council", encounterID = 1798 },
                        { name = "Kilrogg Deadeye",       encounterID = 1786 },
                        { name = "Gorefiend",             encounterID = 1783 },
                        { name = "Shadow-Lord Iskar",     encounterID = 1788 },
                        { name = "Socrethar the Eternal", encounterID = 1794 },
                        { name = "Fel Lord Zakuun",       encounterID = 1777 },
                        { name = "Xhul'horac",            encounterID = 1800 },
                        { name = "Tyrant Velhari",        encounterID = 1784 },
                        { name = "Mannoroth",             encounterID = 1795 },
                        { name = "Archimonde",            encounterID = 1799 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Bloodmaul Slag Mines",
                    mapID = 1175,
                    bosses = {
                        { name = "Magmolatus",            encounterID = 1655 },
                        { name = "Slave Watcher Crushto", encounterID = 1653 },
                        { name = "Roltall",               encounterID = 1652 },
                        { name = "Gug'rokk",              encounterID = 1654 },
                    }
                },
                {
                    name = "Shadowmoon Burial Grounds",
                    mapID = 1176,
                    bosses = {
                        { name = "Sadana Bloodfury", encounterID = 1677 },
                        { name = "Nhallish",         encounterID = 1688 },
                        { name = "Bonemaw",          encounterID = 1679 },
                        { name = "Ner'zhul",         encounterID = 1682 },
                    }
                },
                {
                    name = "Auchindoun",
                    mapID = 1182,
                    bosses = {
                        { name = "Vigilant Kaathar",                encounterID = 1686 },
                        { name = "Soulbinder Nyami",                encounterID = 1685 },
                        { name = "Azzakel, Vanguard of the Legion", encounterID = 1678 },
                        { name = "Teron'gor",                       encounterID = 1714 },
                    }
                },
                {
                    name = "Iron Docks",
                    mapID = 1195,
                    bosses = {
                        { name = "Fleshrender Nok'gar",   encounterID = 1749 },
                        { name = "Grimrail Enforcers",    encounterID = 1748 },
                        { name = "Oshir",                 encounterID = 1750 },
                        { name = "Skulloc, Son of Gruul", encounterID = 1754 },
                    }
                },
                {
                    name = "Grimrail Depot",
                    mapID = 1208,
                    bosses = {
                        { name = "Rocketspark and Borka", encounterID = 1715 },
                        { name = "Nitrogg Thundertower",  encounterID = 1732 },
                        { name = "Skylord Tovra",         encounterID = 1736 },
                    }
                },
                {
                    name = "Skyreach",
                    mapID = 1209,
                    bosses = {
                        { name = "Ranjit",          encounterID = 1698 },
                        { name = "Araknath",        encounterID = 1699 },
                        { name = "Rukhran",         encounterID = 1700 },
                        { name = "High Sage Viryx", encounterID = 1701 },
                    }
                },
                {
                    name = "The Everbloom",
                    mapID = 1279,
                    bosses = {
                        { name = "Witherbark",         encounterID = 1746 },
                        { name = "Ancient Protectors", encounterID = 1757 },
                        { name = "Archmage Sol",       encounterID = 1751 },
                        { name = "Xeri'tac",           encounterID = 1752 },
                        { name = "Yalnu",              encounterID = 1756 },
                    }
                },
                {
                    name = "Upper Blackrock Spire",
                    mapID = 1358,
                    bosses = {
                        { name = "Orebender Gor'ashan",  encounterID = 1761 },
                        { name = "Kyrak",                encounterID = 1758 },
                        { name = "Commander Tharbek",    encounterID = 1759 },
                        { name = "Ragewing the Untamed", encounterID = 1760 },
                        { name = "Warlord Zaela",        encounterID = 1762 },
                    }
                },
            },
        },
        -- Legion
        {
            name = "Legion",
            raids = {
                {
                    name = "The Emerald Nightmare",
                    mapID = 1520,
                    bosses = {
                        { name = "Nythendra",                          encounterID = 1853 },
                        { name = "Ursoc",                              encounterID = 1841 },
                        { name = "Il'gynoth, The Heart of Corruption", encounterID = 1873 },
                        { name = "Dragons of Nightmare",               encounterID = 1854 },
                        { name = "Elerethe Renferal",                  encounterID = 1876 },
                        { name = "Cenarius",                           encounterID = 1877 },
                        { name = "Xavius",                             encounterID = 1864 },
                    }
                },
                {
                    name = "Trial of Valor",
                    mapID = 1648,
                    bosses = {
                        { name = "Odyn",  encounterID = 1958 },
                        { name = "Guarm", encounterID = 1962 },
                        { name = "Helya", encounterID = 2008 },
                    }
                },
                {
                    name = "The Nighthold",
                    mapID = 1530,
                    bosses = {
                        { name = "Skorpyron",                encounterID = 1849 },
                        { name = "Chronomatic Anomaly",      encounterID = 1865 },
                        { name = "Trilliax",                 encounterID = 1867 },
                        { name = "Spellblade Aluriel",       encounterID = 1871 },
                        { name = "Tichondrius",              encounterID = 1862 },
                        { name = "High Botanist Tel'arn",    encounterID = 1886 },
                        { name = "Krosus",                   encounterID = 1842 },
                        { name = "Star Augur Etraeus",       encounterID = 1863 },
                        { name = "Grand Magistrix Elisande", encounterID = 1872 },
                        { name = "Gul'dan",                  encounterID = 1866 },
                    }
                },
                {
                    name = "Tomb of Sargeras",
                    mapID = 1676,
                    bosses = {
                        { name = "Goroth",              encounterID = 2032 },
                        { name = "Demonic Inquisition", encounterID = 2048 },
                        { name = "Harjatan",            encounterID = 2036 },
                        { name = "Sisters of the Moon", encounterID = 2050 },
                        { name = "Mistress Sassz'ine",  encounterID = 2037 },
                        { name = "The Desolate Host",   encounterID = 2054 },
                        { name = "Maiden of Vigilance", encounterID = 2052 },
                        { name = "Fallen Avatar",       encounterID = 2038 },
                        { name = "Kil'jaeden",          encounterID = 2051 },
                    }
                },
                {
                    name = "Antorus, the Burning Throne",
                    mapID = 1712,
                    bosses = {
                        { name = "Garothi Worldbreaker",  encounterID = 2076 },
                        { name = "Felhounds of Sargeras", encounterID = 2074 },
                        { name = "Portal Keeper Hasabel", encounterID = 2064 },
                        { name = "Antoran High Command",  encounterID = 2070 },
                        { name = "The Defense of Eonar",  encounterID = 2075 },
                        { name = "Imonar the Soulhunter", encounterID = 2082 },
                        { name = "Kin'garoth",            encounterID = 2088 },
                        { name = "Varimathras",           encounterID = 2069 },
                        { name = "The Coven of Shivarra", encounterID = 2073 },
                        { name = "Aggramar",              encounterID = 2063 },
                        { name = "Argus the Unmaker",     encounterID = 2092 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Eye of Azshara",
                    mapID = 1456,
                    bosses = {
                        { name = "Warlord Parjesh",  encounterID = 1810 },
                        { name = "Lady Hatecoil",    encounterID = 1811 },
                        { name = "King Deepbeard",   encounterID = 1812 },
                        { name = "Serpentrix",       encounterID = 1813 },
                        { name = "Wrath of Azshara", encounterID = 1814 },
                    }
                },
                {
                    name = "Neltharion's Lair",
                    mapID = 1458,
                    bosses = {
                        { name = "Rokmora",               encounterID = 1790 },
                        { name = "Ularogg Cragshaper",    encounterID = 1791 },
                        { name = "Naraxas",               encounterID = 1792 },
                        { name = "Dargrul the Underking", encounterID = 1793 },
                    }
                },
                {
                    name = "Darkheart Thicket",
                    mapID = 1466,
                    bosses = {
                        { name = "Archdruid Glaidalis", encounterID = 1836 },
                        { name = "Oakheart",            encounterID = 1837 },
                        { name = "Dresaron",            encounterID = 1838 },
                        { name = "Shade of Xavius",     encounterID = 1839 },
                    }
                },
                {
                    name = "Halls of Valor",
                    mapID = 1477,
                    bosses = {
                        { name = "Hymdall",          encounterID = 1805 },
                        { name = "Hyrja",            encounterID = 1806 },
                        { name = "Fenryr",           encounterID = 1807 },
                        { name = "God-King Skovald", encounterID = 1808 },
                        { name = "Odyn",             encounterID = 1809 },
                    }
                },
                {
                    name = "Maw of Souls",
                    mapID = 1492,
                    bosses = {
                        { name = "Ymiron, the Fallen King", encounterID = 1822 },
                        { name = "Harbaron",                encounterID = 1823 },
                        { name = "Helya",                   encounterID = 1824 },
                    }
                },
                {
                    name = "Vault of the Wardens",
                    mapID = 1493,
                    bosses = {
                        { name = "Tirathon Saltheril",     encounterID = 1815 },
                        { name = "Inquisitor Tormentorum", encounterID = 1850 },
                        { name = "Ash'Golm",               encounterID = 1816 },
                        { name = "Glazer",                 encounterID = 1817 },
                        { name = "Cordana Felsong",        encounterID = 1818 },
                    }
                },
                {
                    name = "Black Rook Hold",
                    mapID = 1501,
                    bosses = {
                        { name = "Amalgam of Souls",          encounterID = 1832 },
                        { name = "Ilysanna Ravencrest",       encounterID = 1833 },
                        { name = "Smashspite the Hateful",    encounterID = 1834 },
                        { name = "Lord Kur'talos Ravencrest", encounterID = 1835 },
                    }
                },
                {
                    name = "The Arcway",
                    mapID = 1516,
                    bosses = {
                        { name = "Corstilax",       encounterID = 1825 },
                        { name = "Nal'tira",        encounterID = 1826 },
                        { name = "Ivanyr",          encounterID = 1827 },
                        { name = "General Xakal",   encounterID = 1828 },
                        { name = "Advisor Vandros", encounterID = 1829 },
                    }
                },
                {
                    name = "Assault on Violet Hold",
                    mapID = 1544,
                    bosses = {
                        { name = "Shivermaw",               encounterID = 1845 },
                        { name = "Mindflayer Kaahrj",       encounterID = 1846 },
                        { name = "Millificent Manastorm",   encounterID = 1847 },
                        { name = "Festerface",              encounterID = 1848 },
                        { name = "Sael'orn",                encounterID = 1851 },
                        { name = "Anub'esset",              encounterID = 1852 },
                        { name = "Blood-Princess Thal'ena", encounterID = 1855 },
                        { name = "Fel Lord Betrug",         encounterID = 1856 },
                    }
                },
                {
                    name = "Court of Stars",
                    mapID = 1571,
                    bosses = {
                        { name = "Patrol Captain Gerdo", encounterID = 1868 },
                        { name = "Talixae Flamewreath",  encounterID = 1869 },
                        { name = "Advisor Melandrus",    encounterID = 1870 },
                    }
                },
                {
                    name = "Return to Karazhan",
                    mapID = 1651,
                    bosses = {
                        { name = "Opera Hall",            encounterID = 1957 },
                        { name = "Maiden of Virtue",      encounterID = 1954 },
                        { name = "Moroes",                encounterID = 1961 },
                        { name = "Attumen the Huntsman",  encounterID = 1960 },
                        { name = "The Curator",           encounterID = 1964 },
                        { name = "Shade of Medivh",       encounterID = 1965 },
                        { name = "Mana Devourer",         encounterID = 1959 },
                        { name = "Viz'aduum the Watcher", encounterID = 2017 },
                        { name = "Nightbane",             encounterID = 2031 },
                    }
                },
                {
                    name = "Cathedral of Eternal Night",
                    mapID = 1677,
                    bosses = {
                        { name = "Agronox",                 encounterID = 2055 },
                        { name = "Thrashbite the Scornful", encounterID = 2057 },
                        { name = "Mephistroth",             encounterID = 2039 },
                        { name = "Domatrax",                encounterID = 2053 },
                    }
                },
                {
                    name = "Seat of the Triumvirate",
                    mapID = 1753,
                    bosses = {
                        { name = "Zuraal the Ascended", encounterID = 2065 },
                        { name = "Saprish",             encounterID = 2066 },
                        { name = "Viceroy Nezhar",      encounterID = 2067 },
                        { name = "L'ura",               encounterID = 2068 },
                    }
                },
            },
        },
        -- Battle for Azeroth
        {
            name = "Battle for Azeroth",
            raids = {
                {
                    name = "Uldir",
                    mapID = 1861,
                    bosses = {
                        { name = "Taloc",          encounterID = 2144 },
                        { name = "MOTHER",         encounterID = 2141 },
                        { name = "Zek'voz",        encounterID = 2136 },
                        { name = "Fetid Devourer", encounterID = 2128 },
                        { name = "Vectis",         encounterID = 2134 },
                        { name = "Zul",            encounterID = 2145 },
                        { name = "Mythrax",        encounterID = 2135 },
                        { name = "G'huun",         encounterID = 2122 },
                    }
                },
                {
                    name = "Battle of Dazar'alor",
                    mapID = 2070,
                    bosses = {
                        { name = "Champion of the Light",  encounterID = 2265 },
                        { name = "Grong",                  encounterID = 2263 },
                        { name = "Jadefire Masters",       encounterID = 2266 },
                        { name = "Jadefire Masters",       encounterID = 2285 },
                        { name = "Grong the Revenant",     encounterID = 2284 },
                        { name = "Opulence",               encounterID = 2271 },
                        { name = "Conclave of the Chosen", encounterID = 2268 },
                        { name = "King Rastakhan",         encounterID = 2272 },
                        { name = "Mekkatorque",            encounterID = 2276 },
                        { name = "Stormwall Blockade",     encounterID = 2280 },
                        { name = "Lady Jaina Proudmoore",  encounterID = 2281 },
                    }
                },
                {
                    name = "Crucible of Storms",
                    mapID = 2096,
                    bosses = {
                        { name = "The Restless Cabal",            encounterID = 2269 },
                        { name = "Uu'nat, Harbinger of the Void", encounterID = 2273 },
                    }
                },
                {
                    name = "The Eternal Palace",
                    mapID = 2164,
                    bosses = {
                        { name = "Abyssal Commander Sivara", encounterID = 2298 },
                        { name = "Radiance of Azshara",      encounterID = 2305 },
                        { name = "Blackwater Behemoth",      encounterID = 2289 },
                        { name = "Lady Ashvane",             encounterID = 2304 },
                        { name = "Orgozoa",                  encounterID = 2303 },
                        { name = "The Queen's Court",        encounterID = 2311 },
                        { name = "Za'qul",                   encounterID = 2293 },
                        { name = "Queen Azshara",            encounterID = 2299 },
                    }
                },
                {
                    name = "Ny'alotha, the Waking City",
                    mapID = 2217,
                    bosses = {
                        { name = "Wrathion",                     encounterID = 2329 },
                        { name = "Prophet Skitra",               encounterID = 2334 },
                        { name = "Maut",                         encounterID = 2327 },
                        { name = "Dark Inquisitor Xanesh",       encounterID = 2328 },
                        { name = "Vexiona",                      encounterID = 2336 },
                        { name = "The Hivemind",                 encounterID = 2333 },
                        { name = "Ra-den the Despoiled",         encounterID = 2331 },
                        { name = "Shad'har the Insatiable",      encounterID = 2335 },
                        { name = "Drest'agath",                  encounterID = 2343 },
                        { name = "Il'gynoth, Corruption Reborn", encounterID = 2345 },
                        { name = "Carapace of N'Zoth",           encounterID = 2337 },
                        { name = "N'Zoth the Corruptor",         encounterID = 2344 },
                    }
                },
            },
            dungeons = {
                {
                    name = "The MOTHERLODE!!",
                    mapID = 1594,
                    bosses = {
                        { name = "Coin-Operated Crowd Pummeler", encounterID = 2105 },
                        { name = "Azerokk",                      encounterID = 2106 },
                        { name = "Rixxa Fluxfume",               encounterID = 2107 },
                        { name = "Mogul Razdunk",                encounterID = 2108 },
                        { name = "Betarix Hotfixxle",            encounterID = 3463 },
                    }
                },
                {
                    name = "Freehold",
                    mapID = 1754,
                    bosses = {
                        { name = "Skycap'n Kragg",      encounterID = 2093 },
                        { name = "Council o' Captains", encounterID = 2094 },
                        { name = "Ring of Booty",       encounterID = 2095 },
                        { name = "Lord Harlan Sweete",  encounterID = 2096 },
                    }
                },
                {
                    name = "Kings' Rest",
                    mapID = 1762,
                    bosses = {
                        { name = "The Golden Serpent",    encounterID = 2139 },
                        { name = "Mchimba the Embalmer",  encounterID = 2142 },
                        { name = "The Council of Tribes", encounterID = 2140 },
                        { name = "King Dazar",            encounterID = 2143 },
                    }
                },
                {
                    name = "Atal'Dazar",
                    mapID = 1763,
                    bosses = {
                        { name = "Priestess Alun'za", encounterID = 2084 },
                        { name = "Vol'kaal",          encounterID = 2085 },
                        { name = "Rezan",             encounterID = 2086 },
                        { name = "Yazma",             encounterID = 2087 },
                    }
                },
                {
                    name = "Tol Dagor",
                    mapID = 1771,
                    bosses = {
                        { name = "The Sand Queen",        encounterID = 2101 },
                        { name = "Jes Howlis",            encounterID = 2102 },
                        { name = "Knight Captain Valyri", encounterID = 2103 },
                        { name = "Overseer Korgus",       encounterID = 2104 },
                    }
                },
                {
                    name = "Siege of Boralus",
                    mapID = 1822,
                    bosses = {
                        { name = "Sergeant Bainbridge",    encounterID = 2097 },
                        { name = "Chopper Redhook",        encounterID = 2098 },
                        { name = "Dread Captain Lockwood", encounterID = 2109 },
                        { name = "Hadal Darkfathom",       encounterID = 2099 },
                        { name = "Viq'Goth",               encounterID = 2100 },
                    }
                },
                {
                    name = "The Underrot",
                    mapID = 1841,
                    bosses = {
                        { name = "Elder Leaxa",          encounterID = 2111 },
                        { name = "Cragmaw the Infested", encounterID = 2118 },
                        { name = "Sporecaller Zancha",   encounterID = 2112 },
                        { name = "Unbound Abomination",  encounterID = 2123 },
                    }
                },
                {
                    name = "Waycrest Manor",
                    mapID = 1862,
                    bosses = {
                        { name = "Heartsbane Triad",       encounterID = 2113 },
                        { name = "Soulbound Goliath",      encounterID = 2114 },
                        { name = "Raal the Gluttonous",    encounterID = 2115 },
                        { name = "Lord and Lady Waycrest", encounterID = 2116 },
                        { name = "Gorak Tul",              encounterID = 2117 },
                    }
                },
                {
                    name = "Shrine of the Storm",
                    mapID = 1864,
                    bosses = {
                        { name = "Aqu'sirr",               encounterID = 2130 },
                        { name = "Tidesage Council",       encounterID = 2131 },
                        { name = "Lord Stormsong",         encounterID = 2132 },
                        { name = "Vol'zith the Whisperer", encounterID = 2133 },
                    }
                },
                {
                    name = "Temple of Sethraliss",
                    mapID = 1877,
                    bosses = {
                        { name = "Adderis and Aspix",    encounterID = 2124 },
                        { name = "Merektha",             encounterID = 2125 },
                        { name = "Galvazzt",             encounterID = 2126 },
                        { name = "Avatar of Sethraliss", encounterID = 2127 },
                    }
                },
                {
                    name = "Operation: Mechagon",
                    mapID = 2097,
                    bosses = {
                        { name = "King Gobbamak",               encounterID = 2290 },
                        { name = "Gunker",                      encounterID = 2292 },
                        { name = "Trixie & Naeno",              encounterID = 2312 },
                        { name = "HK-8 Aerial Oppression Unit", encounterID = 2291 },
                        { name = "Tussle Tonks",                encounterID = 2257 },
                        { name = "K.U.-J.0.",                   encounterID = 2258 },
                        { name = "Machinist's Garden",          encounterID = 2259 },
                        { name = "King Mechagon",               encounterID = 2260 },
                    }
                },
                {
                    name = "Darkmaul Citadel",
                    mapID = 2236,
                    bosses = {
                        { name = "Tunk",     encounterID = 2325 },
                        { name = "Kalecgos", encounterID = 2326 },
                    }
                },
            },
        },
        -- Shadowlands
        {
            name = "Shadowlands",
            raids = {
                {
                    name = "Castle Nathria",
                    mapID = 2296,
                    bosses = {
                        { name = "Shriekwing",            encounterID = 2398 },
                        { name = "Huntsman Altimor",      encounterID = 2418 },
                        { name = "Sun King's Salvation",  encounterID = 2402 },
                        { name = "Hungering Destroyer",   encounterID = 2383 },
                        { name = "Artificer Xy'mox",      encounterID = 2405 },
                        { name = "Lady Inerva Darkvein",  encounterID = 2406 },
                        { name = "The Council of Blood",  encounterID = 2412 },
                        { name = "Sludgefist",            encounterID = 2399 },
                        { name = "Stone Legion Generals", encounterID = 2417 },
                        { name = "Sire Denathrius",       encounterID = 2407 },
                    }
                },
                {
                    name = "Sanctum of Domination",
                    mapID = 2450,
                    bosses = {
                        { name = "The Tarragrue",              encounterID = 2423 },
                        { name = "The Eye of the Jailer",      encounterID = 2433 },
                        { name = "The Nine",                   encounterID = 2429 },
                        { name = "Soulrender Dormazain",       encounterID = 2434 },
                        { name = "Remnant of Ner'zhul",        encounterID = 2432 },
                        { name = "Painsmith Raznal",           encounterID = 2430 },
                        { name = "Guardian of the First Ones", encounterID = 2436 },
                        { name = "Fatescribe Roh-Kalo",        encounterID = 2431 },
                        { name = "Kel'Thuzad",                 encounterID = 2422 },
                        { name = "Sylvanas Windrunner",        encounterID = 2435 },
                    }
                },
                {
                    name = "Sepulcher of the First Ones",
                    mapID = 2481,
                    bosses = {
                        { name = "Vigilant Guardian",              encounterID = 2512 },
                        { name = "Dausegne, the Fallen Oracle",    encounterID = 2540 },
                        { name = "Artificer Xy'mox",               encounterID = 2553 },
                        { name = "Prototype Pantheon",             encounterID = 2544 },
                        { name = "Skolex, the Insatiable Ravener", encounterID = 2542 },
                        { name = "Halondrus the Reclaimer",        encounterID = 2529 },
                        { name = "Lihuvim, Principal Architect",   encounterID = 2539 },
                        { name = "Anduin Wrynn",                   encounterID = 2546 },
                        { name = "Lords of Dread",                 encounterID = 2543 },
                        { name = "Rygelon",                        encounterID = 2549 },
                        { name = "The Jailer",                     encounterID = 2537 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Sanguine Depths",
                    mapID = 2284,
                    bosses = {
                        { name = "Kryxis the Voracious",   encounterID = 2360 },
                        { name = "Executor Tarvold",       encounterID = 2361 },
                        { name = "Grand Proctor Beryllia", encounterID = 2362 },
                        { name = "General Kaal",           encounterID = 2363 },
                    }
                },
                {
                    name = "Spires of Ascension",
                    mapID = 2285,
                    bosses = {
                        { name = "Kin-Tara",                  encounterID = 2357 },
                        { name = "Ventunax",                  encounterID = 2356 },
                        { name = "Oryphrion",                 encounterID = 2358 },
                        { name = "Devos, Paragon of Loyalty", encounterID = 2359 },
                    }
                },
                {
                    name = "The Necrotic Wake",
                    mapID = 2286,
                    bosses = {
                        { name = "Blightbone",             encounterID = 2387 },
                        { name = "Amarth, The Harvester",  encounterID = 2388 },
                        { name = "Surgeon Stitchflesh",    encounterID = 2389 },
                        { name = "Nalthor the Rimebinder", encounterID = 2390 },
                    }
                },
                {
                    name = "Halls of Atonement",
                    mapID = 2287,
                    bosses = {
                        { name = "Halkias, the Sin-Stained Goliath", encounterID = 2401 },
                        { name = "Echelon",                          encounterID = 2380 },
                        { name = "High Adjudicator Aleez",           encounterID = 2403 },
                        { name = "Lord Chamberlain",                 encounterID = 2381 },
                    }
                },
                {
                    name = "Plaguefall",
                    mapID = 2289,
                    bosses = {
                        { name = "Globgrog",          encounterID = 2382 },
                        { name = "Doctor Ickus",      encounterID = 2384 },
                        { name = "Domina Venomblade", encounterID = 2385 },
                        { name = "Stradama Margrave", encounterID = 2386 },
                    }
                },
                {
                    name = "Mists of Tirna Scithe",
                    mapID = 2290,
                    bosses = {
                        { name = "Ingra Maloch", encounterID = 2397 },
                        { name = "Mistcaller",   encounterID = 2392 },
                        { name = "Tred'ova",     encounterID = 2393 },
                    }
                },
                {
                    name = "De Other Side",
                    mapID = 2291,
                    bosses = {
                        { name = "Hakkar, the Soulflayer", encounterID = 2395 },
                        { name = "The Manastorms",         encounterID = 2394 },
                        { name = "Dealer Xy'exa",          encounterID = 2400 },
                        { name = "Mueh'zala",              encounterID = 2396 },
                    }
                },
                {
                    name = "Theater of Pain",
                    mapID = 2293,
                    bosses = {
                        { name = "An Affront of Challengers", encounterID = 2391 },
                        { name = "Kul'tharok",                encounterID = 2364 },
                        { name = "Gorechop",                  encounterID = 2365 },
                        { name = "Xav the Unfallen",          encounterID = 2366 },
                        { name = "Mordretha",                 encounterID = 2404 },
                    }
                },
                {
                    name = "Tazavesh, the Veiled Market",
                    mapID = 2441,
                    bosses = {
                        { name = "Zo'phex the Sentinel", encounterID = 2425 },
                        { name = "The Grand Menagerie",  encounterID = 2441 },
                        { name = "Mailroom Mayhem",      encounterID = 2424 },
                        { name = "Myza's Oasis",         encounterID = 2440 },
                        { name = "So'azmi",              encounterID = 2437 },
                        { name = "Hylbrande",            encounterID = 2426 },
                        { name = "Timecap'n Hooktail",   encounterID = 2419 },
                        { name = "So'leah",              encounterID = 2442 },
                    }
                },
            },
        },
        -- Dragonflight
        {
            name = "Dragonflight",
            raids = {
                {
                    name = "Vault of the Incarnates",
                    mapID = 2522,
                    bosses = {
                        { name = "Eranog",                    encounterID = 2587 },
                        { name = "The Primal Council",        encounterID = 2590 },
                        { name = "Dathea, Ascended",          encounterID = 2635 },
                        { name = "Terros",                    encounterID = 2639 },
                        { name = "Sennarth, The Cold Breath", encounterID = 2592 },
                        { name = "Kurog Grimtotem",           encounterID = 2605 },
                        { name = "Broodkeeper Diurna",        encounterID = 2614 },
                        { name = "Raszageth the Storm-Eater", encounterID = 2607 },
                    }
                },
                {
                    name = "Aberrus, the Shadowed Crucible",
                    mapID = 2569,
                    bosses = {
                        { name = "Kazzara, the Hellforged",      encounterID = 2688 },
                        { name = "The Amalgamation Chamber",     encounterID = 2687 },
                        { name = "The Forgotten Experiments",    encounterID = 2693 },
                        { name = "Assault of the Zaqali",        encounterID = 2682 },
                        { name = "Rashok, the Elder",            encounterID = 2680 },
                        { name = "The Vigilant Steward, Zskarn", encounterID = 2689 },
                        { name = "Magmorax",                     encounterID = 2683 },
                        { name = "Echo of Neltharion",           encounterID = 2684 },
                        { name = "Scalecommander Sarkareth",     encounterID = 2685 },
                    }
                },
                {
                    name = "Amirdrassil, the Dream's Hope",
                    mapID = 2549,
                    bosses = {
                        { name = "Gnarlroot",                            encounterID = 2820 },
                        { name = "Igira the Cruel",                      encounterID = 2709 },
                        { name = "Volcoross",                            encounterID = 2737 },
                        { name = "Larodar, Keeper of the Flame",         encounterID = 2731 },
                        { name = "Council of Dreams",                    encounterID = 2728 },
                        { name = "Nymue, Weaver of the Cycle",           encounterID = 2708 },
                        { name = "Smolderon",                            encounterID = 2824 },
                        { name = "Tindral Sageswift, Seer of the Flame", encounterID = 2786 },
                        { name = "Fyrakk the Blazing",                   encounterID = 2677 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Uldaman: Legacy of Tyr",
                    mapID = 2451,
                    bosses = {
                        { name = "The Lost Dwarves",   encounterID = 2555 },
                        { name = "Bromach",            encounterID = 2556 },
                        { name = "Sentinel Talondras", encounterID = 2557 },
                        { name = "Emberon",            encounterID = 2558 },
                        { name = "Chrono-Lord Deios",  encounterID = 2559 },
                    }
                },
                {
                    name = "The Azure Vault",
                    mapID = 2515,
                    bosses = {
                        { name = "Leymor",          encounterID = 2582 },
                        { name = "Azureblade",      encounterID = 2585 },
                        { name = "Umbrelskul",      encounterID = 2584 },
                        { name = "Telash Greywing", encounterID = 2583 },
                    }
                },
                {
                    name = "The Nokhud Offensive",
                    mapID = 2516,
                    bosses = {
                        { name = "Granyth",            encounterID = 2637 },
                        { name = "The Raging Tempest", encounterID = 2636 },
                        { name = "Teera and Maruuk",   encounterID = 2581 },
                        { name = "Balakar Khan",       encounterID = 2580 },
                    }
                },
                {
                    name = "Neltharus",
                    mapID = 2519,
                    bosses = {
                        { name = "Chargath, Bane of Scales", encounterID = 2613 },
                        { name = "Forgemaster Gorek",        encounterID = 2612 },
                        { name = "Magmatusk",                encounterID = 2610 },
                        { name = "Warlord Sargha",           encounterID = 2611 },
                    }
                },
                {
                    name = "Brackenhide Hollow",
                    mapID = 2520,
                    bosses = {
                        { name = "Hackclaw's War-Band",  encounterID = 2570 },
                        { name = "Treemouth",            encounterID = 2568 },
                        { name = "Gutshot",              encounterID = 2567 },
                        { name = "Decatriarch Wratheye", encounterID = 2569 },
                    }
                },
                {
                    name = "Ruby Life Pools",
                    mapID = 2521,
                    bosses = {
                        { name = "Melidrussa Chillworn",          encounterID = 2609 },
                        { name = "Kokia Blazehoof",               encounterID = 2606 },
                        { name = "Kyrakka and Erkhart Stormvein", encounterID = 2623 },
                    }
                },
                {
                    name = "Algeth'ar Academy",
                    mapID = 2526,
                    bosses = {
                        { name = "Vexamus",           encounterID = 2562 },
                        { name = "Overgrown Ancient", encounterID = 2563 },
                        { name = "Crawth",            encounterID = 2564 },
                        { name = "Echo of Doragosa",  encounterID = 2565 },
                    }
                },
                {
                    name = "Halls of Infusion",
                    mapID = 2527,
                    bosses = {
                        { name = "Watcher Irideus",       encounterID = 2615 },
                        { name = "Gulping Goliath",       encounterID = 2616 },
                        { name = "Khajin the Unyielding", encounterID = 2617 },
                        { name = "Primal Tsunami",        encounterID = 2618 },
                    }
                },
                {
                    name = "Dawn of the Infinite",
                    mapID = 2579,
                    bosses = {
                        { name = "Chronikar",                encounterID = 2666 },
                        { name = "Manifested Timeways",      encounterID = 2667 },
                        { name = "Blight of Galakrond",      encounterID = 2668 },
                        { name = "Iridikron",                encounterID = 2669 },
                        { name = "Tyr, the Infinite Keeper", encounterID = 2670 },
                        { name = "Morchie",                  encounterID = 2671 },
                        { name = "Time-Lost Battlefield",    encounterID = 2672 },
                        { name = "Chrono-Lord Deios",        encounterID = 2673 },
                    }
                },
            },
        },
        -- The War Within
        {
            name = "The War Within",
            raids = {
                {
                    name = "Nerub-ar Palace",
                    mapID = 2657,
                    bosses = {
                        { name = "Ulgrax the Devourer",           encounterID = 2902 },
                        { name = "The Bloodbound Horror",         encounterID = 2917 },
                        { name = "Sikran, Captain of the Sureki", encounterID = 2898 },
                        { name = "Rasha'nan",                     encounterID = 2918 },
                        { name = "Broodtwister Ovi'nax",          encounterID = 2919 },
                        { name = "Nexus-Princess Ky'veza",        encounterID = 2920 },
                        { name = "The Silken Court",              encounterID = 2921 },
                        { name = "Queen Ansurek",                 encounterID = 2922 },
                    }
                },
                {
                    name = "Liberation of Undermine",
                    mapID = 2769,
                    bosses = {
                        { name = "Vexie and the Geargrinders", encounterID = 3009 },
                        { name = "Cauldron of Carnage",        encounterID = 3010 },
                        { name = "Rik Reverb",                 encounterID = 3011 },
                        { name = "Stix Bunkjunker",            encounterID = 3012 },
                        { name = "Sprocketmonger Lockenstock", encounterID = 3013 },
                        { name = "One-Armed Bandit",           encounterID = 3014 },
                        { name = "Mug'Zee, Heads of Security", encounterID = 3015 },
                        { name = "Chrome King Gallywix",       encounterID = 3016 },
                    }
                },
            },
            dungeons = {
                {
                    name = "The Rookery",
                    mapID = 2648,
                    bosses = {
                        { name = "Kyrioss",               encounterID = 2816 },
                        { name = "Stormguard Gorren",     encounterID = 2861 },
                        { name = "Voidstone Monstrosity", encounterID = 2836 },
                    }
                },
                {
                    name = "Priory of the Sacred Flame",
                    mapID = 2649,
                    bosses = {
                        { name = "Captain Dailcry",   encounterID = 2847 },
                        { name = "Baron Braunpyke",   encounterID = 2835 },
                        { name = "Prioress Murrpray", encounterID = 2848 },
                    }
                },
                {
                    name = "Darkflame Cleft",
                    mapID = 2651,
                    bosses = {
                        { name = "Ol' Waxbeard",    encounterID = 2829 },
                        { name = "Blazikon",        encounterID = 2826 },
                        { name = "The Candle King", encounterID = 2787 },
                        { name = "The Darkness",    encounterID = 2788 },
                    }
                },
                {
                    name = "The Stonevault",
                    mapID = 2652,
                    bosses = {
                        { name = "E.D.N.A.",            encounterID = 2854 },
                        { name = "Skarmorak",           encounterID = 2880 },
                        { name = "Master Machinists",   encounterID = 2888 },
                        { name = "Void Speaker Eirich", encounterID = 2883 },
                    }
                },
                {
                    name = "Ara-Kara, City of Echoes",
                    mapID = 2660,
                    bosses = {
                        { name = "Avanoxx",                encounterID = 2926 },
                        { name = "Anub'zekt",              encounterID = 2906 },
                        { name = "Ki'katal the Harvester", encounterID = 2901 },
                    }
                },
                {
                    name = "Cinderbrew Meadery",
                    mapID = 2661,
                    bosses = {
                        { name = "Brewmaster Aldryr",  encounterID = 2900 },
                        { name = "I'pa",               encounterID = 2929 },
                        { name = "Benk Buzzbee",       encounterID = 2931 },
                        { name = "Goldie Baronbottom", encounterID = 2930 },
                    }
                },
                {
                    name = "The Dawnbreaker",
                    mapID = 2662,
                    bosses = {
                        { name = "Speaker Shadowcrown", encounterID = 2837 },
                        { name = "Anub'ikkaj",          encounterID = 2838 },
                        { name = "Rasha'nan",           encounterID = 2839 },
                    }
                },
                {
                    name = "City of Threads",
                    mapID = 2669,
                    bosses = {
                        { name = "Orator Krix'vizk",       encounterID = 2907 },
                        { name = "Fangs of the Queen",     encounterID = 2908 },
                        { name = "The Coaglamation",       encounterID = 2905 },
                        { name = "Izo, the Grand Splicer", encounterID = 2909 },
                    }
                },
                {
                    name = "Operation: Floodgate",
                    mapID = 2773,
                    bosses = {
                        { name = "Big M.O.M.M.A.", encounterID = 3020 },
                        { name = "Demolition Duo", encounterID = 3019 },
                        { name = "Swampface",      encounterID = 3053 },
                        { name = "Geezle Gigazap", encounterID = 3054 },
                    }
                },
                {
                    name = "Eco-Dome Al'dani",
                    mapID = 2830,
                    bosses = {
                        { name = "Azhiccar",            encounterID = 3107 },
                        { name = "Taah'bat and A'wazj", encounterID = 3108 },
                        { name = "Soul-Scribe",         encounterID = 3109 },
                    }
                },
            },
        },
        -- Midnight
        {
            name = "Midnight",
            raids = {
                {
                    name = "The Voidspire",
                    mapID = 2912,
                    bosses = {
                        { name = "Imperator Averzian",    encounterID = 3176 },
                        { name = "Vorasius",              encounterID = 3177 },
                        { name = "Fallen-King Salhadaar", encounterID = 3179 },
                        { name = "Vaelgor & Ezzorak",     encounterID = 3178 },
                        { name = "Lightblinded Vanguard", encounterID = 3180 },
                        { name = "Crown of the Cosmos",   encounterID = 3181 },
                    }
                },
                {
                    name = "March on Quel'Danas",
                    mapID = 2913,
                    bosses = {
                        { name = "Belo'ren, Child of Al'ar", encounterID = 3182 },
                        { name = "Midnight Falls",           encounterID = 3183 },
                    }
                },
                {
                    name = "The Dreamrift",
                    mapID = 2939,
                    bosses = {
                        { name = "Chimaerus the Undreamt God", encounterID = 3306 },
                    }
                },
            },
            dungeons = {
                {
                    name = "Windrunner Spire",
                    mapID = 2805,
                    bosses = {
                        { name = "Emberdawn",        encounterID = 3056 },
                        { name = "Derelict Duo",     encounterID = 3057 },
                        { name = "Commander Kroluk", encounterID = 3058 },
                        { name = "Restless Heart",   encounterID = 3059 },
                    }
                },
                {
                    name = "Magisters' Terrace",
                    mapID = 2811,
                    bosses = {
                        { name = "Arcanotron Custos", encounterID = 3071 },
                        { name = "Seranel Sunlash",   encounterID = 3072 },
                        { name = "Gemellus",          encounterID = 3073 },
                        { name = "Degentrius",        encounterID = 3074 },
                    }
                },
                {
                    name = "Murder Row",
                    mapID = 2813,
                    bosses = {
                        { name = "Kystia Manaheart",        encounterID = 3101 },
                        { name = "Zaen Bladesorrow",        encounterID = 3102 },
                        { name = "Xathuux the Annihilator", encounterID = 3103 },
                        { name = "Lithiel Cinderfury",      encounterID = 3105 },
                    }
                },
                {
                    name = "Den of Nalorakk",
                    mapID = 2825,
                    bosses = {
                        { name = "The Hoardmonger",    encounterID = 3207 },
                        { name = "Sentinel of Winter", encounterID = 3208 },
                        { name = "Nalorakk",           encounterID = 3209 },
                    }
                },
                {
                    name = "The Blinding Vale",
                    mapID = 2859,
                    bosses = {
                        { name = "Lightblossom Trinity",   encounterID = 3199 },
                        { name = "Ikuzz the Light Hunter", encounterID = 3200 },
                        { name = "Lightwarden Ruia",       encounterID = 3201 },
                        { name = "Ziekett",                encounterID = 3202 },
                    }
                },
                {
                    name = "Maisara Caverns",
                    mapID = 2874,
                    bosses = {
                        { name = "Muro'jin and Nekraxx",     encounterID = 3212 },
                        { name = "Vordaza",                  encounterID = 3213 },
                        { name = "Rak'tul, Vessel of Souls", encounterID = 3214 },
                    }
                },
                {
                    name = "Nexus-Point Xenas",
                    mapID = 2915,
                    bosses = {
                        { name = "Chief Corewright Kasreth", encounterID = 3328 },
                        { name = "Corewarden Nysarra",       encounterID = 3332 },
                        { name = "Lothraxion",               encounterID = 3333 },
                    }
                },
                {
                    name = "Voidscar Arena",
                    mapID = 2923,
                    bosses = {
                        { name = "Taz'Rah",  encounterID = 3285 },
                        { name = "Atroxus",  encounterID = 3286 },
                        { name = "Charonus", encounterID = 3287 },
                    }
                },
            },
        },
    }
}


-- Returns flat list of expansion names
function CTT_GetExpansionNames()
    local names = {}
    for _, exp in ipairs(CTT_Data.expansions) do
        tinsert(names, exp.name)
    end
    return names
end

-- Returns flat list of raid names for a given expansion index
function CTT_GetRaidNames(expansionIndex)
    local names = {}
    local exp = CTT_Data.expansions[expansionIndex]
    if not exp then return names end
    for _, raid in ipairs(exp.raids) do
        tinsert(names, raid.name)
    end
    return names
end

-- Returns flat list of dungeon names for a given expansion index
function CTT_GetDungeonNames(expansionIndex)
    local names = {}
    local exp = CTT_Data.expansions[expansionIndex]
    if not exp then return names end
    for _, dungeon in ipairs(exp.dungeons) do
        tinsert(names, dungeon.name)
    end
    return names
end

-- Returns flat list of raid boss names
function CTT_GetRaidBossNames(expansionIndex, raidIndex)
    local names = {}
    local exp = CTT_Data.expansions[expansionIndex]
    if not exp then return names end
    local raid = exp.raids[raidIndex]
    if not raid then return names end
    for _, boss in ipairs(raid.bosses) do
        tinsert(names, boss.name)
    end
    return names
end

-- Returns flat list of dungeon boss names
function CTT_GetDungeonBossNames(expansionIndex, dungeonIndex)
    local names = {}
    local exp = CTT_Data.expansions[expansionIndex]
    if not exp then return names end
    local dungeon = exp.dungeons[dungeonIndex]
    if not dungeon then return names end
    for _, boss in ipairs(dungeon.bosses) do
        tinsert(names, boss.name)
    end
    return names
end

-- Returns encounter ID for a specific raid boss
function CTT_GetRaidEncounterID(expansionIndex, raidIndex, bossIndex)
    local exp = CTT_Data.expansions[expansionIndex]
    if not exp then return nil end
    local raid = exp.raids[raidIndex]
    if not raid then return nil end
    local boss = raid.bosses[bossIndex]
    if not boss then return nil end
    return boss.encounterID
end

-- Returns encounter ID for a specific dungeon boss
function CTT_GetDungeonEncounterID(expansionIndex, dungeonIndex, bossIndex)
    local exp = CTT_Data.expansions[expansionIndex]
    if not exp then return nil end
    local dungeon = exp.dungeons[dungeonIndex]
    if not dungeon then return nil end
    local boss = dungeon.bosses[bossIndex]
    if not boss then return nil end
    return boss.encounterID
end

-- Returns all raid zone names as a flat list (for zone-based display logic)
function CTT_GetAllRaidZoneNames()
    local names = {}
    for _, exp in ipairs(CTT_Data.expansions) do
        for _, raid in ipairs(exp.raids) do
            tinsert(names, raid.name)
        end
    end
    return names
end

-- Returns all dungeon zone names as a flat list (for zone-based display logic)
function CTT_GetAllDungeonZoneNames()
    local names = {}
    for _, exp in ipairs(CTT_Data.expansions) do
        for _, dungeon in ipairs(exp.dungeons) do
            tinsert(names, dungeon.name)
        end
    end
    return names
end

-- Returns the expansion name for a given encounter ID (searches raids only)
function CTT_GetExpansionByEncounterId(encounterId)
    for _, exp in ipairs(CTT_Data.expansions) do
        for _, raid in ipairs(exp.raids) do
            for _, boss in ipairs(raid.bosses) do
                if boss.encounterID == encounterId then
                    return exp.name
                end
            end
        end
    end
    return nil
end

-- Returns the raid name matching the current zone text
function CTT_GetRaidByZoneText()
    local zone = GetRealZoneText()
    for _, exp in ipairs(CTT_Data.expansions) do
        for _, raid in ipairs(exp.raids) do
            if zone == raid.name then
                return raid.name
            end
        end
    end
    return nil
end

-- Returns the dungeon name matching the current zone text
function CTT_GetDungeonByZoneText()
    local zone = GetRealZoneText()
    for _, exp in ipairs(CTT_Data.expansions) do
        for _, dungeon in ipairs(exp.dungeons) do
            if zone == dungeon.name then
                return dungeon.name
            end
        end
    end
    return nil
end

-- M+ season metadata keyed by the value returned from C_MythicPlus.GetCurrentSeason().
-- Season numbers match the global cumulative M+ season count (from DisplaySeason game data).
-- expansionName must match expansion names used in CTT_Data.expansions.
-- dungeons lists the dungeon names (as stored in CTT_Data) active in that season's M+ pool.
-- Seasons without a dungeons list will fall back to showing all dungeons for that expansion.
CTT_MythicPlusSeasonData = {
    -- Midnight (ExpansionID 11)
    -- S1: 4 new Midnight dungeons + 4 returning (Algeth'ar Academy, Pit of Saron, Seat of the Triumvirate, Skyreach)
    [17] = {
        expansion = "Midnight",
        seasonNum = 1,
        name = "Season 1",
        dungeons = {
            "Windrunner Spire", "Magisters' Terrace", "Maisara Caverns", "Nexus-Point Xenas",
            "Algeth'ar Academy", "Pit of Saron", "Seat of the Triumvirate", "Skyreach",
        }
    },
}

-- Returns the ordered list of expansion names that have M+ seasons, prefixed with "All"
function CTT_GetMPlusExpansionFilterList()
    return { "All", "Shadowlands", "Dragonflight", "The War Within", "Midnight" }
end

-- Returns season display names for an expansion, prefixed with "All".
-- Returns {"All"} when expansionName is "All" or unknown.
function CTT_GetMPlusSeasonFilterList(expansionName)
    if not expansionName or expansionName == "All" then
        return { "All" }
    end
    local seasons = {}
    for _, data in pairs(CTT_MythicPlusSeasonData) do
        if data.expansion == expansionName then
            tinsert(seasons, { num = data.seasonNum, name = data.name })
        end
    end
    table.sort(seasons, function(a, b) return a.num < b.num end)
    local result = { "All" }
    for _, s in ipairs(seasons) do
        tinsert(result, s.name)
    end
    return result
end

-- Returns a set (table keyed by seasonID → true) of all season IDs that match the given
-- expansion and season name filters. Pass "All" to match any value in that dimension.
function CTT_GetMPlusSeasonIDs(expansionName, seasonName)
    local ids = {}
    for seasonID, data in pairs(CTT_MythicPlusSeasonData) do
        local expMatch = (not expansionName or expansionName == "All") or (data.expansion == expansionName)
        local seaMatch = (not seasonName or seasonName == "All") or (data.name == seasonName)
        if expMatch and seaMatch then
            ids[seasonID] = true
        end
    end
    return ids
end

-- Returns all dungeon names for a named expansion (matches CTT_Data expansion name).
-- Returns empty table for unknown expansion names.
function CTT_GetDungeonNamesForExpansion(expansionName)
    for _, exp in ipairs(CTT_Data.expansions) do
        if exp.name == expansionName then
            local names = {}
            for _, dungeon in ipairs(exp.dungeons) do
                tinsert(names, dungeon.name)
            end
            return names
        end
    end
    return {}
end

-- Returns the dungeon dropdown list for the given expansion+season filter combination.
-- When both are "All", returns nil (caller should use CTT_BuildDungeonFilterList instead).
-- When expansion is set and season is "All", returns all dungeons in that expansion.
-- When both are set, returns the static season pool prefixed with "All".
function CTT_GetDungeonDropdownList(expansionName, seasonName)
    if (not expansionName or expansionName == "All") and (not seasonName or seasonName == "All") then
        return nil -- caller uses run-based list
    end

    local dungeons
    if seasonName and seasonName ~= "All" then
        -- Find the specific season entry and return its pool
        for _, data in pairs(CTT_MythicPlusSeasonData) do
            if data.expansion == expansionName and data.name == seasonName then
                dungeons = data.dungeons
                break
            end
        end
    end

    if not dungeons then
        -- Season is "All" for a specific expansion: use all dungeons in that expansion
        dungeons = CTT_GetDungeonNamesForExpansion(expansionName)
    end

    local result = { "All" }
    for _, name in ipairs(dungeons) do
        tinsert(result, name)
    end
    return result
end
