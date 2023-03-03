import 'package:common/common.dart';
import 'package:flutter/material.dart';

import '../../blocs/canvas_state.dart';
import 'color_picker_dialog.dart';

class RightPane extends StatelessWidget {
  const RightPane({
    super.key,
    required this.state,
    required this.showBlockConfig,
  });
  final CanvasState state;
  final bool showBlockConfig;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        color: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: showBlockConfig
            ? BlockConfigForm(state: state)
            : PageConfigForm(state: state),
      ),
    );
  }
}

class PageConfigForm extends StatefulWidget {
  const PageConfigForm({super.key, required this.state});
  final CanvasState state;
  @override
  State<PageConfigForm> createState() => _PageConfigFormState();
}

class _PageConfigFormState extends State<PageConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _horizontalPaddingController = TextEditingController();
  final _verticalPaddingController = TextEditingController();
  final _baselineScreenWidthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final layoutConfig = widget.state.layout?.config;
    _horizontalPaddingController.text =
        '${layoutConfig?.horizontalPadding ?? 0}';
    _verticalPaddingController.text = '${layoutConfig?.verticalPadding ?? 0}';
    _baselineScreenWidthController.text =
        '${layoutConfig?.baselineScreenWidth ?? 0}';
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text('页面属性'),
          TextFormField(
            /// 需要注意，如果设置 initialValue，那么这个 widget 在切换的时候不会更新
            /// 因为在 widget 树中，这个 widget 的位置没有变化，所以不会重新 build
            /// 所以需要使用 controller 来控制
            controller: _horizontalPaddingController,
            decoration: const InputDecoration(
              labelText: '水平内边距',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: _verticalPaddingController,
            decoration: const InputDecoration(
              labelText: '垂直内边距',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: _baselineScreenWidthController,
            decoration: const InputDecoration(
              labelText: '基准屏幕宽度',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(onPressed: () {}, child: const Text('保存')),
        ],
      ),
    );
  }
}

class BlockConfigForm extends StatefulWidget {
  const BlockConfigForm({super.key, required this.state});
  final CanvasState state;

  @override
  State<BlockConfigForm> createState() => _BlockConfigFormState();
}

class _BlockConfigFormState extends State<BlockConfigForm> {
  final _titleController = TextEditingController();
  final _sortController = TextEditingController();
  final _horizontalPaddingController = TextEditingController();
  final _verticalPaddingController = TextEditingController();
  final _horizontalSpacingController = TextEditingController();
  final _verticalSpacingController = TextEditingController();
  final _blockWidthController = TextEditingController();
  final _blockHeightController = TextEditingController();
  final _backgroundColorController = TextEditingController();
  final _borderColorController = TextEditingController();
  final _borderWidthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final block = widget.state.selectedBlock;
    _titleController.text = block!.title;
    _sortController.text = '${block.sort}';
    _horizontalPaddingController.text = '${block.config.horizontalPadding}';
    _verticalPaddingController.text = '${block.config.verticalPadding}';
    _horizontalSpacingController.text = '${block.config.horizontalSpacing}';
    _verticalSpacingController.text = '${block.config.verticalSpacing}';
    _backgroundColorController.text = block.config.backgroundColor != null
        ? block.config.backgroundColor!.value.toRadixString(16)
        : '';
    _borderColorController.text = block.config.borderColor != null
        ? block.config.borderColor!.value.toRadixString(16)
        : '';
    _borderWidthController.text = block.config.borderWidth != null
        ? block.config.borderWidth!.toString()
        : '0';
    return Form(
      key: _formKey,
      child: Column(children: [
        const Text('区块属性'),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: '标题',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '标题不能为空';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _sortController,
          decoration: const InputDecoration(
            labelText: '排序',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _horizontalPaddingController,
          decoration: const InputDecoration(
            labelText: '水平内边距',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _verticalPaddingController,
          decoration: const InputDecoration(
            labelText: '垂直内边距',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _horizontalSpacingController,
          decoration: const InputDecoration(
            labelText: '水平间距',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _verticalSpacingController,
          decoration: const InputDecoration(
            labelText: '垂直间距',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _blockWidthController,
          decoration: const InputDecoration(
            labelText: '区块宽度',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _blockHeightController,
          decoration: const InputDecoration(
            labelText: '区块高度',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _backgroundColorController,
          decoration: InputDecoration(
            labelText: '背景颜色',
            suffix: const Icon(Icons.color_lens).inkWell(onTap: () async {
              final selectedColor = await showDialog(
                context: context,
                builder: (context) {
                  return const ColorPickerDialog();
                },
              );
              if (selectedColor != null) {
                _backgroundColorController.text =
                    '#${selectedColor.value.toRadixString(16)}';
              }
            }),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _borderColorController,
          decoration: InputDecoration(
            labelText: '边框颜色',
            suffix: const Icon(Icons.color_lens).inkWell(onTap: () async {
              final selectedColor = await showDialog(
                context: context,
                builder: (context) {
                  return const ColorPickerDialog();
                },
              );
              if (selectedColor != null) {
                _borderColorController.text =
                    '#${selectedColor.value.toRadixString(16)}';
              }
            }),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _borderWidthController,
          decoration: const InputDecoration(
            labelText: '边框宽度',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(onPressed: () {}, child: const Text('保存')),
      ]),
    );
  }
}
