import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    final password = _passwordController.text.trim();

    if (password.length == 8) {
      context.go(RouteNames.adminDashboard);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password must be exactly 8 characters long.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 80),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 80),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                const Text(
                  'LOG IN',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'TO CONTINUE',
                  style: TextStyle(color: AppColors.primaryLight, fontSize: 20),
                ),

                const SizedBox(height: 30),

                // Email
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        context.go(RouteNames.signup);
                      },
                      child: Text(
                        'SignUp',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
