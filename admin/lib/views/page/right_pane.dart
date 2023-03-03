import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../blocs/canvas_state.dart';
import 'block_config_form.dart';
import 'page_config_form.dart';

class RightPane extends StatelessWidget {
  const RightPane({
    super.key,
    required this.state,
    required this.showBlockConfig,
    this.onSavePageLayout,
    this.onSavePageBlock,
    this.onDeleteBlock,
  });
  final CanvasState state;
  final bool showBlockConfig;
  final void Function(PageBlock)? onSavePageBlock;
  final void Function(PageLayout)? onSavePageLayout;
  final void Function(int)? onDeleteBlock;

  @override
  Widget build(BuildContext context) {
    final child = showBlockConfig
        ? BlockConfigForm(
            state: state,
            onSave: onSavePageBlock,
            onDelete: onDeleteBlock,
          )
        : PageConfigForm(
            state: state,
            onSave: onSavePageLayout,
          );
    return SizedBox(
      width: 300,
      child: Container(
        color: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: child,
      ),
    );
  }
}
