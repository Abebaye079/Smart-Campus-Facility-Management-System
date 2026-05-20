import 'package:smart_campus_app/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getLoggedInUser();

  Future<UserModel> login(String email, String password);

  Future<UserModel> signup(String name, String email, String password);

  Future<void> logout();

  Future<void> deleteAccount();
}