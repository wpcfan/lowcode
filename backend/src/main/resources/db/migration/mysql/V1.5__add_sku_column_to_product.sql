ALTER TABLE mooc_products ADD COLUMN `sku` VARCHAR(255) NULL;
UPDATE mooc_products SET `sku` = concat('sku_', id);
ALTER TABLE mooc_products ADD CONSTRAINT mooc_products_sku_uindex UNIQUE (sku);
ALTER TABLE mooc_products MODIFY sku VARCHAR(255) NOT NULL;
 