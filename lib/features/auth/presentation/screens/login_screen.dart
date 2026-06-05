import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _validationError = null);

    if (email.isEmpty || password.isEmpty) {
      setState(() => _validationError = 'Please fill in all fields');
      return;
    }

    if (!email.contains('@')) {
      setState(() => _validationError = 'Please enter a valid email');
      return;
    }

    await ref.read(authProvider.notifier).login(email, password);

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (authState.hasError) {
      return;
    }

    if (authState.value != null) {
      context.go(RouteNames.home); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    String? backendError;
    if (authState.hasError) {
      final errorString = authState.error.toString();
      if (!errorString.toLowerCase().contains('signup') && 
          !errorString.toLowerCase().contains('register')) {
        backendError = errorString.replaceAll('Exception: ', '');
      }
    }

    final errorMessage = backendError ?? _validationError;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Color(0xFF2962FF),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'TO CONTINUE',
                  style: TextStyle(
                    color: Color(0xFF2962FF),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 40),

                _buildLabel("Email"),
                InputField(
                  hint: 'Enter your email',
                  controller: _emailController,
                ),
                const SizedBox(height: 20),

                _buildLabel("Password"),
                InputField(
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscure: true,
                ),
                const SizedBox(height: 15),

                if (errorMessage != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 25),

                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        text: 'Login',
                        onPressed: _handleLogin,
                      ),

                const SizedBox(height: 25),
                _buildFooter(
                  "Don't have an account? ",
                  "SignUp",
                  () {
                    ref.invalidate(authProvider);
                    context.go(RouteNames.signup);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget _buildFooter(String text, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2962FF),
            ),
          ),
        ),
      ],
    );
  }
}
