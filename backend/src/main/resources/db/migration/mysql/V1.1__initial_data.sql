insert into mooc_categories (`id`, `code`, `name`, `productId`)
values (1, 'cat_b_m', 'Business & Management', null),
       (2, 'cat_c_s', 'Computer Science', null),
       (3, 'cat_d_s', 'Data Science', null),
       (4, 'cat_d', 'Design', null),
       (5, 'cat_h', 'Health', null),
       (6, 'cat_l', 'Language', null),
       (7, 'cat_m_l', 'Math & Logic', null),
       (8, 'cat_p_d', 'Personal Development', null),
       (9, 'cat_p_s_e', 'Physical Science & Engineering', null),
       (10, 'cat_s_s', 'Social Sciences', null),
       (11, 'cat_t_p', 'Test Prep', null),
       (12, 'cat_n', 'None', null),
       (13, 'cat_java', 'Java', 2),
       (14, 'cat_py', 'Python', 2),
       (15, 'cat_dart', 'Dart', 2),
       (16, 'cat_java_spring', 'Spring', 13);
insert into mooc_products (`id`, `name`, `description`, `price`)
values (1, 'Business & Management 1', 'Learn how to use data to make better decisions', 10),
       (2, 'Computer Science 2', 'Learn how to use data to make better decisions', 20),
       (3, 'Computer Science 3', 'Learn how to use data to make better decisions', 30),
       (4, 'Data Science 4', 'Learn how to use data to make better decisions', 40),
       (5, 'Data Science 5', 'Learn how to use data to make better decisions', 50),
       (6, 'Data Science 6', 'Learn how to use data to make better decisions', 60),
       (7, 'Design 7', 'Learn how to use data to make better decisions', 70),
       (8, 'Health 8', 'Learn how to use data to make better decisions', 80),
       (9, 'Health 9', 'Learn how to use data to make better decisions', 90),
       (10, 'Language 10', 'Learn how to use data to make better decisions', 100),
       (11, 'Language 11', 'Learn how to use data to make better decisions', 110),
       (12, 'Language 12', 'Learn how to use data to make better decisions', 120),
       (13, 'Math & Logic 13', 'Learn how to use data to make better decisions', 130),
       (14, 'Math & Logic 14', 'Learn how to use data to make better decisions', 140),
       (15, 'Personal Development 15', 'Learn how to use data to make better decisions', 150),
       (16, 'Physical Science & Engineering 16', 'Learn how to use data to make better decisions', 160),
       (17, 'Social Sciences 17', 'Learn how to use data to make better decisions', 170),
       (18, 'Test Prep 18', 'Learn how to use data to make better decisions', 180),
       (19, 'Test Prep 19', 'Learn how to use data to make better decisions', 190),
       (20, 'Test Prep 20', 'Learn how to use data to make better decisions', 200),
       (21, 'None 21', 'Learn how to use data to make better decisions', 210),
       (22, 'None 22', 'Learn how to use data to make better decisions', 220),
       (23, 'None 23', 'Learn how to use data to make better decisions', 230),
       (24, 'None 24', 'Learn how to use data to make better decisions', 240);
insert into mooc_product_categories (`product_id`, `category_id`)
values (1, 1),
       (2, 2),
       (3, 2),
       (4, 3),
       (5, 3),
       (6, 3),
       (7, 4),
       (8, 5),
       (9, 5),
       (10, 6),
       (11, 6),
       (12, 6),
       (13, 7),
       (14, 7),
       (15, 8),
       (16, 9),
       (17, 10),
       (18, 11),
       (19, 11),
       (20, 11),
       (21, 12),
       (22, 12),
       (23, 12),
       (24, 12);
insert into mooc_product_images (`product_id`, `image`)
values (1, 'https://www.edx.org/sites/default/files/course/image/promoted/business-analytics-1.jpg'),
       (2, 'https://www.edx.org/sites/default/files/course/image/promoted/ai-for-everyone-1.jpg'),
       (3, 'https://www.edx.org/sites/default/files/course/image/promoted/ai-for-everyone-1.jpg'),
       (4, 'https://www.edx.org/sites/default/files/course/image/promoted/data-science-1.jpg'),
       (5, 'https://www.edx.org/sites/default/files/course/image/promoted/data-science-1.jpg'),
       (6, 'https://www.edx.org/sites/default/files/course/image/promoted/data-science-1.jpg'),
       (7, 'https://www.edx.org/sites/default/files/course/image/promoted/design-thinking-1.jpg'),
       (8, 'https://www.edx.org/sites/default/files/course/image/promoted/healthcare-analytics-1.jpg'),
       (9, 'https://www.edx.org/sites/default/files/course/image/promoted/healthcare-analytics-1.jpg'),
       (10, 'https://www.edx.org/sites/default/files/course/image/promoted/learn-spanish-1.jpg'),
       (11, 'https://www.edx.org/sites/default/files/course/image/promoted/learn-spanish-1.jpg'),
       (12, 'https://www.edx.org/sites/default/files/course/image/promoted/learn-spanish-1.jpg'),
       (13, 'https://www.edx.org/sites/default/files/course/image/promoted/mathematical-thinking-1.jpg'),
       (14, 'https://www.edx.org/sites/default/files/course/image/promoted/mathematical-thinking-1.jpg'),
       (15, 'https://www.edx.org/sites/default/files/course/image/promoted/leadership-1.jpg'),
       (16, 'https://www.edx.org/sites/default/files/course/image/promoted/robotics-1.jpg'),
       (17, 'https://www.edx.org/sites/default/files/course/image/promoted/psychology-1.jpg'),
       (18, 'https://www.edx.org/sites/default/files/course/image/promoted/ielts-1.jpg'),
       (19, 'https://www.edx.org/sites/default/files/course/image/promoted/ielts-1.jpg'),
       (20, 'https://www.edx.org/sites/default/files/course/image/promoted/ielts-1.jpg'),
       (21, 'https://www.edx.org/sites/default/files/course/image/promoted/none-1.jpg'),
       (22, 'https://www.edx.org/sites/default/files/course/image/promoted/none-1.jpg'),
       (23, 'https://www.edx.org/sites/default/files/course/image/promoted/none-1.jpg'),
       (24, 'https://www.edx.org/sites/default/files/course/image/promoted/none-1.jpg');