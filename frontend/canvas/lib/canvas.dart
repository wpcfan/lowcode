library canvas;

import 'package:common/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'center_pane.dart';
import 'right_pane.dart';

export 'left_pane.dart';
export 'models/widget_data.dart';

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
      providers: [
        RepositoryProvider<Dio>(
          create: (context) => AdminClient.getInstance(),
        ),
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<PageBlockRepository>(
          create: (context) => PageBlockRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<PageBlockDataRepository>(
          create: (context) =>
              PageBlockDataRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(client: context.read<Dio>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CanvasBloc>(
            create: (context) => CanvasBloc(
              context.read<PageAdminRepository>(),
              context.read<PageBlockRepository>(),
              context.read<PageBlockDataRepository>(),
              context.read<ProductRepository>(),
            )..add(CanvasEventLoad(id)),
          ),
        ],
        child: Builder(builder: (context) {
          final productRepository = context.read<ProductRepository>();
          return BlocConsumer<CanvasBloc, CanvasState>(
            listener: (context, state) {
              if (state.error.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == FetchStatus.initial) {
                return const Center(child: Text('initial'));
              }
              if (state.status == FetchStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == FetchStatus.error) {
                return const Center(child: Text('error'));
              }
              final rightPane = RightPane(
                showBlockConfig: state.selectedBlock != null,
                state: state,
                productRepository: productRepository,
                onSavePageBlock: (pageBlock) {
                  context.read<CanvasBloc>().add(
                        CanvasEventUpdateBlock(
                            state.layout!.id!, pageBlock.id!, pageBlock),
                      );
                },
                onSavePageLayout: (pageLayout) {
                  context.read<CanvasBloc>().add(
                        CanvasEventUpdate(state.layout!.id!, pageLayout),
                      );
                },
                onDeleteBlock: (blockId) async {
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
                },
                onCategoryAdded: (data) {
                  context.read<CanvasBloc>().add(CanvasEventAddBlockData(data));
                },
                onCategoryUpdated: (data) {
                  context
                      .read<CanvasBloc>()
                      .add(CanvasEventUpdateBlockData(data));
                },
                onCategoryRemoved: (dataId) {
                  context
                      .read<CanvasBloc>()
                      .add(CanvasEventDeleteBlockData(dataId));
                },
                onProductAdded: (data) {
                  context.read<CanvasBloc>().add(CanvasEventAddBlockData(data));
                },
                onProductRemoved: (dataId) {
                  context
                      .read<CanvasBloc>()
                      .add(CanvasEventDeleteBlockData(dataId));
                },
                onImageAdded: (imageData) {
                  context.read<CanvasBloc>().add(CanvasEventAddBlockData(
                        imageData,
                      ));
                },
                onImageRemoved: (dataId) {
                  context
                      .read<CanvasBloc>()
                      .add(CanvasEventDeleteBlockData(dataId));
                },
              );
              final centerPane = CenterPane(
                state: state,
                onTap: () {
                  context.read<CanvasBloc>().add(CanvasEventSelectNoBlock());
                },
              );
              final rows = Responsive.isDesktop(context)
                  ? [centerPane, const Spacer(), rightPane.expanded(flex: 4)]
                  : [centerPane];
              return Scaffold(
                key: scaffoldKey,
                body: rows.toRow(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                endDrawer: Drawer(
                  child: rightPane,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
