library canvas;

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:nested/nested.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'center_pane.dart';
import 'right_pane.dart';

export 'left_pane.dart';
export 'models/widget_data.dart';

/// 画布页面
/// [id] 画布id
/// [scaffoldKey] scaffold key
class CanvasPage extends StatelessWidget {
  const CanvasPage({
    super.key,
    required this.id,
    required this.scaffoldKey,
  });
  final int id;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      /// 仓库提供者
      providers: _buildRepositoryProviders,
      child: MultiBlocProvider(
        /// bloc提供者
        providers: _buildBlocProviders,
        child: Builder(builder: (context) {
          final productRepository = context.read<ProductRepository>();
          return BlocConsumer<CanvasBloc, CanvasState>(
            listener: (context, state) {
              if (state.error.isNotEmpty) {
                _handleErrors(context, state);
              }
            },
            builder: (context, state) {
              if (state.status == FetchStatus.initial) {
                return const Text('initial').center();
              }
              if (state.status == FetchStatus.loading) {
                return const CircularProgressIndicator().center();
              }
              final rightPane =
                  _buildRightPane(state, productRepository, context);
              final centerPane = _buildCenterPane(state, context);
              final body = _buildBody(context, centerPane, rightPane);

              return Scaffold(
                key: scaffoldKey,
                body: body,
                endDrawer: Drawer(child: rightPane),
              );
            },
          );
        }),
      ),
    );
  }

  /// 处理错误，显示snackbar
  void _handleErrors(BuildContext context, CanvasState state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(state.error,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            )),
      ),
    );
    context.read<CanvasBloc>().add(CanvasEventErrorCleared());
  }

  /// 构建 BlocProviders 数组
  List<SingleChildWidget> get _buildBlocProviders => [
        BlocProvider<CanvasBloc>(
          create: (context) => CanvasBloc(
            context.read<PageAdminRepository>(),
            context.read<PageBlockRepository>(),
            context.read<PageBlockDataRepository>(),
            context.read<ProductRepository>(),
          )..add(CanvasEventLoad(id)),
        ),
      ];

  /// 构建 RepositoryProviders 数组
  List<SingleChildWidget> get _buildRepositoryProviders => [
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(),
        ),
        RepositoryProvider<PageBlockRepository>(
          create: (context) => PageBlockRepository(),
        ),
        RepositoryProvider<PageBlockDataRepository>(
          create: (context) => PageBlockDataRepository(),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(),
        ),
      ];

  /// 构建主体，包含中间部分和右侧部分
  Widget _buildBody(
          BuildContext context, CenterPane centerPane, RightPane rightPane) =>
      (Responsive.isDesktop(context)
              ? [centerPane, const Spacer(), rightPane.expanded(flex: 4)]
              : [centerPane])
          .toRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
      );

  /// 构建中间部分
  CenterPane _buildCenterPane(CanvasState state, BuildContext context) =>
      CenterPane(
        blocks: state.layout?.blocks ?? [],
        products: state.waterfallList,
        defaultBlockConfig: BlockConfig(
          horizontalPadding: 12,
          verticalPadding: 12,
          horizontalSpacing: 6,
          verticalSpacing: 6,
          blockWidth: (state.layout?.config.baselineScreenWidth ?? 375.0) - 24,
          blockHeight: 140,
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
          borderWidth: 0,
        ),
        pageConfig: state.layout?.config ??
            const PageConfig(
              horizontalPadding: 0.0,
              verticalPadding: 0.0,
              baselineScreenWidth: 375.0,
            ),
        onTap: () => context.read<CanvasBloc>().add(CanvasEventSelectNoBlock()),
        onBlockAdded: (block) => context
            .read<CanvasBloc>()
            .add(CanvasEventAddBlock(state.layout!.id!, block)),
        onBlockInserted: (block) => context
            .read<CanvasBloc>()
            .add(CanvasEventInsertBlock(state.layout!.id!, block)),
        onBlockSelected: (block) =>
            context.read<CanvasBloc>().add(CanvasEventSelectBlock(block)),
        onBlockMoved: (block, targetSort) => context.read<CanvasBloc>().add(
            CanvasEventMoveBlock(state.layout!.id!, block.id!, targetSort)),
      );

  /// 构建右侧部分
  RightPane _buildRightPane(CanvasState state,
          ProductRepository productRepository, BuildContext context) =>
      RightPane(
        showBlockConfig: state.selectedBlock != null,
        selectedBlock: state.selectedBlock,
        layout: state.layout,
        productRepository: productRepository,
        onSavePageBlock: (pageBlock) => context.read<CanvasBloc>().add(
              CanvasEventUpdateBlock(
                  state.layout!.id!, pageBlock.id!, pageBlock),
            ),
        onSavePageLayout: (pageLayout) => context.read<CanvasBloc>().add(
              CanvasEventUpdate(state.layout!.id!, pageLayout),
            ),
        onDeleteBlock: (blockId) => _deleteBlock(context, state, blockId),
        onCategoryAdded: (data) =>
            context.read<CanvasBloc>().add(CanvasEventAddBlockData(data)),
        onCategoryUpdated: (data) =>
            context.read<CanvasBloc>().add(CanvasEventUpdateBlockData(data)),
        onCategoryRemoved: (dataId) =>
            context.read<CanvasBloc>().add(CanvasEventDeleteBlockData(dataId)),
        onProductAdded: (data) =>
            context.read<CanvasBloc>().add(CanvasEventAddBlockData(data)),
        onProductRemoved: (dataId) =>
            context.read<CanvasBloc>().add(CanvasEventDeleteBlockData(dataId)),
        onImageAdded: (imageData) =>
            context.read<CanvasBloc>().add(CanvasEventAddBlockData(
                  imageData,
                )),
        onImageRemoved: (dataId) =>
            context.read<CanvasBloc>().add(CanvasEventDeleteBlockData(dataId)),
      );

  /// 删除区块
  Future<void> _deleteBlock(
      BuildContext context, CanvasState state, int blockId) async {
    final bloc = context.read<CanvasBloc>();
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('删除'),
            content: const Text('确定要删除吗？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
    if (result) {
      bloc.add(
        CanvasEventDeleteBlock(state.layout!.id!, blockId),
      );
    }
  }
}
