#![feature(decl_macro)]
#[macro_use] extern crate rocket;
#[macro_use] extern crate diesel;

use diesel::prelude::*;
use dotenv;
use maud::{DOCTYPE, html, Markup, PreEscaped};
use rocket::{
    http::Status,
    State,
};

pub struct Config {
    pub domain: String
}

mod schema;
mod blog_post;

use self::schema::*;

use rocket_sync_db_pools::{diesel as rocket_diesel, database};

#[database("postgres")]
pub struct DbConn(rocket_diesel::PgConnection);

fn page<S: AsRef<str>, T: AsRef<str>, U: AsRef<str>>(config: &State<Config>, title: S, description: T, cannonical_path: U, highlighted_path: Option<&str>, content: Markup) -> Markup {
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
                link rel="cannonical" href=(format!("{}{}", config.domain, cannonical_path.as_ref()));
                meta name="viewport" content="width=device-width, initial-scale=1";
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
    page(config, "Clayton Hickey", "Clayton Hickey's website and blog", "/", Some("/"), html! {
        h1 { "Clayton Hickey" }
    })
}

#[get("/blog")]
async fn blog(config: &State<Config>, db_conn: DbConn) -> Markup {
    let posts: Vec<(String, String)> = db_conn.run(|c| blog_posts::table
        .select((blog_posts::id, blog_posts::title))
        .order(blog_posts::published.desc())
        .load(c).unwrap()).await;
    page(config, "Blog Posts | Clayton Hickey", "A list of Clayton Hickey's blog posts", "/blog", Some("/blog"), html! {
        div id="blog-posts-list" {
            @for post in posts {
                div class="blog-posts-item" onclick=(format!("location.href=\"{}/blog/{}\"", config.domain, post.0)) {
                    (post.1)
                }
            }
        }
    })
}

#[get("/blog/<blog_post_id>")]
async fn blog_post_page(blog_post_id: String, config: &State<Config>, db_conn: DbConn) -> Result<Markup, Status> {
    let post: blog_post::BlogPost = db_conn.run(|c| blog_posts::table
        .find(blog_post_id)
        .first(c).unwrap()
    ).await;
    if post.published.is_some() {
        Ok(page(config, &post.title, &post.preview_text, format!("/blog/{}", post.id), Some("/blog"), html! {
            div id="blog-post" {
                div id="blog-post-heading" {
                    h1 {(post.title)}
                    div id="blog-post-contributors" {
                        @for contributor in post.contributors {
                            span class="blog-post-contributor" { (contributor.position) ": " (contributor.name) }
                        }
                    }
                    div id="blog-post-dates" {
                        span id="blog-post-published" { "Published: " (post.published.unwrap().to_string()) }
                        span id="blog-post-updated" {
                            "Updated: "
                            @match post.updated {
                                Some(updated) => (updated.to_string()),
                                None => "Never"
                            }
                        }
                    }
                    div id="blog-post-content" {(PreEscaped(post.content))} // Blog posts are never to be written by non-trusted users. XSS can occur
                }
            }
        }))
    } else {
        Err(Status::NotFound)
    }
}

#[launch]
fn rocket() -> _ {
    dotenv::dotenv().ok();
    rocket::build()
    .attach(DbConn::fairing())
    .mount("/", routes![
        home,
        blog,
        blog_post_page,
    ])
    .manage(Config {
        domain: dotenv::var("DOMAIN").unwrap()
    })
}