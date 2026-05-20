import 'package:smart_campus_app/core/network/api_client.dart';
import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';

class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final userData = data['data'] ?? data;

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<UserModel> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final userData = data['data'] ?? data;

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception("Signup failed: $e");
    }
  }

  Future<void> logout() async {
    try {
      await ApiClient.dio.post('/auth/logout');
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  Future<void> deleteAccount() async {
    try {
      await ApiClient.dio.delete('/auth/account');
    } catch (e) {
      throw Exception("Delete account failed: $e");
    }
  }
}