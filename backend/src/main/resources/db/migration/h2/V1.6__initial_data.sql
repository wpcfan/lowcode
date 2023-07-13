SET REFERENTIAL_INTEGRITY FALSE; // 禁用外键约束
INSERT INTO "PUBLIC"."MOOC_CATEGORIES" VALUES
(1, 'cat_b_m', 'Business & Management', NULL, NULL, NULL),
(2, 'cat_c_s', 'Computer Science', NULL, NULL, NULL),
(3, 'cat_d_s', 'Data Science', NULL, NULL, NULL),
(4, 'cat_d', 'Design', NULL, NULL, NULL),
(5, 'cat_h', 'Health', NULL, NULL, NULL),
(6, 'cat_l', 'Language', NULL, NULL, NULL),
(7, 'cat_m_l', 'Math & Logic', NULL, NULL, NULL),
(8, 'cat_p_d', 'Personal Development', NULL, NULL, NULL),
(9, 'cat_p_s_e', 'Physical Science & Engineering', NULL, NULL, NULL),
(10, 'cat_s_s', 'Social Sciences', NULL, NULL, NULL),
(11, 'cat_t_p', 'Test Prep', NULL, NULL, NULL),
(12, 'cat_n', 'None', NULL, NULL, NULL),
(13, 'cat_java', 'Java', 2, NULL, NULL),
(14, 'cat_py', 'Python', 2, NULL, NULL),
(15, 'cat_dart', 'Dart', 2, NULL, NULL),
(16, 'cat_java_spring', 'Spring', 13, NULL, NULL);
ALTER TABLE "PUBLIC"."MOOC_CATEGORIES" ALTER COLUMN ID RESTART WITH 17;
INSERT INTO "PUBLIC"."MOOC_PRODUCT_CATEGORIES" VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 4),
(3, 5),
(3, 6),
(4, 7),
(5, 8),
(5, 9),
(6, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 15),
(9, 16),
(10, 17),
(11, 18),
(11, 19),
(11, 20),
(12, 21),
(12, 22),
(12, 23),
(12, 24);
INSERT INTO "PUBLIC"."MOOC_PRODUCTS" VALUES
(1, U&'\771f\7ef4\65af\767d\8272\77ed\8896t\6064\5973\590f\5b63\7eaf\68c9\5bbd\677e\4f53\60642023\65b0\6b3e\767e\642d\663e\7626\534a\8896\4e0a\8863', 'Learn how to use data to make better decisions', 10.00, NULL, NULL, 'sku_1', 20.00),
(2, U&'Pioneer camp\51b0\6c27\5427\77ed\8896t\6064\5973\590f\5b63\8584\6b3e\5bbd\677e\900f\6c14\534a\8896\4e0a\8863\901f\5e72\4f53\6064', 'Learn how to use data to make better decisions', 20.00, NULL, NULL, 'sku_2', 30.00),
(3, U&'\6d77\8c272023\590f\65b0\6b3e\7eaf\8272\6781\7b80\7cfb\5e26T\6064\88d9\7b80\7ea6\6c14\8d28\538b\8936\8212\9002\8fde\8863\88d9\5973', 'Learn how to use data to make better decisions', 30.00, NULL, NULL, 'sku_3', 40.00),
(4, 'Data Science 4', 'Learn how to use data to make better decisions', 40.00, NULL, NULL, 'sku_4', 50.00),
(5, 'Data Science 5', 'Learn how to use data to make better decisions', 50.00, NULL, NULL, 'sku_5', 60.00),
(6, 'Data Science 6', 'Learn how to use data to make better decisions', 60.00, NULL, NULL, 'sku_6', 70.00),
(7, 'Design 7', 'Learn how to use data to make better decisions', 70.00, NULL, NULL, 'sku_7', 80.00),
(8, 'Health 8', 'Learn how to use data to make better decisions', 80.00, NULL, NULL, 'sku_8', 90.00),
(9, 'Health 9', 'Learn how to use data to make better decisions', 90.00, NULL, NULL, 'sku_9', 100.00),
(10, 'Language 10', 'Learn how to use data to make better decisions', 100.00, NULL, NULL, 'sku_10', 110.00),
(11, 'Language 11', 'Learn how to use data to make better decisions', 110.00, NULL, NULL, 'sku_11', 120.00),
(12, 'Language 12', 'Learn how to use data to make better decisions', 120.00, NULL, NULL, 'sku_12', 130.00),
(13, 'Math & Logic 13', 'Learn how to use data to make better decisions', 130.00, NULL, NULL, 'sku_13', 140.00),
(14, 'Math & Logic 14', 'Learn how to use data to make better decisions', 140.00, NULL, NULL, 'sku_14', 150.00),
(15, 'Personal Development 15', 'Learn how to use data to make better decisions', 150.00, NULL, NULL, 'sku_15', 160.00),
(16, 'Physical Science & Engineering 16', 'Learn how to use data to make better decisions', 160.00, NULL, NULL, 'sku_16', 170.00),
(17, 'Social Sciences 17', 'Learn how to use data to make better decisions', 170.00, NULL, NULL, 'sku_17', 180.00),
(18, 'Test Prep 18', 'Learn how to use data to make better decisions', 180.00, NULL, NULL, 'sku_18', 190.00),
(19, 'Test Prep 19', 'Learn how to use data to make better decisions', 190.00, NULL, NULL, 'sku_19', 200.00),
(20, 'Test Prep 20', 'Learn how to use data to make better decisions', 200.00, NULL, NULL, 'sku_20', 210.00),
(21, 'Hilton Atlanta', 'Learn how to use data to make better decisions', 210.00, NULL, NULL, 'sku_21', 220.00),
(22, 'SpringHill Suites by Marriott Atlanta Buckhead', 'Learn how to use data to make better decisions', 220.00, NULL, NULL, 'sku_22', 230.00),
(23, 'None 23', 'Learn how to use data to make better decisions', 230.00, NULL, NULL, 'sku_23', NULL),
(24, 'The Westin Peachtree Plaza, Atlanta', 'Learn how to use data to make better decisions', 240.00, NULL, NULL, 'sku_24', NULL);
ALTER TABLE "PUBLIC"."MOOC_PRODUCTS" ALTER COLUMN ID RESTART WITH 25;
INSERT INTO "PUBLIC"."MOOC_PRODUCT_IMAGES" VALUES
(1, 'https://img.pddpic.com/gaudit-image/2023-04-22/b49ab90e9863bea58e706679d1605b7a.jpeg', 1, NULL, NULL),
(2, 'https://img.pddpic.com/gaudit-image/2023-03-17/9cd7fd37e2df711e82db673a3d4a5b73.jpeg', 2, NULL, NULL),
(3, 'https://img.pddpic.com/gaudit-image/2023-06-27/c5919976ed0bac899fcc785c8d651f52.jpeg', 3, NULL, NULL),
(4, 'https://images.pexels.com/photos/11700840/pexels-photo-11700840.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 4, NULL, NULL),
(5, 'https://images.pexels.com/photos/8042737/pexels-photo-8042737.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 5, NULL, NULL),
(6, 'https://images.pexels.com/photos/4659444/pexels-photo-4659444.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 6, NULL, NULL),
(7, 'https://images.pexels.com/photos/7426478/pexels-photo-7426478.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 7, NULL, NULL),
(8, 'https://images.pexels.com/photos/7541732/pexels-photo-7541732.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 8, NULL, NULL),
(9, 'https://images.pexels.com/photos/9143960/pexels-photo-9143960.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 9, NULL, NULL),
(10, 'https://images.pexels.com/photos/9143958/pexels-photo-9143958.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 10, NULL, NULL),
(11, 'https://images.pexels.com/photos/9143964/pexels-photo-9143964.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 11, NULL, NULL),
(12, 'https://images.pexels.com/photos/9143965/pexels-photo-9143965.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 12, NULL, NULL),
(13, 'https://images.pexels.com/photos/9144030/pexels-photo-9144030.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 13, NULL, NULL),
(14, 'https://images.pexels.com/photos/11681061/pexels-photo-11681061.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 14, NULL, NULL),
(15, 'https://images.pexels.com/photos/4045619/pexels-photo-4045619.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', 15, NULL, NULL),
(16, 'https://images.pexels.com/photos/10661108/pexels-photo-10661108.jpeg?auto=compress&cs=tinysrgb&w=1600', 16, NULL, NULL),
(17, 'https://images.pexels.com/photos/13911326/pexels-photo-13911326.jpeg?auto=compress&cs=tinysrgb&w=1600', 17, NULL, NULL),
(18, 'https://images.pexels.com/photos/9588261/pexels-photo-9588261.jpeg?auto=compress&cs=tinysrgb&w=1600', 18, NULL, NULL),
(19, 'https://images.pexels.com/photos/10566125/pexels-photo-10566125.jpeg?auto=compress&cs=tinysrgb&w=1600', 19, NULL, NULL),
(20, 'https://images.pexels.com/photos/4045031/pexels-photo-4045031.jpeg?auto=compress&cs=tinysrgb&w=1600', 20, NULL, NULL),
(21, 'https://ak-d.tripcdn.com/images/22070l000000dann94033_R_640_440_R5_D.jpg_.webp', 21, NULL, NULL),
(22, 'https://ak-d.tripcdn.com/images/220813000000uj76yE162_R_640_440_R5_D.jpg_.webp', 22, NULL, NULL),
(23, 'https://images.pexels.com/photos/12528815/pexels-photo-12528815.jpeg', 23, NULL, NULL),
(24, 'https://ak-d.tripcdn.com/images/220j050000000iape685E_R_600_400_R5_D.jpg_.webp', 24, NULL, NULL);
ALTER TABLE "PUBLIC"."MOOC_PRODUCT_IMAGES" ALTER COLUMN ID RESTART WITH 25;
INSERT INTO "PUBLIC"."MOOC_PAGES" VALUES
(1, TIMESTAMP '2023-02-19 20:03:50.345727', TIMESTAMP '2023-07-04 15:11:15.308011', 'App', 'Home', JSON '{"horizontalPadding":0.0,"verticalPadding":0.0,"baselineScreenWidth":400.0}', U&'\65c5\6e38\9996\9875\5e03\5c40', NULL, NULL, 'Draft'),
(2, TIMESTAMP '2023-07-04 15:11:51.294033', TIMESTAMP '2023-07-04 20:30:09.52612', 'App', 'Home', JSON '{"horizontalPadding":8.0,"verticalPadding":4.0,"baselineScreenWidth":400.0}', U&'\670d\88c5\9996\9875\5e03\5c40', DATEADD('DAY', -1, CURRENT_TIMESTAMP()), DATEADD('DAY', 120, CURRENT_TIMESTAMP()), 'Published');
ALTER TABLE "PUBLIC"."MOOC_PAGES" ALTER COLUMN ID RESTART WITH 3;
INSERT INTO "PUBLIC"."MOOC_PAGE_BLOCKS" VALUES
(1, U&'\8f6e\64ad\56fe\533a\5757', 'Banner', 1, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":220.0,"backgroundColor":"#00000000","borderColor":"#00000000","borderWidth":0.0}', 1),
(2, U&'\4e00\884c\4e00\56fe\7247\533a\5757', 'ImageRow', 4, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":120.0,"backgroundColor":"#00000000","borderColor":"#00000000","borderWidth":0.0}', 1),
(3, U&'\4e00\884c\4e8c\56fe\7247\533a\5757', 'ImageRow', 3, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":96.0,"backgroundColor":null,"borderColor":null,"borderWidth":null}', 1),
(4, U&'\4e00\884c\4e09\56fe\7247\533a\5757', 'ImageRow', 6, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":96.0,"backgroundColor":null,"borderColor":null,"borderWidth":null}', 1),
(6, U&'\4e00\884c\4e00\4ea7\54c1\533a\5757', 'ProductRow', 5, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":136.0,"backgroundColor":"#fff9f9f9","borderColor":"#00000000","borderWidth":0.0}', 1),
(7, U&'\4e00\884c\4e8c\4ea7\54c1\533a\5757', 'ProductRow', 2, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":320.0,"backgroundColor":"#00000000","borderColor":"#00000000","borderWidth":0.0}', 1),
(8, U&'\7011\5e03\6d41\533a\5757', 'Waterfall', 8, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":null}', 1),
(10, 'ImageRow 1', 'ImageRow', 0, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":6.0,"verticalSpacing":6.0,"blockWidth":376.0,"blockHeight":200.0,"backgroundColor":"#ffffffff","borderColor":"#00000000","borderWidth":0.0}', 2),
(11, 'ProductRow 2', 'ProductRow', 1, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":6.0,"verticalSpacing":6.0,"blockWidth":376.0,"blockHeight":148.0,"backgroundColor":"#ffffffff","borderColor":"#00000000","borderWidth":0.0}', 2),
(12, 'ProductRow 3', 'ProductRow', 2, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":6.0,"verticalSpacing":6.0,"blockWidth":376.0,"blockHeight":336.0,"backgroundColor":"#ffffffff","borderColor":"#00000000","borderWidth":0.0}', 2),
(13, 'ImageRow 4', 'ImageRow', 3, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":6.0,"verticalSpacing":6.0,"blockWidth":376.0,"blockHeight":200.0,"backgroundColor":"#ffffffff","borderColor":"#00000000","borderWidth":0.0}', 2),
(14, 'ImageRow 5', 'ImageRow', 4, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":6.0,"verticalSpacing":6.0,"blockWidth":376.0,"blockHeight":200.0,"backgroundColor":"#ffffffff","borderColor":"#00000000","borderWidth":0.0}', 2);
ALTER TABLE "PUBLIC"."MOOC_PAGE_BLOCKS" ALTER COLUMN ID RESTART WITH 15;
INSERT INTO "PUBLIC"."MOOC_PAGE_BLOCK_DATA" VALUES
(1, 1, JSON '{"image":"https://ak-d.tripcdn.com/images/0a10612000aq6nbiu0827.jpg","title":"image1","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 1),
(2, 2, JSON '{"image":"https://ak-d.tripcdn.com/images/0a12j12000becq7g4ACD1.png","title":"image2","link":{"type":"url","value":"https://google.com"},"dataType":"image"}', 1),
(3, 3, JSON '{"image":"https://ak-d.tripcdn.com/images/0a12w12000b96vq19AE13.png","title":"image3","link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 1),
(9, 3, JSON '{"image":"https://images.pexels.com/photos/13551077/pexels-photo-13551077.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load","title":"image3","link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 4),
(14, 1, JSON '{"id":24,"sku":"sku_24","name":"The Westin Peachtree Plaza, Atlanta","description":"Learn how to use data to make better decisions","price":"\u00a5240.22","categories":[{"id":12,"name":"None","code":"cat_n","parentId":null,"children":[],"dataType":"category"}],"images":["https://ak-d.tripcdn.com/images/220j050000000iape685E_R_600_400_R5_D.jpg_.webp"],"dataType":"product"}', 6),
(15, 1, JSON '{"id":22,"sku":"sku_22","name":"SpringHill Suites by Marriott Atlanta Buckhead","description":"Learn how to use data to make better decisions","price":"\u00a5220.0","categories":[{"id":12,"name":"None","code":"cat_n","parentId":null,"children":[],"dataType":"category"}],"images":["https://ak-d.tripcdn.com/images/220813000000uj76yE162_R_640_440_R5_D.jpg_.webp"],"dataType":"product"}', 7),
(16, 2, JSON '{"id":21,"sku":"sku_21","name":"Hilton Atlanta","description":"Learn how to use data to make better decisions","price":"\u00a5210.0","categories":[{"id":12,"name":"None","code":"cat_n","parentId":null,"children":[],"dataType":"category"}],"images":["https://ak-d.tripcdn.com/images/22070l000000dann94033_R_640_440_R5_D.jpg_.webp"],"dataType":"product"}', 7),
(17, 1, JSON '{"id":12,"name":"None","code":"cat_n","parentId":null,"children":[],"dataType":"category"}', 8),
(18, 1, JSON '{"image":"https://youimg1.tripcdn.com/target/100j0s000000i8kplE8EF_C_880_350_R5.jpg?proc=source%2ftrip","title":null,"link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 2),
(19, 1, JSON '{"image":"https://ak-d.tripcdn.com/images/100s0q000000gg1fs4B9F_C_880_350_R5.jpg?proc=source%2ftrip","title":null,"link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 3),
(21, 2, JSON '{"image":"https://youimg1.tripcdn.com/target/01032120008skjakk70E6_C_670_376_Q70.webp?proc=source%2ftrip&proc=source%2ftrip","title":null,"link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 3),
(22, 3, JSON '{"image":"https://ak-d.tripcdn.com/images/220a0g00000081pbu618A_R_960_660_R5_D.jpg_.webp","title":null,"link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 4),
(23, 2, JSON '{"image":"https://ak-d.tripcdn.com/images/220r10000000og6skA912_R_452_274_R5_D.jpg_.webp","title":null,"link":{"type":"route","value":"/detail/1"},"dataType":"image"}', 4),
(24, 3, JSON '{"image":"https://ak-d.tripcdn.com/images/220u180000013xjyv7EAA_R_452_274_R5_D.jpg_.webp","title":null,"link":{"type":"route","value":"/detail/2"},"dataType":"image"}', 4),
(29, 1, JSON '{"image":"https://cdn.pinduoduo.com/upload/home/img/subject/girlclothes.jpg","title":null,"link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 10),
(31, 1, JSON '{"id":1,"sku":"sku_1","name":"\u771f\u7ef4\u65af\u767d\u8272\u77ed\u8896t\u6064\u5973\u590f\u5b63\u7eaf\u68c9\u5bbd\u677e\u4f53\u60642023\u65b0\u6b3e\u767e\u642d\u663e\u7626\u534a\u8896\u4e0a\u8863","description":"Learn how to use data to make better decisions","originalPrice":"\u00a520.00","price":"\u00a510.00","categories":[{"id":1,"name":"Business & Management","code":"cat_b_m","parentId":null,"children":[],"dataType":"category"}],"images":["https://img.pddpic.com/gaudit-image/2023-04-22/b49ab90e9863bea58e706679d1605b7a.jpeg"],"dataType":"product"}', 11),
(32, 1, JSON '{"id":3,"sku":"sku_3","name":"\u6d77\u8c272023\u590f\u65b0\u6b3e\u7eaf\u8272\u6781\u7b80\u7cfb\u5e26T\u6064\u88d9\u7b80\u7ea6\u6c14\u8d28\u538b\u8936\u8212\u9002\u8fde\u8863\u88d9\u5973","description":"Learn how to use data to make better decisions","originalPrice":"\u00a540.00","price":"\u00a530.00","categories":[{"id":2,"name":"Computer Science","code":"cat_c_s","parentId":null,"children":[{"id":15,"name":"Dart","code":"cat_dart","parentId":null,"children":[],"dataType":"category"},{"id":13,"name":"Java","code":"cat_java","parentId":null,"children":[{"id":16,"name":"Spring","code":"cat_java_spring","parentId":null,"children":[],"dataType":"category"}],"dataType":"category"},{"id":14,"name":"Python","code":"cat_py","parentId":null,"children":[],"dataType":"category"}],"dataType":"category"}],"images":["https://img.pddpic.com/gaudit-image/2023-06-27/c5919976ed0bac899fcc785c8d651f52.jpeg"],"dataType":"product"}', 12);
INSERT INTO "PUBLIC"."MOOC_PAGE_BLOCK_DATA" VALUES
(33, 2, JSON '{"id":2,"sku":"sku_2","name":"Pioneer camp\u51b0\u6c27\u5427\u77ed\u8896t\u6064\u5973\u590f\u5b63\u8584\u6b3e\u5bbd\u677e\u900f\u6c14\u534a\u8896\u4e0a\u8863\u901f\u5e72\u4f53\u6064","description":"Learn how to use data to make better decisions","originalPrice":"\u00a530.00","price":"\u00a520.00","categories":[{"id":2,"name":"Computer Science","code":"cat_c_s","parentId":null,"children":[{"id":15,"name":"Dart","code":"cat_dart","parentId":null,"children":[],"dataType":"category"},{"id":13,"name":"Java","code":"cat_java","parentId":null,"children":[{"id":16,"name":"Spring","code":"cat_java_spring","parentId":null,"children":[],"dataType":"category"}],"dataType":"category"},{"id":14,"name":"Python","code":"cat_py","parentId":null,"children":[],"dataType":"category"}],"dataType":"category"}],"images":["https://img.pddpic.com/gaudit-image/2023-03-17/9cd7fd37e2df711e82db673a3d4a5b73.jpeg"],"dataType":"product"}', 12),
(34, 1, JSON '{"image":"https://cdn.pinduoduo.com/upload/home/img/subject/boyshirt.jpg","title":null,"link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 13),
(35, 1, JSON '{"image":"https://img.pddpic.com/gaudit-image/2023-03-03/4aa56691591d8709dc7bb79db150ad6f.jpeg","title":null,"link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 14),
(36, 2, JSON '{"image":"https://img.pddpic.com/gaudit-image/2023-05-31/2b22395407796522922e249b3a488c47.jpeg","title":null,"link":{"type":"url","value":"https://google.com"},"dataType":"image"}', 14);
ALTER TABLE "PUBLIC"."MOOC_PAGE_BLOCK_DATA" ALTER COLUMN ID RESTART WITH 37;
SET REFERENTIAL_INTEGRITY TRUE; // 开启外键约束