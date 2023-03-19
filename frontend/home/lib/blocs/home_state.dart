import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class HomeState extends Equatable {
  final PageLayout? layout;
  final FetchStatus status;
  final List<Product> waterfallList;
  final int page;
  final bool hasReachedMax;
  final bool loadingMore;
  final int? categoryId;
  final int selectedIndex;
  final bool drawerOpen;

  const HomeState({
    this.layout,
    required this.status,
    this.waterfallList = const [],
    this.page = 0,
    this.hasReachedMax = true,
    this.loadingMore = false,
    this.categoryId,
    this.selectedIndex = 0,
    this.drawerOpen = false,
  });

  HomeState copyWith({
    PageLayout? layout,
    FetchStatus? status,
    List<Product>? waterfallList,
    int? page,
    bool? hasReachedMax,
    bool? loadingMore,
    int? categoryId,
    int? selectedIndex,
    bool? drawerOpen,
  }) {
    return HomeState(
      layout: layout ?? this.layout,
      status: status ?? this.status,
      waterfallList: waterfallList ?? this.waterfallList,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loadingMore: loadingMore ?? this.loadingMore,
      categoryId: categoryId ?? this.categoryId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      drawerOpen: drawerOpen ?? this.drawerOpen,
    );
  }

  @override
  String toString() {
    return 'HomeState{layout: $layout, status: $status, waterfallList: $waterfallList, page: $page, hasReachedMax: $hasReachedMax, loadingMore: $loadingMore, categoryId: $categoryId, selectedIndex: $selectedIndex, drawerOpen: $drawerOpen}';
  }

  @override
  List<Object?> get props => [
        layout,
        status,
        waterfallList,
        page,
        hasReachedMax,
        loadingMore,
        categoryId,
        selectedIndex,
        drawerOpen,
      ];

  factory HomeState.populated(
    PageLayout layout, {
    List<Product> waterfallList = const [],
    bool hasReachedMax = true,
    int page = 0,
    int? categoryId,
  }) {
    return HomeState(
      layout: layout,
      waterfallList: waterfallList,
      status: FetchStatus.populated,
      hasReachedMax: hasReachedMax,
      page: page,
      categoryId: categoryId,
    );
  }

  bool get isInitial => status == FetchStatus.initial;

  bool get isLoading => status == FetchStatus.loading;

  bool get isPopulated => status == FetchStatus.populated;

  bool get isError => status == FetchStatus.error;

  bool get isEnd => hasReachedMax;

  bool get isLoadingMore => loadingMore;
}
