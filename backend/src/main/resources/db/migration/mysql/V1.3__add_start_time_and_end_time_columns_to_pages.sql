ALTER TABLE mooc_pages
    ADD COLUMN start_time datetime NULL COMMENT '生效时间';

ALTER TABLE mooc_pages
    ADD COLUMN end_time datetime NULL   COMMENT '失效时间';