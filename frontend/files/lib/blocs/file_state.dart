import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

/// 文件状态
class FileState extends Equatable {
  /// 文件列表
  final List<FileDto> files;

  /// 是否正在加载文件列表
  final bool loading;

  /// 是否正在上传文件
  final bool uploading;

  /// 错误信息
  final String error;

  /// 是否处于编辑模式
  final bool editable;

  /// 选中的文件
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
