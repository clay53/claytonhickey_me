ALTER TABLE blog_posts
ADD thumbnail TEXT NOT NULL DEFAULT 'http://localhost:8000/files/missing_thumbnail.png';

UPDATE blog_posts
SET thumbnail = 'http://localhost:8000/files/blog_post_res/published-test-post/thumbnail.png'
WHERE id = 'published-test-post';

UPDATE blog_posts
SET thumbnail = 'http://localhost:8000/files/blog_post_res/unpublished-test-post/thumbnail.png'
WHERE ID = 'unpublished-test-post';