import 'package:flutter/material.dart';
import 'package:aimhigher_app/services/auth_service.dart';
import 'stream_assessment_screen.dart';
import 'profile_screen.dart';
import 'location_screen.dart';
import 'trend_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeBody(),
    const StreamAssessmentScreen(),
    const LocationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).cardColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Nearby'),
        ],
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String _userName = 'User';
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final name = await _authService.getUserName();
    setState(() => _userName = name);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/aimhigher_logo.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.rocket_launch, color: Color(0xFF1A237E)),
              ),
            ),
          ),
        ),
        title: const Text(
          'AimHigher',
          style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ).then((_) => _loadUser());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF1A237E),
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Header Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF1A237E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A237E).withAlpha(60),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getGreeting()}, $_userName 👋',
                      style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Future Starts Here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Get transparent, personalized career recommendations based on your unique profile.',
                      style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StreamAssessmentScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A237E),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Start Test', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.auto_awesome, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // AI Insight Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_circle, color: Colors.orange, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Did you know?',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Over 60% of students choose the wrong stream due to lack of guidance. You\'re already ahead!',
                            style: TextStyle(fontSize: 12, color: Colors.brown.withAlpha(200)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'What\'s Trending',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
            ),
            const SizedBox(height: 12),
            
            // Latest Updates List
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTrendCard(
                    context,
                    'The Rise of AI Ethics',
                    'Why philosophy is becoming vital in tech.',
                    '3 min read',
                    Icons.psychology,
                    Colors.purple.shade50,
                  ),
                  _buildTrendCard(
                    context,
                    'Space Tech 2.0',
                    'How new-age startups are reaching orbit.',
                    '5 min read',
                    Icons.rocket,
                    Colors.blue.shade50,
                  ),
                  _buildTrendCard(
                    context,
                    'Future of FinTech',
                    'Digital banking is changing everything.',
                    '4 min read',
                    Icons.account_balance_wallet,
                    Colors.green.shade50,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Quick Tools',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
            ),
            const SizedBox(height: 12),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(Icons.map_outlined, 'Roadmaps', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Complete an assessment to unlock roadmaps')),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(Icons.gps_fixed, 'Find Experts', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationScreen()));
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(BuildContext context, String title, String subtitle, String readTime, IconData icon, Color bgColor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrendDetailScreen(title: title, subtitle: subtitle, icon: icon),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withAlpha(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF1A237E), size: 28),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(readTime, style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withAlpha(50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF1A237E)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          ],
        ),
      ),
    );
  }
}
