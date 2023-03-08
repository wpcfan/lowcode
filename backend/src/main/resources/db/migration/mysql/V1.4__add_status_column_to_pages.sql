ALTER TABLE mooc_pages
    ADD COLUMN `status` VARCHAR(255) NOT NULL COMMENT '页面状态' AFTER `content`;