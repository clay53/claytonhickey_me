CREATE TYPE contributor AS (
    position TEXT,
    name TEXT
);

CREATE TABLE blog_posts (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    preview_text TEXT NOT NULL,
    content TEXT NOT NULL,
    contributors contributor[] NOT NULL,
    published TIMESTAMP DEFAULT NULL,
    updated TIMESTAMP DEFAULT NULL
);
CREATE UNIQUE INDEX blog_post_id_unique on blog_posts (LOWER(id));