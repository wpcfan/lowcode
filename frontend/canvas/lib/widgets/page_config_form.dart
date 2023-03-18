import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../blocs/canvas_state.dart';
import '../forms/my_text_form_field.dart';
import '../forms/validators.dart';

class PageConfigForm extends StatefulWidget {
  const PageConfigForm({super.key, required this.state, this.onSave});
  final CanvasState state;
  final void Function(PageLayout)? onSave;
  @override
  State<PageConfigForm> createState() => _PageConfigFormState();
}

class _PageConfigFormState extends State<PageConfigForm> {
  final _formKey = GlobalKey<FormState>();
  late PageLayout? _formValue;

  @override
  Widget build(BuildContext context) {
    _formValue = widget.state.layout;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text('页面属性'),
          ..._createFormItems(),
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
        initialValue: _formValue?.title,
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(title: value);
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
        initialValue: _formValue?.config.horizontalPadding.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(
                config: _formValue?.config
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
        initialValue: _formValue?.config.verticalPadding.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(
                config: _formValue?.config
                    .copyWith(verticalPadding: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '基准屏幕宽度',
        hint: '请输入基准屏幕宽度',
        validators: [
          Validators.required(label: '基准屏幕宽度'),
          Validators.isInteger(label: '基准屏幕宽度'),
          Validators.min(label: '基准屏幕宽度', min: 0),
          Validators.max(label: '基准屏幕宽度', max: 1000),
        ],
        initialValue: _formValue?.config.baselineScreenWidth.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(
                config: _formValue?.config
                    .copyWith(baselineScreenWidth: double.parse(value ?? '0')));
          });
        },
      ),
    ];
  }
}
