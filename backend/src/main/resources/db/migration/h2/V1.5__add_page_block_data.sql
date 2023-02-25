INSERT INTO MOOC_PAGES
    (`created_at`, `updated_at`, `platform`, `page_type`, `config`, `title`, `start_time`, `end_time`, `status`) VALUES
    (TIMESTAMP '2023-02-19 20:03:50.345727', TIMESTAMP '2023-02-19 20:27:09.460289', 'App', 'Home', JSON '{"horizontalPadding":0.0,"verticalPadding":0.0,"baselineScreenWidth":400.0}', U&'\9996\9875\5e03\5c40', TIMESTAMP '2023-02-19 00:00:00.000', TIMESTAMP '2030-02-28 23:59:59.999', 'Published');

INSERT INTO MOOC_PAGE_BLOCKS (`title`, `type`, `sort`, `config`, `page_id`) VALUES
                                            (U&'\8f6e\64ad\56fe\533a\5757', 'Banner', 1, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":180.0}', 1),
                                            (U&'\4e00\884c\4e00\56fe\7247\533a\5757', 'ImageRow', 2, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":96.0}', 1),
                                            (U&'\4e00\884c\4e8c\56fe\7247\533a\5757', 'ImageRow', 3, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":96.0}', 1),
                                            (U&'\4e00\884c\4e09\56fe\7247\533a\5757', 'ImageRow', 4, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":96.0}', 1),
                                            (U&'\4e00\884c\6eda\52a8\56fe\7247\533a\5757', 'ImageRow', 5, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":96.0}', 1),
                                            (U&'\4e00\884c\4e00\4ea7\54c1\533a\5757', 'ProductRow', 6, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":120.0}', 1),
                                            (U&'\4e00\884c\4e8c\4ea7\54c1\533a\5757', 'ProductRow', 7, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":300.0}', 1),
                                            (U&'\7011\5e03\6d41\533a\5757', 'Waterfall', 8, JSON '{"horizontalPadding":12.0,"verticalPadding":12.0,"horizontalSpacing":4.0,"verticalSpacing":4.0,"blockWidth":376.0,"blockHeight":null}', 1);

INSERT INTO MOOC_PAGE_BLOCK_DATA VALUES
(1, 1, JSON '{"image":"https://via.placeholder.com/100x100/image1","title":"image1","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 1),
(2, 2, JSON '{"image":"https://via.placeholder.com/100x100/image2","title":"image2","link":{"type":"url","value":"https://google.com"},"dataType":"image"}', 1),
(3, 3, JSON '{"image":"https://via.placeholder.com/100x100/image3","title":"image3","link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 1),
(4, 1, JSON '{"image":"https://via.placeholder.com/100x100/image1","title":"image1","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 2),
(5, 1, JSON '{"image":"https://via.placeholder.com/100x100/image1","title":"image1","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 3),
(6, 2, JSON '{"image":"https://via.placeholder.com/100x100/image2","title":"image2","link":{"type":"url","value":"https://google.com"},"dataType":"image"}', 3),
(7, 1, JSON '{"image":"https://via.placeholder.com/100x100/image1","title":"image1","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 4),
(8, 2, JSON '{"image":"https://via.placeholder.com/100x100/image2","title":"image2","link":{"type":"url","value":"https://google.com"},"dataType":"image"}', 4),
(9, 3, JSON '{"image":"https://via.placeholder.com/100x100/image3","title":"image3","link":{"type":"url","value":"https://bing.com"},"dataType":"image"}', 4),
(10, 1, JSON '{"image":"https://via.placeholder.com/100x100/image1","title":"image1","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 5),
(11, 2, JSON '{"image":"https://via.placeholder.com/100x100/image2","title":"image2","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 5),
(12, 3, JSON '{"image":"https://via.placeholder.com/100x100/image3","title":"image3","link":{"type":"url","value":"https://baidu.com"},"dataType":"image"}', 5),
(13, 4, JSON '{"image":"https://via.placeholder.com/100x100/image4","title":"image4","link":{"type":"url","value":"https://google.com"},"dataType":"image"}', 5),
(14, 4, JSON '{"id":24,"name":"None 24","description":"Learn how to use data to make better decisions","price":"¥240.22","categories":[{"id":12,"name":"None","code":"cat_n","parentId":null,"children":[],"dataType":"category"}],"images":["https://images.pexels.com/photos/7034219/pexels-photo-7034219.jpeg"],"dataType":"product"}', 6),
(16, 4, JSON '{"id":22,"name":"None 22","description":"Learn how to use data to make better decisions","price":"¥220.0","categories":[{"id":12,"name":"None","code":"cat_n","parentId":null,"children":[],"dataType":"category"}],"images":["https://images.pexels.com/photos/6625403/pexels-photo-6625403.jpeg"],"dataType":"product"}', 7),
(17, 4, JSON '{"id":21,"name":"None 21","description":"Learn how to use data to make better decisions","price":"¥210.0","categories":[{"id":12,"name":"None","code":"cat_n","parentId":null,"children":[],"dataType":"category"}],"images":["https://images.pexels.com/photos/5390114/pexels-photo-5390114.jpeg"],"dataType":"product"}', 7),
(18, 4, JSON '{"id":2,"name":"Computer Science","code":"cat_c_s","parentId":null,"children":null,"dataType":"category"}', 8);