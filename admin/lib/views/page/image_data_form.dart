import 'package:admin/views/page/image_uploader.dart';
import 'package:common/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

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
    final columns = [
      ImageUploader(
        onImagesSubmitted: (images) => _uploadImages(images),
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

  Future<void> _uploadImages(List<Map<String, dynamic>> images) async {
    final client = FileClient.getInstance();
    if (images.isEmpty) {
      return;
    }
    FormData formData = FormData();
    for (var i = 0; i < images.length; i++) {
      formData.files.add(MapEntry(
          "files",
          MultipartFile.fromBytes(
            images[i]['file'],
            filename: images[i]['name'],
          )));
    }
    final res = await client.post('/files', data: formData);
    if (res.data is List) {
      final json = res.data as List;
      final urls = json.map((e) => e['url'] as String).toList();
      setState(() {
        _urls.clear();
        _urls.addAll(urls);
      });
    }
  }
}
