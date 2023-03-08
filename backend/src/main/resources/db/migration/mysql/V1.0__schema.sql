CREATE TABLE mooc_categories
(
    id        BIGINT AUTO_INCREMENT NOT NULL    COMMENT '主键',
    code      VARCHAR(255)          NOT NULL    COMMENT '分类编码',
    name      VARCHAR(255)          NOT NULL    COMMENT '分类名称',
    parent_id BIGINT                            COMMENT '父级分类',
    created_at datetime             NULL        COMMENT '创建时间',
    updated_at datetime             NULL        COMMENT '更新时间',
    CONSTRAINT pk_mooc_categories PRIMARY KEY (id)
) COMMENT '分类表';

ALTER TABLE mooc_categories
    ADD CONSTRAINT uc_mooc_categories_code UNIQUE (code);

ALTER TABLE mooc_categories
    ADD CONSTRAINT FK_MOOC_CATEGORIES_ON_PARENT FOREIGN KEY (parent_id) REFERENCES mooc_categories (id);

CREATE TABLE mooc_product_categories
(
    category_id BIGINT NOT NULL     COMMENT '分类ID',
    product_id  BIGINT NOT NULL     COMMENT '产品ID',
    CONSTRAINT pk_mooc_product_categories PRIMARY KEY (category_id, product_id)
) COMMENT '产品分类关联表';

CREATE TABLE mooc_products
(
    id            BIGINT AUTO_INCREMENT NOT NULL    COMMENT '主键',
    name          VARCHAR(100)          NOT NULL    COMMENT '产品名称',
    `description` VARCHAR(255)          NOT NULL    COMMENT '产品描述',
    price         DECIMAL(10,2)         NOT NULL    COMMENT '产品价格',
    created_at    datetime              NULL        COMMENT '创建时间',
    updated_at    datetime              NULL        COMMENT '更新时间',
    CONSTRAINT pk_mooc_products PRIMARY KEY (id)
) COMMENT '产品表';

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_category FOREIGN KEY (category_id) REFERENCES mooc_categories (id);

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_product FOREIGN KEY (product_id) REFERENCES mooc_products (id);

CREATE TABLE mooc_product_images
(
    id         BIGINT AUTO_INCREMENT NOT NULL   COMMENT '主键',
    image_url  VARCHAR(255)          NOT NULL   COMMENT '图片地址',
    product_id BIGINT                NULL       COMMENT '产品ID',
    created_at datetime              NULL       COMMENT '创建时间',
    updated_at datetime              NULL       COMMENT '更新时间',
    CONSTRAINT pk_mooc_product_images PRIMARY KEY (id)
) COMMENT '产品图片表';

ALTER TABLE mooc_product_images
    ADD CONSTRAINT FK_MOOC_PRODUCT_IMAGES_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES mooc_products (id);

CREATE TABLE mooc_pages
(
    id         BIGINT AUTO_INCREMENT NOT NULL   COMMENT '主键',
    created_at datetime              NULL       COMMENT '创建时间',
    updated_at datetime              NULL       COMMENT '更新时间',
    platform   VARCHAR(255)          NOT NULL   COMMENT '平台',
    page_type  VARCHAR(255)          NOT NULL   COMMENT '页面类型',
    config     JSON                  NOT NULL   COMMENT '页面配置',
    CONSTRAINT pk_mooc_pages PRIMARY KEY (id)
) COMMENT '页面表';

CREATE TABLE mooc_page_blocks
(
    id      BIGINT AUTO_INCREMENT NOT NULL      COMMENT '主键',
    title   VARCHAR(255)          NOT NULL      COMMENT '标题',
    type    VARCHAR(255)          NOT NULL      COMMENT '类型',
    sort    INT                   NOT NULL      COMMENT '排序',
    config  JSON                  NOT NULL      COMMENT '配置',
    page_id BIGINT                NULL          COMMENT '页面ID',
    CONSTRAINT pk_mooc_page_blocks PRIMARY KEY (id)
) COMMENT '页面块表';

ALTER TABLE mooc_page_blocks
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCKS_ON_PAGE FOREIGN KEY (page_id) REFERENCES mooc_pages (id);

CREATE TABLE mooc_page_block_data
(
    id            BIGINT AUTO_INCREMENT NOT NULL    COMMENT '主键',
    sort          INT                   NOT NULL    COMMENT '排序',
    content       JSON                  NOT NULL    COMMENT '内容',
    page_block_id BIGINT                NULL        COMMENT '页面块ID',
    CONSTRAINT pk_mooc_page_block_data PRIMARY KEY (id)
) COMMENT '页面块数据表';

ALTER TABLE mooc_page_block_data
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCK_DATA_ON_PAGE_BLOCK FOREIGN KEY (page_block_id) REFERENCES mooc_page_blocks (id);