alter table mooc_products add column original_price DECIMAL(10,2) null;
update mooc_products set original_price = price + 10.0 where price < 230.0;