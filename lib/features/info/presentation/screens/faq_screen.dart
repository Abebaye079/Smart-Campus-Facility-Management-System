import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      // HEADER
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
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
              child: Text("About Us", style: TextStyle(color: Colors.black)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text("FAQ", style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How can we help?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Find quick answers to common resources and booking spaces.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // BOOKING CARD
            Center(
              child: Container(
                width: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    Icon(Icons.calendar_month, size: 40, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      "Bookings",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // FAQ LIST
            Expanded(
              child: ListView(
                children: const [
                  FaqItem(
                    question: "How do I reserve a lecture hall?",
                    answer:
                        "Go to the Bookings tab, select the building, choose a time slot, and submit your request. The system confirms instantly.",
                  ),
                  FaqItem(
                    question: "Can I cancel a booking at last minute?",
                    answer:
                        "Yes, you can cancel up to 1 hour before the scheduled time.",
                  ),
                  FaqItem(
                    question: "How do I check available rooms?",
                    answer:
                        "Go to Facilities tab and view real-time availability.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.answer,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
