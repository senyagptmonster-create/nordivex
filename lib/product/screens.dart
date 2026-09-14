import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../app/brand.dart';

class NordivexMain extends StatefulWidget {
  const NordivexMain({super.key});
  @override
  State<NordivexMain> createState() => _NordivexMainState();
}

class _NordivexMainState extends State<NordivexMain> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nordivex', style: AppTheme.display(cSurface)),
        backgroundColor: cAccent,
      ),
      body: PageView(
        controller: _controller,
        children: const [
          SummitRegistryScreen(),
          ElevationProfileScreen(),
          TrailGearChecklistScreen(),
          MilestoneBadgesScreen(),
        ],
      ),
    );
  }
}

class SummitRegistryScreen extends StatelessWidget {
  const SummitRegistryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Summit Registry', style: AppTheme.display(cInk)),
    );
  }
}

class ElevationProfileScreen extends StatelessWidget {
  const ElevationProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Elevation Profile', style: AppTheme.display(cInk)),
    );
  }
}

class TrailGearChecklistScreen extends StatelessWidget {
  const TrailGearChecklistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Trail Gear Checklist', style: AppTheme.display(cInk)),
    );
  }
}

class MilestoneBadgesScreen extends StatelessWidget {
  const MilestoneBadgesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Milestone Badges', style: AppTheme.display(cInk)),
    );
  }
}
