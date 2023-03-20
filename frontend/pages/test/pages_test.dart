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
  });
}
