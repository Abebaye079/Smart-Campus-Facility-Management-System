import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/core/widgets/input_field.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _passFocusNode = FocusNode();
  bool _showPassHint = false;

  @override
  void initState() {
    super.initState();

    _passFocusNode.addListener(() {
      setState(() {
        _showPassHint = _passFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passController.text.trim();
    final confirmPassword = _confirmPassController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return;
    }

    if (!email.contains('@')) {
      return;
    }

    if (password.length < 8) {
      return;
    }

    if (password != confirmPassword) {
      return;
    }

    await ref.read(authProvider.notifier).signup(
          name,
          email,
          password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ✅ Adapted to team AsyncValue specification (Rule 8)
    final isLoading = authState.isLoading;
    final errorMessage = authState.hasError
        ? authState.error.toString().replaceAll('Exception: ', '')
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 80,
          ),
          child: Column(
            children: [
              const Text(
                'SIGN UP',
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

              _buildLabel("Full Name"),
              InputField(
                hint: "Enter your full name",
                controller: _nameController,
              ),

              const SizedBox(height: 20),

              _buildLabel("Email"),
              InputField(
                hint: "Enter your email",
                controller: _emailController,
              ),

              const SizedBox(height: 20),

              _buildLabel("Password"),
              InputField(
                hint: "Create a password",
                controller: _passController,
                obscure: true,
                focusNode: _passFocusNode,
              ),

              if (_showPassHint)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Password must be at least 8 characters',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              _buildLabel("Confirm Password"),
              InputField(
                hint: "Repeat your password",
                controller: _confirmPassController,
                obscure: true,
              ),

              const SizedBox(height: 20),

              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              isLoading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: 'Sign Up',
                      onPressed: _handleSignUp,
                    ),

              const SizedBox(height: 25),

              _buildFooter(
                "Already have an account? ",
                "Login",
                () => context.go(RouteNames.login),
              ),
            ],
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

  Widget _buildFooter(
    String text,
    String action,
    VoidCallback onTap,
  ) =>
      Row(
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