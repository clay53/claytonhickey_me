INSERT INTO blog_posts(id, title, preview_text, content, contributors, published, updated)
VALUES (
    'unpublished-test-post',
    'Unpublished Test Post',
    'This is a unpublished post used for testing',
    '<p>You CAN''T see this right? Ok, that means it''s good (right??).</p>',
    ARRAY[ROW('Author', 'System')::contributor], NULL, NULL
);

INSERT INTO blog_posts(id, title, preview_text, content, contributors, published, updated)
VALUES (
    'published-test-post',
    'Published Test Post',
    'This is a published post used for testing',
    '<p>You CAN see this right? Ok, that means it''s good (right??).</p>',
    ARRAY[ROW('Author', 'System')::contributor], current_timestamp, NULL
);