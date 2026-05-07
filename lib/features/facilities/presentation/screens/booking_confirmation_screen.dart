import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';


import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String? facilityName;

  const BookingConfirmationScreen({super.key, this.facilityName});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  DateTime _focusedDay = DateTime(2022, 11, 25);
  DateTime? _selectedDay;
  int? _selectedTimeSlotIndex;

  @override
  void initState() {
    super.initState();
    _selectedDay = null; 
  }


  void _handleBooking(BuildContext context) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 2),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFB9E5A8), 
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'Booked Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    // Redirect to bookings page after the message displays
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        context.go('/bookings');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonWidget(onTap: () => context.pop()),
              const SizedBox(height: 25),
              
              Text(
                widget.facilityName ?? 'Room 101',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 42,
                ),
              ),
              const Text(
                'FINIALIZING YOUR BOOKING', 
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

              _buildTimeSlotsGrid(),

              const SizedBox(height: 40),

              PrimaryButton(
                text: 'Confirm Booking',
                onPressed: (_selectedDay == null || _selectedTimeSlotIndex == null) 
                  ? null 
                  : () => _handleBooking(context),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(2022, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: _focusedDay,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.keyboard_double_arrow_left, size: 30),
          rightChevronIcon: Icon(Icons.keyboard_double_arrow_right, size: 30),
        ),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(color: Color(0xFF2D6AFA), shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: Colors.transparent),
          todayTextStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    final List<Map<String, dynamic>> slots = [
      {'time': '9:00 AM - 10:00 AM', 'status': 'Booked', 'available': false},
      {'time': '10:00 AM - 11:00 AM', 'status': 'Available', 'available': true},
      {'time': '11:00 AM - 12:00 AM', 'status': 'Available', 'available': true},
      {'time': '1:00 PM - 2:00 PM', 'status': 'Available', 'available': true},
    ];

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
        bool isAvailable = slots[index]['available'];
        bool isSelected = _selectedTimeSlotIndex == index;

        return GestureDetector(
          onTap: isAvailable ? () => setState(() => _selectedTimeSlotIndex = index) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? const Color(0xFF2D6AFA) : Colors.grey.shade100,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(slots[index]['time'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text("Status: ", style: TextStyle(fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        slots[index]['status'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
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