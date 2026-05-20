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

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  bool _showCancelledBanner = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(bookingNotifierProvider.notifier).getBookings();
    });
  }

  void _onEdit(BookingModel booking) {
    context.push(
      RouteNames.bookingStep,
      extra: booking,
    );
  }

  void _onCancel(BookingModel booking) {
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

        await ref
            .read(bookingNotifierProvider.notifier)
            .cancelBooking(booking.id);

        if (mounted) {
          setState(() {
            _showCancelledBanner = true;
          });

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showCancelledBanner = false;
              });
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

            const SizedBox(height: 10),

            Expanded(
              child: Stack(
                children: [
                  bookingState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),

                    error: (error, stackTrace) => Center(
                      child: Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                    data: (bookings) {
                      if (bookings.isEmpty) {
                        return const Center(
                          child: Text(
                            'No bookings found.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
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
                            onEdit: () => _onEdit(booking),
                            onCancel: () => _onCancel(booking),
                          );
                        },
                      );
                    },
                  ),

                  if (_showCancelledBanner)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9999),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.black,
                              size: 20,
                            ),

                            SizedBox(width: 10),

                            Text(
                              'Cancelled Successfully!',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 2),
    );
  }
}
