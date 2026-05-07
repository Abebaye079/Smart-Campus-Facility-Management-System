import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';
import '../../../../core/constants/route_names.dart';

class FacilitiesDetailScreen extends StatelessWidget {
  final String? name;
  final String? capacity;
  final String? description;

  const FacilitiesDetailScreen({
    super.key,
    this.name,
    this.capacity,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayName = name ?? 'Room 101';
    final displayCapacity = capacity ?? '30';
    final displayDescription = description ?? 
        'A spacious classroom with modern projection and seating, ideal for lectures and workshops.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButtonWidget(onTap: () => context.pop()),
                  const SizedBox(width: 20),
                  Text(
                    'Facility Details',
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),              
              Text(
                displayName,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                displayDescription,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Icon(Icons.people_outline, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Capacity: $displayCapacity',
                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Text(
                'Available Time Slots',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),

              _buildTimeSlot(
                context,
                time: '9:00 AM - 10:00 AM',
                status: 'Booked',
                isAvailable: false,
              ),
              const SizedBox(height: 12),
              _buildTimeSlot(
                context,
                time: '10:00 AM - 11:00 AM',
                status: 'Available',
                isAvailable: true,
              ),
              const SizedBox(height: 40),

              PrimaryButton(
                text: 'Book Now',
                onPressed: () => context.push(RouteNames.bookingStep),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildTimeSlot(BuildContext context, {
    required String time, 
    required String status, 
    required bool isAvailable
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                time, 
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textPrimary
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.success : AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}