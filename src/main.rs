#![feature(decl_macro)]
#[macro_use] extern crate rocket;
#[macro_use] extern crate diesel;

use chrono::NaiveDateTime;
use diesel::prelude::*;
use dotenv;
use maud::{DOCTYPE, html, Markup, PreEscaped};
use rocket::{
    http::Status,
    State,
    fs::NamedFile,
};
use std::path::{
    PathBuf,
    Path,
};

pub struct Config {
    pub domain: String,
    pub g_analytics_measurement_id: String,
}

mod schema;
mod blog_post;

use self::schema::*;

use rocket_sync_db_pools::{diesel as rocket_diesel, database};

#[database("postgres")]
pub struct DbConn(rocket_diesel::PgConnection);

#[get("/favicon.ico")]
async fn favicon() -> std::io::Result<NamedFile> {
    NamedFile::open("favicon.ico").await
}

#[get("/styles.css")]
async fn styles() -> std::io::Result<NamedFile> {
    NamedFile::open("styles.css").await
}

#[get("/files/<path..>")]
async fn files(path: PathBuf) -> Result<NamedFile, Status> {
    let path = Path::new("files/").join(path);
    NamedFile::open(&path).await.map_err(|_| Status::NotFound)
}

#[get("/sitemap.xml")]
async fn sitemap(config: &State<Config>, db_conn: DbConn) -> String {
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

    (html! {
        (PreEscaped(r#"<?xml version="1.0" encoding="UTF-8"?>"#))
        urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" {
            (url("/".to_string(), None, "daily", "1"))
            (url("/blog".to_string(), None, "daily", "0.9"))
            @let blog_posts: Vec<(String, Option<NaiveDateTime>, Option<NaiveDateTime>)> = db_conn.run(|c| blog_posts::table
                .filter(blog_posts::published.is_not_null())
                .select((blog_posts::id, blog_posts::published, blog_posts::updated))
            .load(c).unwrap()).await;
            @for blog_post in blog_posts {
                (url(
                    format!("/blog/{}", blog_post.0),
                    Some(match blog_post.2 {
                        Some(updated) => updated,
                        None => blog_post.1.unwrap() // published (known Some because of filter)
                    }),
                    "monthly",
                    "0.8"
                ))
            }
        }
    }).into_string()
}

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
                link rel="canonical" href=(format!("{}{}", config.domain, cannonical_path.as_ref()));
                meta name="viewport" content="width=device-width, initial-scale=1";
                link rel="stylesheet" type="text/css" href="/styles.css";
                link rel="icon" type="image/ico" href="/favicon.ico";
                script sync src=(format!("{}{}", "https://www.googletagmanager.com/gtag/js?id=", config.g_analytics_measurement_id)) {}
                script {r"window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);}gtag('js',new Date());gtag('config', '" (config.g_analytics_measurement_id) r"');"}
            }
            body {
                nav id="nav" {
                    (nav_element("Home", "/"))
                    (nav_element("Blog", "/blog"))
                }
                main id="content" {
                    (content)
                }
                footer id="footer" {
                    hr;
                    span { "Check out the code on " a href="https://github.com/clay53/claytonhickey_me" { "GitHub.com" } }
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
    let posts: Vec<(String, String, String, Vec<blog_post::Contributor>, Option<NaiveDateTime>, String)> = db_conn.run(|c| blog_posts::table
        .filter(blog_posts::published.is_not_null())
        .select((blog_posts::id, blog_posts::title, blog_posts::preview_text, blog_posts::contributors, blog_posts::published, blog_posts::thumbnail))
        .order(blog_posts::published.desc())
        .load(c).unwrap()).await;
    page(config, "Blog Posts | Clayton Hickey", "A list of Clayton Hickey's blog posts", "/blog", Some("/blog"), html! {
        div id="blog-posts-list" {
            @for (i, post) in posts.into_iter().enumerate() {
                @if i != 0 { br; }
                div class="blog-posts-container" onclick=(format!("location.href=\"{}/blog/{}\"", config.domain, post.0)) {
                    div class="blog-posts-thumbnail-container" {
                        img src=(post.5);
                    }
                    div class="blog-posts-info-container" {
                        h2 class="blog-posts-title" {(post.1)}
                        div class="blog-posts-contributors" {
                            @for contributor in post.3 {
                                span class="blog-posts-contributor" { (contributor.position) ": " (contributor.name) }
                            }
                        }
                        p class="blog-posts-preview" { (post.2) }
                        @match post.4 {
                            Some(published) => span class="blog-posts-published" {"Published: " (published.to_string())},
                            None => {}
                        }
                    }
                }
            }
        }
    })
}

#[get("/blog/<blog_post_id>")]
async fn blog_post_page(blog_post_id: String, config: &State<Config>, db_conn: DbConn) -> Result<Markup, Status> {
    let post: blog_post::BlogPost = match db_conn.run(|c| blog_posts::table
        .find(blog_post_id)
        .first(c)
    ).await {
        Ok(post) => post,
        Err(_) => return Err(Status::NotFound)
    };
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
                }
                div id="blog-post-content" {(PreEscaped(post.content))} // Blog posts are never to be written by non-trusted users. XSS can occur
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
        favicon,
        styles,
        files,
        sitemap,
        home,
        blog,
        blog_post_page,
    ])
    .manage(Config {
        domain: dotenv::var("DOMAIN").unwrap(),
        g_analytics_measurement_id: dotenv::var("G_ANALYTICS_MEASUREMENT_ID").unwrap(),
    })
}