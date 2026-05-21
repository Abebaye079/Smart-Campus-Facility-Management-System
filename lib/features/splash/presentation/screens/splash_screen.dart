import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Trigger auth check
    Future.microtask(() {
      ref.read(authProvider);
    });
  }

  @override
  Widget build(BuildContext context) {

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
                  colors: [
                    Color(0xFF2AB0FF),
                    Color(0xFF5A57FF),
                  ],
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

              const Text(
                'Facility Management',
                style: TextStyle(
                  color: Color(0xFF4A89FF),
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(),
            ],
          ),
        ),

        data: (_) {
          // Router redirect handles navigation
          return const SizedBox();
        },

        error: (_, __) {
          return const Center(
            child: Text(
              'Something went wrong',
            ),
          );
        },
      ),
    );
  }
}
