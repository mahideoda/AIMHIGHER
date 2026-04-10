import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _loading = false;
  Position? _currentPosition;
  String _status = 'Permission required to find nearby centers';

  final List<Map<String, String>> _dummyCoachingCenters = [
    {'name': 'AimHigher Excellence Center', 'distance': '1.2 km', 'address': '123 Main St, Education Hub', 'rating': '4.8'},
    {'name': 'Future Scholars Academy', 'distance': '2.5 km', 'address': '456 Knowledge Ave', 'rating': '4.5'},
    {'name': 'Elite Coaching Institute', 'distance': '3.8 km', 'address': '789 Success Rd', 'rating': '4.2'},
    {'name': 'Bright Spark Tutorials', 'distance': '5.1 km', 'address': '101 Smart Lane', 'rating': '4.9'},
    {'name': 'Knowledge Peak', 'distance': '6.4 km', 'address': '202 Wisdom Blvd', 'rating': '4.0'},
  ];

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      _loading = true;
      _status = 'Requesting permissions...';
    });

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _status = 'Location services are disabled. Please enable them.';
        _loading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _status = 'Location permissions are denied';
          _loading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _status = 'Location permissions are permanently denied. Please enable them in settings.';
        _loading = false;
      });
      return;
    }

    try {
      setState(() => _status = 'Fetching accurate location...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _loading = false;
        _status = 'Showing centers near your current location';
      });
    } catch (e) {
      setState(() {
        _status = 'Error fetching location: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Coaching', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.indigo.withAlpha(40), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  const Icon(Icons.location_on, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  if (_currentPosition != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Accurate to within 10 meters',
                        style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (_currentPosition == null)
                    ElevatedButton(
                      onPressed: _loading ? null : _handleLocationPermission,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A237E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: _loading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Allow & Detect Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (_currentPosition != null)
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _dummyCoachingCenters.length,
                  itemBuilder: (context, index) {
                    final center = _dummyCoachingCenters[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
                        border: Border.all(color: Colors.grey.withAlpha(20)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFF1A237E).withAlpha(15), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.school, color: Color(0xFF1A237E)),
                        ),
                        title: Text(center['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(center['address']!, style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.orange.shade700),
                                const SizedBox(width: 4),
                                Text(center['rating']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                const SizedBox(width: 12),
                                Icon(Icons.directions_walk, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(center['distance']!, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
