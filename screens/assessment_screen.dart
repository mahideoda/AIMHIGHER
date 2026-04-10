import 'package:flutter/material.dart';
import '../services/assessment_logic.dart';
import 'roadmap_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int _currentQuestionIndex = 0;
  final List<String> _answers = [];
  final _questions = StreamAssessmentLogic.questions;

  void _handleAnswer(String answer) async {
    _answers.add(answer);

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      final result = StreamAssessmentLogic.calculateResult(_answers);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RoadmapScreen(
              career: result['stream'] ?? 'Generalist',
              stream: result['stream'] ?? 'Science',
              userDream: result['dream'] ?? 'Not specified',
              strengths: List<String>.from(result['strengths'] ?? []),
              weaknesses: List<String>.from(result['weaknesses'] ?? []),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Industry-Grade Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1A237E),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${_questions.length}', 
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%', 
                      style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE8EAF6),
                    color: const Color(0xFF1A237E),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  question['q'] ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E), height: 1.3),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: (question['options'] as List).length,
              itemBuilder: (context, index) {
                final option = question['options'][index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleAnswer(option),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF1A237E), width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
