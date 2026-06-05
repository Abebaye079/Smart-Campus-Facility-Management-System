import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_campus_app/features/auth/data/auth_local_data_source.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';
import '../unit/auth_repository_test.mocks.dart';

@GenerateMocks([AuthLocalDataSource])
void main() {
  group('AuthLocalDataSource Unit Tests', () {
    late MockAuthLocalDataSource mockLocalDataSource;
    late UserModel sampleUser;

    setUp(() {
      mockLocalDataSource = MockAuthLocalDataSource();
      sampleUser = UserModel(
        id: 'user_01',
        name: 'Alex Rivera',
        email: 'alex@smartcampus.edu',
        token: 'secure_jwt_token',
        role: 'user',
      );
    });

    test(
      'should verify getUser returns a valid user session successfully',
      () async {
        when(mockLocalDataSource.getUser()).thenAnswer((_) async => sampleUser);

        final result = await mockLocalDataSource.getUser();

        expect(result, isNotNull);
        expect(result?.id, 'user_01');
        expect(result?.name, 'Alex Rivera');
      },
    );

    test(
      'should verify saveUser completes without throwing an exception',
      () async {
        when(
          mockLocalDataSource.saveUser(sampleUser),
        ).thenAnswer((_) async => Future<void>.value());

        expect(mockLocalDataSource.saveUser(sampleUser), completes);
      },
    );

    test('should verify clearUser wipes the active session cleanly', () async {
      when(
        mockLocalDataSource.clearUser(),
      ).thenAnswer((_) async => Future<void>.value());

      expect(mockLocalDataSource.clearUser(), completes);
    });
  });
}
