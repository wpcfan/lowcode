insert into mooc_categories (`code`, `name`)
values ('cat_b_m', 'Business & Management');
insert into mooc_categories (`code`, `name`)
values ('cat_c_s', 'Computer Science');
insert into mooc_categories (`code`, `name`)
values ('cat_d_s', 'Data Science');
insert into mooc_categories (`code`, `name`)
values ('cat_d', 'Design');
insert into mooc_categories (`code`, `name`)
values ('cat_h', 'Health');
insert into mooc_categories (`code`, `name`)
values ('cat_l', 'Language');
insert into mooc_categories (`code`, `name`)
values ('cat_m_l', 'Math & Logic');
insert into mooc_categories (`code`, `name`)
values ('cat_p_d', 'Personal Development');
insert into mooc_categories (`code`, `name`)
values ('cat_p_s_e', 'Physical Science & Engineering');
insert into mooc_categories (`code`, `name`)
values ('cat_s_s', 'Social Sciences');
insert into mooc_categories (`code`, `name`)
values ('cat_t_p', 'Test Prep');
insert into mooc_categories (`code`, `name`)
values ('cat_n', 'None');
insert into mooc_categories (`code`, `name`, `parent_id`)
values ('cat_java', 'Java', 2);
insert into mooc_categories (`code`, `name`, `parent_id`)
values ('cat_py', 'Python', 2);
insert into mooc_categories (`code`, `name`, `parent_id`)
values ('cat_dart', 'Dart', 2);
insert into mooc_categories (`code`, `name`, `parent_id`)
values ('cat_java_spring', 'Spring', 13);
insert into mooc_products (`name`, `description`, `price`)
values ('Business & Management 1', 'Learn how to use data to make better decisions', 10);
insert into mooc_products (`name`, `description`, `price`)
values ('Computer Science 2', 'Learn how to use data to make better decisions', 20);
insert into mooc_products (`name`, `description`, `price`)
values ('Computer Science 3', 'Learn how to use data to make better decisions', 30);
insert into mooc_products (`name`, `description`, `price`)
values ('Data Science 4', 'Learn how to use data to make better decisions', 40);
insert into mooc_products (`name`, `description`, `price`)
values ('Data Science 5', 'Learn how to use data to make better decisions', 50);
insert into mooc_products (`name`, `description`, `price`)
values ('Data Science 6', 'Learn how to use data to make better decisions', 60);
insert into mooc_products (`name`, `description`, `price`)
values ('Design 7', 'Learn how to use data to make better decisions', 70);
insert into mooc_products (`name`, `description`, `price`)
values ('Health 8', 'Learn how to use data to make better decisions', 80);
insert into mooc_products (`name`, `description`, `price`)
values ('Health 9', 'Learn how to use data to make better decisions', 90);
insert into mooc_products (`name`, `description`, `price`)
values ('Language 10', 'Learn how to use data to make better decisions', 100);
insert into mooc_products (`name`, `description`, `price`)
values ('Language 11', 'Learn how to use data to make better decisions', 110);
insert into mooc_products (`name`, `description`, `price`)
values ('Language 12', 'Learn how to use data to make better decisions', 120);
insert into mooc_products (`name`, `description`, `price`)
values ('Math & Logic 13', 'Learn how to use data to make better decisions', 130);
insert into mooc_products (`name`, `description`, `price`)
values ('Math & Logic 14', 'Learn how to use data to make better decisions', 140);
insert into mooc_products (`name`, `description`, `price`)
values ('Personal Development 15', 'Learn how to use data to make better decisions', 150);
insert into mooc_products (`name`, `description`, `price`)
values ('Physical Science & Engineering 16', 'Learn how to use data to make better decisions', 160);
insert into mooc_products (`name`, `description`, `price`)
values ('Social Sciences 17', 'Learn how to use data to make better decisions', 170);
insert into mooc_products (`name`, `description`, `price`)
values ('Test Prep 18', 'Learn how to use data to make better decisions', 180);
insert into mooc_products (`name`, `description`, `price`)
values ('Test Prep 19', 'Learn how to use data to make better decisions', 190);
insert into mooc_products (`name`, `description`, `price`)
values ('Test Prep 20', 'Learn how to use data to make better decisions', 200);
insert into mooc_products (`name`, `description`, `price`)
values ('None 21', 'Learn how to use data to make better decisions', 210);
insert into mooc_products (`name`, `description`, `price`)
values ('None 22', 'Learn how to use data to make better decisions', 220);
insert into mooc_products (`name`, `description`, `price`)
values ('None 23', 'Learn how to use data to make better decisions', 230);
insert into mooc_products (`name`, `description`, `price`)
values ('None 24', 'Learn how to use data to make better decisions', 240);
insert into mooc_product_categories (`product_id`, `category_id`)
values (1, 1);
insert into mooc_product_categories (`product_id`, `category_id`)
values (2, 2);
insert into mooc_product_categories (`product_id`, `category_id`)
values (3, 2);
insert into mooc_product_categories (`product_id`, `category_id`)
values (4, 3);
insert into mooc_product_categories (`product_id`, `category_id`)
values (5, 3);
insert into mooc_product_categories (`product_id`, `category_id`)
values (6, 3);
insert into mooc_product_categories (`product_id`, `category_id`)
values (7, 4);
insert into mooc_product_categories (`product_id`, `category_id`)
values (8, 5);
insert into mooc_product_categories (`product_id`, `category_id`)
values (9, 5);
insert into mooc_product_categories (`product_id`, `category_id`)
values (10, 6);
insert into mooc_product_categories (`product_id`, `category_id`)
values (11, 6);
insert into mooc_product_categories (`product_id`, `category_id`)
values (12, 6);
insert into mooc_product_categories (`product_id`, `category_id`)
values (13, 7);
insert into mooc_product_categories (`product_id`, `category_id`)
values (14, 7);
insert into mooc_product_categories (`product_id`, `category_id`)
values (15, 8);
insert into mooc_product_categories (`product_id`, `category_id`)
values (16, 9);
insert into mooc_product_categories (`product_id`, `category_id`)
values (17, 10);
insert into mooc_product_categories (`product_id`, `category_id`)
values (18, 11);
insert into mooc_product_categories (`product_id`, `category_id`)
values (19, 11);
insert into mooc_product_categories (`product_id`, `category_id`)
values (20, 11);
insert into mooc_product_categories (`product_id`, `category_id`)
values (21, 12);
insert into mooc_product_categories (`product_id`, `category_id`)
values (22, 12);
insert into mooc_product_categories (`product_id`, `category_id`)
values (23, 12);
insert into mooc_product_categories (`product_id`, `category_id`)
values (24, 12);
insert into mooc_product_images (`product_id`, `image_url`)
values (1, 'https://images.pexels.com/photos/12951893/pexels-photo-12951893.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (2, 'https://images.pexels.com/photos/9928345/pexels-photo-9928345.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (3, 'https://images.pexels.com/photos/8622885/pexels-photo-8622885.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (4, 'https://images.pexels.com/photos/11700840/pexels-photo-11700840.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (5, 'https://images.pexels.com/photos/8042737/pexels-photo-8042737.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (6, 'https://images.pexels.com/photos/4659444/pexels-photo-4659444.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (7, 'https://images.pexels.com/photos/7426478/pexels-photo-7426478.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (8, 'https://images.pexels.com/photos/7541732/pexels-photo-7541732.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (9, 'https://images.pexels.com/photos/9143960/pexels-photo-9143960.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (10, 'https://images.pexels.com/photos/9143958/pexels-photo-9143958.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (11, 'https://images.pexels.com/photos/9143964/pexels-photo-9143964.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (12, 'https://images.pexels.com/photos/9143965/pexels-photo-9143965.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (13, 'https://images.pexels.com/photos/9144030/pexels-photo-9144030.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (14, 'https://images.pexels.com/photos/11681061/pexels-photo-11681061.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (15, 'https://images.pexels.com/photos/4045619/pexels-photo-4045619.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load');
insert into mooc_product_images (`product_id`, `image_url`)
values (16, 'https://images.pexels.com/photos/10661108/pexels-photo-10661108.jpeg?auto=compress&cs=tinysrgb&w=1600');
insert into mooc_product_images (`product_id`, `image_url`)
values (17, 'https://images.pexels.com/photos/13911326/pexels-photo-13911326.jpeg?auto=compress&cs=tinysrgb&w=1600');
insert into mooc_product_images (`product_id`, `image_url`)
values (18, 'https://images.pexels.com/photos/9588261/pexels-photo-9588261.jpeg?auto=compress&cs=tinysrgb&w=1600');
insert into mooc_product_images (`product_id`, `image_url`)
values (19, 'https://images.pexels.com/photos/10566125/pexels-photo-10566125.jpeg?auto=compress&cs=tinysrgb&w=1600');
insert into mooc_product_images (`product_id`, `image_url`)
values (20, 'https://images.pexels.com/photos/4045031/pexels-photo-4045031.jpeg?auto=compress&cs=tinysrgb&w=1600');
insert into mooc_product_images (`product_id`, `image_url`)
values (21, 'https://images.pexels.com/photos/5390114/pexels-photo-5390114.jpeg');
insert into mooc_product_images (`product_id`, `image_url`)
values (22, 'https://images.pexels.com/photos/6625403/pexels-photo-6625403.jpeg');
insert into mooc_product_images (`product_id`, `image_url`)
values (23, 'https://images.pexels.com/photos/12528815/pexels-photo-12528815.jpeg');
insert into mooc_product_images (`product_id`, `image_url`)
values (24, 'https://images.pexels.com/photos/7034219/pexels-photo-7034219.jpeg');