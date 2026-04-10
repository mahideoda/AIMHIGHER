import 'package:flutter/material.dart';
import 'roadmap_screen.dart';

class ResultScreen extends StatelessWidget {
  final String stream;
  final String career;
  final List<String> alternatives;
  final int matchPercentage;
  final String whyReason;
  final Map<String, int> scores;
  final String userDream;
  final List<String> strengths;
  final List<String> weaknesses;

  const ResultScreen({
    super.key,
    required this.stream,
    required this.career,
    required this.alternatives,
    required this.matchPercentage,
    required this.whyReason,
    required this.scores,
    required this.userDream,
    required this.strengths,
    required this.weaknesses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: matchPercentage / 100,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.withAlpha(30),
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      Text(
                        '$matchPercentage%',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('AI Compatibility Match', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Smart Alignment Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withAlpha(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology, color: Colors.orange),
                      SizedBox(width: 10),
                      Text('Smart Alignment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('You want to become: $userDream', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('AI Recommends: $stream ($career)', style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  const Text('Final Path: We will align your dream with the best possible path in our detailed roadmap.', 
                    style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text('Your Strengths & Weaknesses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Strengths
            ...strengths.map((s) => _buildPoint(s, Icons.check_circle, Colors.green)),
            const SizedBox(height: 8),
            // Weaknesses
            ...weaknesses.map((w) => _buildPoint(w, Icons.warning, Colors.redAccent)),

            const SizedBox(height: 32),
            const Text('Industry Compatibility Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildScoreBar('Science', scores['science']! / 100, Colors.blue),
            _buildScoreBar('Commerce', scores['commerce']! / 100, Colors.green),
            _buildScoreBar('Arts', scores['arts']! / 100, Colors.orange),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoadmapScreen(
                        career: career,
                        stream: stream,
                        userDream: userDream,
                        strengths: strengths,
                        weaknesses: weaknesses,
                      ),
                    ),
                  );
                },
                child: const Text('Generate Detailed Roadmap', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPoint(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(progress * 100).toInt()}%', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: color.withAlpha(30),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E).withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A237E).withAlpha(30)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A237E), size: 30),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            ],
          ),
        ],
      ),
    );
  }
}
