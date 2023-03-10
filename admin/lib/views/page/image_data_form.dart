import 'package:admin/views/page/image_uploader.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

class ImageDataForm extends StatefulWidget {
  const ImageDataForm({
    super.key,
    required this.data,
  });
  final List<BlockData<ImageData>> data;

  @override
  State<ImageDataForm> createState() => _ImageDataFormState();
}

class _ImageDataFormState extends State<ImageDataForm> {
  final List<String> _urls = [];

  @override
  Widget build(BuildContext context) {
    final repo = context.read<FileUploadRepository>();
    final columns = [
      ImageUploader(
        onImagesSubmitted: (images) => _uploadImages(repo, images),
        onError: (error) {
          debugPrint(error);
        },
        maxImages: 9,
      ),
      DataTable(
        columns: const [
          DataColumn(label: Text('图片')),
          DataColumn(label: Text('链接类型')),
          DataColumn(label: Text('链接地址')),
        ],
        rows: widget.data
            .map((e) => e.content)
            .map((e) => DataRow(cells: [
                  DataCell(Image.network(e.image)),
                  DataCell(Text(e.link?.type.value ?? '')),
                  DataCell(Text(e.link?.value ?? '')),
                ]))
            .toList(),
      ),
    ].toColumn();
    return SingleChildScrollView(
      child: columns,
    );
  }

  Future<void> _uploadImages(
      FileUploadRepository repo, List<UploadFile> images) async {
    final urls = await repo.uploadFiles(images);
    setState(() {
      _urls.clear();
      _urls.addAll(urls);
    });
  }
}
