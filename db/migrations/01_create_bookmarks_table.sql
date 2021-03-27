CREATE TABLE bookmarks(id SERIAL PRIMARY KEY, url VARCHAR(60), title VARCHAR(60));
CREATE TABLE comments(comment_ID SERIAL PRIMARY KEY, comment VARCHAR(240), bookmark_ID integer REFERENCES bookmarks);
