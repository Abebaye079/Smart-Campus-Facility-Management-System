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

  String get _facilityId {
    final id = widget.facility?.id ?? widget.existingBooking?.facilityId;

    debugPrint("SELECTED FACILITY ID: $id");

    return id ?? '';
  }

  String get _facilityName =>
      widget.facility?.name ??
      widget.existingBooking?.facilityName ??
      'Room 101';

  @override
  void initState() {
    super.initState();

    _selectedDay = widget.existingBooking != null
        ? DateTime.tryParse(widget.existingBooking!.date) ?? DateTime.now()
        : DateTime.now();

    if (widget.existingBooking != null) {
      _purposeController.text = widget.existingBooking!.purpose;
    }

    if (_facilityId.isNotEmpty) {
      Future.microtask(() {
        ref
            .read(availabilityProvider.notifier)
            .getAvailability(
              _facilityId,
              _selectedDay!.toIso8601String().split('T')[0],
            );
      });
    }
  }

  Future<void> _handleBooking() async {
    final availabilityState = ref.read(availabilityProvider);

    if (availabilityState.value == null || _selectedTimeSlotIndex == null) {
      return;
    }

    final selectedSlot = availabilityState.value![_selectedTimeSlotIndex!];

    final booking = BookingModel(
      id: widget.existingBooking?.id ?? '',
      facilityId: _facilityId,
      facilityName: _facilityName,
      date: _selectedDay!.toIso8601String().split('T')[0],
      timeSlot: selectedSlot['time'],
      purpose: _purposeController.text,
      status: 'booked',
    );

    try {
      if (widget.existingBooking != null) {
        await ref
            .read(bookingNotifierProvider.notifier)
            .updateBooking(widget.existingBooking!.id, booking);
      } else {
        await ref.read(bookingNotifierProvider.notifier).createBooking(booking);
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
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Booking failed: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availabilityState = ref.watch(availabilityProvider);
    final bookingState = ref.watch(bookingNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

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
                _facilityName,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 42,
                ),
              ),

              const Text(
                'FINALIZING YOUR BOOKING',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                error: (error, stack) => Center(child: Text(error.toString())),
                data: (slots) => _buildTimeSlotsGrid(slots),
              ),

              const SizedBox(height: 30),

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
                          (_selectedTimeSlotIndex == null ||
                              _facilityId.isEmpty)
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
      padding: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(2022, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedTimeSlotIndex = null;
          });

          final id = _facilityId;

          if (id.isEmpty) return;

          ref
              .read(availabilityProvider.notifier)
              .getAvailability(id, selectedDay.toIso8601String().split('T')[0]);
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
        final isAvailable = slot['available'] == true;
        final isSelected = _selectedTimeSlotIndex == index;

        return GestureDetector(
          onTap: isAvailable
              ? () {
                  setState(() {
                    _selectedTimeSlotIndex = index;
                  });
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot['time'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  isAvailable ? 'Available' : 'Booked',
                  style: TextStyle(
                    color: isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
