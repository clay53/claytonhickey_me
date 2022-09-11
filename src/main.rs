use chrono::NaiveDateTime;
use dotenv;
use maud::{DOCTYPE, html, Markup, PreEscaped};
use std::{
    fs,
    path::{
        PathBuf,
        Path,
    }
};

use claytonhickey_me::{PROJECTS, ABANDONED_PROJECTS, CONTRIBUTIONS, SOCIALS};

pub struct Config {
    pub domain: String,
}


fn page<S: AsRef<str>, T: AsRef<str>, U: AsRef<str>>(config: &Config, title: S, description: T, cannonical_path: U, highlighted_path: Option<&str>, content: Markup) -> Markup {
    let nav_element = |text: &str, path: &str| -> Markup {
        html! {
            div class=(format!("nav-item{}", match highlighted_path {
                Some(highlighted_path) if highlighted_path==path => " nav-item-selected",
                _ => ""
            })) {
                a href={(config.domain)(path)} { (text) }
            }
        }
    };
    html! {
        (DOCTYPE)
        html lang="en" { // Only English is supported as of now
            head {
                meta charset="UTF-8";
                title {(title.as_ref())}
                meta name="description" content=(description.as_ref());
                link rel="canonical" href=(format!("{}{}", config.domain, cannonical_path.as_ref()));
                meta name="viewport" content="width=device-width, initial-scale=1";
                link rel="stylesheet" type="text/css" href="/styles.css";
                link rel="icon" type="image/ico" href="/favicon.ico";
            }
            body {
                nav id="nav" {
                    (nav_element("Home", "/"))
                    (nav_element("Services", "/services"))
                    (nav_element("Notes", "/notes"))
                }
                main id="content" {
                    (content)
                }
                footer id="footer" {
                    hr;
                    span { "Check out the code on " a href="https://github.com/clay53/claytonhickey_me" { "GitHub.com" } }
                    div id="footer-social-media" {
                        @for social in SOCIALS {
                            a href=(social.link) title=(social.handle) { img src=(social.white_icon) alt=(social.platform); }
                        }
                    }
                }
            }
        }
    }
}

