import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practice_app/core/network/netrwork_info.dart';

class MockInternetConnection extends Mock implements InternetConnection{}

void main() {
  late MockInternetConnection mockInternetConnection;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockInternetConnection = MockInternetConnection();
    networkInfo = NetworkInfoImpl(connection: mockInternetConnection);
  });

  group('is online', () {
    test('should forward the call to data connection checker', () async {
      // arrange
      final tHasConnection = Future.value(true);
      when(
        () => mockInternetConnection.hasInternetAccess,
      ).thenAnswer((_) => tHasConnection);
      // act
      final result = networkInfo.isConnected;
      // assert
      verify(() => mockInternetConnection.hasInternetAccess);
      expect(result, tHasConnection);
    });
  });
}
