import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Ensure GoRouter is imported
import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: authState.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF2AB0FF), Color(0xFF5A57FF)],
                ).createShader(bounds),
                child: const Icon(Icons.school, size: 180, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Smart Campus',
                style: TextStyle(
                  color: Color(0xFF3366FF),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Facility Management',
                style: TextStyle(color: Color(0xFF4A89FF), fontSize: 20),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(),
            ],
          ),
        ),
        data: (user) {
          // Safe execution outside of the widget build pipeline using GoRouter execution paths
          Future.microtask(() {
            if (context.mounted) {
              if (user != null) {
                context.go(
                  '/home',
                ); // Change to match your exact home route string if different
              } else {
                context.go(
                  '/login',
                ); // Change to match your exact login route string if different
              }
            }
          });

          // Show the splash UI layout while GoRouter executes the page replacement transition
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF2AB0FF), Color(0xFF5A57FF)],
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.school,
                    size: 180,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Smart Campus',
                  style: TextStyle(
                    color: Color(0xFF3366FF),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(),
              ],
            ),
          );
        },
        error: (_, __) => const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
