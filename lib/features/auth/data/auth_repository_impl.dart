import 'package:smart_campus_app/core/network/api_client.dart';
import 'package:smart_campus_app/features/auth/data/auth_local_data_source.dart';
import 'package:smart_campus_app/features/auth/data/auth_remote_data_source.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';
import 'package:smart_campus_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserModel?> getLoggedInUser() async {
    try {
      final user = await localDataSource.getUser();
      if (user != null) {
        ApiClient.setToken(user.token);
      }
      return user;
    } catch (e) {
      throw Exception("Failed to retrieve cached user: $e");
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.saveUser(user);
      ApiClient.setToken(user.token);
      return user;
    } catch (e) {
      throw Exception("Login repository failure: $e");
    }
  }

  @override
  Future<UserModel> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.signup(name, email, password);
      await localDataSource.saveUser(user);
      return user;
    } catch (e) {
      throw Exception("Signup repository failure: $e");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {
    } finally {
      await localDataSource.clearUser();
      ApiClient.clearToken();
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
    } catch (_) {
    } finally {
      await localDataSource.clearUser();
      ApiClient.clearToken();
    }
  }
}