import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

class FileState extends Equatable {
  final List<FileDto> files;
  final bool loading;
  final bool uploading;
  final String error;
  final bool editable;
  final List<String> selectedKeys;

  const FileState({
    this.files = const [],
    this.uploading = false,
    this.loading = false,
    this.error = '',
    this.editable = false,
    this.selectedKeys = const [],
  });

  @override
  List<Object?> get props =>
      [files, uploading, loading, error, editable, selectedKeys];

  FileState copyWith({
    List<FileDto>? files,
    bool? uploading,
    bool? loading,
    String? error,
    bool? editable,
    List<String>? selectedKeys,
  }) {
    return FileState(
      files: files ?? this.files,
      uploading: uploading ?? this.uploading,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      editable: editable ?? this.editable,
      selectedKeys: selectedKeys ?? this.selectedKeys,
    );
  }
}
