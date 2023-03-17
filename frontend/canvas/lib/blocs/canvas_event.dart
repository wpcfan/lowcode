import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class CanvasEvent extends Equatable {}

class CanvasEventSave extends CanvasEvent {
  CanvasEventSave(this.id, this.layout) : super();
  final PageLayout layout;
  final int id;

  @override
  List<Object?> get props => [id, layout];
}

class CanvasEventLoad extends CanvasEvent {
  CanvasEventLoad(this.id) : super();
  final int id;

  @override
  List<Object?> get props => [id];
}

class CanvasEventAddBlock extends CanvasEvent {
  CanvasEventAddBlock(this.pageId, this.block) : super();
  final PageBlock block;
  final int pageId;

  @override
  List<Object?> get props => [pageId, block];
}

class CanvasEventInsertBlock extends CanvasEvent {
  CanvasEventInsertBlock(this.pageId, this.block) : super();
  final PageBlock block;
  final int pageId;

  @override
  List<Object?> get props => [pageId, block];
}

class CanvasEventUpdateBlock extends CanvasEvent {
  CanvasEventUpdateBlock(this.pageId, this.blockId, this.block) : super();
  final PageBlock block;
  final int pageId;
  final int blockId;

  @override
  List<Object?> get props => [pageId, blockId, block];
}

class CanvasEventMoveBlock extends CanvasEvent {
  CanvasEventMoveBlock(this.pageId, this.blockId, this.sort) : super();
  final int pageId;
  final int blockId;
  final int sort;

  @override
  List<Object?> get props => [pageId, blockId, sort];
}

class CanvasEventDeleteBlock extends CanvasEvent {
  CanvasEventDeleteBlock(this.pageId, this.blockId) : super();
  final int pageId;
  final int blockId;

  @override
  List<Object?> get props => [pageId, blockId];
}

class CanvasEventSelectBlock extends CanvasEvent {
  CanvasEventSelectBlock(this.block) : super();
  final PageBlock block;

  @override
  List<Object?> get props => [block];
}

class CanvasEventSelectNoBlock extends CanvasEvent {
  CanvasEventSelectNoBlock() : super();

  @override
  List<Object?> get props => [];
}

class CanvasEventAddBlockData extends CanvasEvent {
  CanvasEventAddBlockData(this.data) : super();
  final BlockData data;

  @override
  List<Object> get props => [data];
}

class CanvasEventDeleteBlockData extends CanvasEvent {
  CanvasEventDeleteBlockData(this.dataId) : super();
  final int dataId;

  @override
  List<Object> get props => [dataId];
}

class CanvasEventUpdateBlockData extends CanvasEvent {
  CanvasEventUpdateBlockData(this.data) : super();
  final BlockData data;

  @override
  List<Object> get props => [data];
}
