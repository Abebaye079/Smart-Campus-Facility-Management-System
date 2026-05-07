import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/facility_card.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/main_header.dart';
import '../../../../core/widgets/search_bar.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeaderWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Facilities',
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: SearchBarWidget(
                controller: _searchController,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  FacilityCard(
                    name: 'Room 101',
                    capacity: '30',
                    onBook: () => context.push(RouteNames.bookingStep),
                    onTap: () => context.push(RouteNames.facilityDetails),
                  ),
                  const SizedBox(height: 16),
                  FacilityCard(
                    name: 'Lab A',
                    capacity: '25',
                    onBook: () => context.push(RouteNames.bookingStep),
                    onTap: () => context.push(RouteNames.facilityDetails),
                  ),
                  const SizedBox(height: 16),
                  FacilityCard(
                    name: 'Library Study Room 4',
                    capacity: '6',
                    onBook: () => context.push(RouteNames.bookingStep),
                    onTap: () => context.push(RouteNames.facilityDetails),
                  ),
                  const SizedBox(height: 16),
                  FacilityCard(
                    name: 'Main Conference Hall',
                    capacity: '150',
                    onBook: () => context.push(RouteNames.bookingStep),
                    onTap: () => context.push(RouteNames.facilityDetails),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 1),
    );
  }
}