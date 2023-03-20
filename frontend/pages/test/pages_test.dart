import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:pages/blocs/blocs.dart';
import 'package:repositories/repositories.dart';

class MockPageAdminRepository extends Mock implements PageAdminRepository {}

void main() {
  late PageAdminRepository adminRepo;
  late PageBloc pageBloc;
  setUp(() {
    adminRepo = MockPageAdminRepository();
    pageBloc = PageBloc(adminRepo);
  });

  setUpAll(() {
    registerFallbackValue(const PageQuery());
  });

  tearDown(() {
    pageBloc.close();
  });

  group('PageBloc', () {
    blocTest<PageBloc, PageState>(
      'emits [] when nothing is added',
      build: () => pageBloc,
      expect: () => [],
    );

    // Test for PageEventTitleChanged
    blocTest<PageBloc, PageState>(
      'emits updated state when title changed',
      setUp: () {
        when(() => adminRepo.search(any<PageQuery>()))
            .thenAnswer((_) async => PageWrapper(
                  items: [],
                  page: 0,
                  size: 10,
                  totalPage: 0,
                  totalSize: 0,
                ));
      },
      build: () => pageBloc,
      act: (bloc) => bloc.add(PageEventTitleChanged('New Title')),
      expect: () => [
        const PageState(
          status: FetchStatus.loading,
        ),
        const PageState(
          query: PageQuery(title: 'New Title'),
          status: FetchStatus.populated,
        )
      ], // Add expected states here
    );

    blocTest<PageBloc, PageState>(
      'emits updated state when page changed',
      setUp: () {
        when(() => adminRepo.search(any<PageQuery>()))
            .thenAnswer((_) async => PageWrapper(
                  items: [],
                  page: 2,
                  size: 10,
                  totalPage: 0,
                  totalSize: 0,
                ));
      },
      build: () => pageBloc,
      act: (bloc) => bloc.add(PageEventPageChanged(2)),
      expect: () => [
        const PageState(
          status: FetchStatus.loading,
        ),
        const PageState(
          page: 2,
          query: PageQuery(page: 2),
          status: FetchStatus.populated,
        )
      ], // Add expected states here
    );

    blocTest<PageBloc, PageState>('emits updated state when platform changed',
        setUp: () {
          when(() => adminRepo.search(any<PageQuery>()))
              .thenAnswer((_) async => PageWrapper(
                    items: [],
                    page: 0,
                    size: 10,
                    totalPage: 0,
                    totalSize: 0,
                  ));
        },
        build: () => pageBloc,
        act: (bloc) => bloc.add(PageEventPlatformChanged(Platform.app)),
        expect: () => [
              const PageState(
                status: FetchStatus.loading,
              ),
              const PageState(
                query: PageQuery(platform: Platform.app),
                status: FetchStatus.populated,
              )
            ] // Add expected states here
        );

    blocTest<PageBloc, PageState>('emits updated state when status changed',
        setUp: () {
          when(() => adminRepo.search(any<PageQuery>()))
              .thenAnswer((_) async => PageWrapper(
                    items: [],
                    page: 0,
                    size: 10,
                    totalPage: 0,
                    totalSize: 0,
                  ));
        },
        build: () => pageBloc,
        act: (bloc) => bloc.add(PageEventPageStatusChanged(PageStatus.draft)),
        expect: () => [
              const PageState(
                status: FetchStatus.loading,
              ),
              const PageState(
                query: PageQuery(status: PageStatus.draft),
                status: FetchStatus.populated,
              )
            ] // Add expected states here
        );

    blocTest<PageBloc, PageState>('emits updated state when page type changed',
        setUp: () {
          when(() => adminRepo.search(any<PageQuery>()))
              .thenAnswer((_) async => PageWrapper(
                    items: [],
                    page: 0,
                    size: 10,
                    totalPage: 0,
                    totalSize: 0,
                  ));
        },
        build: () => pageBloc,
        act: (bloc) => bloc.add(PageEventPageTypeChanged(PageType.home)),
        expect: () => [
              const PageState(
                status: FetchStatus.loading,
              ),
              const PageState(
                query: PageQuery(pageType: PageType.home),
                status: FetchStatus.populated,
              )
            ] // Add expected states here
        );
  });
}
