const IDMAP = {
    Rust: 0,
    RocketRs: 1,
    FullstackWeb: 2,
    DNS: 3,
    Cloudflare: 4,
    WebHosting: 5,
    Linode: 6,
    ServerSideRendering: 7,
    WebTemplating: 8,
    Maud: 9,
    SEO: 10,
    GoogleSEO: 11,
    BingSEO: 12,
    DynamicSitemap: 13,
    HTML: 14,
    CSS: 15,
    Microcontrollers: 16,
    RaspberryPi: 17,
    DynamicParsing: 18,
    UnityEngine: 19,
    CSharp: 20,
    AI: 21,
    ML: 22,
    CustomML: 23,
    DesktopSoftware: 24,
    WindowsSoftware: 25,
    LinuxSoftware: 26,
    MacSoftware: 27,
    WebApps: 28,
    WGPU: 29,
    Winit: 30,
    GUIDesign: 31,
    GUIFrameworkDesign: 32,
    BUI: 33,
    BUIBasic: 34,
    Constrainer: 35,
    AudioVisualization: 36,
    SoftwareAudioPlayback: 37,
    AsyncSoftware: 38,
    RustAsync: 39,
    JavaScript: 40,
    P5JS: 41,
    P5Sound: 42,
    ExpressJS: 43,
    Websockets: 44,
    SocketIO: 45,
    RealTimeMultiplayer: 46,
    WebMultiplayer: 47,
    MultiplayerClientPredicationAndRollback: 48,
    MultiplayerMatchmaking: 49,
    PeripheralDevelopment: 50,
    CAD: 51,
    FreeCAD: 52,
    FDM3DPrinting: 53,
    Debouncing: 54,
    Soldering: 55,
    Arduino: 56,
    CPP: 57,
    OpenSCAD: 58,
    Nginx: 59,
    ReverseProxy: 60,
    Linux: 61,
    Ubuntu: 62,
    NodeJS: 63,
    API: 64,
    ReverseEngineeringAPI: 65,
    RESTAPI: 66,
    BrowserExtensions: 67,
    BrowserExtensionPublishing: 68,
    Python: 69,
    FFmpeg: 70,
    YouTubeAPI: 71,
    C: 72,
    LowLevelEmbeddedSoftware: 73,
    PebbleUI: 74,
    GameDevelopment: 75,
    FirmwareDevelopment: 76,
    FreeRTOSSoftware: 77,
    LittleVGL: 78,
    AndroidNative: 79,
    AndroidLayoutsViews: 80,
    Java: 81,
    MobileApps: 82,
    VRAppDevelopment: 83,
    OpenXR: 84,
    Godot: 85,
    GodotRust: 86,
    FFI: 87,
    DesktopGames: 88,
    WindowsGames: 89,
    TCPSockets: 90,
    RenderShaders: 91,
    WGSL: 92,
    Websites: 93,
    CrossPlatformDesktopMobileWeb: 94,
    ComputeShaders: 95,
    StaticSites: 96,
    CLI: 97,
    Algorithms: 98,
    OCR: 99,
    wgpuGameOfLife: 100,
    buiBasic: 101,
    bui: 102,
    microVSRG: 103,
    claytonHickeyMe: 104,
    wordSearchSolverOCR: 105,
    claytonDoesThingsXYZ: 106,
    carAI: 107,
    soundGalaxy: 108,
    meetWithPong: 109,
    osuKeypad: 110,
    symbolTranslator: 111,
    pebbleXCTimer: 112,
    imagesFromImages2: 113,
    legitimateImagesFromImages: 114,
    multiKahoot: 115,
    givingDuo: 116,
    liveStreamMusicPlayer: 117,
    fromAnarchy: 118,
    repeatOptionInfinitime: 119,
    addedComentsLBRYAndroid: 120,
    publishUnpublishLBRYAndroid: 121,
    Nix: 122,
    WebComponents: 123,
    claytonHickeyMeWC: 124,
};

