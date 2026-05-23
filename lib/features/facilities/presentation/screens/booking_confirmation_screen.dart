import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:smart_campus_app/core/constants/route_names.dart';
import 'package:smart_campus_app/core/widgets/back_button.dart';
import 'package:smart_campus_app/core/widgets/primary_button.dart';
import 'package:smart_campus_app/core/widgets/user_bottom_nav_bar.dart';
import 'package:smart_campus_app/features/bookings/domain/models/booking_model.dart';
import 'package:smart_campus_app/features/bookings/presentation/providers/booking_provider.dart';
import 'package:smart_campus_app/features/facilities/domain/models/facility_model.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final FacilityModel? facility;
  final BookingModel? existingBooking;

  const BookingConfirmationScreen({
    super.key,
    this.facility,
    this.existingBooking,
  });

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _selectedTimeSlotIndex;
  final TextEditingController _purposeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    // Pre-fill purpose if editing existing booking
    if (widget.existingBooking != null) {
      _purposeController.text = widget.existingBooking!.purpose;
    }

    // Load availability for today
    final facilityId =
        widget.facility?.id ?? widget.existingBooking?.facilityId ?? '';

    if (facilityId.isNotEmpty) {
      Future.microtask(() {
        ref
            .read(availabilityProvider.notifier)
            .getAvailability(facilityId, _selectedDay.toString().split(' ')[0]);
      });
    }
  }

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _handleBooking() async {
    // Validate purpose field
    if (_purposeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter the purpose of booking'),
        ),
      );
      return;
    }

    if (_selectedTimeSlotIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a time slot'),
        ),
      );
      return;
    }

    final availabilityState = ref.read(availabilityProvider);
    if (availabilityState.value == null) return;

    final selectedSlot = availabilityState.value![_selectedTimeSlotIndex!];

    final facilityId =
        widget.facility?.id ?? widget.existingBooking?.facilityId ?? '';

    final facilityName =
        widget.facility?.name ?? widget.existingBooking?.facilityName ?? '';

    final date = _selectedDay.toString().split(' ')[0];
    final timeSlot = selectedSlot['time'].toString();
    final purpose = _purposeController.text.trim();

    try {
      if (widget.existingBooking != null) {
        // Edit existing booking
        final updatedBooking = BookingModel(
          id: widget.existingBooking!.id,
          facilityId: facilityId,
          facilityName: facilityName,
          date: date,
          timeSlot: timeSlot,
          purpose: purpose,
          status: 'booked',
        );
        await ref
            .read(bookingNotifierProvider.notifier)
            .updateBooking(updatedBooking);
      } else {
        // Create new booking
        await ref
            .read(bookingNotifierProvider.notifier)
            .createBooking(
              facilityId: facilityId,
              date: date,
              timeSlot: timeSlot,
              purpose: purpose,
            );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.existingBooking != null
                  ? 'Booking Updated Successfully!'
                  : 'Booked Successfully!',
            ),
          ),
        );
        context.go(RouteNames.bookings);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availabilityState = ref.watch(availabilityProvider);
    final bookingState = ref.watch(bookingNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    final facilityName =
        widget.facility?.name ??
        widget.existingBooking?.facilityName ??
        'Facility';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonWidget(onTap: () => context.pop()),
              const SizedBox(height: 25),

              Text(
                facilityName,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 42,
                ),
              ),

              const Text(
                'FINALIZING YOUR BOOKING',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 25),
              _buildCalendarCard(),
              const SizedBox(height: 30),

              const Text(
                'Select Time Slot',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),

              const SizedBox(height: 20),

              availabilityState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Column(
                    children: [
                      const Text(
                        'Failed to load time slots',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          final facilityId =
                              widget.facility?.id ??
                              widget.existingBooking?.facilityId ??
                              '';
                          ref
                              .read(availabilityProvider.notifier)
                              .getAvailability(
                                facilityId,
                                _selectedDay.toString().split(' ')[0],
                              );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (slots) => slots.isEmpty
                    ? const Center(child: Text('No time slots available'))
                    : _buildTimeSlotsGrid(slots),
              ),

              const SizedBox(height: 30),
              // Purpose field
              TextField(
                controller: _purposeController,
                decoration: InputDecoration(
                  hintText: 'Purpose of booking',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              bookingState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      text: widget.existingBooking != null
                          ? 'Update Booking'
                          : 'Confirm Booking',
                      onPressed:
                          (_selectedDay == null ||
                              _selectedTimeSlotIndex == null)
                          ? null
                          : _handleBooking,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(2022, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedTimeSlotIndex = null;
          });
          final facilityId =
              widget.facility?.id ?? widget.existingBooking?.facilityId ?? '';
          ref
              .read(availabilityProvider.notifier)
              .getAvailability(
                facilityId,
                selectedDay.toString().split(' ')[0],
              );
        },
      ),
    );
  }

  Widget _buildTimeSlotsGrid(List<Map<String, dynamic>> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.1,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final bool isAvailable = slot['available'] == true;
        final bool isSelected = _selectedTimeSlotIndex == index;
        return GestureDetector(
          onTap: isAvailable
              ? () => setState(() => _selectedTimeSlotIndex = index)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2D6AFA)
                    : Colors.grey.shade100,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot['time'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isAvailable ? 'Available' : 'Booked',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
