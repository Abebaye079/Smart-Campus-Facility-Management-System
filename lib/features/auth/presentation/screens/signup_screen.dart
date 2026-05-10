import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  
  final _passFocusNode = FocusNode();
  bool _showPassHint = false; 
  bool _showBanner = false;
  String _bannerMessage = "";

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
    _passFocusNode.dispose(); 
    super.dispose();
  }

  void _handleSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passController.text.trim();
    final confirmPassword = _confirmPassController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _triggerBanner("Please fill in all fields.");
      return;
    }

    if (!email.contains('@')) {
      _triggerBanner("Please enter a valid email address.");
      return;
    }

    if (password.length < 8) {
      _triggerBanner("Password must be at least 8 characters.");
      return;
    }

    if (password != confirmPassword) {
      _triggerBanner("Passwords do not match.");
      return;
    }

    context.go(RouteNames.login);
  }

  void _triggerBanner(String msg) {
    setState(() {
      _bannerMessage = msg;
      _showBanner = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showBanner = false);
    });
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
              child: Column(
                children: [
                  const Text('SIGN UP',
                      style: TextStyle(
                          color: Color(0xFF2962FF),
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const Text('TO CONTINUE',
                      style: TextStyle(color: Color(0xFF2962FF), fontSize: 20)),
                  const SizedBox(height: 40),
                  _buildLabel("Full Name"),
                  InputField(
                      hint: "Enter your full name",
                      controller: _nameController),
                  const SizedBox(height: 20),
                  _buildLabel("Email"),
                  InputField(
                      hint: "Enter your email", controller: _emailController),
                  const SizedBox(height: 20),
                  _buildLabel("Password"),
                  InputField(
                      hint: "Create a password",
                      controller: _passController,
                      obscure: true,
                      focusNode: _passFocusNode),
                 
                  if (_showPassHint) ...[
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'password must be atleast 8 characters',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  _buildLabel("Confirm Password"),
                  InputField(
                      hint: "Repeat your password",
                      controller: _confirmPassController,
                      obscure: true),
                  const SizedBox(height: 40),
                  PrimaryButton(text: 'Sign Up', onPressed: _handleSignUp),
                  const SizedBox(height: 25),
                  _buildFooter("Already have an account? ", "Login",
                      () => context.go(RouteNames.login)),
                ],
              ),
            ),
          ),
          if (_showBanner) _buildBanner(),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(text,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500))));

  Widget _buildFooter(String text, String action, VoidCallback onTap) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(text, style: const TextStyle(color: Colors.grey)),
        GestureDetector(
            onTap: onTap,
            child: Text(action,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF2962FF))))
      ]);

  Widget _buildBanner() => Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
              color: const Color(0xFFFF9999),
              borderRadius: BorderRadius.circular(20)),
          child: Text(_bannerMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16))));
}
