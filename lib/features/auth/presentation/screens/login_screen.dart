import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showBanner = false;
  String _bannerMessage = "";

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    
    if (email.isEmpty || password.isEmpty) {
      _triggerBanner("Please fill in all fields.");
      return;
    }


    if (!email.contains('@')) {
      _triggerBanner("Please enter a valid email address.");
      return;
    }

    if (password.length == 8) {
   
      context.go(RouteNames.home);
    } else if (password.length == 6) {
      
      context.go(RouteNames.adminDashboard);
    } else {
      _triggerBanner("Invalid credentials.");
    }
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('LOG IN',
                    style: TextStyle(
                        color: Color(0xFF2962FF),
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                const Text('TO CONTINUE',
                    style: TextStyle(color: Color(0xFF2962FF), fontSize: 20)),
                const SizedBox(height: 40),
                _buildLabel("Email"),
                InputField(hint: 'Enter your email', controller: _emailController),
                const SizedBox(height: 20),
                _buildLabel("Password"),
                InputField(
                    hint: 'Enter your password',
                    controller: _passwordController,
                    obscure: true),
                const SizedBox(height: 40),
                PrimaryButton(text: 'Login', onPressed: _handleLogin),
                const SizedBox(height: 25),
                _buildFooter("Don't have an account? ", "SignUp",
                    () => context.go(RouteNames.signup)),
              ],
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
                  fontSize: 16)),
        ),
      );
}
