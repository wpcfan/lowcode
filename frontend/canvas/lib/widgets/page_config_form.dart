import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../blocs/canvas_state.dart';

class PageConfigForm extends StatefulWidget {
  const PageConfigForm({super.key, required this.state, this.onSave});
  final CanvasState state;
  final void Function(PageLayout)? onSave;
  @override
  State<PageConfigForm> createState() => _PageConfigFormState();
}

class _PageConfigFormState extends State<PageConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _horizontalPaddingController = TextEditingController();
  final _verticalPaddingController = TextEditingController();
  final _baselineScreenWidthController = TextEditingController();
  late PageLayout? _formValue;

  @override
  Widget build(BuildContext context) {
    _formValue = widget.state.layout;
    _titleController.text = _formValue?.title ?? '';
    _horizontalPaddingController.text =
        '${_formValue?.config.horizontalPadding ?? 0}';
    _verticalPaddingController.text =
        '${_formValue?.config.verticalPadding ?? 0}';
    _baselineScreenWidthController.text =
        '${_formValue?.config.baselineScreenWidth ?? 0}';
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text('页面属性'),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '页面标题',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '标题不能为空';
              }
              if (value.length > 100) {
                return '标题不能超过100个字符';
              }
              if (value.length < 2) {
                return '标题不能少于2个字符';
              }
              return null;
            },
            onSaved: (value) {
              _formValue = _formValue?.copyWith(title: value!);
            },
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            /// 需要注意，如果设置 initialValue，那么这个 widget 在切换的时候不会更新
            /// 因为在 widget 树中，这个 widget 的位置没有变化，所以不会重新 build
            /// 所以需要使用 controller 来控制
            controller: _horizontalPaddingController,
            decoration: const InputDecoration(
              labelText: '水平内边距',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '水平内边距不能为空';
              }
              if (double.tryParse(value) == null) {
                return '水平内边距必须是数字';
              }
              if (double.parse(value) < 0) {
                return '水平内边距不能小于0';
              }
              if (double.parse(value) > 100) {
                return '水平内边距不能大于100';
              }
              return null;
            },
            onSaved: (newValue) {
              setState(() {
                _formValue = _formValue?.copyWith(
                    config: _formValue?.config
                        .copyWith(horizontalPadding: double.parse(newValue!)));
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: _verticalPaddingController,
            decoration: const InputDecoration(
              labelText: '垂直内边距',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '垂直内边距不能为空';
              }
              if (double.tryParse(value) == null) {
                return '垂直内边距必须是数字';
              }
              if (double.parse(value) < 0) {
                return '垂直内边距不能小于0';
              }
              if (double.parse(value) > 100) {
                return '垂直内边距不能大于100';
              }
              return null;
            },
            onSaved: (newValue) {
              setState(() {
                _formValue = _formValue?.copyWith(
                    config: _formValue?.config
                        .copyWith(verticalPadding: double.parse(newValue!)));
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: _baselineScreenWidthController,
            decoration: const InputDecoration(
              labelText: '基准屏幕宽度',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '基准屏幕宽度不能为空';
              }
              if (double.tryParse(value) == null) {
                return '基准屏幕宽度必须是数字';
              }
              if (double.parse(value) < 0) {
                return '基准屏幕宽度不能小于0';
              }
              if (double.parse(value) > 1000) {
                return '基准屏幕宽度不能大于1000';
              }
              return null;
            },
            onSaved: (newValue) {
              setState(() {
                _formValue = _formValue?.copyWith(
                    config: _formValue?.config.copyWith(
                        baselineScreenWidth: double.parse(newValue!)));
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                widget.onSave?.call(_formValue!);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
