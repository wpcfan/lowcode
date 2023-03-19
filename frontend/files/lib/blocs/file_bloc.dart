import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

import 'file_event.dart';
import 'file_state.dart';

/// 处理文件上传、删除、加载等事件
class FileBloc extends Bloc<FileEvent, FileState> {
  final FileUploadRepository fileRepo;
  final FileAdminRepository fileAdminRepo;

  FileBloc({
    required this.fileRepo,
    required this.fileAdminRepo,
  }) : super(const FileState()) {
    on<FileEventUpload>(_onFileEventUpload);
    on<FileEventUploadMultiple>(_onFileEventUploadMultiple);
    on<FileEventLoad>(_onFileEventLoad);
    on<FileEventDelete>(_onFileEventDelete);
    on<FileEventToggleEditable>(_onFileEventToggleEditable);
    on<FileEventToggleSelected>(_onFileEventToggleSelected);
  }

  /// 选择文件
  void _onFileEventToggleSelected(
      FileEventToggleSelected event, Emitter<FileState> emit) {
    if (state.selectedKeys.contains(event.key)) {
      emit(state.copyWith(
          selectedKeys:
              state.selectedKeys.where((e) => e != event.key).toList()));
    } else {
      emit(state.copyWith(selectedKeys: [...state.selectedKeys, event.key]));
    }
  }

  /// 切换编辑模式
  void _onFileEventToggleEditable(
      FileEventToggleEditable event, Emitter<FileState> emit) {
    emit(state.copyWith(editable: !state.editable));
  }

  /// 删除文件
  void _onFileEventDelete(
      FileEventDelete event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await fileAdminRepo.deleteFiles(state.selectedKeys);
      emit(state.copyWith(
        files: state.files
            .where((e) => !state.selectedKeys.contains(e.key))
            .toList(),
        selectedKeys: [],
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  /// 加载文件
  void _onFileEventLoad(FileEventLoad event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final files = await fileAdminRepo.getFiles();
      emit(state.copyWith(files: files));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  /// 上传多个文件
  void _onFileEventUploadMultiple(
      FileEventUploadMultiple event, Emitter<FileState> emit) async {
    emit(state.copyWith(uploading: true));
    try {
      final files = await fileRepo.uploadFiles(event.files);
      emit(state.copyWith(files: [
        ...files,
        ...state.files,
      ]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(uploading: false));
    }
  }

  /// 上传单个文件
  void _onFileEventUpload(
      FileEventUpload event, Emitter<FileState> emit) async {
    emit(state.copyWith(uploading: true));
    try {
      final file = await fileRepo.uploadFile(event.file);
      emit(state.copyWith(files: [...state.files, file]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(uploading: false));
    }
  }
}
