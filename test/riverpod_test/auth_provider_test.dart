import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_campus_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';
import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';

class FakeAuthRepository implements AuthRepository {
  Future<UserModel?> Function()? getLoggedInUserCallback;
  Future<UserModel> Function(String email, String password)? loginCallback;
  Future<UserModel> Function(String name, String email, String password)?
  signupCallback;
  Future<void> Function()? logoutCallback;
  Future<void> Function()? deleteAccountCallback;

  @override
  Future<UserModel?> getLoggedInUser() =>
      getLoggedInUserCallback?.call() ?? Future.value(null);

  @override
  Future<UserModel> login(String email, String password) =>
      loginCallback?.call(email, password) ??
      Future.error(StateError('loginCallback not set'));

  @override
  Future<UserModel> signup(String name, String email, String password) =>
      signupCallback?.call(name, email, password) ??
      Future.error(StateError('signupCallback not set'));

  @override
  Future<void> logout() => logoutCallback?.call() ?? Future.value();

  @override
  Future<void> deleteAccount() =>
      deleteAccountCallback?.call() ?? Future.value();
}

void main() {
  group('AuthNotifier Riverpod State Provider Tests', () {
    late FakeAuthRepository mockAuthRepository;
    late UserModel sampleUser;

    setUp(() {
      mockAuthRepository = FakeAuthRepository();
      sampleUser = const UserModel(
        id: 'user_007',
        name: 'James Bond',
        email: 'bond@campus.io',
        role: 'user',
        token: 'secret_token_jwt',
      );
    });

    ProviderContainer createContainer() {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test(
      'Initial state is null when no cached user exists in SQLite database',
      () async {
        mockAuthRepository.getLoggedInUserCallback = () async => null;

        final container = createContainer();

        expect(container.read(authProvider).isLoading, isTrue);

        final finalState = await container.read(authProvider.future);

        expect(finalState, isNull);
        expect(container.read(authProvider).value, isNull);
      },
    );

    test(
      'Initial state has user data when cached user structure is present inside SQLite storage',
      () async {
        mockAuthRepository.getLoggedInUserCallback = () async => sampleUser;

        final container = createContainer();
        final finalState = await container.read(authProvider.future);

        expect(finalState, equals(sampleUser));
        expect(container.read(authProvider).value!.email, 'bond@campus.io');
      },
    );

    test(
      'State becomes explicitly loading while login transaction is currently in progress',
      () async {
        mockAuthRepository.getLoggedInUserCallback = () async => null;
        mockAuthRepository.loginCallback = (_, __) async => sampleUser;

        final container = createContainer();
        await container.read(authProvider.future);

        final futureLogin = container
            .read(authProvider.notifier)
            .login('bond@campus.io', 'password123');

        expect(container.read(authProvider).isLoading, isTrue);

        await futureLogin;
      },
    );

    test(
      'State becomes user data wrapping structural model after successful authentication login completion',
      () async {
        mockAuthRepository.getLoggedInUserCallback = () async => null;
        mockAuthRepository.loginCallback = (email, password) async {
          if (email == 'bond@campus.io' && password == 'password123') {
            return sampleUser;
          }
          throw Exception('Unexpected login call');
        };

        final container = createContainer();
        await container.read(authProvider.future);

        await container
            .read(authProvider.notifier)
            .login('bond@campus.io', 'password123');

        final authState = container.read(authProvider);
        expect(authState.value, equals(sampleUser));
        expect(authState.value!.name, 'James Bond');
      },
    );

    test(
      'State becomes error envelope after a failed login execution trail due to wrong credentials',
      () async {
        final runtimeException = Exception('Invalid email or password');
        mockAuthRepository.getLoggedInUserCallback = () async => null;
        mockAuthRepository.loginCallback = (email, password) async {
          if (email == 'bond@campus.io' && password == 'wrong_pass') {
            throw runtimeException;
          }
          throw Exception('Unexpected login call');
        };

        final container = createContainer();
        await container.read(authProvider.future);

        await container
            .read(authProvider.notifier)
            .login('bond@campus.io', 'wrong_pass');

        final authState = container.read(authProvider);
        expect(authState, isA<AsyncError>());
        expect(
          authState.error.toString(),
          contains('Invalid email or password'),
        );
      },
    );
    test(
      'State clears and resets back to null data signature after calling logout command',
      () async {
        mockAuthRepository.getLoggedInUserCallback = () async => sampleUser;
        mockAuthRepository.logoutCallback = () async {};

        final container = createContainer();
        await container.read(authProvider.future);

        await container.read(authProvider.notifier).logout();

        final authState = container.read(authProvider);
        expect(authState.value, isNull);
      },
    );

    test(
      'State resets cleanly to null signature after calling remote deleteAccount method block',
      () async {
        mockAuthRepository.getLoggedInUserCallback = () async => sampleUser;
        mockAuthRepository.deleteAccountCallback = () async {};

        final container = createContainer();
        await container.read(authProvider.future);

        await container.read(authProvider.notifier).deleteAccount();

        final authState = container.read(authProvider);
        expect(authState.value, isNull);
      },
    );
  });
}
