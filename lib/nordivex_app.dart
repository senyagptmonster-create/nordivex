import 'package:flutter/material.dart';
import 'theme/nordivex_theme.dart';
import 'painters/summit_elevation_painter.dart';

class NordivexApp extends StatefulWidget {
  const NordivexApp({super.key});

  @override
  State<NordivexApp> createState() => _NordivexAppState();
}

class _NordivexAppState extends State<NordivexApp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _summits = [
    {'name': 'Mont Blanc', 'elevation': 4809, 'range': 'Graian Alps', 'ascent': '4,809 m', 'conquered': true},
    {'name': 'Matterhorn', 'elevation': 4478, 'range': 'Pennine Alps', 'ascent': '4,478 m', 'conquered': true},
    {'name': 'Mount Whitney', 'elevation': 4421, 'range': 'Sierra Nevada', 'ascent': '4,421 m', 'conquered': false},
    {'name': 'Zugspitze', 'elevation': 2962, 'range': 'Wetterstein', 'ascent': '2,962 m', 'conquered': true},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nordivex Expeditions',
      debugShowCheckedModeBanner: false,
      theme: NordivexTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NORDIVEX SUMMITS',
              style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold, fontSize: 16)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  children: [
                    _buildSummitsPage(),
                    _buildElevationProfilePage(),
                    _buildGearPage(),
                    _buildMilestonesPage(),
                  ],
                ),
              ),
              // Page indicator dots
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final isSel = _currentPage == i;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSel ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSel ? NordivexTheme.accent : NordivexTheme.edge,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummitsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Alpine Summit Registry',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._summits.map((summit) {
          final isDone = summit['conquered'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NordivexTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: NordivexTheme.edge),
            ),
            child: Row(
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? NordivexTheme.accent : NordivexTheme.muted,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(summit['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(summit['range'] as String,
                          style: const TextStyle(color: NordivexTheme.muted, fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: NordivexTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${summit['elevation']} m',
                    style: const TextStyle(color: NordivexTheme.accent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildElevationProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Topographic Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Visual ridge ascent and altitude contours', style: TextStyle(color: NordivexTheme.muted)),
          const SizedBox(height: 20),
          Container(
            height: 240,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NordivexTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NordivexTheme.edge),
            ),
            child: CustomPaint(
              painter: SummitElevationPainter(elevations: const [2962, 4421, 4478, 4809]),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Total Vertical Ascent Logged: 12,249 m',
              style: TextStyle(color: NordivexTheme.accent, fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildGearPage() {
    final gear = [
      {'item': 'Bivy Shelter & Sleeping Bag', 'weight': '1.8 kg'},
      {'item': 'Crampons & Ice Axe', 'weight': '1.4 kg'},
      {'item': 'Alpine Harness & Carabiners', 'weight': '0.9 kg'},
      {'item': 'Jetboil Stove & Gas', 'weight': '0.6 kg'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Trail Pack Base Weight', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...gear.map((g) => Card(
              color: NordivexTheme.surface,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: NordivexTheme.edge),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.backpack_outlined, color: NordivexTheme.accent),
                title: Text(g['item'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Text(g['weight'] as String,
                    style: const TextStyle(color: NordivexTheme.accentLight, fontWeight: FontWeight.bold)),
              ),
            )),
      ],
    );
  }

  Widget _buildMilestonesPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Altitude Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _badgeItem('Alpine Initiate (1000m)', 'Completed 5 lower peaks', true),
          _badgeItem('High Ridge Master (3000m)', 'Zugspitze summit achieved', true),
          _badgeItem('Four-Thousander Club', 'Matterhorn & Mont Blanc conquered', true),
          _badgeItem('Seven Summits Contender', 'High alpine expedition pending', false),
        ],
      ),
    );
  }

  Widget _badgeItem(String title, String desc, bool unlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NordivexTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: unlocked ? NordivexTheme.accent.withValues(alpha: 0.4) : NordivexTheme.edge),
      ),
      child: Row(
        children: [
          Icon(
            unlocked ? Icons.military_tech : Icons.lock_outline,
            color: unlocked ? NordivexTheme.accent : NordivexTheme.muted,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(desc, style: const TextStyle(color: NordivexTheme.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
