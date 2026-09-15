import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'elevation_profile_view.dart';
import 'hiking_state.dart';
import 'milestone_badges_view.dart';
import 'nordivex_theme.dart';
import 'summit_registry_view.dart';
import 'trail_gear_view.dart';

class NordivexSummitApp extends StatelessWidget {
  const NordivexSummitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HikingState>(
      create: (_) => HikingState(),
      child: MaterialApp(
        title: 'Nordivex Alpine Tracker',
        debugShowCheckedModeBanner: false,
        theme: NordivexTheme.themeData(),
        home: const _NordivexHomeShell(),
      ),
    );
  }
}

class _NordivexHomeShell extends StatefulWidget {
  const _NordivexHomeShell();

  @override
  State<_NordivexHomeShell> createState() => _NordivexHomeShellState();
}

class _NordivexHomeShellState extends State<_NordivexHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    SummitRegistryView(),
    ElevationProfileView(),
    TrailGearView(),
    MilestoneBadgesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.landscape_outlined),
            selectedIcon: Icon(Icons.landscape_rounded),
            label: 'Summits',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart_rounded),
            label: 'Elevation',
          ),
          NavigationDestination(
            icon: Icon(Icons.backpack_outlined),
            selectedIcon: Icon(Icons.backpack_rounded),
            label: 'Gear Pack',
          ),
          NavigationDestination(
            icon: Icon(Icons.military_tech_outlined),
            selectedIcon: Icon(Icons.military_tech_rounded),
            label: 'Badges',
          ),
        ],
      ),
    );
  }
}
