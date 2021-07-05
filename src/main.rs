#![feature(decl_macro)]
#[macro_use] extern crate rocket;

use dotenv;
use maud::{DOCTYPE, html, Markup};
use rocket::State;

pub struct Config {
    pub domain: String
}

fn page(config: &State<Config>, highlighted_path: Option<&str>, content: Markup) -> Markup {
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
        html {
            head {

            }
            body {
                div id="nav" {
                    (nav_element("Home", "/"))
                    (nav_element("Blog", "/blog"))
                }
                (content)
                div id="footer" {

                }
            }
        }
    }
}

#[get("/")]
async fn home(config: &State<Config>) -> Markup {
    page(config, Some("/"), html! {
        h1 { "Clayton Hickey" }
    })
}

#[get("/blog")]
async fn blog(config: &State<Config>) -> Markup {
    page(config, Some("/blog"), html! {

    })
}

#[launch]
fn rocket() -> _ {
    dotenv::dotenv().ok();
    rocket::build()
    .mount("/", routes![
        home,
        blog,
    ])
    .manage(Config {
        domain: dotenv::var("DOMAIN").unwrap()
    })
}