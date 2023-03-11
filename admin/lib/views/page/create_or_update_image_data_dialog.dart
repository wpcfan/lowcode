import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../blocs/file_bloc.dart';

class CreateOrUpdateImageDataDialog extends StatefulWidget {
  const CreateOrUpdateImageDataDialog({
    super.key,
    this.onUpdate,
    this.onCreate,
    this.data,
    required this.title,
    required this.fileBloc,
  });
  final void Function(BlockData<ImageData> data)? onUpdate;
  final void Function(BlockData<ImageData> data)? onCreate;
  final BlockData<ImageData>? data;
  final String title;
  final FileBloc fileBloc;

  @override
  State<CreateOrUpdateImageDataDialog> createState() =>
      _CreateOrUpdateImageDataDialogState();
}

class _CreateOrUpdateImageDataDialogState
    extends State<CreateOrUpdateImageDataDialog> {
  late BlockData<ImageData> _formValue;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _formValue = widget.data ??
        BlockData<ImageData>(
          sort: 0,
          content: const ImageData(
            image: '',
            link: MyLink(type: LinkType.route, value: ''),
          ),
        );
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
            TextFormField(
              initialValue: widget.data?.content.image,
              decoration: const InputDecoration(
                labelText: '图片地址',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '图片地址不能为空';
                }
                if (value.length > 255) {
                  return '图片地址不能超过255个字符';
                }
                if (value.length < 12) {
                  return '图片地址不能少于12个字符';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      content: _formValue.content.copyWith(image: value ?? ''));
                });
              },
            ),
            DropdownButtonFormField<LinkType>(
              value: widget.data?.content.link?.type,
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
                      content: _formValue.content.copyWith(
                          link: _formValue.content.link
                              ?.copyWith(type: value ?? LinkType.route)));
                });
              },
            ),
            TextFormField(
              initialValue: widget.data?.content.link?.value,
              decoration: const InputDecoration(
                labelText: '链接地址',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '链接地址不能为空';
                }
                if (value.length > 255) {
                  return '链接地址不能超过255个字符';
                }
                if (value.length < 12) {
                  return '链接地址不能少于12个字符';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _formValue = _formValue.copyWith(
                      content: _formValue.content.copyWith(
                          link: _formValue.content.link
                              ?.copyWith(value: value ?? '') as MyLink));
                });
              },
            ),
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
}
