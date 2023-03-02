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
    final layout = await blockRepo.insertBlock(event.pageId, event.block);
    emit(state.copyWith(layout: layout, error: ''));
  }

  void _onCanvasEventUpdateBlock(
      CanvasEventUpdateBlock event, Emitter<CanvasState> emit) async {
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
          error: ''));
    }
  }

  void _onCanvasEventMoveBlock(
      CanvasEventMoveBlock event, Emitter<CanvasState> emit) async {
    final layout =
        await blockRepo.moveBlock(event.pageId, event.blockId, event.sort);

    emit(state.copyWith(layout: layout, error: ''));
  }

  void _onCanvasEventAddBlock(
      CanvasEventAddBlock event, Emitter<CanvasState> emit) async {
    final layout = await blockRepo.createBlock(state.layout!.id!, event.block);

    emit(state.copyWith(layout: layout, error: ''));
  }

  void _onCanvasEventDeleteBlock(
      CanvasEventDeleteBlock event, Emitter<CanvasState> emit) async {
    await blockRepo.deleteBlock(event.pageId, event.blockId);
    final blocks = state.layout?.blocks ?? [];
    final index = blocks.indexWhere((element) => element.id == event.blockId);
    if (index != -1) {
      blocks.removeAt(index);
      emit(state.copyWith(
          layout: state.layout?.copyWith(blocks: blocks), error: ''));
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
        final waterfallBlock = layout.blocks.firstWhere(
                (element) => element.type == PageBlockType.waterfall)
            as WaterfallPageBlock;

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
          error: ''));
    } catch (e) {
      emit(state.copyWith(status: FetchStatus.error, error: e.toString()));
    }
  }

  void _onCanvasEventSave(
      CanvasEventSave event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout = await adminRepo.update(event.id, event.layout);
      emit(state.copyWith(saving: false, layout: layout, error: ''));
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }
}
