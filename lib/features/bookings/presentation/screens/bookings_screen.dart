import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/core/theme/app_colors.dart';
import 'package:smart_campus_app/core/widgets/booking_card.dart';
import 'package:smart_campus_app/core/widgets/confirmation_dialog.dart';
import 'package:smart_campus_app/core/widgets/main_header.dart';
import 'package:smart_campus_app/core/widgets/user_bottom_nav_bar.dart';

import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';
import 'package:smart_campus_app/features/bookings/presentation/providers/booking_provider.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This watches the provider. Whenever create/update/cancel
    // calls getBookings(), the UI will automatically refresh.
    final bookingState = ref.watch(bookingNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeaderWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Text(
                'My Bookings',
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: bookingState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text("Error: $error")),
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return const Center(child: Text('No bookings found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingCard(
                        title: booking.facilityName,
                        date: booking.date,
                        time: booking.timeSlot,
                        onEdit: () => context.push(
                          RouteNames.bookingStep,
                          extra: booking,
                        ),
                        onCancel: () => _confirmCancel(context, ref, booking),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 2),
    );
  }

  void _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    BookingModel booking,
  ) {
    CustomDialog.show(
      context: context,
      title: "Cancel Booking?",
      message:
          "Are you sure you want to cancel the booking for ${booking.facilityName}?",
      confirmText: "Yes, Cancel",
      cancelText: "Keep Booking",
      isBookingCancel: true,
      onConfirm: () async {
        Navigator.pop(context);
        // This triggers the API call and re-fetches the list from DB
        await ref
            .read(bookingNotifierProvider.notifier)
            .cancelBooking(booking.id);
      },
    );
  }
}
