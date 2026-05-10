import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/main_header.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/user_bottom_nav_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/route_names.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWidget(showLinks: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                   
                    const Text(
                      'Efficiency by',
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      'Design',
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold, 
                        color: AppColors.primary, 
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Streamlining modern educational environments with precision infrastructure management.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: 200,
                      child: PrimaryButton(
                        text: 'Get Started',
                        onPressed: () {
                          context.push(RouteNames.facilities); 
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1562774053-701939374585?q=80&w=1000',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    const Text(
                      'Mission',
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        color: AppColors.primary
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '"We provide the digital structural integrity needed for educators to focus on teaching, while we handle the infrastructure."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 18,
                        height: 1.4,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    const Text(
                      'Operational Excellence',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildFeatureCard(
                      'Unified Control',
                      'Single-pane visibility for all campus facility and resource metrics.',
                    ),
                    _buildFeatureCard(
                      'Smart Scheduling',
                      'Automated booking systems that maximize space utilization.',
                    ),
                    _buildFeatureCard(
                      'Secure Data',
                      'Institutional-grade encryption for student and facility records.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildFeatureCard(String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
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
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}
