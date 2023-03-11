import 'package:equatable/equatable.dart';
import 'package:page_repository/page_repository.dart';

abstract class FileEvent extends Equatable {}

class FileEventLoad extends FileEvent {
  FileEventLoad() : super();

  @override
  List<Object?> get props => [];
}

class FileEventUpload extends FileEvent {
  FileEventUpload(this.file) : super();
  final UploadFile file;

  @override
  List<Object?> get props => [file];
}

class FileEventUploadMultiple extends FileEvent {
  FileEventUploadMultiple(this.files) : super();
  final List<UploadFile> files;

  @override
  List<Object?> get props => [files];
}

class FileEventDelete extends FileEvent {
  FileEventDelete(this.key) : super();
  final String key;

  @override
  List<Object?> get props => [key];
}
