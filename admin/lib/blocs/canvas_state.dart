import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CanvasState extends Equatable {
  final PageLayout? layout;
  final List<Product> waterfallList;
  final bool saving;
  final String error;
  final FetchStatus status;
  final int moveOverIndex;

  const CanvasState({
    this.layout,
    this.saving = false,
    this.error = '',
    this.waterfallList = const [],
    this.status = FetchStatus.initial,
    this.moveOverIndex = -1,
  });

  @override
  List<Object?> get props =>
      [layout, saving, error, waterfallList, status, moveOverIndex];

  CanvasState copyWith({
    PageLayout? layout,
    bool? saving,
    String? error,
    List<Product>? waterfallList,
    FetchStatus? status,
    int? moveOverIndex,
  }) {
    return CanvasState(
      layout: layout ?? this.layout,
      saving: saving ?? this.saving,
      error: error ?? this.error,
      waterfallList: waterfallList ?? this.waterfallList,
      status: status ?? this.status,
      moveOverIndex: moveOverIndex ?? this.moveOverIndex,
    );
  }
}

class CanvasInitial extends CanvasState {
  const CanvasInitial() : super();
}
