import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:repositories/repositories.dart';

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
        final editableItem = [
          Image.network(image.url),
          Icon(selectedKeys.contains(image.key)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank)
              .inkWell(
                onTap: () => onSelected(image.key),
              )
              .positioned(
                top: 0,
                right: 0,
              ),
        ].toStack();
        return editable ? editableItem : selectableItem;
      },
    ).constrained(
      width: 400,
      height: 600,
    );
  }
}
