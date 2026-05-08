import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sign up',
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
                  'SIGN UP',
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

                // Full Name
                _buildLabel(context, "Full Name"),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your full name",
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // Email
                _buildLabel(context, "Email"),
                const SizedBox(height: 8),
                const TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                _buildLabel(context, "Password"),
                const SizedBox(height: 8),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Create a password",
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Password
                _buildLabel(context, "Confirm Password"),
                const SizedBox(height: 8),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Repeat your password",
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ Navigate to Home or Login after registration
                      context.go(RouteNames.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
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
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        // ✅ Navigate back to Login
                        context.go(RouteNames.login);
                      },
                      child: const Text(
                        "Login",
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

  // Helper widget to keep the code clean, similar to your Align/Text pattern
  Widget _buildLabel(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
