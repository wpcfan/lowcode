import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CanvasState extends Equatable {
  final PageLayout? layout;
  final List<Product> waterfallList;
  final bool saving;
  final String error;
  final FetchStatus status;

  const CanvasState({
    this.layout,
    this.saving = false,
    this.error = '',
    this.waterfallList = const [],
    this.status = FetchStatus.initial,
  });

  @override
  List<Object?> get props => [layout, saving, error, waterfallList, status];

  CanvasState copyWith({
    PageLayout? layout,
    bool? loading,
    bool? saving,
    String? error,
    List<Product>? waterfallList,
    FetchStatus? status,
  }) {
    return CanvasState(
      layout: layout ?? this.layout,
      saving: saving ?? this.saving,
      error: error ?? this.error,
      waterfallList: waterfallList ?? this.waterfallList,
      status: status ?? this.status,
    );
  }
}

class CanvasInitial extends CanvasState {
  const CanvasInitial() : super();
}
