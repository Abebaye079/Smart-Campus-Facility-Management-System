import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              "Smart Campus",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text("About Us", style: TextStyle(color: Colors.blue)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text("FAQ", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              const Text(
                "Efficiency by Design",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Streamlining modern educational environments with intelligent infrastructure management.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // IMAGE CARD
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://images.unsplash.com/photo-1562774053-701939374585",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // MISSION CARD
              _buildCard(
                title: "Mission",
                text:
                    "We provide the digital infrastructure needed for students to focus on teaching, while we handle the infrastructure.",
              ),

              const SizedBox(height: 12),

              _buildCard(
                title: "Operational Excellence",
                text:
                    "Ensuring smooth management of all campus facilities through smart automation.",
              ),

              const SizedBox(height: 12),

              _buildCard(
                title: "Unified Control",
                text:
                    "Single interface for all campus facility and resource tracking.",
              ),

              const SizedBox(height: 12),

              _buildCard(
                title: "Smart Scheduling",
                text:
                    "Automated booking system that prevents conflicts and improves utilization.",
              ),

              const SizedBox(height: 12),

              _buildCard(
                title: "Secure Data",
                text: "End-to-end encryption for student and facility records.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // REUSABLE CARD WIDGET
  Widget _buildCard({required String title, required String text}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
