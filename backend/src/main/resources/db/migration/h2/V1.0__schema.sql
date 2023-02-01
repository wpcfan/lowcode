CREATE TABLE mooc_categories
(
    id        BIGINT AUTO_INCREMENT NOT NULL,
    code      VARCHAR(255)          NOT NULL,
    name      VARCHAR(255)          NOT NULL,
    parent_id BIGINT,
    created_at datetime             NULL,
    updated_at datetime             NULL,
    CONSTRAINT pk_mooc_categories PRIMARY KEY (id)
);

ALTER TABLE mooc_categories
    ADD CONSTRAINT uc_mooc_categories_code UNIQUE (code);

ALTER TABLE mooc_categories
    ADD CONSTRAINT FK_MOOC_CATEGORIES_ON_PARENT FOREIGN KEY (parent_id) REFERENCES mooc_categories (id);

CREATE TABLE mooc_product_categories
(
    category_id BIGINT NOT NULL,
    product_id  BIGINT NOT NULL,
    CONSTRAINT pk_mooc_product_categories PRIMARY KEY (category_id, product_id)
);

CREATE TABLE mooc_products
(
    id          BIGINT AUTO_INCREMENT NOT NULL,
    name        VARCHAR(255)          NOT NULL,
    description VARCHAR(255)          NOT NULL,
    price       INT                   NOT NULL,
    created_at  datetime              NULL,
    updated_at  datetime              NULL,
    CONSTRAINT pk_mooc_products PRIMARY KEY (id)
);

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_category FOREIGN KEY (category_id) REFERENCES mooc_categories (id);

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_product FOREIGN KEY (product_id) REFERENCES mooc_products (id);

CREATE TABLE mooc_product_images
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
    image_url  VARCHAR(255)          NOT NULL,
    product_id BIGINT                NOT NULL,
    created_at datetime              NULL,
    updated_at datetime              NULL,
    CONSTRAINT pk_mooc_product_images PRIMARY KEY (id)
);

ALTER TABLE mooc_product_images
    ADD CONSTRAINT FK_MOOC_PRODUCT_IMAGES_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES mooc_products (id);