import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'widgets/widgets.dart';

/// 右侧面板
/// [selectedBlock] 选中的区块
/// [layout] 页面布局
/// [showBlockConfig] 是否显示块配置
/// [onSavePageLayout] 保存页面布局回调
/// [onSavePageBlock] 保存页面块回调
/// [onDeleteBlock] 删除块回调
/// [onCategoryAdded] 添加分类回调
/// [onCategoryUpdated] 更新分类回调
/// [onCategoryRemoved] 删除分类回调
/// [onProductAdded] 添加商品回调
/// [onProductRemoved] 删除商品回调
///
class RightPane extends StatelessWidget {
  const RightPane({
    super.key,
    required this.showBlockConfig,
    required this.productRepository,
    this.onSavePageLayout,
    this.onSavePageBlock,
    this.onDeleteBlock,
    required this.onCategoryAdded,
    required this.onCategoryUpdated,
    required this.onCategoryRemoved,
    required this.onProductAdded,
    required this.onProductRemoved,
    required this.onImageAdded,
    required this.onImageRemoved,
    this.selectedBlock,
    this.layout,
  });
  final PageBlock<dynamic>? selectedBlock;
  final PageLayout? layout;
  final bool showBlockConfig;
  final ProductRepository productRepository;
  final void Function(PageBlock)? onSavePageBlock;
  final void Function(PageLayout)? onSavePageLayout;
  final void Function(int)? onDeleteBlock;
  final void Function(BlockData<Product>) onProductAdded;
  final void Function(int) onProductRemoved;
  final void Function(BlockData<Category>) onCategoryAdded;
  final void Function(BlockData<Category>) onCategoryUpdated;
  final void Function(int) onCategoryRemoved;
  final void Function(BlockData<ImageData>) onImageAdded;
  final void Function(int) onImageRemoved;

  @override
  Widget build(BuildContext context) {
    final child = showBlockConfig
        ? DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              appBar: const TabBar(
                tabs: [
                  Tab(text: '配置'),
                  Tab(text: '数据'),
                ],
              ),
              body: TabBarView(
                children: [
                  BlockConfigForm(
                    block: selectedBlock!,
                    onSave: onSavePageBlock,
                    onDelete: onDeleteBlock,
                  ),
                  _buildBlockDataPane(),
                ],
              ),
            ),
          )
        : PageConfigForm(
            layout: layout!,
            onSave: onSavePageLayout,
          );
    return child.padding(horizontal: 12);
  }

  BlockDataPane _buildBlockDataPane() {
    return BlockDataPane(
      block: selectedBlock!,
      productRepository: productRepository,
      onCategoryAdded: (category) {
        final data = BlockData<Category>(
          sort: selectedBlock!.data.length,
          content: category,
        );
        onCategoryAdded(data);
      },
      onCategoryUpdated: (category) {
        final matchedData = selectedBlock!.data.first;
        final data = BlockData<Category>(
          id: matchedData.id,
          sort: matchedData.sort,
          content: category,
        );
        onCategoryUpdated(data);
      },
      onCategoryRemoved: (category) {
        final index = selectedBlock!.data
            .indexWhere((element) => element.content.id == category.id);
        if (index == -1) return;
        onCategoryRemoved.call(index);
      },
      onProductAdded: (product) {
        final data = BlockData<Product>(
          sort: selectedBlock!.data.length,
          content: product,
        );
        onProductAdded(data);
      },
      onProductRemoved: (product) {
        final index = selectedBlock!.data
            .indexWhere((element) => element.content.id == product.id);
        if (index == -1) return;
        onProductRemoved(selectedBlock!.data[index].id!);
      },
      onImageAdded: (image) {
        final imageDataList = selectedBlock!.data as List<BlockData<ImageData>>;
        final maxSort = imageDataList.isEmpty
            ? 0
            : imageDataList.map((e) => e.sort).reduce((a, b) => a > b ? a : b);
        final data = BlockData<ImageData>(
          sort: maxSort + 1,
          content: image,
        );
        onImageAdded(data);
      },
      onImageRemoved: (id) {
        onImageRemoved(id);
      },
    );
  }
}
