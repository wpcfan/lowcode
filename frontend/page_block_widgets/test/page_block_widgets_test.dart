import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

void main() {
  testWidgets('BannerWidget renders correctly with given ImageData items',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      final List<ImageData> items = [
        const ImageData(
            image: 'https://example.com/image1.jpg',
            link: MyLink(value: 'https://example.com/1', type: LinkType.url)),
        const ImageData(
            image: 'https://example.com/image2.jpg',
            link: MyLink(value: 'https://example.com/2', type: LinkType.url)),
      ];

      final BlockConfig config = BlockConfig(
        borderWidth: 1,
        borderColor: Colors.red,
        backgroundColor: Colors.blue,
        blockWidth: 400,
        blockHeight: 200,
        horizontalPadding: 10,
        verticalPadding: 10,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BannerWidget(
            items: items,
            config: config,
            errorImage: 'https://example.com/error.jpg',
            ratio: 1.0,
          ),
        ),
      ));

      // 检查是否有正确数量的图片
      expect(find.byType(ImageWidget), findsNWidgets(1));

      // 检查是否有正确数量的点击区域，Banner 中有 items.length + 1 个点击区域
      // 包括 indicator 和当前的图片
      expect(find.byType(InkWell), findsNWidgets(items.length + 1));
    });
  });

  testWidgets('ImageRowWidget renders correctly with given ImageData items',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      final List<ImageData> items = [
        const ImageData(
            image: 'https://example.com/image1.jpg',
            link: MyLink(value: 'https://example.com/1', type: LinkType.url)),
        const ImageData(
            image: 'https://example.com/image2.jpg',
            link: MyLink(value: 'https://example.com/2', type: LinkType.url)),
      ];

      final BlockConfig config = BlockConfig(
        borderWidth: 1,
        borderColor: Colors.red,
        backgroundColor: Colors.blue,
        blockWidth: 400,
        blockHeight: 200,
        horizontalPadding: 10,
        verticalPadding: 10,
      );
      const ratio = 1.0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageRowWidget(
            items: items,
            config: config,
            errorImage: 'https://example.com/error.jpg',
            ratio: ratio,
          ),
        ),
      ));

      // 检查是否有正确数量的图片
      expect(find.byType(ImageWidget), findsNWidgets(items.length));

      // 检查是否有正确数量的点击区域
      expect(find.byType(InkWell), findsNWidgets(items.length));

      // 检查图片的宽度是否正确
      final imageWidgets = find.byType(ImageWidget);
      for (final imageWidgetElement in imageWidgets.evaluate()) {
        final imageWidget = imageWidgetElement.widget as ImageWidget;
        final finder = find.byWidget(imageWidget);
        final size = tester.getSize(finder);
        expect(
            size.width,
            (config.blockWidth! / ratio -
                    2 * config.horizontalPadding! / ratio) /
                items.length);
        expect(size.height,
            config.blockHeight! / ratio - 2 * config.verticalPadding! / ratio);
      }
      final size = tester.getSize(find.byType(ImageRowWidget));
      expect(size.width, config.blockWidth! / ratio);
    });
  });

  testWidgets('ProductCardOneRowOneWidget renders correctly with given Product',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      const Product product = Product(
        id: 1,
        sku: 'sku1',
        name: 'Product 1',
        images: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
        price: '¥100.0',
        originalPrice: '¥210.0',
        description: 'Description',
      );

      final BlockConfig config = BlockConfig(
        borderWidth: 1,
        borderColor: Colors.red,
        backgroundColor: Colors.blue,
        blockWidth: 400,
        blockHeight: 280,
        horizontalPadding: 10,
        verticalPadding: 10,
        horizontalSpacing: 10,
        verticalSpacing: 10,
      );
      const ratio = 1.0;
      final width =
          config.blockWidth! / ratio - 2 * config.horizontalPadding! / ratio;
      final height =
          config.blockHeight! / ratio - 2 * config.verticalPadding! / ratio;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductCardOneRowOneWidget(
            product: product,
            width: width,
            height: height,
            errorImage: 'https://example.com/error.jpg',
            horizontalSpacing: config.horizontalSpacing! / ratio,
            verticalSpacing: config.verticalSpacing! / ratio,
          ),
        ),
      ));

      // 检查是否有正确数量的图片
      expect(find.byType(ImageWidget), findsNWidgets(1));

      // 检查是否有正确数量的点击区域
      expect(find.byType(InkWell), findsNWidgets(2));

      // 检查图片的宽度是否正确
      final imageWidgets = find.byType(ImageWidget);
      for (final imageWidgetElement in imageWidgets.evaluate()) {
        final imageWidget = imageWidgetElement.widget as ImageWidget;
        final finder = find.byWidget(imageWidget);
        final size = tester.getSize(finder);
        expect(size.width, height - 2 * config.borderWidth! / ratio);
        expect(size.height, height - 2 * config.borderWidth! / ratio);
      }
    });
  });
}
