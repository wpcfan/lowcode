import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:networking/admin_client.dart';
import 'package:networking/problem.dart';

void main() {
  group('AdminClient', () {
    late Dio adminClient;

    setUp(() {
      adminClient = AdminClient.getInstance();
    });

    test('interceptors have been added', () {
      verify(adminClient.interceptors.add(const Interceptor())).called(2);
    });

    test('onError interceptor handles problem correctly', () async {
      final problem = Problem(title: 'Test Problem');
      final response = Response(
        statusCode: 400,
        data: problem.toJson(),
        requestOptions: RequestOptions(path: ''),
      );
      when(adminClient.get('')).thenThrow(DioError(
        response: response,
        requestOptions: RequestOptions(path: ''),
        type: DioErrorType.badResponse,
      ));

      try {
        await adminClient.get('');
        fail('Expected DioError');
      } on DioError catch (e) {
        expect(e.message, problem.title);
        expect(e.error, problem);
        expect(e.type, DioErrorType.badResponse);
      }
    });
  });
}
