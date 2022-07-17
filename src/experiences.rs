use crate::skills::Skills;
use maud::{Markup, html};
use chrono::NaiveDate;

pub struct Experience {
    pub title: Title,
    pub started: Option<NaiveDate>,
    pub completed: Option<NaiveDate>,
    pub last_updated: Option<NaiveDate>,
    pub skills: &'static [Skills],
    pub description: &'static [DescriptionPart],
    pub links: &'static [Link],
    pub thumb: Option<Thumb>,
}

impl Experience {
    pub fn to_markup(&self) -> Markup {
        html! {
            div class="experience" {
                h3 {
                    div class="experience-title-links" {
                        @match self.title {
                            Title::Raw(title) => span class="experience-title" { (title) },
                            Title::Linked(title, link) => a class="experience-title" href=(link) { (title) }
                        }
                        @for link in self.links {
                            a href=(link.destination) { (link.as_str()) }
                        }
                    }
                }

                @if let Some(thumb) = &self.thumb {
                    @match self.title {
                        Title::Raw(_) => img class="experience-img" src=(thumb.source) alt=(thumb.alt);,
                        Title::Linked(_, link) => a href=(link) { img class="experience-img" src=(thumb.source) alt=(thumb.alt); },
                    }
                }

                @let mut dates_empty = true;
                @let dates = html! {
                    @if let Some(started) = self.started {
                        ({dates_empty = false; started.format("Started: %b. %d, %Y")})
                    }

                    @if let Some(completed) = self.completed {
                        @if !dates_empty {
                            "; "
                        } @else {
                            ({{dates_empty = false; ""}})
                        }
                        (completed.format("Completed: %b. %d, %Y"))
                    }

                    @if let Some(last_updated) = self.last_updated {
                        @if !dates_empty {
                            "; "
                        } @else {
                            ({{dates_empty = false; ""}})
                        }
                        (last_updated.format("Last updated: %b. %d, %Y"))
                    }
                };
                @if !dates_empty {
                    p { (dates) }
                }

                @if self.skills.len() > 0 {
                    p {
                        "skills: "
                        @for i in 0..self.skills.len()-1 {
                            (self.skills[i].as_str()) ", "
                        }
                        (self.skills[self.skills.len()-1].as_str())
                    }
                }
                div class="description-container" {
                    (description_parts_to_markup(self.description))
                }
            }
        }
    }
}

pub enum Title {
    Raw(&'static str),
    Linked(&'static str, &'static str),
}

pub enum DescriptionPart {
    Paragraph(&'static [DescriptionPart]),
    Text(&'static str),
}

pub fn description_parts_to_markup(parts: &[DescriptionPart]) -> Markup {
    html! {
        @for part in parts {
            @match part {
                DescriptionPart::Paragraph(parts) => p { (description_parts_to_markup(parts)) },
                DescriptionPart::Text(text) => (text)
            }
        }
    }
}

pub struct Link {
    pub ty: LinkType,
    pub destination: &'static str,
}

impl Link {
    pub const fn as_str(&self) -> &'static str {
        match self.ty {
            LinkType::Code => "Code",
            LinkType::Live => "Live",
            LinkType::Download => "Download",
            LinkType::Showcase => "Showcase",
            LinkType::ChromeWebStore => "Chrome Web Store",
            LinkType::FirefoxAddOns => "Firefox Add-ons",
            LinkType::RebbleStore => "Rebble Store",
            LinkType::PR => "PR",
        }
    }
}

pub enum LinkType {
    Code,
    Live,
    Download,
    Showcase,
    ChromeWebStore,
    FirefoxAddOns,
    RebbleStore,
    PR,
}

pub struct Thumb {
    pub source: &'static str,
    pub alt: &'static str,
}