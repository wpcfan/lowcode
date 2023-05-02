import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'canvas_event.dart';
import 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  final PageAdminRepository adminRepo;
  final PageBlockRepository blockRepo;
  final PageBlockDataRepository blockDataRepo;
  final ProductRepository productRepo;
  CanvasBloc(
      this.adminRepo, this.blockRepo, this.blockDataRepo, this.productRepo)
      : super(const CanvasInitial()) {
    on<CanvasEventLoad>(_onCanvasEventLoad);
    on<CanvasEventUpdate>(_onCanvasEventUpdate);
    on<CanvasEventAddBlock>(_onCanvasEventAddBlock);
    on<CanvasEventUpdateBlock>(_onCanvasEventUpdateBlock);
    on<CanvasEventInsertBlock>(_onCanvasEventInsertBlock);
    on<CanvasEventMoveBlock>(_onCanvasEventMoveBlock);
    on<CanvasEventDeleteBlock>(_onCanvasEventDeleteBlock);
    on<CanvasEventSelectBlock>(_onCanvasEventSelectBlock);
    on<CanvasEventSelectNoBlock>(_onCanvasEventSelectNoBlock);
    on<CanvasEventAddBlockData>(_onCanvasEventAddBlockData);
    on<CanvasEventDeleteBlockData>(_onCanvasEventDeleteBlockData);
    on<CanvasEventUpdateBlockData>(_onCanvasEventUpdateBlockData);
    on<CanvasEventErrorCleared>(_onCanvasEventErrorCleared);
  }

  /// 清除错误
  void _onCanvasEventErrorCleared(
      CanvasEventErrorCleared event, Emitter<CanvasState> emit) {
    emit(state.copyWith(error: ''));
  }

  /// 错误处理
  void _handleError(Emitter<CanvasState> emit, dynamic error) {
    final message = error is CustomException ? error.message : error.toString();
    emit(state.copyWith(
      error: message,
      saving: false,
      status: FetchStatus.error,
    ));
  }

  /// 加载瀑布流
  Future<List<Product>> _loadWaterfallData(PageLayout layout) async {
    try {
      final waterfallBlock = layout.blocks
          .firstWhere((element) => element.type == PageBlockType.waterfall);

      if (waterfallBlock.data.isNotEmpty) {
        final categoryId = waterfallBlock.data.first.content.id;
        if (categoryId != null) {
          final waterfall =
              await productRepo.getByCategory(categoryId: categoryId);
          return waterfall.data;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  PageLayout? _buildNewLayoutWhenBlockChanges(PageBlock<dynamic> newBlock) {
    final blocks = state.layout?.blocks ?? [];
    final blockIndex =
        blocks.indexWhere((element) => element.id == state.selectedBlock!.id!);

    final newLayout = state.layout?.copyWith(blocks: [
      ...blocks.sublist(0, blockIndex),
      newBlock,
      ...blocks.sublist(blockIndex + 1)
    ]);
    return newLayout;
  }

  /// 更新区块数据
  void _onCanvasEventUpdateBlockData(
      CanvasEventUpdateBlockData event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final data = await blockDataRepo.updateData(
          state.layout!.id!, state.selectedBlock!.id!, event.data);
      final dataList = state.selectedBlock!.data;
      final dataIndex = dataList.indexWhere((element) => element.id == data.id);
      if (dataIndex != -1) {
        dataList[dataIndex] = data;
      }
      final newBlock = state.selectedBlock!.copyWith(data: dataList);
      final newLayout = _buildNewLayoutWhenBlockChanges(newBlock);
      final waterfallList = await _loadWaterfallData(state.layout!);
      emit(state.copyWith(
        layout: newLayout,
        waterfallList: waterfallList,
        selectedBlock: newBlock,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 删除区块数据
  void _onCanvasEventDeleteBlockData(
      CanvasEventDeleteBlockData event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      await blockDataRepo.deleteData(
          state.layout!.id!, state.selectedBlock!.id!, event.dataId);
      final dataList = state.selectedBlock!.data;
      final dataIndex =
          dataList.indexWhere((element) => element.id == event.dataId);
      if (dataIndex != -1) {
        dataList.removeAt(dataIndex);
      }
      final newBlock = state.selectedBlock!.copyWith(data: dataList);
      final newLayout = _buildNewLayoutWhenBlockChanges(newBlock);
      emit(state.copyWith(
        layout: newLayout,
        selectedBlock: newBlock,
        error: '',
        saving: false,
      ));

      /// 如果选中的区块是瀑布流，清空瀑布流数据
      if (state.selectedBlock!.type == PageBlockType.waterfall) {
        emit(state.copyWith(waterfallList: []));
      }
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 添加区块数据
  void _onCanvasEventAddBlockData(
      CanvasEventAddBlockData event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final blockData = await blockDataRepo.addData(
          state.layout!.id!, state.selectedBlock!.id!, event.data);
      final dataList = state.selectedBlock!.data;
      dataList.add(blockData);

      final newBlock = state.selectedBlock!.copyWith(data: dataList);
      final newLayout = _buildNewLayoutWhenBlockChanges(newBlock);
      final waterfallList = await _loadWaterfallData(state.layout!);
      emit(state.copyWith(
        layout: newLayout,
        waterfallList: waterfallList,
        selectedBlock: newBlock,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 点击页面时，清除选中的区块
  void _onCanvasEventSelectNoBlock(
      CanvasEventSelectNoBlock event, Emitter<CanvasState> emit) {
    emit(state.clearSelectedBlock());
  }

  /// 选中区块
  void _onCanvasEventSelectBlock(
      CanvasEventSelectBlock event, Emitter<CanvasState> emit) {
    emit(state.copyWith(selectedBlock: event.block));
  }

  /// 插入区块
  void _onCanvasEventInsertBlock(
      CanvasEventInsertBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout = await blockRepo.insertBlock(event.pageId, event.block);
      emit(state.copyWith(
        layout: layout,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 更新区块
  void _onCanvasEventUpdateBlock(
      CanvasEventUpdateBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final block =
          await blockRepo.updateBlock(event.pageId, event.blockId, event.block);
      final blocks = state.layout?.blocks ?? [];
      final index = blocks.indexWhere((element) => element.id == event.blockId);
      if (index == -1) {
        return;
      }
      emit(state.copyWith(
        layout: state.layout?.copyWith(blocks: [
          ...blocks.sublist(0, index),
          block,
          ...blocks.sublist(index + 1)
        ]),
        selectedBlock: block,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 移动区块
  void _onCanvasEventMoveBlock(
      CanvasEventMoveBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout =
          await blockRepo.moveBlock(event.pageId, event.blockId, event.sort);
      emit(state.copyWith(
        layout: layout,
        selectedBlock: event.blockId == state.selectedBlock?.id
            ? state.selectedBlock?.copyWith(sort: event.sort)
            : layout.blocks
                .firstWhere((element) => element.id == event.blockId),
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 添加区块
  void _onCanvasEventAddBlock(
      CanvasEventAddBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout =
          await blockRepo.createBlock(state.layout!.id!, event.block);

      emit(state.copyWith(
        layout: layout,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 删除区块
  void _onCanvasEventDeleteBlock(
      CanvasEventDeleteBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      await blockRepo.deleteBlock(event.pageId, event.blockId);
      final blocks = state.layout?.blocks ?? [];
      final index = blocks.indexWhere((element) => element.id == event.blockId);
      if (index == -1) {
        return;
      }
      blocks.removeAt(index);
      emit(CanvasState(
        status: FetchStatus.populated,
        layout: state.layout?.copyWith(blocks: blocks),
        saving: false,
        error: '',
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 加载页面
  void _onCanvasEventLoad(
      CanvasEventLoad event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final layout = await adminRepo.get(event.id);
      final waterfallList = await _loadWaterfallData(layout);

      emit(state.copyWith(
        status: FetchStatus.populated,
        layout: layout,
        waterfallList: waterfallList,
        error: '',
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 保存页面
  void _onCanvasEventUpdate(
      CanvasEventUpdate event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout = await adminRepo.update(event.id, event.layout);
      emit(state.copyWith(
        saving: false,
        layout: layout,
        error: '',
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }
}
