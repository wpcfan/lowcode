alter table mooc_products
 add column sku varchar(255) null;
update mooc_products set sku = 'sku_' || id;
alter table mooc_products
 add constraint mooc_products_sku_uindex
 unique (sku);
alter table mooc_products
 