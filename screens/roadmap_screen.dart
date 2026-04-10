import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RoadmapScreen extends StatelessWidget {
  final String career;
  final String stream;
  final String userDream;
  final List<String> strengths;
  final List<String> weaknesses;

  const RoadmapScreen({
    super.key,
    required this.career,
    required this.stream,
    required this.userDream,
    required this.strengths,
    required this.weaknesses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Master Roadmap', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            onPressed: () => _generatePdf(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 30),
            _buildSectionTitle('📘 PHASE 1: Class 11–12 (Foundation)'),
            _buildPhaseOne(),
            const SizedBox(height: 30),
            _buildSectionTitle('📈 PHASE 2: After 12th (Decision)'),
            _buildPhaseTwo(),
            const SizedBox(height: 30),
            _buildSectionTitle('🚀 PHASE 3: College & Industry'),
            _buildPhaseThree(),
            const SizedBox(height: 30),
            _buildSectionTitle('🔄 PERSONALIZED IMPROVEMENT PLAN'),
            _buildImprovementPlan(),
            const SizedBox(height: 40),
            _buildDownloadButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TARGET CAREER', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(userDream.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white24, height: 30),
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Text('AI Recommended Stream: $stream', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
    );
  }

  Widget _buildPhaseOne() {
    return _buildStepCard(
      icon: Icons.book_outlined,
      title: 'Goal: Strong Basics & Direction',
      content: stream == 'Science'
          ? 'Study: Physics, Chemistry, Math/Bio.\nSkill: Start basic Python or logic building.\nDaily: 3 hrs self-study + 30 mins reading.'
          : stream == 'Commerce'
              ? 'Study: Accounts, Economics, Business.\nSkill: Basics of Finance & Stock Market.\nDaily: 2 hrs problem solving + News tracking.'
              : 'Study: Psychology, History, Pol Science.\nSkill: Creative Writing & Critical Thinking.\nDaily: 2 hrs reading + Journaling.',
    );
  }

  Widget _buildPhaseTwo() {
    return _buildStepCard(
      icon: Icons.school_outlined,
      title: 'Goal: Professional Specialization',
      content: stream == 'Science'
          ? 'Path: Pursue B.Tech (JEE) or MBBS (NEET).\nFocus: High-level problem solving.\nOutcome: Technical expertise in your chosen domain.'
          : stream == 'Commerce'
              ? 'Path: Pursue CA, CS, or B.Com Honors.\nFocus: Internships in finance firms.\nOutcome: Corporate and market readiness.'
              : 'Path: Pursue BA in Design, Law, or Arts.\nFocus: Portfolio building and research.\nOutcome: Creative mastery and public influence.',
    );
  }

  Widget _buildPhaseThree() {
    return _buildStepCard(
      icon: Icons.rocket_launch_outlined,
      title: 'Goal: Industry Ready',
      content: 'Action: Practical Internships & Projects.\nCertifications: Online courses (Coursera/Udemy).\nNetworking: Join LinkedIn and career communities.',
    );
  }

  Widget _buildImprovementPlan() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withAlpha(30)),
      ),
      child: Column(
        children: [
          _buildPlanRow(Icons.trending_down, 'Subject Weakness', 'Plan: Revise Class 8-10 basics + Daily 10 practice problems.'),
          const Divider(),
          _buildPlanRow(Icons.psychology_outlined, 'Low Confidence', 'Plan: Take small weekly tests + Track improvements regularly.'),
          const Divider(),
          _buildPlanRow(Icons.timer_outlined, 'Distractions', 'Plan: Fixed study blocks + App usage tracking reward system.'),
        ],
      ),
    );
  }

  Widget _buildPlanRow(IconData icon, String title, String plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(plan, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({required IconData icon, required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(20)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF1A237E).withAlpha(10), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF1A237E), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text(content, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () => _generatePdf(context),
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: const Text('Download Full Report (PDF)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('AimHigher Personalized Roadmap', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text('Target Career: $userDream'),
          pw.Text('AI Recommended Stream: $stream'),
          pw.SizedBox(height: 20),
          pw.Text('PHASE 1: Foundation (Class 11-12)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Focus on core $stream subjects and basic skills.'),
          pw.SizedBox(height: 10),
          pw.Text('PHASE 2: Specialization', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Choose professional degrees like B.Tech, MBBS, or CA.'),
          pw.SizedBox(height: 20),
          pw.Text('Personalized Improvement Plan:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Bullet(text: 'Daily problem solving for subjects you find tough.'),
          pw.Bullet(text: 'Weekly mock tests to build confidence.'),
        ],
      ),
    ));
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
