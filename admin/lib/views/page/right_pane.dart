import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../blocs/canvas_state.dart';
import 'block_config_form.dart';
import 'block_data_pane.dart';
import 'page_config_form.dart';

class RighePane extends StatelessWidget {
  const RighePane({
    super.key,
    required this.state,
    required this.showBlockConfig,
    this.onSavePageLayout,
    this.onSavePageBlock,
    this.onDeleteBlock,
    required this.onCategoryAdded,
    required this.onCategoryRemoved,
    required this.onProductAdded,
    required this.onProductRemoved,
  });
  final CanvasState state;
  final bool showBlockConfig;
  final void Function(PageBlock)? onSavePageBlock;
  final void Function(PageLayout)? onSavePageLayout;
  final void Function(int)? onDeleteBlock;
  final void Function(BlockData<Product>) onProductAdded;
  final void Function(int) onProductRemoved;
  final void Function(BlockData<Category>) onCategoryAdded;
  final void Function(int) onCategoryRemoved;

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
                    state: state,
                    onSave: onSavePageBlock,
                    onDelete: onDeleteBlock,
                  ),
                  BlockDataPane(
                    block: state.selectedBlock!,
                    onCategoryAdded: (category) {
                      final data = BlockData<Category>(
                          sort: state.selectedBlock!.data.length,
                          content: category);
                      onCategoryAdded.call(data);
                    },
                    onCategoryRemoved: (category) {
                      final index = state.selectedBlock!.data.indexWhere(
                          (element) => element.content.id == category.id);
                      if (index == -1) return;
                      onCategoryRemoved.call(index);
                    },
                    onProductAdded: (product) {
                      final data = BlockData<Product>(
                          sort: state.selectedBlock!.data.length,
                          content: product);
                      onProductAdded.call(data);
                    },
                    onProductRemoved: (product) {
                      final index = state.selectedBlock!.data.indexWhere(
                          (element) => element.content.id == product.id);
                      if (index == -1) return;
                      onProductRemoved
                          .call(state.selectedBlock!.data[index].id!);
                    },
                    onImagesSubmitted: (images) {},
                  ),
                ],
              ),
            ),
          )
        : PageConfigForm(
            state: state,
            onSave: onSavePageLayout,
          );
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}
