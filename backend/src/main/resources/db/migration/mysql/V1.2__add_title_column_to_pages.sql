ALTER TABLE mooc_pages
    ADD COLUMN title VARCHAR(255) NOT NULL;

ALTER TABLE mooc_pages
    ADD CONSTRAINT uc_mooc_pages_title UNIQUE (title);