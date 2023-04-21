import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// 文件对话框标题
/// [editable] 是否可编辑
/// [selectedKeys] 选中的文件
/// [onEditableChanged] 可编辑状态改变回调
/// [onUpload] 上传回调
/// [onDelete] 删除回调
class FileDialogTitle extends StatelessWidget {
  const FileDialogTitle({
    super.key,
    required this.editable,
    required this.selectedKeys,
    required this.onEditableChanged,
    required this.onUpload,
    required this.onDelete,
  });
  final bool editable;
  final List<String> selectedKeys;
  final void Function(bool) onEditableChanged;
  final void Function() onUpload;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    /// 编辑按钮
    final editableIcon = Icon(editable ? Icons.lock : Icons.lock_open).inkWell(
      onTap: () => onEditableChanged(!editable),
    );

    /// 上传按钮
    final uploadIcon = const Icon(Icons.upload_file).inkWell(
      onTap: onUpload,
    );

    /// 删除按钮
    final deleteIcon = const Icon(Icons.delete).inkWell(
      onTap: () async {
        if (selectedKeys.isEmpty) {
          return;
        }
        final cancelButton = TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        );
        final confirmButton = TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('确定'),
        );
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除图片'),
            content: const Text('确定要删除这些图片吗？'),
            actions: [cancelButton, confirmButton],
          ),
        );
        if (result ?? false) {
          onDelete();
        }
      },
    );
    return [
      const Text('图片资源'),
      const Spacer(),
      editableIcon,
      if (editable) uploadIcon,
      if (editable && selectedKeys.isNotEmpty) deleteIcon,
    ].toRow();
  }
}
