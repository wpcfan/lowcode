import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

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
    on<CanvasEventSave>(_onCanvasEventSave);
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
  }

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
      final blocks = state.layout?.blocks ?? [];
      final blockIndex = blocks
          .indexWhere((element) => element.id == state.selectedBlock!.id!);
      if (blockIndex != -1) {
        await _handleWaterfall(blocks, emit, blockIndex, newBlock);
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  Future<void> _handleWaterfall(
      List<PageBlock<dynamic>> blocks,
      Emitter<CanvasState> emit,
      int blockIndex,
      PageBlock<dynamic> newBlock) async {
    if (state.selectedBlock?.type == PageBlockType.waterfall) {
      final waterfallBlock = state.selectedBlock!;

      /// 如果瀑布流布局有内容，获取瀑布流数据
      if (waterfallBlock.data.isNotEmpty) {
        /// 获取瀑布流数据的分类ID
        final categoryId = waterfallBlock.data.first.content.id;
        if (categoryId != null) {
          /// 按分类获取瀑布流中的产品数据
          final waterfall =
              await productRepo.getByCategory(categoryId: categoryId);

          /// 更新瀑布流数据
          emit(state.copyWith(
            layout: state.layout?.copyWith(blocks: [
              ...blocks.sublist(0, blockIndex),
              newBlock,
              ...blocks.sublist(blockIndex + 1)
            ]),
            waterfallList: waterfall.data,
            selectedBlock: newBlock,
            error: '',
            saving: false,
          ));
        }
      }
    } else {
      emit(state.copyWith(
        layout: state.layout?.copyWith(blocks: [
          ...blocks.sublist(0, blockIndex),
          newBlock,
          ...blocks.sublist(blockIndex + 1)
        ]),
        waterfallList: [],
        selectedBlock: newBlock,
        error: '',
        saving: false,
      ));
    }
  }

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
      final blocks = state.layout?.blocks ?? [];
      final blockIndex = blocks
          .indexWhere((element) => element.id == state.selectedBlock!.id!);
      if (blockIndex != -1) {
        emit(state.copyWith(
          layout: state.layout?.copyWith(blocks: [
            ...blocks.sublist(0, blockIndex),
            newBlock,
            ...blocks.sublist(blockIndex + 1)
          ]),
          selectedBlock: newBlock,
          error: '',
          saving: false,
        ));
        if (state.selectedBlock!.type == PageBlockType.waterfall) {
          emit(state.copyWith(waterfallList: []));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  void _onCanvasEventAddBlockData(
      CanvasEventAddBlockData event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final blockData = await blockDataRepo.addData(
          state.layout!.id!, state.selectedBlock!.id!, event.data);
      final dataList = state.selectedBlock!.data;
      dataList.add(blockData);

      final newBlock = state.selectedBlock!.copyWith(data: dataList);
      final blocks = state.layout?.blocks ?? [];
      final blockIndex = blocks
          .indexWhere((element) => element.id == state.selectedBlock!.id!);
      if (blockIndex != -1) {
        await _handleWaterfall(blocks, emit, blockIndex, newBlock);
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  void _onCanvasEventSelectNoBlock(
      CanvasEventSelectNoBlock event, Emitter<CanvasState> emit) {
    emit(state.clearSelectedBlock());
  }

  void _onCanvasEventSelectBlock(
      CanvasEventSelectBlock event, Emitter<CanvasState> emit) {
    emit(state.copyWith(selectedBlock: event.block));
  }

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
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  void _onCanvasEventUpdateBlock(
      CanvasEventUpdateBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final block =
          await blockRepo.updateBlock(event.pageId, event.blockId, event.block);
      final blocks = state.layout?.blocks ?? [];
      final index = blocks.indexWhere((element) => element.id == event.blockId);
      if (index != -1) {
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
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

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
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

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
      emit(state.copyWith(
        error: e.toString(),
        saving: false,
      ));
    }
  }

  void _onCanvasEventDeleteBlock(
      CanvasEventDeleteBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      await blockRepo.deleteBlock(event.pageId, event.blockId);
      final blocks = state.layout?.blocks ?? [];
      final index = blocks.indexWhere((element) => element.id == event.blockId);
      if (index != -1) {
        blocks.removeAt(index);
        emit(CanvasState(
          status: FetchStatus.populated,
          layout: state.layout?.copyWith(blocks: blocks),
          saving: false,
          error: '',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        saving: false,
        error: e.toString(),
      ));
    }
  }

  void _onCanvasEventLoad(
      CanvasEventLoad event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final layout = await adminRepo.get(event.id);

      /// 如果有瀑布流布局，获取瀑布流数据
      if (layout.blocks
          .where((element) => element.type == PageBlockType.waterfall)
          .isNotEmpty) {
        /// 获取第一个瀑布流布局
        final waterfallBlock = layout.blocks
            .firstWhere((element) => element.type == PageBlockType.waterfall);

        /// 如果瀑布流布局有内容，获取瀑布流数据
        if (waterfallBlock.data.isNotEmpty) {
          /// 获取瀑布流数据的分类ID
          final categoryId = waterfallBlock.data.first.content.id;
          if (categoryId != null) {
            /// 按分类获取瀑布流中的产品数据
            final waterfall =
                await productRepo.getByCategory(categoryId: categoryId);
            emit(state.copyWith(
              status: FetchStatus.populated,
              layout: layout,
              waterfallList: waterfall.data,
              error: '',
            ));
            return;
          }
        }
      }
      emit(state.copyWith(
        status: FetchStatus.populated,
        layout: layout,
        waterfallList: [],
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FetchStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _onCanvasEventSave(
      CanvasEventSave event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout = await adminRepo.update(event.id, event.layout);
      emit(state.copyWith(
        saving: false,
        layout: layout,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        saving: false,
        error: e.toString(),
      ));
    }
  }
}
