import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_repository/page_repository.dart';

import 'file_state.dart';
import 'flie_event.dart';

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
  }

  void _onFileEventDelete(
      FileEventDelete event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await fileAdminRepo.deleteFile(event.key);
      emit(state.copyWith(
          files: state.files.where((e) => e.key != event.key).toList()));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

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

  void _onFileEventUploadMultiple(
      FileEventUploadMultiple event, Emitter<FileState> emit) async {
    emit(state.copyWith(uploading: true));
    try {
      final files = await fileRepo.uploadFiles(event.files);
      emit(state.copyWith(files: [...state.files, ...files]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(uploading: false));
    }
  }

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
