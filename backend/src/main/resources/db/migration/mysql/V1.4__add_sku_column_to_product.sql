ALTER TABLE mooc_products
    ADD COLUMN `sku` VARCHAR(255) NULL COMMENT '产品唯一编码'
        AFTER `updated_at`;
ALTER TABLE mooc_products ADD CONSTRAINT mooc_products_sku_uindex UNIQUE (sku);
ALTER TABLE mooc_products MODIFY sku VARCHAR(255) NOT NULL;
# UPDATE mooc_page_block_data SET content = JSON_SET(content, '$.sku', (SELECT sku FROM mooc_products WHERE id = JSON_EXTRACT(content, '$.productId')));