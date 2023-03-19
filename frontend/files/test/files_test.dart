import 'package:files/blocs/file_bloc.dart';
import 'package:files/blocs/file_state.dart';
import 'package:files/files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repositories/repositories.dart';

class MockFileUploadRepository extends Mock implements FileUploadRepository {}

class MockFileAdminRepository extends Mock implements FileAdminRepository {}

class MockFileBloc extends Mock implements FileBloc {}

void main() {
  group('ImageExplorer widget', () {
    late FileUploadRepository fileUploadRepo;
    late FileAdminRepository fileAdminRepo;
    late FileBloc fileBloc;
    late List<FileDto> files;

    setUp(() {
      fileUploadRepo = MockFileUploadRepository();
      fileAdminRepo = MockFileAdminRepository();
      fileBloc = MockFileBloc();
      files = List.generate(10, (index) {
        return FileDto(
          key: '$index',
          url: 'http://example.com/file_$index.png',
        );
      });
    });

    testWidgets('should show CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      when(() => fileBloc.state).thenReturn(
        () => const FileState(
          files: [],
          editable: false,
          selectedKeys: [],
          loading: true,
          error: '',
        ),
      );
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<FileUploadRepository>(
              create: (context) => fileUploadRepo,
            ),
            RepositoryProvider<FileAdminRepository>(
              create: (context) => fileAdminRepo,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<FileBloc>(
                create: (context) => fileBloc,
              ),
            ],
            child: const ImageExplorer(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