fn main() {
    let config = Config {
        domain: dotenv::var("DOMAIN").expect("failed to get DOMAIN from .env")
    };

    let stdin = std::io::stdin();
    let mut input = String::new();

    // recreate site folder

    let www_dir = dotenv::var("WWW_DIR").unwrap_or("./www".to_string());

    println!("This script will delete {} and recreate it. Is that ok (y/N)?", www_dir);
    stdin.read_line(&mut input).unwrap();
    if !input.trim_end().eq_ignore_ascii_case("y") {
        return
    }
    
    let www_dir = Path::new(&www_dir);
    if www_dir.exists() {
        for entry in fs::read_dir(www_dir).unwrap() {
            let entry = entry.unwrap();
            let file_type = entry.file_type().unwrap();
            if file_type.is_dir() {
                fs::remove_dir_all(entry.path()).unwrap();
            } else {
                fs::remove_file(entry.path()).unwrap();
            }
        }
    } else {
        fs::create_dir(www_dir).unwrap();
    }

    fn subdir<S: AsRef<Path>>(path: &Path, subdir: S) -> PathBuf {
        let mut new_path = path.to_path_buf();
        new_path.push(subdir);
        new_path
    }

    // clone assets

    fs_extra::dir::copy("./assets", www_dir, &fs_extra::dir::CopyOptions {
        content_only: true,
        ..Default::default()
    }).unwrap();

    // sitemap

    let url = |path: String, lastmod: Option<NaiveDateTime>, changefreq: &str, priority: &str| -> Markup {
        html! {
            url {
                loc {(config.domain)(path)}
                @match lastmod { Some(lastmod) => {lastmod {(lastmod.format("%Y-%m-%d"))}} None => {} }
                changefreq {(changefreq)}
                priority {(priority)}
            }
        }
    };

    fs::write(subdir(www_dir, "sitemap.xml"), html! {
        (PreEscaped(r#"<?xml version="1.0" encoding="UTF-8"?>"#))
        urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" {
            (url("/".to_string(), None, "weekly", "1"))
            (url("/services".to_string(), None, "weekly", "1"))
            (url("/notes".to_string(), None, "weekly", "1"))
        }
    }.into_string()).unwrap();

    // home

    fs::write(subdir(www_dir, "index.html"), page(
        &config,
        "Clayton Hickey",
        "Clayton Hickey's website",
        "/",
        Some("/"),
        html! {
            section id="introduction" {}
            div id="introduction-container" {
                div {
                    h1 { "Clayton Hickey" }
                    p {
                        "I'm a 17 year old fullstack web/software developer. Prospective bioengineer and computer engineer. \
                        Taught myself programming since 2nd grade by just going for it. \
                        I'm currently working on developing an educational software suite to compete with \
                        Anki, Quizlet, Kahoot, GimKit, Google Classroom, and Duolingo that runs on all \
                        platforms (desktop, web, & mobile) and is federated (not exactly but it's the same spirit), \
                        free, and open source. It's being developed with my own gui/software framework, "
                        a href="https://github.com/clay53/bui_basic" { "BUI Basic" } ". \
                        The language learning portion of the suite's development is being document on Twitter: "
                        a href="https://twitter.com/LanguageTutorRS" { "@LanguageTutorRS" } "."
                    }
                }
                img src="/images/headshot_square.webp" id="headshot" alt="Headshot of Clayton Hickey";
            }
            
            section id="experiences" {}
            h1 { "Experiences" }
            div {
                // h3 { "skills" }
                // div {
                    
                // }
                h2 { "Projects" }
                div class="experience-container" {
                    @for project in PROJECTS {
                        (project.to_markup())
                    }
                }
                h2 { "Open Source Contributions" }
                div class="experience-container" {
                    @for contribution in CONTRIBUTIONS {
                        (contribution.to_markup())
                    }
                }
                h2 { "Abandoned Projects" }
                div class="experience-container" {
                    @for unfinished_project in ABANDONED_PROJECTS {
                        (unfinished_project.to_markup())
                    }
                }
            }
            
            section id="tidbits" {}
            h1 { "Tidbits" }
            div id="tidbits-container" {
                div {
                    h2 class="tidbit-subheader" { "Desktop: custom" }
                    p class="tidbit-details" {
                        "OS: Arch" br;
                        "WM: LeftWM" br;
                        "CPU: i7-6700" br;
                        "GPU: RTX 2060" br;
                        "RAM: 32GB" br;
                        "Monitors: 2.8"
                    }
                }
                div {
                    h2 class="tidbit-subheader" { "Laptop: Samsung Chomebook 3" }
                    p class="tidbit-details" {
                        "OS: Arch" br;
                        "WM: Sway" br;
                        "CPU: Celeron N3060" br;
                        "RAM: 4GB" br;
                        "Storage: 128 GB SanDisk Extreme MicroSD XC"
                    }
                }
                div {
                    h2 class="tidbit-subheader" { "Programming Environment" }
                    p class="tidbit-details" {
                        "IDE: VSCode" br;
                        "Terminal: Alacritty" br;
                        "Shell: Bash" br;
                        "RAM: 4GB" br;
                        "Branch preference: LTS (but probably using nightly)"
                    }
                }
                div {
                    h2 class="tidbit-subheader" { "Personal Server" }
                    p class="tidbit-details" {
                        "Host: Linode" br;
                        "RAM: 1GB" br;
                        "CPU: 1 core Xeon E5-2697" br;
                        "OS: Ubuntu 20.04" br;
                        "Proxy: Nginx" br;
                        "Server: Nextcloud"
                    }
                }
                div {
                    h2 class="tidbit-subheader" { "<3 Software Stack" }
                    p class="tidbit-details" {
                        "Main Language: Rust" br;
                        "GUI Framework: BUI Basic" br;
                        "Windower: Winit" br;
                        "Graphics Library: WGPU + BUI" br;
                        "Android bridge: android-ndk-rs"
                    }
                }
                div {
                    h2 class="tidbit-subheader" { "<3 Web Stack" }
                    p class="tidbit-details" {
                        "Main Language: Rust" br;
                        "Framework: Rocket.rs" br;
                        "Templater: Maud" br;
                        "Database: Postgres (want to replace with my own)" br;
                        "Database Driver: Diesel"
                    }
                }
                div {
                    h2 class="tidbit-subheader" { "HS Clubs" }
                    p class="tidbit-details" {
                        a href="https://tsaweb.org/teams" { "TEAMS" } ": President" br;
                        a href="https://www.soinc.org/" { "Science Olympiad" } ": President" br;
                        "Esports: Vice President" br;
                        "GMSGA: Historian" br;
                        a href="https://tsaweb.org/" { "TSA" } br;
                        "Spanish Club"
                    }
                }
                div {
                    h2 class="tidbit-subheader" { "Sports" }
                    p class="tidbit-details" {
                        "Cross Country" br;
                        "Winter/Spring Track" br;
                        "Tennis"
                    }
                }
            }
        }).into_string()
    ).unwrap();

    // services

    let services_dir = subdir(www_dir, "services");

    fs::create_dir(&services_dir).unwrap();
    fs::write(subdir(services_dir.as_path(), "index.html"),page(
        &config,
        "Services - Clayton Hickey",
        "Services offered by Clayton Hickey.",
        "/services",
        Some("/services"),
        html! {
            h1 { "Services" }

            section id="contact" {}
            h2 { "Contact" }
            p {
                "even if you want something not listed on this page, feel free to contact me."
            }
            address {
                "mail: " a href="mailto:clayton@claytondoesthings.xyz" { "clayton@claytondoesthings.xyz" } br;
                "phone (Google Voice): " a href="tel:+14842589302" { "+1 (484) 258-9302" } br;
                "Discord: ClaytonDoesThings#4119" br;
                "Twitter DM: " a href="https://twitter.com/ClaytonsThings" { "https://twitter.com/ClaytonsThings" } br;
                "Snapchat, Instagram, etc. are fine if I know you"
            }

            section id="contract-programming" {}
            h2 { "Contract/commission Programming" }
            p {
                "I will program something for you be it a feature for something you're already creating, fixing a bug, or \
                even a whole application. I cannot take all jobs because I do have limited time and I cannot determine a rate \
                until I know what I'm creating so " a href="#contact" { "contact me" } "."
            }

            section id="in-person-tutoring" {}
            h2 { "In-person Tutoring" }
            p {
                "If you're nearby, I am available to do in-person tutoring. Otherwise, "
                a href="#online-tutoring" { "online tutoring"} " is available. Currently, over the summer, I'm free most of the time. \
                During the school year, I will most likely not be able to tutor during the weekdays save for a studyhall. Weekends \
                are usually ok after like 10am."
            }

            section id="online-tutoring" {}
            h2 { "Online Tutoring" }
            p {
                "While I much prefer " a href="#in-person-tutoring" { "in-person tutoring" } ", online tutoring may be \
                much more convenient for some/most people. Rates for online tutoring will be slightly less because of gas. \
                I prefer to use " a href="https://discord.com" { "Discord" } " for online tutoring but most applications \
                including Zoom are fine. For more information on tutoring, please refer to the "
                a href="#in-person-tutoring" { "in-person tutoring" } " section. To talk about online tutoring, "
                a href="#contact" { "contact me" } "."
            }
        }).into_string()
    ).unwrap();

    // notes

    let notes_dir = subdir(www_dir, "notes");

    fs::create_dir(&notes_dir).unwrap();
    fs::write(subdir(notes_dir.as_path(), "index.html"),page(
        &config,
        "Notes - Clayton Hickey",
        "Notes offered by Clayton Hickey.",
        "/notes",
        Some("/notes"),
        html! {
            h1 { "Notes" }
            section id="ap-chemistry" {}
            h2 { "AP Chemistry" }
            a href="https://nextcloud.claytondoesthings.xyz/index.php/s/tteKW8N7p3w3wAD" { "Element Tutor (Linux v0.0.1)" } " "  a href="https://nextcloud.claytondoesthings.xyz/index.php/s/qydeH3QTSbfRZnS" { "Element Tutor (Windows v0.0.1)" } " - CLI tool to learn the elements. VERY early development - will completely change and you may have to manually resync progress."
            br;
            a href="https://nextcloud.claytondoesthings.xyz/index.php/s/3pB7q5XgaqxZ7y5" { "Anki Deck (2022-09-11.0)" }
        }).into_string()
    ).unwrap();
}