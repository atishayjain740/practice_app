import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:practice_app/features/counter/data/datasources/counter_remote_data_source.dart';
import 'package:practice_app/features/counter/data/models/counter_model.dart';

import '../../fixtures/fixture_reader.dart';
import 'package:practice_app/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import 'counter_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late CounterRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockClient();
    dataSource = CounterRemoteDataSourceImpl(client: mockClient);
  });

  void setUpSuccessHttpGetRequest() {
    when(
      mockClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('counter.json'), 200));
  }

  void setUpFailureHttpGetRequest() {
    when(
      mockClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('something went wrong', 404));
  }

  group('get counter', () {
    final CounterModel counterModel = CounterModel.fromJson(
      json.decode(fixture('counter.json')),
    );
    test(
      'should perform a get request with url for getting a number and with application/json as header',
      () {
        // arrange
        setUpSuccessHttpGetRequest();

        // act
        dataSource.getCounter();
        // assert
        verify(
          mockClient.get(
            Uri.parse(
              'https://www.randomnumberapi.com/api/v1.0/random?min=1&max=100&count=1',
            ),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test('should return counter when the response code is success', () async {
      // arrange
      setUpSuccessHttpGetRequest();

      // act
      final result = await dataSource.getCounter();
      // assert
      expect(result, equals(counterModel));
    });

    test(
      'should throw server exception when the response code is not success',
      () async {
        // arrange
        setUpFailureHttpGetRequest();

        // act
        final call = dataSource.getCounter;
        // assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
