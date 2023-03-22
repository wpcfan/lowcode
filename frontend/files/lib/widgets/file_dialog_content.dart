import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:repositories/repositories.dart';

/// 文件对话框内容
/// [images] 文件列表
/// [editable] 是否可编辑
/// [selectedKeys] 选中的文件 key 列表
/// [onSelected] 选中文件的回调
class FileDialogContent extends StatelessWidget {
  const FileDialogContent({
    super.key,
    required this.images,
    required this.editable,
    required this.selectedKeys,
    required this.onSelected,
  });
  final List<FileDto> images;
  final bool editable;
  final List<String> selectedKeys;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    /// 使用 GridView 显示图片
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];

        /// 非编辑模式下的图片
        final selectableItem = Image.network(image.url).inkWell(
          onTap: () => Navigator.of(context).pop(image),
        );

        /// 编辑模式下的图片
        final editableItem = _buildEditableItem(image);
        return editable ? editableItem : selectableItem;
      },
    ).constrained(
      width: 400,
      height: 600,
    );
  }

  /// 构建可编辑状态下的图片
  Widget _buildEditableItem(FileDto image) {
    final checkedIcon = Icon(selectedKeys.contains(image.key)
            ? Icons.check_box
            : Icons.check_box_outline_blank)
        .inkWell(
          onTap: () => onSelected(image.key),
        )
        .positioned(
          top: 0,
          right: 0,
        );
    return [Image.network(image.url), checkedIcon].toStack();
  }
}
