import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hiking_state.dart';
import 'nordivex_theme.dart';

class TrailGearView extends StatefulWidget {
  const TrailGearView({super.key});

  @override
  State<TrailGearView> createState() => _TrailGearViewState();
}

class _TrailGearViewState extends State<TrailGearView> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Shelter', 'Cooking', 'Apparel', 'Safety', 'Navigation'];

  void _showAddGearDialog(BuildContext context) {
    final state = context.read<HikingState>();
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    String category = 'Shelter';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: NordivexColors.slateRock,
          title: const Text('Add Alpine Gear', style: TextStyle(color: NordivexColors.textBright)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Gear Item Name',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: NordivexColors.stoneBorder)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (Grams)',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: NordivexColors.stoneBorder)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  dropdownColor: NordivexColors.slateRock,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: NordivexColors.textMuted),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Shelter', child: Text('Shelter & Sleep')),
                    DropdownMenuItem(value: 'Cooking', child: Text('Cooking & Water')),
                    DropdownMenuItem(value: 'Apparel', child: Text('Apparel & Layering')),
                    DropdownMenuItem(value: 'Safety', child: Text('Alpine Safety & First Aid')),
                    DropdownMenuItem(value: 'Navigation', child: Text('Navigation & Comms')),
                  ],
                  onChanged: (v) {
                    if (v != null) setDialogState(() => category = v);
                  },
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
                if (nameController.text.trim().isEmpty) return;
                final weight = int.tryParse(weightController.text.trim()) ?? 250;

                final item = GearItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  category: category,
                  weightGrams: weight,
                  isPacked: false,
                );

                state.addGear(item);
                Navigator.pop(ctx);
              },
              child: const Text('Add to Pack'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HikingState>();
    final allGear = state.gearList;
    final filteredGear = _selectedCategory == 'All'
        ? allGear
        : allGear.where((g) => g.category == _selectedCategory).toList();

    final totalKg = (state.totalGearWeightGrams / 1000.0).toStringAsFixed(2);
    final packedKg = (state.packedGearWeightGrams / 1000.0).toStringAsFixed(2);
    final progress = state.packingProgress;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.backpack_outlined, color: NordivexColors.pineEmerald),
            SizedBox(width: 8),
            Text('Alpine Pack & Gear Tally'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddGearDialog(context),
            icon: const Icon(Icons.add_circle_outline_rounded, color: NordivexColors.pineEmerald),
            tooltip: 'Add Gear Item',
          ),
        ],
      ),
      body: Column(
        children: [
          // Weight Tally Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: NordivexColors.slateRock,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: NordivexColors.stoneBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PACKED BASE WEIGHT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: NordivexColors.textMuted),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$packedKg / $totalKg kg',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NordivexColors.textBright),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: progress >= 1.0 ? NordivexColors.pineEmerald : NordivexColors.stoneElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        progress >= 1.0 ? 'READY FOR TRAIL' : '${(progress * 100).round()}% PACKED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: progress >= 1.0 ? Colors.black : NordivexColors.glacierCyan,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: NordivexColors.stoneBorder,
                    color: NordivexColors.pineEmerald,
                  ),
                ),
              ],
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: NordivexColors.pineEmerald,
                    backgroundColor: NordivexColors.slateRock,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : NordivexColors.textBright,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? NordivexColors.pineEmerald : NordivexColors.stoneBorder,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          // Gear Items List
          Expanded(
            child: filteredGear.isEmpty
                ? Center(
                    child: Text(
                      'No gear in $_selectedCategory category',
                      style: const TextStyle(color: NordivexColors.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredGear.length,
                    itemBuilder: (context, index) {
                      final item = filteredGear[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: NordivexColors.slateRock,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: item.isPacked ? NordivexColors.pineEmerald.withValues(alpha: 0.4) : NordivexColors.stoneBorder,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          leading: Checkbox(
                            value: item.isPacked,
                            activeColor: NordivexColors.pineEmerald,
                            checkColor: Colors.black,
                            onChanged: (_) => state.toggleGear(item.id),
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: item.isPacked ? NordivexColors.textMuted : NordivexColors.textBright,
                              decoration: item.isPacked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text(
                            item.category,
                            style: const TextStyle(fontSize: 11, color: NordivexColors.textMuted),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.weightGrams}g',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: NordivexColors.glacierCyan,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18, color: NordivexColors.textMuted),
                                onPressed: () => state.deleteGear(item.id),
                              ),
                            ],
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
