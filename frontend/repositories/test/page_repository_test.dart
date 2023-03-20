import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';
import 'package:repositories/category_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('CategoryRepository', () {
    late Dio client;
    late CategoryRepository repository;

    setUp(() {
      client = MockDio();
      repository = CategoryRepository(client: client);
    });

    test('getCategories - basic', () async {
      final categories = [
        const Category(id: 1, name: 'Category 1'),
        const Category(id: 2, name: 'Category 2'),
      ];

      when(client.get('/categories',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
              data: categories,
              requestOptions: RequestOptions(
                path: '/categories',
              )));

      final result = await repository.getCategories(
          categoryRepresenation: CategoryRepresenation.basic);

      expect(result, categories);
    });

    test('getCategories - withChildren', () async {
      final categories = [
        const Category(
          id: 1,
          name: 'Category 1',
          children: [
            Category(id: 2, name: 'Category 2'),
            Category(id: 3, name: 'Category 3'),
          ],
        ),
        const Category(
          id: 4,
          name: 'Category 4',
          children: [
            Category(id: 5, name: 'Category 5'),
          ],
        ),
      ];

      when(client.get('/categories',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
              data: categories,
              requestOptions: RequestOptions(path: '/categories')));

      final result = await repository.getCategories(
          categoryRepresenation: CategoryRepresenation.withChildren);

      expect(result, categories);
    });

    test('getCategories - rootOnly', () async {
      final categories = [
        const Category(id: 1, name: 'Category 1'),
        const Category(id: 2, name: 'Category 2'),
      ];

      when(client.get('/categories',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
              data: categories,
              requestOptions: RequestOptions(path: '/categories')));

      final result = await repository.getCategories(
          categoryRepresenation: CategoryRepresenation.rootOnly);

      expect(result, categories);
    });
  });
}
