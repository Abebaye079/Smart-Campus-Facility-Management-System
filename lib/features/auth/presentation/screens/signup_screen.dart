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
  String? _validationError;

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

    setState(() => _validationError = null);

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _validationError = 'Please fill in all fields');
      return;
    }

    if (!email.contains('@')) {
      setState(() => _validationError = 'Please enter a valid email');
      return;
    }

    if (password.length < 8) {
      setState(() => _validationError = 'Password must be at least 8 characters');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _validationError = 'Passwords do not match');
      return;
    }

    await ref.read(authProvider.notifier).signup(
          name,
          email,
          password,
        );

    final authState = ref.read(authProvider);
    if (!authState.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Account created successfully! Please login.'),
        ),
      );
      
      ref.invalidate(authProvider);
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    String? backendError;
    if (authState.hasError) {
      final errorString = authState.error.toString();
      if (!errorString.toLowerCase().contains('login')) {
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
                        style: TextStyle(color: Colors.red, fontSize: 12),
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
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        text: 'Sign Up',
                        onPressed: _handleSignUp,
                      ),

                const SizedBox(height: 25),

                _buildFooter(
                  "Already have an account? ",
                  "Login",
                  () {
                    ref.invalidate(authProvider);
                    context.go(RouteNames.login);
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

  Widget _buildFooter(String text, String action, VoidCallback onTap) =>
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
