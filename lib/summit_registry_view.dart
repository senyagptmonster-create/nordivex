import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hiking_state.dart';
import 'nordivex_theme.dart';

class SummitRegistryView extends StatelessWidget {
  const SummitRegistryView({super.key});

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _showAddSummitDialog(BuildContext context) {
    final state = context.read<HikingState>();
    final peakController = TextEditingController();
    final rangeController = TextEditingController();
    final altController = TextEditingController();
    final notesController = TextEditingController();
    String difficulty = 'Class 2 Mountain Trail';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: NordivexColors.slateRock,
          title: const Text('Log Summit Ascent', style: TextStyle(color: NordivexColors.textBright)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: peakController,
                  decoration: const InputDecoration(
                    labelText: 'Mountain Peak Name',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: NordivexColors.stoneBorder)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: rangeController,
                  decoration: const InputDecoration(
                    labelText: 'Mountain Range / Region',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: NordivexColors.stoneBorder)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: altController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Summit Altitude (Meters)',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: NordivexColors.stoneBorder)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: difficulty,
                  dropdownColor: NordivexColors.slateRock,
                  decoration: const InputDecoration(
                    labelText: 'Ascent Difficulty Rating',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Class 1 Trail', child: Text('Class 1 Trail (Walking)')),
                    DropdownMenuItem(value: 'Class 2 Mountain Trail', child: Text('Class 2 Mountain Trail (Steep/Rough)')),
                    DropdownMenuItem(value: 'Class 3 Scramble', child: Text('Class 3 (Handholds & Scrambling)')),
                    DropdownMenuItem(value: 'Alpine Snow / Glacier', child: Text('Alpine Snow / Glacier Climb')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => difficulty = val);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Summit Experience Notes',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: NordivexColors.stoneBorder)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: NordivexColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NordivexColors.pineEmerald,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                if (peakController.text.trim().isEmpty) return;
                final alt = int.tryParse(altController.text.trim()) ?? 1500;

                final summit = SummitEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  peakName: peakController.text.trim(),
                  mountainRange: rangeController.text.trim().isEmpty ? 'Alpine' : rangeController.text.trim(),
                  altitudeMeters: alt,
                  ascentDate: DateTime.now(),
                  difficulty: difficulty,
                  notes: notesController.text.trim(),
                );

                state.addSummit(summit);
                Navigator.pop(ctx);
              },
              child: const Text('Register Peak'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HikingState>();
    final summits = state.summits;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.landscape_rounded, color: NordivexColors.pineEmerald),
            SizedBox(width: 8),
            Text('Summit Registry'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddSummitDialog(context),
            icon: const Icon(Icons.add_circle_outline_rounded, color: NordivexColors.pineEmerald),
            tooltip: 'Log Summit Ascent',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Alpine Stats Header
          Row(
            children: [
              Expanded(
                child: _buildAlpineStat(
                  title: 'SUMMITS',
                  value: '${summits.length}',
                  color: NordivexColors.pineEmerald,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAlpineStat(
                  title: 'MAX ALTITUDE',
                  value: '${state.highestAltitude}m',
                  color: NordivexColors.glacierCyan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAlpineStat(
                  title: 'TOTAL GAIN',
                  value: '${state.totalCumulativeElevationGain}m',
                  color: NordivexColors.mountainGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'CONQUERED MOUNTAIN PEAKS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: NordivexColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          if (summits.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Text(
                'No summits registered yet.\nTap the + button to record your first alpine ascent!',
                textAlign: TextAlign.center,
                style: TextStyle(color: NordivexColors.textMuted),
              ),
            )
          else
            ...summits.map((summit) => _buildSummitCard(context, summit, state)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAlpineStat({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: NordivexColors.slateRock,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NordivexColors.stoneBorder),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: NordivexColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSummitCard(BuildContext context, SummitEntry summit, HikingState state) {
    final feet = (summit.altitudeMeters * 3.28084).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NordivexColors.slateRock,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NordivexColors.stoneBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: NordivexColors.stoneElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NordivexColors.pineEmerald.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.terrain_rounded, color: NordivexColors.pineEmerald, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summit.peakName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: NordivexColors.textBright,
                      ),
                    ),
                    Text(
                      '${summit.mountainRange} • ${_formatDate(summit.ascentDate)}',
                      style: const TextStyle(fontSize: 12, color: NordivexColors.textMuted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${summit.altitudeMeters} m',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: NordivexColors.glacierCyan,
                    ),
                  ),
                  Text(
                    '$feet ft',
                    style: const TextStyle(fontSize: 11, color: NordivexColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: NordivexColors.stoneElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: NordivexColors.stoneBorder),
                ),
                child: Text(
                  summit.difficulty,
                  style: const TextStyle(fontSize: 11, color: NordivexColors.mountainGold, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: NordivexColors.textMuted),
                onPressed: () => state.deleteSummit(summit.id),
              ),
            ],
          ),

          if (summit.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: NordivexColors.stoneElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                summit.notes,
                style: const TextStyle(fontSize: 12, color: NordivexColors.textMuted, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
