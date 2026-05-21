import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/confirmation_dialog.dart';
import 'package:smart_campus_app/core/widgets/main_header.dart';
import 'package:smart_campus_app/core/widgets/user_bottom_nav_bar.dart';

import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [

            const MainHeaderWidget(),

            const SizedBox(height: 40),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [

                  Text(
                    user?.name ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      user?.role ?? 'user',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 250,
              height: 50,

              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(authProvider.notifier)
                      .logout();
                },

                child: const Text('Logout'),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: 250,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),

                onPressed: () {

                  CustomDialog.show(
                    context: context,
                    title: 'Delete Account?',
                    message:
                        'Are you sure you want to delete your account?',

                    isDelete: true,

                    onConfirm: () async {

                      Navigator.pop(context);

                      await ref
                          .read(authProvider.notifier)
                          .deleteAccount();
                    },
                  );
                },

                child: const Text(
                  'Delete Account',
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar:
          const UserBottomNavBar(currentIndex: 3),
    );
  }
}