const SKILLTONAMEMAP = {
    [IDMAP.Rust]: "Rust",
    [IDMAP.RocketRs]: "Rocket.rs",
    [IDMAP.FullstackWeb]: "fullstack web",
    [IDMAP.DNS]: "DNS",
    [IDMAP.Cloudflare]: "Cloudflare",
    [IDMAP.WebHosting]: "web hosting",
    [IDMAP.Linode]: "Linode",
    [IDMAP.ServerSideRendering]: "server-side rendering",
    [IDMAP.WebTemplating]: "web templating",
    [IDMAP.Maud]: "Maud",
    [IDMAP.SEO]: "SEO",
    [IDMAP.GoogleSEO]: "Google SEO",
    [IDMAP.BingSEO]: "Bing SEO",
    [IDMAP.DynamicSitemap]: "dynamic sitemap",
    [IDMAP.HTML]: "HTML",
    [IDMAP.CSS]: "CSS",
    [IDMAP.Microcontrollers]: "microcontrollers",
    [IDMAP.RaspberryPi]: "Raspberry Pi",
    [IDMAP.DynamicParsing]: "dynamic parsing",
    [IDMAP.UnityEngine]: "Unity Engine",
    [IDMAP.CSharp]: "C#",
    [IDMAP.AI]: "AI",
    [IDMAP.ML]: "ML",
    [IDMAP.CustomML]: "custom ML",
    [IDMAP.DesktopSoftware]: "desktop software",
    [IDMAP.WindowsSoftware]: "Windows software",
    [IDMAP.LinuxSoftware]: "Linux software",
    [IDMAP.MacSoftware]: "Mac software",
    [IDMAP.WebApps]: "web apps",
    [IDMAP.WGPU]: "WGPU",
    [IDMAP.Winit]: "Winit",
    [IDMAP.GUIDesign]: "GUI design",
    [IDMAP.GUIFrameworkDesign]: "GUI framework design",
    [IDMAP.BUI]: "BUI (my core gui lib)",
    [IDMAP.BUIBasic]: "BUI Basic (my gui framework)",
    [IDMAP.Constrainer]: "Constrainer (now \"archived indefinitely\" tool for creating CAD-like GUI)",
    [IDMAP.AudioVisualization]: "audio visualization",
    [IDMAP.SoftwareAudioPlayback]: "software audio playback",
    [IDMAP.AsyncSoftware]: "async software",
    [IDMAP.RustAsync]: "async in Rust",
    [IDMAP.JavaScript]: "JavaScript",
    [IDMAP.P5JS]: "p5.js",
    [IDMAP.P5Sound]: "p5.sound",
    [IDMAP.ExpressJS]: "ExpressJS",
    [IDMAP.Websockets]: "Websockets",
    [IDMAP.SocketIO]: "socket.io",
    [IDMAP.RealTimeMultiplayer]: "real-time multiplayer",
    [IDMAP.WebMultiplayer]: "multiplayer on the web",
    [IDMAP.MultiplayerClientPredicationAndRollback]: "multiplayer client prediction and rollback",
    [IDMAP.MultiplayerMatchmaking]: "multiplayer matchmaking",
    [IDMAP.PeripheralDevelopment]: "peripheral dev",
    [IDMAP.CAD]: "CAD",
    [IDMAP.FreeCAD]: "FreeCAD",
    [IDMAP.FDM3DPrinting]: "FDM 3D Printing",
    [IDMAP.Debouncing]: "Debouncing",
    [IDMAP.Soldering]: "Soldering",
    [IDMAP.Arduino]: "Arduino",
    [IDMAP.CPP]: "C++",
    [IDMAP.OpenSCAD]: "OpenSCAD",
    [IDMAP.Nginx]: "Nginx",
    [IDMAP.ReverseProxy]: "reverse proxy",
    [IDMAP.Linux]: "Linux",
    [IDMAP.Ubuntu]: "Ubuntu",
    [IDMAP.NodeJS]: "Node.js",
    [IDMAP.API]: "API",
    [IDMAP.ReverseEngineeringAPI]: "reverse engineering APIs",
    [IDMAP.RESTAPI]: "REST API",
    [IDMAP.BrowserExtensions]: "browser extensions",
    [IDMAP.BrowserExtensionPublishing]: "browser extension publishing",
    [IDMAP.Python]: "Python",
    [IDMAP.FFmpeg]: "FFmpeg",
    [IDMAP.YouTubeAPI]: "YouTube API",
    [IDMAP.C]: "C",
    [IDMAP.LowLevelEmbeddedSoftware]: "low-level/embedded software",
    [IDMAP.PebbleUI]: "Pebble UI",
    [IDMAP.GameDevelopment]: "game development",
    [IDMAP.FirmwareDevelopment]: "firmware development",
    [IDMAP.FreeRTOSSoftware]: "FreeRTOS software",
    [IDMAP.LittleVGL]: "LittleVGL",
    [IDMAP.AndroidNative]: "Android Native",
    [IDMAP.AndroidLayoutsViews]: "Android layouts/views",
    [IDMAP.Java]: "Java",
    [IDMAP.MobileApps]: "mobile apps",
    [IDMAP.VRAppDevelopment]: "VR app development",
    [IDMAP.OpenXR]: "OpenXR",
    [IDMAP.Godot]: "Godot",
    [IDMAP.GodotRust]: "Rust in Godot",
    [IDMAP.FFI]: "FFI",
    [IDMAP.DesktopGames]: "Desktop Games",
    [IDMAP.WindowsGames]: "Windows Games",
    [IDMAP.TCPSockets]: "TCP Sockets",
    [IDMAP.RenderShaders]: "render shaders",
    [IDMAP.WGSL]: "WGSL",
    [IDMAP.Websites]: "websites",
    [IDMAP.CrossPlatformDesktopMobileWeb]: "cross-platform (mobile, desktop, web)",
    [IDMAP.ComputeShaders]: "compute shaders",
    [IDMAP.StaticSites]: "static sites",
    [IDMAP.CLI]: "CLI",
    [IDMAP.Algorithms]: "algorithms",
    [IDMAP.OCR]: "OCR",
    [IDMAP.Nix]: "Nix",
    [IDMAP.WebComponents]: "Web Components",
};

