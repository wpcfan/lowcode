import 'package:equatable/equatable.dart';
import 'package:page_repository/page_repository.dart';

class FileState extends Equatable {
  final List<FileDto> files;
  final bool loading;
  final bool uploading;
  final String error;

  const FileState({
    this.files = const [],
    this.uploading = false,
    this.loading = false,
    this.error = '',
  });

  @override
  List<Object?> get props => [files, uploading, loading, error];

  FileState copyWith({
    List<FileDto>? files,
    bool? uploading,
    bool? loading,
    String? error,
  }) {
    return FileState(
      files: files ?? this.files,
      uploading: uploading ?? this.uploading,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
