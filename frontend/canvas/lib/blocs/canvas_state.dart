import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CanvasState extends Equatable {
  final PageLayout? layout;
  final List<Product> waterfallList;
  final bool saving;
  final String error;
  final FetchStatus status;
  final PageBlock? selectedBlock;

  const CanvasState({
    this.layout,
    this.saving = false,
    this.error = '',
    this.waterfallList = const [],
    this.status = FetchStatus.initial,
    this.selectedBlock,
  });

  @override
  List<Object?> get props =>
      [layout, saving, error, waterfallList, status, selectedBlock];

  CanvasState clearSelectedBlock() {
    return CanvasState(
      layout: layout,
      saving: saving,
      error: error,
      waterfallList: waterfallList,
      status: status,
      selectedBlock: null,
    );
  }

  CanvasState copyWith({
    PageLayout? layout,
    bool? saving,
    String? error,
    List<Product>? waterfallList,
    FetchStatus? status,
    PageBlock? selectedBlock,
  }) {
    return CanvasState(
      layout: layout ?? this.layout,
      saving: saving ?? this.saving,
      error: error ?? this.error,
      waterfallList: waterfallList ?? this.waterfallList,
      status: status ?? this.status,
      selectedBlock: selectedBlock ?? this.selectedBlock,
    );
  }
}

class CanvasInitial extends CanvasState {
  const CanvasInitial() : super();
}
