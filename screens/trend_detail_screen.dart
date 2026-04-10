import 'package:flutter/material.dart';

class TrendDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const TrendDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career Trend')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 80, color: const Color(0xFF1A237E)),
              ),
            ),
            const SizedBox(height: 32),
            Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(subtitle, style: const TextStyle(fontSize: 18, color: Colors.grey, height: 1.4)),
            const SizedBox(height: 32),
            const Text('Why this is trending?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'As industries evolve, this field is seeing a massive surge in demand. Companies are looking for fresh talent who can adapt to new challenges and bring creative solutions to the table.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            const Text('Expected Growth', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            const Text('85% projected growth in the next 5 years', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
