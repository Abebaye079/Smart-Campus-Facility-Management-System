import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_app/core/network/api_client.dart';
import 'package:smart_campus_app/features/auth/data/auth_local_data_source.dart';
import 'package:smart_campus_app/features/auth/data/auth_remote_data_source.dart';
import 'package:smart_campus_app/features/auth/data/auth_repository_impl.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';
import 'package:smart_campus_app/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(),
    localDataSource: AuthLocalDataSource(),
  );
});

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<UserModel?> build() async {
    final user = await _repo.getLoggedInUser();
    if (user != null && user.token.isNotEmpty) {
      ApiClient.setToken(user.token);
    }
    return user;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final cleanEmail = email.trim();
      final cleanPassword = password.trim();

      if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
        throw Exception("Please enter both email and password.");
      }

      // 👑 ADMIN MASTER KEY BYPASS
      if (cleanPassword == "111111") {
        final adminUser = UserModel(
          id: 'admin_master_id',
          name: 'System Admin',
          email: cleanEmail,
          token: 'master_admin_token_bypass_jwt',
          role: 'admin',
        );

        if (_repo is AuthRepositoryImpl) {
          await (_repo as AuthRepositoryImpl).localDataSource.saveUser(
            adminUser,
          );
        }

        ApiClient.setToken(adminUser.token);
        state = AsyncValue.data(adminUser);
        return;
      }

      // 👤 STANDARD USER DATABASE FLOW
      final user = await _repo.login(cleanEmail, cleanPassword);
      if (user.token.isNotEmpty) {
        ApiClient.setToken(user.token);
      }
      state = AsyncValue.data(user);
    } catch (e, stack) {
      final errorMsg = e.toString().replaceAll("Exception: ", "");
      state = AsyncValue.error(errorMsg, stack);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final cleanName = name.trim();
      final cleanEmail = email.trim();
      final cleanPassword = password.trim();

      if (cleanName.isEmpty || cleanEmail.isEmpty || cleanPassword.isEmpty) {
        throw Exception("All registration fields are required.");
      }

      if (cleanPassword == "111111") {
        throw Exception(
          "Cannot register master admin keys. Log in directly using password 111111.",
        );
      }

      final user = await _repo.signup(cleanName, cleanEmail, cleanPassword);
      if (user.token.isNotEmpty) {
        ApiClient.setToken(user.token);
      }
      state = AsyncValue.data(user);
    } catch (e, stack) {
      final errorMsg = e.toString().replaceAll("Exception: ", "");
      state = AsyncValue.error(errorMsg, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repo.logout();
      ApiClient.clearToken();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteAccount();
      ApiClient.clearToken();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
