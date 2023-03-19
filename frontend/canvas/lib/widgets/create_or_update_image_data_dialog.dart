import 'package:files/files.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

/// 用于图片数据的对话框
/// [onUpdate] 更新回调
/// [onCreate] 创建回调
/// [data] 数据
/// [title] 标题
class CreateOrUpdateImageDataDialog extends StatefulWidget {
  const CreateOrUpdateImageDataDialog({
    super.key,
    this.onUpdate,
    this.onCreate,
    this.data,
    required this.title,
  });
  final void Function(ImageData data)? onUpdate;
  final void Function(ImageData data)? onCreate;
  final ImageData? data;
  final String title;

  @override
  State<CreateOrUpdateImageDataDialog> createState() =>
      _CreateOrUpdateImageDataDialogState();
}

class _CreateOrUpdateImageDataDialogState
    extends State<CreateOrUpdateImageDataDialog> {
  /// 表单数据
  late ImageData _formValue;

  /// 表单key
  final _formKey = GlobalKey<FormState>();

  /// 选中的图片
  String _selectedImage = '';

  /// 初始化
  @override
  void initState() {
    super.initState();
    _formValue = widget.data ??
        const ImageData(
          image: '',
          link: MyLink(type: LinkType.route, value: ''),
        );
  }

  /// 销毁
  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._createFormItems(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              if (widget.onCreate != null) {
                widget.onCreate?.call(_formValue);
              }
              if (widget.onUpdate != null) {
                widget.onUpdate?.call(_formValue);
              }
            }
            Navigator.of(context).pop();
          },
          child: const Text('确定'),
        ),
      ],
    );
  }

  /// 创建表单项
  List<Widget> _createFormItems() {
    return [
      MyTextFormField(
        label: '图片地址',
        hint: '请输入图片地址',
        suffix: IconButton(
          icon: const Icon(Icons.image),
          onPressed: () async {
            final FileDto? result = await showDialog<FileDto?>(
              context: context,
              builder: (context) => const ImageExplorer(),
            );
            if (result != null) {
              setState(() {
                _selectedImage = result.url;
              });
            }
          },
        ),
        validators: [
          Validators.required(label: '图片地址'),
          Validators.maxLength(label: '图片地址', maxLength: 255),
          Validators.minLength(label: '图片地址', minLength: 12),
        ],
        initialValue:
            _selectedImage.isEmpty ? widget.data?.image : _selectedImage,
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(image: value ?? '');
          });
        },
      ),
      DropdownButtonFormField<LinkType>(
        value: widget.data?.link?.type,
        decoration: const InputDecoration(
          labelText: '链接类型',
        ),
        items: const [
          DropdownMenuItem(
            value: LinkType.route,
            child: Text('路由'),
          ),
          DropdownMenuItem(
            value: LinkType.url,
            child: Text('链接'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                link: _formValue.link?.copyWith(type: value ?? LinkType.route));
          });
        },
      ),
      MyTextFormField(
        label: '链接地址',
        hint: '请输入链接地址',
        validators: [
          Validators.required(label: '链接地址'),
          Validators.maxLength(label: '链接地址', maxLength: 255),
          Validators.minLength(label: '链接地址', minLength: 12),
        ],
        initialValue: _formValue.link?.value,
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                link: _formValue.link?.copyWith(value: value ?? '') as MyLink);
          });
        },
      ),
    ];
  }
}
