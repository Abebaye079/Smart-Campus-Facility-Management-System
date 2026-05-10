import 'package:flutter/material.dart';
import '../../../../core/widgets/main_header.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';
import '../../../../core/theme/app_colors.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), 
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWidget(showLinks: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                children: [
                  const Text(
                    'How can we help?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Find quick answers to common resources and booking spaces.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                 
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined, 
                            size: 64, 
                            color: AppColors.primary
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bookings',
                            style: TextStyle(
                              fontSize: 28, 
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
              
                  _buildFAQItem(
                    'How do I reserve a lecture hall?',
                    'To reserve a lecture hall, navigate to the "Bookings" tab from your dashboard. Select the desired building, choose a time slot, and provide a brief description of the event. Our automated system will confirm availability instantly for regular hours.',
                  ),
                  _buildFAQItem(
                    'Can I cancel a booking at the last minute?',
                    'Cancellations can be made up to 1 hour before the scheduled time via the "My Bookings" section in your profile.',
                  ),
                  _buildFAQItem(
                    'What happens if I forget my login credentials?',
                    'You can use the "Forgot Password" link on the login screen to reset your credentials using your institutional email.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildFAQItem(String question, String answer, {bool isInitiallyExpanded = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
    
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isInitiallyExpanded,
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500, 
              color: Color(0xFF2563EB), 
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.topLeft,
          children: [
            Text(
              answer,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