const IDTOCARD = {
    [IDMAP.wgpuGameOfLife]: {
        title: "WGPU Game of Life",
        started: new Date(2022, 7, 13),
        completed: new Date(2022, 7, 13),
        last_updated: null,
        skills: [
            IDMAP.Rust,
            IDMAP.BUI,
            IDMAP.BUIBasic,
            IDMAP.WGPU,
            IDMAP.WGSL,
            IDMAP.ComputeShaders,
            IDMAP.DesktopSoftware,
            IDMAP.WindowsSoftware,
            IDMAP.LinuxSoftware,
            IDMAP.Winit,
        ],
        description: "<p>Conway's Game of Life computed and rendered on the GPU using WGPU. Written with my own gui framework, BUI Basic.</p>",
        links: [
            {
                href: "https://github.com/clay53/wgpu_game_of_life",
                text: "Code",
            },
            {
                href: "https://github.com/clay53/wgpu_game_of_life/releases/",
                text: "Download",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/wgpu_game_of_life.png",
            alt: "a simple example of Conway's game of life",
        },
    },
    [IDMAP.buiBasic]: {
        title: "BUI Basic",
        started: new Date(2022, 2, 22),
        completed: null,
        last_updated: new Date(2023, 5),
        skills: [
            IDMAP.Rust,
            IDMAP.BUI,
            IDMAP.GUIFrameworkDesign,
            IDMAP.CrossPlatformDesktopMobileWeb,
        ],
        description:
            `<p>Simplified wrapper around bui for building guis without sacrificing any performance.</p>
            <p>Won 1st place wth a perfect score at the PJAS state competition.</p>
            <p>I'm a little bit disenchanted with this. I think there will need to be innovations (that I'm working on) in 
            programming languges to actually achieve the ideal this project seeks.</p>
            <p>Note: Latest update is not pushed</p>`,
        links: [
            {
                href: "https://github.com/clay53/bui_basic",
                text: "Code",
            },
        ],
        thumb: null,
    },
    [IDMAP.bui]: {
        title: "BUI",
        started: new Date(2021, 8, 13),
        completed: null,
        last_updated: new Date(2023, 5),
        skills: [
            IDMAP.Rust,
            IDMAP.WGPU,
            IDMAP.WGSL,
            IDMAP.RenderShaders,
            IDMAP.CrossPlatformDesktopMobileWeb,
        ],
        description:
            `<p>A performant WGPU (currently - plan to support multiple backends) GUI rendering library.</p>
            <p>Note: Latest update is not pushed.</p>`,
        links: [
            {
                href: "https://github.com/clay53/bui",
                text: "Code",
            },
        ],
        thumb: null,
    },
    [IDMAP.microVSRG]: {
        title: "Micro VSRG",
        started: new Date(2021, 11, 12),
        completed: new Date(2021, 11, 28),
        last_updated: null,
        skills: [
            IDMAP.Rust,
            IDMAP.Microcontrollers,
            IDMAP.RaspberryPi,
            IDMAP.DynamicParsing,
        ],
        description: 
                `<p>A rhythm game for Raspberry Pi - specifically the Raspberry Pi 3B+. 
                Imports 4k osu!mania maps (no hold notes). Single player (2 player may be added). 
                I completed this project for a Raspberry Pi 3. 
                This game is meant to be played with wheeled robots hitting the notes and sacrifices were made for that. 
                However, it can be easily modified to fit one's requirements. 
                The game dynamically reads and parses osu!mania (a popular and now open source rhythm game for desktop operating systems) 
                set/map files that the user can choose from to play on startup.</p>`,
        links: [
            {
                href: "https://github.com/clay53/micro_vsrg",
                text: "Code",
            },
            {
                href: "/videos/experiences/micro-vsrg.mp4",
                text: "Showcase",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/micro-vsrg.webp",
            alt: "Students playing Micro VSRG with RC robots"
        },
    },
    [IDMAP.claytonHickeyMe]: {
        title: "claytonhickey.me (old)",
        started: new Date(2021, 7, 5),
        completed: new Date(2021, 7, 5),
        last_updated: new Date(2023, 8, 28),
        skills: [
            IDMAP.Websites,
            IDMAP.Rust,
            IDMAP.Maud,
            IDMAP.StaticSites,
            IDMAP.HTML,
            IDMAP.CSS,
            IDMAP.WebHosting,
            IDMAP.Linode,
            IDMAP.Nginx,
            IDMAP.DNS,
            IDMAP.Cloudflare,
            IDMAP.Nix,
        ],
        description: `<p>The old version of this site was generated statically with Rust and the Maud templating engine. Deployed with Nix.</p>`,
        links: [
            {
                href: "https://github.com/clay53/claytonhickey_me/tree/5ae5be4883054a938d0cfe588a54e19d179e3a65",
                text: "Code",
            },
        ],
        thumb: null,
    },
    [IDMAP.wordSearchSolverOCR]: {
        title: "Word Search Solver OCR",
        started: null,
        completed: new Date(2019, 2, 1),
        last_updated: null,
        skills: [
            IDMAP.Websites,
            IDMAP.WebApps,
            IDMAP.Algorithms,
            IDMAP.OCR,
            IDMAP.JavaScript,
            IDMAP.P5JS,
            IDMAP.HTML,
            IDMAP.CSS,
        ],
        description: `<p>A tool to solve word searching using OCR which allows users to upload pictures of word searches 
                so they can solve them quickly. Developed because I am very bad at word searches.</p>`,
        links: [
            {
                href: "https://claytondoesthings.xyz/software/word-search-cheats-ocr/web",
                text: "Live",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/word-search-cheats-ocr.png",
            alt: "screenshot of a word search solved with Word Search Cheats",
        },
    },
    [IDMAP.claytonDoesThingsXYZ]: {
        title: "ClaytonDoesThings.xyz",
        started: null,
        completed: null,
        last_updated: new Date(2021, 12, 28),
        skills: [
            IDMAP.Rust,
            IDMAP.RocketRs,
            IDMAP.FullstackWeb,
            IDMAP.DNS,
            IDMAP.Cloudflare,
            IDMAP.WebHosting,
            IDMAP.Linode,
            IDMAP.Linux,
            IDMAP.Ubuntu,
            IDMAP.Nginx,
            IDMAP.ServerSideRendering,
            IDMAP.WebTemplating,
            IDMAP.Maud,
            IDMAP.GoogleSEO,
            IDMAP.BingSEO,
            IDMAP.DynamicSitemap,
            IDMAP.HTML,
            IDMAP.CSS,
            IDMAP.Websites,
        ],
        description: 
            `<p>My personal website to show off projects. Has gone through many rewrites. 
                The current version is made with Rust using the backend framework, Rocket, and the compile-time templating engine, Maud. 
                The website is hosted on Linode and put behind a Cloudflare proxy to protect from the surprisingly common DDOS attacks. 
                It's also behind a reverse proxy, nginx, to allow for other sites to be hosted on the same Ubuntu Linode server 
                Gets 100% on Google Lighthouse. Previous version used NodeJS, expressJS, and a custom web framework/templator.</p>`,
        links: [
            {
                href: "https://claytondoesthings.xyz",
                text: "Live",
            },
            {
                href: "https://github.com/clay53/ClaytonXYZ",
                text: "Code",
            },
        ],
        thumb: null,
    },
    [IDMAP.carAI]: {
        title: "CarAI",
        started: new Date(2019, 4, 7),
        completed: new Date(2019, 4, 7),
        last_updated: null,
        skills: [
            IDMAP.UnityEngine,
            IDMAP.CSharp,
            IDMAP.AI,
            IDMAP.ML,
            IDMAP.CustomML,
            IDMAP.DesktopSoftware,
            IDMAP.WindowsSoftware,
            IDMAP.LinuxSoftware,
            IDMAP.MacSoftware,
            IDMAP.WebApps,
        ],
        description: 
            `<p>I created a custom neural net/machine learning procedure to train a neural net to drive through a track. 
                It's inefficient but it works. I made a video describing how I developed it and how it works.</p>`,
        links: [
            {
                href: "https://claytondoesthings.xyz/games/carai/web",
                text: "Live",
            },
            {
                href: "https://github.com/clay53/CarAI",
                text: "Code",
            },
            {
                href: "https://claytondoesthings.xyz/games/carai",
                text: "Download",
            },
            {
                href: "https://youtu.be/jjhNab0bJgQ",
                text: "Showcase",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/carai.png",
            alt: "the car AI making a turn towards the exit",
        },
    },
    [IDMAP.soundGalaxy]: {
        title: "Sound Galaxy",
        started: new Date(2021, 11, 28),
        completed: new Date(2021, 11, 28),
        last_updated: null,
        skills: [
            IDMAP.Rust,
            IDMAP.WGPU,
            IDMAP.WGSL,
            IDMAP.RenderShaders,
            IDMAP.Winit,
            IDMAP.BUI,
            IDMAP.Constrainer,
            IDMAP.DesktopSoftware,
            IDMAP.WindowsSoftware,
            IDMAP.LinuxSoftware,
            IDMAP.AudioVisualization,
            IDMAP.AsyncSoftware,
            IDMAP.RustAsync
        ],
        description: 
            `<p>I adapted a JavaScript/p5.js tutorial by ExecuteBig which itself was an adaptation from 
                a HackClub tutorial to use Rust and my own GUI libraries/tools which are fully GPU accelerated.</p>
            <p>Usage: place a sound file named \"input.mp3\" next to the downloaded executable/binary file 
                and run the executable or specifify the location of the file as the first argument when executing from a terminal</p>`,
        links: [
            {
                href: "https://github.com/clay53/sound_galaxy/releases",
                text: "Download",
            },
            {
                href: "https://github.com/clay53/sound_galaxy",
                text: "Code",
            },
            {
                href: "https://www.youtube.com/watch?v=kzUnaH4M824",
                text: "Showcase",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/sound_galaxy.png",
            alt: "Crab Rave visualized with Sound Galaxy as colored circles flowing downward",
        },
    },
    [IDMAP.meetWithPong]: {
        title: "Meet With Pong",
        started: null,
        completed: new Date(2020, 1, 21),
        last_updated: null,
        skills: [
            IDMAP.JavaScript,
            IDMAP.HTML,
            IDMAP.CSS,
            IDMAP.P5JS,
            IDMAP.P5Sound,
            IDMAP.WebApps,
            IDMAP.SoftwareAudioPlayback,
            IDMAP.NodeJS,
            IDMAP.Websockets,
            IDMAP.SocketIO,
            IDMAP.RealTimeMultiplayer,
            IDMAP.WebMultiplayer,
            IDMAP.MultiplayerClientPredicationAndRollback,
            IDMAP.MultiplayerMatchmaking,
        ],
        description: 
            `<p>A real-time multiplayer pong clone made for a Repl.it competition. 
            Instead of just playing to a score, winning a point reveals information about the other 
            player (that they submit) so that they can get to know each other a bit. Physics calculations 
            are done server-side to prevent cheating. Optional singleplayer is available.</p>`,
        links: [
            {
                href: "https://meet-with-pong.clay53.repl.co/w/index.html",
                text: "Live",
            },
            {
                href: "https://github.com/clay53/Meet-With-Pong",
                text: "Code",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/meet-with-pong.png",
            alt: "Clayton playing png against Bob. Revealed names and Bob's favorite programming language."
        },
    },
    [IDMAP.osuKeypad]: {
        title: "osu!keypad",
        started: null,
        completed: new Date(2020, 7, 22),
        last_updated: null,
        skills: [
            IDMAP.OpenSCAD,
            IDMAP.Arduino,
            IDMAP.CPP,
            IDMAP.Microcontrollers,
            IDMAP.PeripheralDevelopment,
            IDMAP.CAD,
            IDMAP.FreeCAD,
            IDMAP.FDM3DPrinting,
            IDMAP.Debouncing,
            IDMAP.Soldering,
        ],
        description: 
            `<p>An extremely cheap ($10) 2 key keyboard for playing Osu!, 
                a rhythm game, with an Arduino Pro Micro base. Case designed by me in FreeCAD, 
                keycaps designed by rsheldiii and customized with OpenSCAD, 
                all 3D printed on my MP Select Mini V2 in PLA. 
                Code was developed by me using Arduino's pre-built tools and C++.</p>`,
        links: [
            {
                href: "https://github.com/clay53/Osu-Keypad",
                text: "Code",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/osu!keypad.webp",
            alt: "Picture of the 2 key keypad 3D printed in red filament with kalih box brown key switches."
        },
    },
    [IDMAP.symbolTranslator]: {
        title: "Symbol Translator",
        started: null,
        completed: new Date(2019, 6, 4),
        last_updated: new Date(2019, 7, 19),
        skills: [
            IDMAP.WebApps,
            IDMAP.JavaScript,
            IDMAP.HTML,
            IDMAP.P5JS
        ],
        description: 
            `<p>Created a web app with p5.js to make visually translating between 
                cryptic \"fonts\" easier. Made for the Game Theory ARG.</p>`,
        links: [
            {
                href: "https://claytondoesthings.xyz/software/symbol-translator/web",
                text: "Live",
            },
            {
                href: "https://github.com/ClaytonDoesThings/SymbolTranslator",
                text: "Code",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/symbol-translator.png",
            alt: "Decoded \"hello\" from BirbText",
        },
    },
    [IDMAP.pebbleXCTimer]: {
        title: "PebbleXCTimer",
        started: null,
        completed: new Date(2018, 8, 20),
        last_updated: null,
        skills: [
            IDMAP.C,
            IDMAP.LowLevelEmbeddedSoftware,
            IDMAP.PebbleUI
        ],
        description: 
            `<p>A timer for keeping track of cross country or track running 
                intervals and other repeating timer needs. Also functions as a stopwatch. Uses the native Pebble SDK.</p>`,
        links: [
            {
                href: "https://apps.rebble.io/en_US/application/62cdbbd1f0886b0009c74042",
                text: "RebbleStore",
            },
            {
                href: "https://github.com/ClaytonDoesThings/PebbleXCTimer",
                text: "Code",
            },
            {
                href: "https://github.com/clay53/PebbleXCTimer/releases",
                text: "Download",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/pebbleXCTimer.png",
            alt: "Screenshot showing time and interval",
        },
    },
    [IDMAP.imagesFromImages2]: {
        title: "Images From Images 2",
        started: new Date(2022, 7, 22),
        completed: null,
        last_updated: new Date(2022, 8, 17),
        skills: [
            IDMAP.WGPU,
            IDMAP.Rust,
            IDMAP.CLI,
        ],
        description: 
            `<p>Makes images from images using the GPU so it's much faster. 
                Will update so that it also works in the web and desktop without CLI.</p>`,
        links: [
            {
                href: "https://github.com/clay53/images_from_images2",
                text: "Code",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/legitimate-images-from-images.webp",
            alt: "Cat made from dogs",
        },
    },
    [IDMAP.legitimateImagesFromImages]: {
        title: "Legitimate Images From Images",
        started: null,
        completed: new Date(2018, 5, 26),
        last_updated: null,
        skills: [
            IDMAP.JavaScript,
            IDMAP.P5JS,
            IDMAP.HTML,
            IDMAP.CSS,
            IDMAP.WebApps
        ],
        description: `<p>I made a program that takes a bunch of images and forms them into another image by color matching.</p>`,
        links: [
            {
                href: "https://claytondoesthings.xyz/software/legitimate-images-made-from-images",
                text: "Live",
            },
            {
                href: "https://github.com/clay53/Legitimate-Images-From-Images",
                text: "Code",
            },
        ],
        thumb: {
           source: "/images/experiences/thumbs/legitimate-images-from-images.webp",
           alt: "Cat made from dogs",
        },
    },
    [IDMAP.multiKahoot]: {
        title: "MultiKahoot",
        started: null,
        completed: new Date(2019, 10, 9),
        last_updated: null,
        skills: [
            IDMAP.JavaScript,
            IDMAP.NodeJS,
            IDMAP.ExpressJS,
            IDMAP.HTML,
            IDMAP.CSS,
            IDMAP.API,
            IDMAP.WebApps
        ],
        description: 
            `<p>Allows a single player to control multiple Kahoot \"users\" from an 
                entirely separate website. Also allows keyboard controls without the use of 
                external hotkey software so that one can answer faster on a Chromebook.</p>
            <p>Does not work for now due to changes in Kahoot's API</p>`,
        links: [
            {
                href: "https://replit.com/@ClaytonHickey/MultiKahoot",
                text: "Code",
            },
            {
                href: "https://MultiKahoot.claytonhickey.repl.co/",
                text: "Live",
            },
        ],
        thumb: null,
    },
    [IDMAP.givingDuo]: {
        title: "GivingDuo",
        started: new Date(2020, 8, 12),
        completed: new Date(2020, 8, 30),
        last_updated: null,
        skills: [
            IDMAP.ReverseEngineeringAPI,
            IDMAP.JavaScript,
            IDMAP.HTML,
            IDMAP.RESTAPI,
            IDMAP.BrowserExtensions,
            IDMAP.BrowserExtensionPublishing
        ],
        description: 
            `<p>A browser extension to allow users of Duolingo to give multiple lingots 
                at the same time to users for their contributions to the forums or helping them understand a new topic.</p>
            <p>Note: Lingots no longer exist so the extension no longer works..</p>`,
        links: [
            {
                href: "https://github.com/clay53/GivingDuo",
                text: "Code",
            },
            {
                href: "https://chrome.google.com/webstore/detail/giving-duo/lacfjcephcjbihliackggaifbkbiimfl",
                text: "ChromeWebStore",
            },
            {
                href: "https://addons.mozilla.org/en-US/firefox/addon/giving-duo/",
                text: "FirefoxAddOns",
            },
            {
                href: "https://github.com/clay53/GivingDuo/releases",
                text: "Download",
            },
        ],
        thumb: {
            source: "/images/experiences/thumbs/givingduo.jpg",
            alt: "Example of giving multiple lingots."
        },
    },
    [IDMAP.liveStreamMusicPlayer]: {
        title: "Live Stream Music Player",
        started: new Date(2018, 3, 30),
        completed: new Date(2018, 4, 3),
        last_updated: null,
        skills: [
            IDMAP.Python,
            IDMAP.FFmpeg,
            IDMAP.DesktopSoftware,
            IDMAP.WindowsSoftware,
            IDMAP.LinuxSoftware,
            IDMAP.MacSoftware,
            IDMAP.API,
            IDMAP.YouTubeAPI,
        ],
        description: 
            `<p>Gets royalty free music from creators and automatically gives them credit to 
                play during live streams through integration with OBS</p>`,
        links: [
            {
                href: "https://github.com/ClaytonDoesThings/Live-Stream-Music-Player",
                text: "Code",
            },
        ],
        thumb: null,
    },
    [IDMAP.fromAnarchy]: {
        title: "From Anarchy",
        started: new Date(2021, 7, 20),
        last_updated: new Date(2021, 7, 23),
        skills: [
            IDMAP.VRAppDevelopment,
            IDMAP.OpenXR,
            IDMAP.Godot,
            IDMAP.FFI,
            IDMAP.DesktopGames,
            IDMAP.WindowsGames,
            IDMAP.TCPSockets,
            IDMAP.RealTimeMultiplayer,
            IDMAP.AsyncSoftware,
            IDMAP.DesktopSoftware,
            IDMAP.WindowsSoftware,
            IDMAP.LinuxSoftware,
        ],
        description:
            `<p>A micro voxel-world VR game. Never finished but it was a good exercise in making VR 
                games and using Rust/FFI in game engines for optimal performance. 
                Likely applicable to other engines like Unity and Unreal. 
                This game would probably require a custom rendering pipeline to make performant at all so 
                if this were to be fully developed, a custom engine would be used.</p>`,
        links: [
            {
                href: "https://github.com/clay53/from_anarchy",
                text: "Code",
            }
        ],
    },
    [IDMAP.repeatOptionInfinitime]: {
        title: "Added repeat option to timer for Infinitime (open source watch firmware)",
        started: new Date(2022, 1, 9),
        completed: new Date(2022, 1, 9),
        last_updated: new Date(2022, 2, 8),
        skills: [
            IDMAP.CPP,
            IDMAP.FirmwareDevelopment,
            IDMAP.FreeRTOSSoftware,
            IDMAP.LittleVGL,
        ],
        description:
            `<p>I purchased a new PineTime watch which uses the Infinitime firmware. 
                I had previously used my own app (PebbleXCTimer) on my old Pebble Time for this function 
                but it's not portable and the Infinitime firmware does not have the function built in or sideloading. 
                So, I added the functionality to the timer app already built in.</p>
            <p>Note: PR is unmerged but code is functional. They said they want it to be 
                put into a separate app but I haven't gotten to it yet.</p>`,
        links: [
            {
                href: "https://github.com/InfiniTimeOrg/InfiniTime/pull/926",
                text: "PR",
            }
        ],
        thumb: {
            source: "/images/experiences/thumbs/infinitime-repeat-timer-option.png",
            href: "Showing repeat option selected while playing timer",
        }
    },
    [IDMAP.addedComentsLBRYAndroid]: {
        title: "Added ability to view comments to LBRY Android app",
        started: new Date(2020, 5, 28),
        completed: new Date(2020, 5, 29),
        skills: [
            IDMAP.AndroidNative,
            IDMAP.AndroidLayoutsViews,
            IDMAP.Java,
            IDMAP.RESTAPI,
            IDMAP.MobileApps,
        ],
        description:
            `<p>Comments on the LBRY website were already present but they were not available on the Android app. 
                I like to read comments so I decided I should add them to the Android app so I analyzed how their website 
                (ReactJS) was able to get comments from the LBRY REST backend server and adapted a similar technique to 
                make comments available on the Android app.</p>
            <p>Note: I only included the first page of comments in my PR because I didn't see a way with their 
                API to ensure that the comments were kept in sync (if a comment was added or removed before a user 
                would scroll, comments may be missing or duplicated on the user's screen) without fetching all the pages at once 
                (defeating the purpose of pagination of saving memory and bandwidth). 
                I thought they were going to add something to their API or something but after my PR, 
                they just went with the latter solution and fetched all the pages at once.</p>`,
        links: [
            {
                href: "https://github.com/lbryio/lbry-android/pull/920",
                text: "PR",
            }
        ],
    },
    [IDMAP.publishUnpublishLBRYAndroid]: {
        title: "Made it so that one can unpublish and/or delete their own videos from LBRY Android app",
        started: new Date(2020, 10, 2),
        completed: new Date(2020, 10, 2),
        skills: [
            IDMAP.AndroidNative,
            IDMAP.AndroidLayoutsViews,
            IDMAP.Java,
            IDMAP.RESTAPI,
            IDMAP.MobileApps,
        ],
        description:
            `<p>Unpublishing and deleting videos are separate actions on the LBRY platform. 
                However, the LBRY Android app did not make this distinction and performed both actions. 
                So, I added another button and fixed some UI logic around it.</p>`,
        links: [
            {
                href: "https://github.com/lbryio/lbry-android/pull/1013",
                text: "PR",
            }
        ],
    },
    [IDMAP.claytonHickeyMeWC]: {
        title: "claytonhickey.me",
        started: new Date(2023, 11, 15),
        completed: new Date(2023, 11, 16),
        skills: [
            IDMAP.Websites,
            IDMAP.JavaScript,
            IDMAP.HTML,
            IDMAP.CSS,
            IDMAP.WebHosting,
            IDMAP.Linode,
            IDMAP.Nginx,
            IDMAP.DNS,
            IDMAP.Cloudflare,
            IDMAP.Nix,
            IDMAP.StaticSites,
            IDMAP.WebComponents,
        ],
        description: `<p>A portfolio website (this website) created in raw HTML, CSS, and JS using web components</p>`,
        links: [
            {
                href: "https://claytonhickey.me",
                text: "Live",
            },
            {
                href: "https://github.com/clay53/claytonhickey_me",
                text: "Code",
            },
        ],
    },
};
