import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

      debugPrint('==== LOGIN RESPONSE ====');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      final statusCode = response.statusCode ?? 200;

      if (statusCode >= 400) {
        final message = response.data['message'] ?? 'Login failed';
        throw Exception(message);
      }

      if (response.data is Map && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
      }

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('DioException during login: ${e.message}');
      final message = e.response?.data['message'] ?? 'Login failed';
      throw Exception(message);
    } catch (e) {
      debugPrint('Unexpected error during login: $e');
      if (e is Exception) rethrow;
      throw Exception('Login failed: $e');
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

      debugPrint('==== SIGNUP RESPONSE ====');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      final statusCode = response.statusCode ?? 200;

      if (statusCode >= 400) {
        final message = response.data['message'] ?? 'Signup failed';
        throw Exception(message);
      }

      if (response.data is Map && response.data['user'] != null) {
        return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
      }

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Signup failed';
      throw Exception(message);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Signup failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await ApiClient.dio.post('/auth/logout');
    } catch (_) {}
  }

  Future<void> deleteAccount() async {
    try {
      await ApiClient.dio.delete('/auth/account');
    } catch (_) {}
  }
}
