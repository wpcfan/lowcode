import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class CanvasEvent extends Equatable {}

/// 更新画布
class CanvasEventUpdate extends CanvasEvent {
  CanvasEventUpdate(this.id, this.layout) : super();
  final PageLayout layout;
  final int id;

  @override
  List<Object?> get props => [id, layout];
}

/// 加载画布
class CanvasEventLoad extends CanvasEvent {
  CanvasEventLoad(this.id) : super();
  final int id;

  @override
  List<Object?> get props => [id];
}

/// 添加页面区块
class CanvasEventAddBlock extends CanvasEvent {
  CanvasEventAddBlock(this.pageId, this.block) : super();
  final PageBlock block;
  final int pageId;

  @override
  List<Object?> get props => [pageId, block];
}

/// 插入页面区块
class CanvasEventInsertBlock extends CanvasEvent {
  CanvasEventInsertBlock(this.pageId, this.block) : super();
  final PageBlock block;
  final int pageId;

  @override
  List<Object?> get props => [pageId, block];
}

/// 更新页面区块
class CanvasEventUpdateBlock extends CanvasEvent {
  CanvasEventUpdateBlock(this.pageId, this.blockId, this.block) : super();
  final PageBlock block;
  final int pageId;
  final int blockId;

  @override
  List<Object?> get props => [pageId, blockId, block];
}

/// 移动页面区块
class CanvasEventMoveBlock extends CanvasEvent {
  CanvasEventMoveBlock(this.pageId, this.blockId, this.sort) : super();
  final int pageId;
  final int blockId;
  final int sort;

  @override
  List<Object?> get props => [pageId, blockId, sort];
}

/// 删除页面区块
class CanvasEventDeleteBlock extends CanvasEvent {
  CanvasEventDeleteBlock(this.pageId, this.blockId) : super();
  final int pageId;
  final int blockId;

  @override
  List<Object?> get props => [pageId, blockId];
}

/// 选择页面区块
class CanvasEventSelectBlock extends CanvasEvent {
  CanvasEventSelectBlock(this.block) : super();
  final PageBlock block;

  @override
  List<Object?> get props => [block];
}

/// 取消选择页面区块
class CanvasEventSelectNoBlock extends CanvasEvent {
  CanvasEventSelectNoBlock() : super();

  @override
  List<Object?> get props => [];
}

/// 添加页面区块数据
class CanvasEventAddBlockData extends CanvasEvent {
  CanvasEventAddBlockData(this.data) : super();
  final BlockData data;

  @override
  List<Object> get props => [data];
}

/// 删除页面区块数据
class CanvasEventDeleteBlockData extends CanvasEvent {
  CanvasEventDeleteBlockData(this.dataId) : super();
  final int dataId;

  @override
  List<Object> get props => [dataId];
}

/// 更新页面区块数据
class CanvasEventUpdateBlockData extends CanvasEvent {
  CanvasEventUpdateBlockData(this.data) : super();
  final BlockData data;

  @override
  List<Object> get props => [data];
}

class CanvasEventErrorCleared extends CanvasEvent {
  CanvasEventErrorCleared() : super();

  @override
  List<Object?> get props => [];
}
