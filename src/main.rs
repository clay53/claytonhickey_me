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

use claytonhickey_me::{PROJECTS, ABANDONED_PROJECTS, CONTRIBUTIONS};

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
                }
                main id="content" {
                    (content)
                }
                footer id="footer" {
                    hr;
                    span { "Check out the code on " a href="https://github.com/ClaytonDoesThings/claytonhickey_me" { "GitHub.com" } }
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

    println!("This script will delete ./www and recreate it. Is that ok (y/N)?");
    stdin.read_line(&mut input).unwrap();
    if !input.trim_end().eq_ignore_ascii_case("y") {
        return
    }

    let www_dir = Path::new("www");
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
        }
    }.into_string()).unwrap();

    // home

    fs::write(subdir(www_dir, "index.html"), page(&config, "Clayton Hickey", "Clayton Hickey's website and blog", "/", Some("/"), html! {
        div id="introduction-container" {
            div {
                h1 { "Clayton Hickey" }
                p {
                    "I'm a 17 year old fullstack web/software developer. Prospective bioengineer. \
                    Taught myself programming since 2nd grade by just going for it. \
                    I'm currently working on developing an educational software suite to defeat \
                    Anki, Quizlet, Kahoot, GimKit, Google Classroom, and Duolingo in one fell swoop \
                    that runs on all platforms (desktop, web, & mobile) and is federated (not exactly), free, and open source. \
                    It's being developed with my own gui/software framework, "
                    a href="https://github.com/clay53/bui_basic" { "BUI Basic" } ". \
                    The language learning portion of the suite's development is being document on Twitter: "
                    a href="https://twitter.com/LanguageTutorRS" { "@LanguageTutorRS" } "."
                }
            }
            img src="/images/headshot_square.webp" id="headshot";
        }
        
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
        
        h1 { "Setup" }
        div id="setup-container" {
            div {
                h2 class="setup-subheader" { "Desktop: custom" }
                p class="setup-specs" {
                    "OS: Arch" br;
                    "WM: LeftWM" br;
                    "CPU: i7-6700" br;
                    "GPU: RTX 2060" br;
                    "RAM: 32GB" br;
                    "Monitors: 2.8"
                }
            }
            div {
                h2 class="setup-subheader" { "Laptop: Samsung Chomebook 3" }
                p class="setup-specs" {
                    "OS: Arch" br;
                    "WM: LeftWM" br;
                    "CPU: Celeron N3060" br;
                    "RAM: 4GB" br;
                    "Storage: 128 GB SanDisk Extreme MicroSD XC"
                }
            }
            div {
                h2 class="setup-subheader" { "Programming Environment" }
                p class="setup-specs" {
                    "IDE: VSCode" br;
                    "Terminal: Alacritty" br;
                    "Shell: Bash" br;
                    "RAM: 4GB" br;
                    "Branch preference: LTS (but probably using nightly)"
                }
            }
            div {
                h2 class="setup-subheader" { "Personal Server" }
                p class="setup-specs" {
                    "Host: Linode" br;
                    "RAM: 1GB" br;
                    "CPU: 1 core Xeon E5-2697" br;
                    "OS: Ubuntu 20.04" br;
                    "Proxy: Nginx" br;
                    "Server: Nextcloud"
                }
            }
            div {
                h2 class="setup-subheader" { "<3 Software Stack" }
                p class="setup-specs" {
                    "Main Language: Rust" br;
                    "GUI Framework: BUI Basic" br;
                    "Windower: Winit" br;
                    "Graphics Library: WGPU + BUI" br;
                    "Android bridge: android-ndk-rs"
                }
            }
            div {
                h2 class="setup-subheader" { "<3 Web Stack" }
                p class="setup-specs" {
                    "Main Language: Rust" br;
                    "Framework: Rocket.rs" br;
                    "Templater: Maud" br;
                    "Database: Postgres (want to replace with my own)" br;
                    "Database Driver: Diesel"
                }
            }
        }

        // h1 { "Blog" }

    }).into_string()).unwrap();
}