import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models/models.dart';

class CreateOrUpdatePageDialog extends StatefulWidget {
  const CreateOrUpdatePageDialog({
    super.key,
    required this.title,
    this.layout,
    this.onUpdate,
    this.onCreate,
  });
  final PageLayout? layout;
  final void Function(PageLayout layout)? onUpdate;
  final void Function(PageLayout layout)? onCreate;
  final String title;

  @override
  State<CreateOrUpdatePageDialog> createState() =>
      _CreateOrUpdatePageDialogState();
}

class _CreateOrUpdatePageDialogState extends State<CreateOrUpdatePageDialog> {
  late PageLayout _formValue;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _formValue = widget.layout ?? PageLayout.empty();
  }

  @override
  Widget build(BuildContext context) {
    final cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('取消'),
    );

    final confirmButton = TextButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          if (widget.layout == null) {
            widget.onCreate?.call(_formValue);
          } else {
            widget.onUpdate?.call(_formValue);
          }
          Navigator.of(context).pop();
        }
      },
      child: const Text('确定'),
    );
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
          key: _formKey,
          child: _createFormItems().toColumn(mainAxisSize: MainAxisSize.min)),
      actions: [cancelButton, confirmButton],
    );
  }

  List<Widget> _createFormItems() {
    return [
      MyTextFormField(
        initialValue: widget.layout?.title,
        label: '标题',
        hint: '请输入标题',
        validators: [
          Validators.required(label: '标题'),
          Validators.maxLength(maxLength: 100, label: '标题'),
          Validators.minLength(minLength: 2, label: '标题'),
        ],
        onChanged: (value) => setState(() {
          _formValue = _formValue.copyWith(title: value);
        }),
      ),
      DropdownButtonFormField<Platform>(
        value: widget.layout?.platform,
        decoration: const InputDecoration(
          labelText: '平台',
        ),
        items: [
          DropdownMenuItem(
            value: Platform.app,
            child: Text(Platform.app.value),
          ),
          DropdownMenuItem(
            value: Platform.web,
            child: Text(Platform.web.value),
          ),
        ],
        onChanged: (value) {},
        onSaved: (newValue) => setState(() {
          _formValue = _formValue.copyWith(platform: newValue);
        }),
      ),
      DropdownButtonFormField<PageType>(
        value: widget.layout?.pageType,
        decoration: const InputDecoration(
          labelText: '类型',
        ),
        items: const [
          DropdownMenuItem(
            value: PageType.home,
            child: Text('首页'),
          ),
          DropdownMenuItem(
            value: PageType.category,
            child: Text('列表'),
          ),
          DropdownMenuItem(
            value: PageType.about,
            child: Text('关于'),
          ),
        ],
        onChanged: (value) {},
        onSaved: (newValue) => setState(() {
          _formValue = _formValue.copyWith(pageType: newValue);
        }),
      ),
      MyTextFormField(
        initialValue: widget.layout?.config.horizontalPadding?.toString(),
        label: '水平内边距',
        hint: '请输入水平内边距',
        validators: [
          Validators.required(label: '水平内边距'),
          Validators.isDouble(label: '水平内边距'),
          Validators.min(min: 0, label: '水平内边距'),
          Validators.max(max: 100, label: '水平内边距'),
        ],
        onChanged: (newValue) => setState(() {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(horizontalPadding: double.parse(newValue!)));
        }),
      ),
      MyTextFormField(
        initialValue: widget.layout?.config.verticalPadding?.toString(),
        label: '垂直内边距',
        hint: '请输入垂直内边距',
        validators: [
          Validators.required(label: '垂直内边距'),
          Validators.isDouble(label: '垂直内边距'),
          Validators.min(min: 0, label: '垂直内边距'),
          Validators.max(max: 100, label: '垂直内边距'),
        ],
        onChanged: (newValue) => setState(() {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(verticalPadding: double.parse(newValue!)));
        }),
      ),
      MyTextFormField(
        initialValue: widget.layout?.config.baselineScreenWidth?.toString(),
        label: '基线屏幕宽度',
        hint: '请输入基线屏幕宽度',
        validators: [
          Validators.required(label: '基线屏幕宽度'),
          Validators.isDouble(label: '基线屏幕宽度'),
          Validators.min(min: 300, label: '基线屏幕宽度'),
          Validators.max(max: 1800, label: '基线屏幕宽度'),
        ],
        onChanged: (newValue) => setState(() {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(baselineScreenWidth: double.parse(newValue!)));
        }),
      ),
    ];
  }
}
