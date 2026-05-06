import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/facility_card.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background, 
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Hana Tesfaye!',
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'What would you like to do today?',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: InkWell(
                        onTap: () => context.push(RouteNames.bookings),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.card, // White card on grey background
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 50, color: AppColors.primary),
                              const SizedBox(height: 10),
                              Text(
                                'My Bookings',
                                style: textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    const Center(
                      child: Text(
                        'Facilities',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FacilityCard(
                      name: 'Room 101',
                      capacity: '30',
                      onBook: () => context.push(RouteNames.bookingStep),
                      onTap: () => context.push(RouteNames.facilityDetails),
                    ),
                    const SizedBox(height: 12),
                    FacilityCard(
                      name: 'Lab A',
                      capacity: '25',
                      onBook: () => context.push(RouteNames.bookingStep),
                      onTap: () => context.push(RouteNames.facilityDetails),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.push(RouteNames.facilities),
                        icon: const Icon(Icons.arrow_forward,
                            size: 16, color: AppColors.primary),
                        label: const Text(
                          'View all facilities',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 0),
    );
  }
}