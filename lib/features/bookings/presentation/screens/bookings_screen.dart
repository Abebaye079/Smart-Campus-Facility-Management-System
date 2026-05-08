import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/confirmation_dialog.dart'; 
import '../../../../core/widgets/main_header.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';

class _BookingItem {
  final String id;
  final String title;
  final String date;
  final String time;

  const _BookingItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
  });
}

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final List<_BookingItem> _bookings = [
    const _BookingItem(
      id: '1',
      title: 'Room 101',
      date: 'Wed, Oct 16',
      time: '10:00 AM–11:00 AM',
    ),
    const _BookingItem(
      id: '2',
      title: 'Conference Hall B',
      date: 'Thu, Oct 17',
      time: '1:00 PM–2:00 PM',
    ),
  ];

  bool _showCancelledBanner = false;

  void _onEdit(_BookingItem booking) {
    context.push(RouteNames.bookingStep, extra: booking.id);
  }

  void _onCancel(_BookingItem booking) {
    CustomDialog.show(
      context: context,
      title: "Cancel Booking?",
      message: "Are you sure you want to cancel the booking for ${booking.title} on ${booking.date}?",
      onConfirm: () {
        Navigator.pop(context); // Close dialog
        setState(() {
          _bookings.removeWhere((b) => b.id == booking.id);
          _showCancelledBanner = true;
        });
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showCancelledBanner = false);
        });
      },
    );
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
                  _bookings.isEmpty
                      ? const Center(child: Text('No bookings found.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          itemCount: _bookings.length,
                          itemBuilder: (context, index) {
                            final b = _bookings[index];
                            return BookingCard(
                              title: b.title,
                              date: b.date,
                              time: b.time,
                              onEdit: () => _onEdit(b),
                              onCancel: () => _onCancel(b),
                            );
                          },
                        ),
                  if (_showCancelledBanner)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9999),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.black, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Cancelled Successfully!',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
