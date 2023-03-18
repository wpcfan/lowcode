import 'package:canvas/forms/color_picker_form_field.dart';
import 'package:canvas/forms/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../blocs/canvas_state.dart';
import '../forms/validators.dart';

class BlockConfigForm extends StatefulWidget {
  const BlockConfigForm({
    super.key,
    required this.state,
    this.onSave,
    this.onDelete,
  });
  final CanvasState state;
  final void Function(PageBlock)? onSave;
  final void Function(int)? onDelete;

  @override
  State<BlockConfigForm> createState() => _BlockConfigFormState();
}

class _BlockConfigFormState extends State<BlockConfigForm> {
  final _formKey = GlobalKey<FormState>();
  late PageBlock _formValue;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _formValue = widget.state.selectedBlock!;
    });

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ..._createFormItems(),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      widget.onSave?.call(_formValue);
                    }
                  },
                  child: const Text('保存'),
                ),
                TextButton(
                    onPressed: () {
                      widget.onDelete?.call(_formValue.id!);
                    },
                    child: const Text(
                      '删除',
                      style: TextStyle(color: Colors.redAccent),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _createFormItems() {
    return [
      MyTextFormField(
        label: '标题',
        hint: '请输入标题',
        validators: [
          Validators.required(label: '标题'),
          Validators.maxLength(label: '标题', maxLength: 100),
          Validators.minLength(label: '标题', minLength: 2),
        ],
        initialValue: _formValue.title,
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(title: value);
          });
        },
      ),
      MyTextFormField(
        label: '排序',
        hint: '请输入排序',
        validators: [
          Validators.required(label: '排序'),
          Validators.isInteger(label: '排序'),
          Validators.min(label: '排序', min: 0),
          Validators.max(label: '排序', max: 1000),
        ],
        initialValue: _formValue.sort.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(sort: int.parse(value ?? '0'));
          });
        },
      ),
      MyTextFormField(
        label: '水平内边距',
        hint: '请输入水平内边距',
        validators: [
          Validators.required(label: '水平内边距'),
          Validators.isInteger(label: '水平内边距'),
          Validators.min(label: '水平内边距', min: 0),
          Validators.max(label: '水平内边距', max: 1000),
        ],
        initialValue: _formValue.config.horizontalPadding.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config
                    .copyWith(horizontalPadding: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '垂直内边距',
        hint: '请输入垂直内边距',
        validators: [
          Validators.required(label: '垂直内边距'),
          Validators.isInteger(label: '垂直内边距'),
          Validators.min(label: '垂直内边距', min: 0),
          Validators.max(label: '垂直内边距', max: 1000),
        ],
        initialValue: _formValue.config.verticalPadding.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config
                    .copyWith(verticalPadding: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '水平间距',
        hint: '请输入水平间距',
        validators: [
          Validators.required(label: '水平间距'),
          Validators.isInteger(label: '水平间距'),
          Validators.min(label: '水平间距', min: 0),
          Validators.max(label: '水平间距', max: 1000),
        ],
        initialValue: _formValue.config.horizontalSpacing.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config
                    .copyWith(horizontalSpacing: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '垂直间距',
        hint: '请输入垂直间距',
        validators: [
          Validators.required(label: '垂直间距'),
          Validators.isInteger(label: '垂直间距'),
          Validators.min(label: '垂直间距', min: 0),
          Validators.max(label: '垂直间距', max: 1000),
        ],
        initialValue: _formValue.config.verticalSpacing.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config
                    .copyWith(verticalSpacing: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '块宽度',
        hint: '请输入块宽度',
        validators: [
          Validators.required(label: '块宽度'),
          Validators.isInteger(label: '块宽度'),
          Validators.min(label: '块宽度', min: 0),
          Validators.max(label: '块宽度', max: 1000),
        ],
        initialValue: _formValue.config.blockWidth.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config
                    .copyWith(blockWidth: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '块高度',
        hint: '请输入块高度',
        validators: [
          Validators.required(label: '块高度'),
          Validators.isInteger(label: '块高度'),
          Validators.min(label: '块高度', min: 0),
          Validators.max(label: '块高度', max: 1000),
        ],
        initialValue: _formValue.config.blockHeight != null
            ? _formValue.config.blockHeight.toString()
            : '0',
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config
                    .copyWith(blockHeight: double.parse(value ?? '0')));
          });
        },
      ),
      ColorPickerFormField(
        label: '背景颜色',
        colorNotifier: ValueNotifier(
            widget.state.selectedBlock!.config.backgroundColor ??
                Colors.transparent),
        validator: (value) => null,
        onSaved: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config.copyWith(backgroundColor: value));
          });
        },
      ),
      ColorPickerFormField(
        label: '边框颜色',
        colorNotifier: ValueNotifier(
            widget.state.selectedBlock!.config.borderColor ??
                Colors.transparent),
        validator: (value) => null,
        onSaved: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config.copyWith(borderColor: value));
          });
        },
      ),
      MyTextFormField(
        label: '边框宽度',
        hint: '请输入边框宽度',
        validators: [
          Validators.required(label: '边框宽度'),
          Validators.isInteger(label: '边框宽度'),
          Validators.min(label: '边框宽度', min: 0),
          Validators.max(label: '边框宽度', max: 100),
        ],
        initialValue: _formValue.config.borderWidth != null
            ? _formValue.config.borderWidth.toString()
            : '0',
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                config: _formValue.config
                    .copyWith(borderWidth: double.parse(value ?? '0')));
          });
        },
      ),
    ];
  }
}
