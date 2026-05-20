import 'package:flutter_riverpod/flutter_riverpod.dart';

// TEMPORARY PLACEHOLDER
final authProvider = NotifierProvider<AuthNotifier, AsyncValue<dynamic>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<dynamic>> {
  @override
  AsyncValue<dynamic> build() {
    // Returns null meaning "not logged in" → router sends to login screen
    return const AsyncValue.data(null);
  }
}