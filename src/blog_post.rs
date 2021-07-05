use diesel::prelude::*;
use chrono::naive::NaiveDateTime;
use diesel::pg::{Pg, PgValue};
use diesel::deserialize::{self, FromSql};
use diesel::sql_types::{Record, Text};

pub use crate::schema::blog_posts;

#[derive(Debug, AsExpression, FromSqlRow)]
#[sql_type = "crate::schema::sql_types::Contributor"]
pub struct Contributor {
    pub position: String,
    pub name: String
}

impl FromSql<crate::schema::sql_types::Contributor, Pg> for Contributor {
    fn from_sql(bytes: PgValue) -> deserialize::Result<Self> {
        let (position, name) = FromSql::<Record<(Text, Text)>, Pg>::from_sql(bytes)?;
        Ok(Contributor {
            position,
            name
        })
    }
}

#[derive(Queryable, Debug)]
pub struct BlogPost {
    pub id: String,
    pub title: String,
    pub preview_text: String,
    pub content: String,
    pub contributors: Vec<Contributor>,
    pub published: Option<NaiveDateTime>,
    pub updated: Option<NaiveDateTime>
}