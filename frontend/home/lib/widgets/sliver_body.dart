import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:skeletons/skeletons.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../blocs/home_bloc.dart';
import '../blocs/home_state.dart';

/// 首页的内容
class SliverBodyWidget extends StatelessWidget {
  const SliverBodyWidget({
    super.key,
    this.errorImage,
    this.onTap,
    this.addToCart,
    this.onTapProduct,
  });
  final String? errorImage;
  final void Function(MyLink?)? onTap;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTapProduct;

  @override
  Widget build(BuildContext context) {
    /// 使用 BlocBuilder 来监听 HomeBloc 的状态
    /// 当 HomeBloc 的状态发生变化时，BlocBuilder 会重新构建 Widget
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        /// 如果状态是错误状态，那么显示错误信息
        if (state.isError) {
          return SliverToBoxAdapter(
            child: const Text('Error').center(),
          );
        }

        /// 如果状态是初始状态，那么显示骨架屏
        if (state.isInitial) {
          return SliverToBoxAdapter(child: SkeletonListView());
        }

        /// 屏幕的宽度
        final screenWidth = MediaQuery.of(context).size.width;

        /// 最终的比例
        final ratio =
            (state.layout?.config.baselineScreenWidth ?? 400) / screenWidth;
        final blocks = state.layout?.blocks ?? [];
        final products = state.waterfallList;
        final horizontalPadding =
            (state.layout?.config.horizontalPadding ?? 0) / ratio;
        final verticalPadding =
            (state.layout?.config.verticalPadding ?? 0) / ratio;

        /// MultiSliver 是一个可以包含多个 Sliver 的 Widget
        /// 允许一个方法返回多个 Sliver，这个是 `sliver_tools` 包提供的
        return SliverPadding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          sliver: MultiSliver(
              children: blocks.map((block) {
            switch (block.type) {
              case PageBlockType.banner:
                final it = block as PageBlock<ImageData>;

                /// SliverToBoxAdapter 可以将一个 Widget 转换成 Sliver
                return SliverToBoxAdapter(
                  child: BannerWidget(
                    items: it.data.map((di) => di.content).toList(),
                    config: it.config,
                    ratio: ratio,
                    errorImage: errorImage,
                    onTap: onTap,
                  ),
                );
              case PageBlockType.imageRow:
                final it = block as PageBlock<ImageData>;
                return SliverToBoxAdapter(
                  child: ImageRowWidget(
                    items: it.data.map((di) => di.content).toList(),
                    config: it.config,
                    ratio: ratio,
                    errorImage: errorImage,
                    onTap: onTap,
                  ),
                );
              case PageBlockType.productRow:
                final it = block as PageBlock<Product>;
                return SliverToBoxAdapter(
                  child: ProductRowWidget(
                    items: it.data.map((di) => di.content).toList(),
                    config: it.config,
                    ratio: ratio,
                    errorImage: errorImage,
                    onTap: onTapProduct,
                    addToCart: addToCart,
                  ),
                );
              case PageBlockType.waterfall:
                final it = block as PageBlock<Category>;

                /// WaterfallWidget 是一个瀑布流的 Widget
                /// 它本身就是 Sliver，所以不需要再包装一层 SliverToBoxAdapter
                return WaterfallWidget(
                  products: products,
                  config: it.config,
                  ratio: ratio,
                  errorImage: errorImage,
                  onTap: onTapProduct,
                  addToCart: addToCart,
                );
              default:
                return SliverToBoxAdapter(
                  child: Container(),
                );
            }
          }).toList()),
        );
      },
    );
  }
}
