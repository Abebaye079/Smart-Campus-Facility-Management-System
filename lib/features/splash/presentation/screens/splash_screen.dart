import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_app/core/constants/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Login after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(RouteNames.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F5F5,
      ), // Light grey background from image
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Graduation Cap Icon with Gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF2AB0FF), Color(0xFF5A57FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(
                Icons.school,
                size: 180,
                color: Colors.white, // Required for ShaderMask to show
              ),
            ),

            const SizedBox(height: 20),

            // 2. Main Title: "Smart Campus"
            const Text(
              'Smart Campus',
              style: TextStyle(
                color: Color(0xFF3366FF), // Specific blue from image
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 3. Subtitle: "Facility Management"
            const Text(
              'Facility Management',
              style: TextStyle(
                color: Color(0xFF4A89FF),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 40),

            // 4. Custom Loading Indicator (Three Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(8),
                const SizedBox(width: 8),
                _buildDot(16, isLarge: true), // Center dot is larger
                const SizedBox(width: 8),
                _buildDot(8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(double size, {bool isLarge = false}) {
    return Container(
      width: isLarge ? 24 : 12,
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFF2D62ED),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
