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
    this.onBlockDataChanged,
  });
  final CanvasState state;
  final bool showBlockConfig;
  final void Function(PageBlock)? onSavePageBlock;
  final void Function(PageLayout)? onSavePageLayout;
  final void Function(int)? onDeleteBlock;
  final void Function(List<BlockData>)? onBlockDataChanged;

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
                    onCategoryChanged: (categories) {
                      final data = categories
                          .map((e) => BlockData<Category>(sort: 0, content: e))
                          .toList();
                      onBlockDataChanged?.call(data);
                    },
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
