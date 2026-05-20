import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return await _repo.getLoggedInUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signup(name, email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repo.logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteAccount();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}