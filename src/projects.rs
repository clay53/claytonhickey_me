use crate::{
    experiences::{
        *,
        DescriptionPart::*,
    },
    skills::Skills::*
};
use chrono::NaiveDate;

pub const PROJECTS: &'static [Experience] = &[
    Experience {
        title: Title::Linked("WGPU Game of Life", "https://github.com/clay53/wgpu_game_of_life"),
        started: Some(NaiveDate::from_ymd(2022, 7, 13)),
        completed: Some(NaiveDate::from_ymd(2022, 7, 13)),
        last_updated: None,
        skills: &[
            Rust,
            BUI,
            BUIBasic,
            WGPU,
            WGSL,
            ComputeShaders,
            DesktopSoftware,
            WindowsSoftware,
            LinuxSoftware,
            Winit,
        ],
        description: &[
            Paragraph(&[
                Text("Conway's Game of Life computed and rendered on the GPU using WGPU. Written with my own gui framework, BUI Basic.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/wgpu_game_of_life"
            },
            Link {
                ty: LinkType::Download,
                destination: "https://github.com/clay53/wgpu_game_of_life/releases/"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/wgpu_game_of_life.png",
            alt: "a simple example of Conway's game of life",
        }),
    },
    Experience {
        title: Title::Linked("BUI Basic", "https://github.com/clay53/bui_basic"),
        started: Some(NaiveDate::from_ymd(2022, 2, 22)),
        completed: None,
        last_updated: Some(NaiveDate::from_ymd(2022, 7, 14)),
        skills: &[
            Rust,
            BUI,
            GUIFrameworkDesign,
            CrossPlatformDesktopMobileWeb,
        ],
        description: &[
            Paragraph(&[
                Text("Simplified wrapper around bui for building guis without sacrificing any performance.")
            ]),
            Paragraph(&[
                Text("Note: Development is very active. Latest update is likely not pushed.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/bui_basic"
            }
        ],
        thumb: None,
    },
    Experience {
        title: Title::Linked("BUI", "https://github.com/clay53/bui"),
        started: Some(NaiveDate::from_ymd(2021, 8, 13)),
        completed: None,
        last_updated: Some(NaiveDate::from_ymd(2022, 7, 14)),
        skills: &[
            Rust,
            WGPU,
            WGSL,
            RenderShaders,
            CrossPlatformDesktopMobileWeb,
        ],
        description: &[
            Paragraph(&[
                Text("A performant WGPU (currently - plan to support multiple backends) GUI rendering library.")
            ]),
            Paragraph(&[
                Text("Note: Development is very active. Latest update is likely not pushed.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/bui"
            }
        ],
        thumb: None,
    },
    Experience {
        title: Title::Linked("Micro VSRG", "https://github.com/clay53/micro_vsrg"),
        started: Some(NaiveDate::from_ymd(2021, 11, 12)),
        completed: Some(NaiveDate::from_ymd(2021, 11, 28)),
        last_updated: None,
        skills: &[
            Rust,
            Microcontrollers,
            RaspberryPi,
            DynamicParsing,
        ],
        description: &[
            Paragraph(&[
                Text("A rhythm game for Raspberry Pi - specifically the Raspberry Pi 3B+. \
                Imports 4k osu!mania maps (no hold notes). Single player (2 player may be added). \
                I completed this project for a Raspberry Pi 3. \
                This game is meant to be played with wheeled robots hitting the notes and sacrifices were made for that. \
                However, it can be easily modified to fit one's requirements. \
                The game dynamically reads and parses osu!mania (a popular and now open source rhythm game for desktop operating systems) \
                set/map files that the user can choose from to play on startup.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/micro_vsrg"
            },
            Link {
                ty: LinkType::Showcase,
                destination: "/videos/experiences/micro-vsrg.mp4"
            },
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/micro-vsrg.webp",
            alt: "Students playing Micro VSRG with RC robots"
        }),
    },
    Experience {
        title: Title::Linked("ClaytonHickey.me", "https://claytonhickey.me"),
        started: Some(NaiveDate::from_ymd(2021, 7, 5)),
        completed: Some(NaiveDate::from_ymd(2021, 7, 5)),
        last_updated: Some(NaiveDate::from_ymd(2022, 12, 6)),
        skills: &[
            Websites,
            Rust,
            Maud,
            StaticSites,
            HTML,
            CSS,
            WebHosting,
            Linode,
            Nginx,
            DNS,
            Cloudflare
        ],
        description: &[
            Paragraph(&[
                Text("The site you are viewing is generated statically with Rust and the Maud templating engine.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/claytonhickey_me"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://claytonhickey.me"
            }
        ],
        thumb: None,
    },
    Experience {
        title: Title::Linked("Word Search Solver OCR", "https://claytondoesthings.xyz/software/word-search-cheats-ocr/web"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2019, 2, 1)),
        last_updated: None,
        skills: &[
            Websites,
            WebApps,
            Algorithms,
            OCR,
            JavaScript,
            P5JS,
            HTML,
            CSS,
        ],
        description: &[
            Paragraph(&[
                Text("A tool to solve word searching using OCR which allows users to upload pictures of word searches \
                so they can solve them quickly. Developed because I am very bad at word searches."),
            ]),
        ],
        links: &[
            Link {
                ty: LinkType::Live,
                destination: "https://claytondoesthings.xyz/software/word-search-cheats-ocr/web",
            },
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/word-search-cheats-ocr.png",
            alt: "screenshot of a word search solved with Word Search Cheats",
        }),
    },
    Experience {
        title: Title::Linked("ClaytonDoesThings.xyz", "https://claytondoesthings.xyz"),
        started: None,
        completed: None,
        last_updated: Some(NaiveDate::from_ymd(2021, 12, 28)),
        skills: &[
            Rust,
            RocketRs,
            FullstackWeb,
            DNS,
            Cloudflare,
            WebHosting,
            Linode,
            Linux,
            Ubuntu,
            Nginx,
            ServerSideRendering,
            WebTemplating,
            Maud,
            GoogleSEO,
            BingSEO,
            DynamicSitemap,
            HTML,
            CSS,
            Websites,
        ],
        description: &[
            Paragraph(&[
                Text("My personal website to show off projects. Has gone through many rewrites. \
                The current version is made with Rust using the backend framework, Rocket, and the compile-time templating engine, Maud. \
                The website is hosted on Linode and put behind a Cloudflare proxy to protect from the surprisingly common DDOS attacks. \
                It's also behind a reverse proxy, nginx, to allow for other sites to be hosted on the same Ubuntu Linode server \
                Gets 100% on Google Lighthouse. Previous version used NodeJS, expressJS, and a custom web framework/templator."),
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/ClaytonXYZ"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://claytondoesthings.xyz"
            }
        ],
        thumb: None,
    },
    Experience {
        title: Title::Linked("CarAI", "https://claytondoesthings.xyz/games/carai/web"),
        started: Some(NaiveDate::from_ymd(2019, 4, 7)),
        completed: Some(NaiveDate::from_ymd(2019, 4, 7)),
        last_updated: None,
        skills: &[
            UnityEngine,
            CSharp,
            AI,
            ML,
            CustomML,
            DesktopSoftware,
            WindowsSoftware,
            LinuxSoftware,
            MacSoftware,
            WebApps,
        ],
        description: &[
            Paragraph(&[
                Text("I created a custom neural net/machine learning procedure to train a neural net to drive through a track. \
                It's inefficient but it works. I made a video describing how I developed it and how it works.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/CarAI"
            },
            Link {
                ty: LinkType::Download,
                destination: "https://claytondoesthings.xyz/games/carai"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://claytondoesthings.xyz/games/carai/web"
            },
            Link {
                ty: LinkType::Showcase,
                destination: "https://youtu.be/jjhNab0bJgQ"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/carai.png",
            alt: "the car AI making a turn towards the exit",
        }),
    },
    Experience {
        title: Title::Linked("Sound Galaxy", "https://github.com/clay53/sound_galaxy/releases"),
        started: Some(NaiveDate::from_ymd(2021, 11, 28)),
        completed: Some(NaiveDate::from_ymd(2021, 11, 28)),
        last_updated: None,
        skills: &[
            Rust,
            WGPU,
            WGSL,
            RenderShaders,
            Winit,
            BUI,
            Constrainer,
            DesktopSoftware,
            WindowsSoftware,
            LinuxSoftware,
            AudioVisualization,
            AsyncSoftware,
            RustAsync
        ],
        description: &[
            Paragraph(&[
                Text("I adapted a JavaScript/p5.js tutorial by ExecuteBig which itself was an adaptation from \
                a HackClub tutorial to use Rust and my own GUI libraries/tools which are fully GPU accelerated.")
            ]),
            Paragraph(&[
                Text("Usage: place a sound file named \"input.mp3\" next to the downloaded executable/binary file \
                and run the executable or specifify the location of the file as the first argument when executing from a terminal")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/sound_galaxy"
            },
            Link {
                ty: LinkType::Download,
                destination: "https://github.com/clay53/sound_galaxy/releases"
            },
            Link {
                ty: LinkType::Showcase,
                destination: "https://www.youtube.com/watch?v=kzUnaH4M824"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/sound_galaxy.png",
            alt: "Crab Rave visualized with Sound Galaxy as colored circles flowing downward",
        }),
    },
    Experience {
        title: Title::Linked("Meet With Pong", "https://meet-with-pong.clay53.repl.co/w/index.html"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2020, 1, 21)),
        last_updated: None,
        skills: &[
            JavaScript,
            HTML,
            CSS,
            P5JS,
            P5Sound,
            WebApps,
            SoftwareAudioPlayback,
            NodeJS,
            Websockets,
            SocketIO,
            RealTimeMultiplayer,
            WebMultiplayer,
            MultiplayerClientPredicationAndRollback,
            MultiplayerMatchmaking,
        ],
        description: &[
            Paragraph(&[
                Text("A real-time multiplayer pong clone made for a Repl.it competition. \
                Instead of just playing to a score, winning a point reveals information about the other \
                player (that they submit) so that they can get to know each other a bit. Physics calculations \
                are done server-side to prevent cheating. Optional singleplayer is available.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/Meet-With-Pong"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://meet-with-pong.clay53.repl.co/w/index.html"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/meet-with-pong.png",
            alt: "Clayton playing png against Bob. Revealed names and Bob's favorite programming language."
        }),
    },
    Experience {
        title: Title::Raw("osu!keypad"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2020, 7, 22)),
        last_updated: None,
        skills: &[
            OpenSCAD,
            Arduino,
            CPP,
            Microcontrollers,
            PeripheralDevelopment,
            CAD,
            FreeCAD,
            FDM3DPrinting,
            Debouncing,
            Soldering,
        ],
        description: &[
            Paragraph(&[
                Text("An extremely cheap ($10) 2 key keyboard for playing Osu!, \
                a rhythm game, with an Arduino Pro Micro base. Case designed by me in FreeCAD, \
                keycaps designed by rsheldiii and customized with OpenSCAD, \
                all 3D printed on my MP Select Mini V2 in PLA. \
                Code was developed by me using Arduino's pre-built tools and C++.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/Osu-Keypad"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/osu!keypad.webp",
            alt: "Picture of the 2 key keypad 3D printed in red filament with kalih box brown key switches."
        }),
    },
    Experience {
        title: Title::Linked("Symbol Translator", "https://claytondoesthings.xyz/software/symbol-translator/web"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2019, 6, 4)),
        last_updated: Some(NaiveDate::from_ymd(2019, 7, 19)),
        skills: &[
            WebApps,
            JavaScript,
            HTML,
            P5JS
        ],
        description: &[
            Paragraph(&[
                Text("Created a web app with p5.js to make visually translating between \
                cryptic \"fonts\" easier. Made for the Game Theory ARG.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/ClaytonDoesThings/SymbolTranslator"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://claytondoesthings.xyz/software/symbol-translator/web"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/symbol-translator.png",
            alt: "Decoded \"hello\" from BirbText",
        }),
    },
    Experience {
        title: Title::Linked("Russian Roulette", "https://claytondoesthings.xyz/games/russian-roulette/web"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2018, 4, 1)),
        last_updated: None,
        skills: &[
            JavaScript,
            HTML,
            P5JS,
            P5Sound,
            WebApps,
            GameDevelopment,
        ],
        description: &[
            Paragraph(&[
                Text("Made a Russian Roulette game against my friend to see who could do it better, \
                he didn't finish but I had fun making it anyway.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://replit.com/@ClaytonHickey/p5js-russian-roulette"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://claytondoesthings.xyz/games/russian-roulette/web"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/russian-roulette.png",
            alt: "Losing Russian Roulette"
        }),
    },
    Experience {
        title: Title::Linked("PebbleXCTimer", "https://github.com/ClaytonDoesThings/PebbleXCTimer"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2018, 8, 20)),
        last_updated: None,
        skills: &[
            C,
            LowLevelEmbeddedSoftware,
            PebbleUI
        ],
        description: &[
            Paragraph(&[
                Text("A timer for keeping track of cross country or track running \
                intervals and other repeating timer needs. Also functions as a stopwatch. Uses the native Pebble SDK.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/ClaytonDoesThings/PebbleXCTimer"
            },
            Link {
                ty: LinkType::Download,
                destination: "https://github.com/clay53/PebbleXCTimer/releases"
            },
            Link {
                ty: LinkType::RebbleStore,
                destination: "https://apps.rebble.io/en_US/application/62cdbbd1f0886b0009c74042"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/pebbleXCTimer.png",
            alt: "Screenshot showing time and interval",
        }),
    },
    Experience {
        title: Title::Linked("Images From Images 2", "https://github.com/clay53/images_from_images2"),
        started: Some(NaiveDate::from_ymd(2022, 7, 22)),
        completed: None,
        last_updated: Some(NaiveDate::from_ymd(2022, 8, 17)),
        skills: &[
            WGPU,
            Rust,
            CLI,
        ],
        description: &[
            Paragraph(&[
                Text("Makes images from images using the GPU so it's much faster. \
                Will update so that it also works in the web and desktop without CLI."),
            ]),
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/images_from_images2"
            },
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/legitimate-images-from-images.webp",
            alt: "Cat made from dogs",
        }),
    },
    Experience {
        title: Title::Linked("Legitimate Images From Images", "https://claytondoesthings.xyz/software/legitimate-images-made-from-images"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2018, 5, 26)),
        last_updated: None,
        skills: &[
            JavaScript,
            P5JS,
            HTML,
            CSS,
            WebApps
        ],
        description: &[
            Paragraph(&[
                Text("I made a program that takes a bunch of images and forms them into another image by color matching.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/Legitimate-Images-From-Images"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://claytondoesthings.xyz/software/legitimate-images-made-from-images"
            }
        ],
        thumb: Some(Thumb {
           source: "/images/experiences/thumbs/legitimate-images-from-images.webp",
           alt: "Cat made from dogs",
        }),
    },
    Experience {
        title: Title::Linked("MultiKahoot", "https://MultiKahoot.claytonhickey.repl.co/"),
        started: None,
        completed: Some(NaiveDate::from_ymd(2019, 10, 9)),
        last_updated: None,
        skills: &[
            JavaScript,
            NodeJS,
            ExpressJS,
            HTML,
            CSS,
            API,
            WebApps
        ],
        description: &[
            Paragraph(&[
                Text("Allows a single player to control multiple Kahoot \"users\" from an \
                entirely separate website. Also allows keyboard controls without the use of \
                external hotkey software so that one can answer faster on a Chromebook.")
            ]),
            Paragraph(&[
                Text("Does not work for now due to changes in Kahoot's API")
            ]),
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://replit.com/@ClaytonHickey/MultiKahoot"
            },
            Link {
                ty: LinkType::Live,
                destination: "https://MultiKahoot.claytonhickey.repl.co/"
            }
        ],
        thumb: None,
    },
    Experience {
        title: Title::Linked("GivingDuo", "https://github.com/clay53/GivingDuo"),
        started: Some(NaiveDate::from_ymd(2020, 8, 12)),
        completed: Some(NaiveDate::from_ymd(2020, 8, 30)),
        last_updated: None,
        skills: &[
            ReverseEngineeringAPI,
            JavaScript,
            HTML,
            RESTAPI,
            BrowserExtensions,
            BrowserExtensionPublishing
        ],
        description: &[
            Paragraph(&[
                Text("A browser extension to allow users of Duolingo to give multiple lingots \
                at the same time to users for their contributions to the forums or helping them understand a new topic."),
            ]),
            Paragraph(&[
                Text("Note: Duolingo is deprecating Lingots and throttling API requests which causes the extension to go slow sometimes.")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/GivingDuo"
            },
            Link {
                ty: LinkType::ChromeWebStore,
                destination: "https://chrome.google.com/webstore/detail/giving-duo/lacfjcephcjbihliackggaifbkbiimfl"
            },
            Link {
                ty: LinkType::FirefoxAddOns,
                destination: "https://addons.mozilla.org/en-US/firefox/addon/giving-duo/"
            },
            Link {
                ty: LinkType::Download,
                destination: "https://github.com/clay53/GivingDuo/releases"
            }
        ],
        thumb: Some(Thumb {
            source: "/images/experiences/thumbs/givingduo.jpg",
            alt: "Example of giving multiple lingots."
        }),
    },
    Experience {
        title: Title::Linked("Live Stream Music Player", "https://github.com/ClaytonDoesThings/Live-Stream-Music-Player"),
        started: Some(NaiveDate::from_ymd(2018, 3, 30)),
        completed: Some(NaiveDate::from_ymd(2018, 4, 3)),
        last_updated: None,
        skills: &[
            Python,
            FFmpeg,
            DesktopSoftware,
            WindowsSoftware,
            LinuxSoftware,
            MacSoftware,
            API,
            YouTubeAPI,
        ],
        description: &[
            Paragraph(&[
                Text("Gets royalty free music from creators and automatically gives them credit to \
                play during live streams. (integration with OBS through changing files).")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/ClaytonDoesThings/Live-Stream-Music-Player"
            }
        ],
        thumb: None,
    },
];

pub const ABANDONED_PROJECTS: &'static [Experience] = &[
    Experience {
        title: Title::Raw("From Anarchy"),
        started: Some(NaiveDate::from_ymd(2021, 7, 20)),
        completed: None,
        last_updated: Some(NaiveDate::from_ymd(2021, 7, 23)),
        skills: &[
            VRAppDevelopment,
            OpenXR,
            Godot,
            FFI,
            DesktopGames,
            WindowsGames,
            TCPSockets,
            RealTimeMultiplayer,
            AsyncSoftware,
            DesktopSoftware,
            WindowsSoftware,
            LinuxSoftware,
        ],
        description: &[
            Paragraph(&[
                Text("A micro voxel-world VR game. Never finished but it was a good exercise in making VR \
                games and using Rust/FFI in game engines for optimal performance. \
                Likely applicable to other engines like Unity and Unreal. \
                This game would probably require a custom rendering pipeline to make performant at all so \
                if this were to be fully developed, a custom engine would be used."),
            ]),
            Paragraph(&[
                Text("Note: Latest development version isn't pushed")
            ])
        ],
        links: &[
            Link {
                ty: LinkType::Code,
                destination: "https://github.com/clay53/from_anarchy"
            }
        ],
        thumb: None,
    }
];