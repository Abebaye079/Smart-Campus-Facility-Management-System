import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/facility_card.dart';
import 'package:smart_campus_app/core/widgets/home_header.dart';
import 'package:smart_campus_app/core/widgets/user_bottom_nav_bar.dart';

import 'package:smart_campus_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:smart_campus_app/features/bookings/presentation/providers/booking_provider.dart';
import 'package:smart_campus_app/features/facilities/presentation/providers/facility_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(facilityProvider.notifier).getFacilities();
      ref.read(bookingNotifierProvider.notifier).getBookings();
    });
  }

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authProvider);
    final facilityState = ref.watch(facilityProvider);
    final bookingState = ref.watch(bookingNotifierProvider);

    final user = authState.value;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [

            const HomeHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Welcome, ${user?.name ?? "User"}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'What would you like to do today?',
                    ),

                    const SizedBox(height: 25),

                    Center(
                      child: InkWell(
                        onTap: () => context.push(RouteNames.bookings),

                        child: Container(
                          width: 160,
                          height: 160,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 50,
                                color: AppColors.primary,
                              ),

                              const SizedBox(height: 10),

                              bookingState.when(
                                data: (bookings) => Text(
                                  'My Bookings (${bookings.length})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                loading: () => const CircularProgressIndicator(),

                                error: (_, __) => const Text('Error'),
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
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    facilityState.when(

                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),

                      error: (e, _) => Center(
                        child: Text(
                          e.toString(),
                        ),
                      ),

                      data: (facilities) {

                        if (facilities.isEmpty) {
                          return const Center(
                            child: Text('No facilities available'),
                          );
                        }

                        final previewFacilities =
                            facilities.take(2).toList();

                        return Column(
                          children: previewFacilities.map((facility) {

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),

                              child: FacilityCard(
                                name: facility.name,
                                capacity: facility.capacity.toString(),

                                onBook: () {
                                  context.push(
                                    RouteNames.bookingStep,
                                    extra: facility,
                                  );
                                },

                                onTap: () {
                                  context.push(
                                    RouteNames.facilityDetails,
                                    extra: facility,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          context.push(RouteNames.facilities);
                        },

                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                        ),

                        label: const Text(
                          'View all facilities',
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

      bottomNavigationBar:
          const UserBottomNavBar(currentIndex: 0),
    );
  }
}
