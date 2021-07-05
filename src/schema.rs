// @generated automatically by Diesel CLI.

pub mod sql_types {
    #[derive(diesel::sql_types::SqlType)]
    #[postgres(type_name = "contributor")]
    pub struct Contributor;
}

diesel::table! {
    use diesel::sql_types::*;
    use super::sql_types::Contributor;

    blog_posts (id) {
        id -> Text,
        title -> Text,
        preview_text -> Text,
        content -> Text,
        contributors -> Array<Contributor>,
        published -> Nullable<Timestamp>,
        updated -> Nullable<Timestamp>,
    }
}
