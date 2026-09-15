import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hiking_state.dart';
import 'nordivex_theme.dart';

class MilestoneBadgesView extends StatelessWidget {
  const MilestoneBadgesView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HikingState>();
    final maxAlt = state.highestAltitude;
    final count = state.summits.length;
    final isFullyPacked = state.gearList.isNotEmpty && state.packingProgress >= 1.0;

    final List<Map<String, dynamic>> badges = [
      {
        'title': '1,000m Highland Scout',
        'req': 'Ascend past 1,000m elevation',
        'isUnlocked': maxAlt >= 1000,
        'icon': Icons.filter_hdr_rounded,
        'color': NordivexColors.glacierCyan,
      },
      {
        'title': '2,000m Alpine Trekker',
        'req': 'Ascend past 2,000m elevation',
        'isUnlocked': maxAlt >= 2000,
        'icon': Icons.terrain_rounded,
        'color': NordivexColors.pineEmerald,
      },
      {
        'title': '3,000m Glacier Nomad',
        'req': 'Conquer a peak above 3,000m',
        'isUnlocked': maxAlt >= 3000,
        'icon': Icons.ac_unit_rounded,
        'color': NordivexColors.mountainGold,
      },
      {
        'title': '4,000m Cloud Piercer',
        'req': 'Reach extreme 4,000m altitude',
        'isUnlocked': maxAlt >= 4000,
        'icon': Icons.auto_awesome_rounded,
        'color': NordivexColors.summitOrange,
      },
      {
        'title': '5 Summits Veteran',
        'req': 'Complete and log 5 distinct summits',
        'isUnlocked': count >= 5,
        'icon': Icons.military_tech_rounded,
        'color': Colors.purpleAccent,
      },
      {
        'title': 'Alpine Packmaster',
        'req': 'Complete 100% of your trail checklist',
        'isUnlocked': isFullyPacked,
        'icon': Icons.backpack_rounded,
        'color': Colors.tealAccent,
      },
    ];

    final unlockedCount = badges.where((b) => b['isUnlocked'] as bool).length;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.workspace_premium_rounded, color: NordivexColors.mountainGold),
            SizedBox(width: 8),
            Text('Altitude Milestones'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: NordivexColors.slateRock,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: NordivexColors.stoneBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NordivexColors.mountainGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.military_tech_rounded, color: NordivexColors.mountainGold, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$unlockedCount of ${badges.length} Badges Unlocked',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: NordivexColors.textBright,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Highest Conquered Altitude: ${maxAlt}m',
                        style: const TextStyle(fontSize: 12, color: NordivexColors.glacierCyan),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'MOUNTAINEERING ACHIEVEMENTS',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: NordivexColors.textMuted),
          ),
          const SizedBox(height: 10),

          // Grid of Badges
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final b = badges[index];
              final isUnlocked = b['isUnlocked'] as bool;
              final color = b['color'] as Color;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUnlocked ? NordivexColors.slateRock : NordivexColors.stoneElevated.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnlocked ? color.withValues(alpha: 0.6) : NordivexColors.stoneBorder,
                    width: isUnlocked ? 1.5 : 1.0,
                  ),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUnlocked ? color.withValues(alpha: 0.15) : Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        b['icon'] as IconData,
                        size: 30,
                        color: isUnlocked ? color : NordivexColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      b['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? NordivexColors.textBright : NordivexColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      b['req'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, color: NordivexColors.textMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isUnlocked ? color.withValues(alpha: 0.15) : NordivexColors.stoneBorder,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isUnlocked ? 'UNLOCKED' : 'LOCKED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: isUnlocked ? color : NordivexColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
