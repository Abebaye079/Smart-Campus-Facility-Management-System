import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/back_button.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/core/widgets/user_bottom_nav_bar.dart';
import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';

class FacilitiesDetailScreen extends StatelessWidget {
  final FacilityModel facility;

  const FacilitiesDetailScreen({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header navigation row at the top
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
              
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(color: Colors.grey.shade100),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              facility.name,
                              textAlign: TextAlign.center, 
                              style: textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              facility.description.isEmpty
                                  ? 'No description available for this facility.'
                                  : facility.description,
                              textAlign: TextAlign.center, 
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.people_outline, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Text(
                                  'Capacity: ${facility.capacity}',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            
                            PrimaryButton(
                              text: 'Book Now',
                              onPressed: () => context.push(
                                RouteNames.bookingStep, 
                                extra: facility,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 1),
    );
  }
}