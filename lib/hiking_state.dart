import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummitEntry {
  final String id;
  final String peakName;
  final String mountainRange;
  final int altitudeMeters;
  final DateTime ascentDate;
  final String difficulty;
  final String notes;

  SummitEntry({
    required this.id,
    required this.peakName,
    required this.mountainRange,
    required this.altitudeMeters,
    required this.ascentDate,
    required this.difficulty,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'peakName': peakName,
        'mountainRange': mountainRange,
        'altitudeMeters': altitudeMeters,
        'ascentDate': ascentDate.toIso8601String(),
        'difficulty': difficulty,
        'notes': notes,
      };

  factory SummitEntry.fromJson(Map<String, dynamic> json) => SummitEntry(
        id: json['id'] as String,
        peakName: json['peakName'] as String,
        mountainRange: json['mountainRange'] as String,
        altitudeMeters: json['altitudeMeters'] as int,
        ascentDate: DateTime.parse(json['ascentDate'] as String),
        difficulty: json['difficulty'] as String,
        notes: (json['notes'] as String?) ?? '',
      );
}

class GearItem {
  final String id;
  final String name;
  final String category; // Shelter, Cooking, Apparel, Safety, Navigation
  final int weightGrams;
  bool isPacked;

  GearItem({
    required this.id,
    required this.name,
    required this.category,
    required this.weightGrams,
    this.isPacked = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'weightGrams': weightGrams,
        'isPacked': isPacked,
      };

  factory GearItem.fromJson(Map<String, dynamic> json) => GearItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        weightGrams: json['weightGrams'] as int,
        isPacked: (json['isPacked'] as bool?) ?? false,
      );
}

class HikingState extends ChangeNotifier {
  static const String _keySummits = 'nordivex_summits';
  static const String _keyGear = 'nordivex_gear';
  static const String _keyTrailhead = 'nordivex_trailhead_alt';
  static const String _keyTargetPeak = 'nordivex_target_peak_alt';
  static const String _keyDistance = 'nordivex_trail_distance_km';

  List<SummitEntry> _summits = [];
  List<GearItem> _gearList = [];

  // Elevation Calculator
  double _trailheadAlt = 1050.0;
  double _targetPeakAlt = 2962.0;
  double _trailDistanceKm = 11.5;

  HikingState() {
    _loadState();
  }

  List<SummitEntry> get summits => List.unmodifiable(_summits);
  List<GearItem> get gearList => List.unmodifiable(_gearList);

  double get trailheadAlt => _trailheadAlt;
  double get targetPeakAlt => _targetPeakAlt;
  double get trailDistanceKm => _trailDistanceKm;

  int get totalElevationGain => (_targetPeakAlt - _trailheadAlt).clamp(0, 8848).round();

  int get highestAltitude {
    if (_summits.isEmpty) return 0;
    return _summits.map((s) => s.altitudeMeters).reduce((a, b) => a > b ? a : b);
  }

  int get totalCumulativeElevationGain {
    return _summits.fold(0, (sum, s) => sum + s.altitudeMeters);
  }

  int get totalGearWeightGrams {
    return _gearList.fold(0, (sum, g) => sum + g.weightGrams);
  }

  int get packedGearWeightGrams {
    return _gearList.where((g) => g.isPacked).fold(0, (sum, g) => sum + g.weightGrams);
  }

  double get packingProgress {
    if (_gearList.isEmpty) return 0.0;
    return _gearList.where((g) => g.isPacked).length / _gearList.length;
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _trailheadAlt = prefs.getDouble(_keyTrailhead) ?? 1050.0;
      _targetPeakAlt = prefs.getDouble(_keyTargetPeak) ?? 2962.0;
      _trailDistanceKm = prefs.getDouble(_keyDistance) ?? 11.5;

      final rawSummits = prefs.getStringList(_keySummits);
      if (rawSummits != null && rawSummits.isNotEmpty) {
        _summits = rawSummits
            .map((str) => SummitEntry.fromJson(jsonDecode(str) as Map<String, dynamic>))
            .toList();
      } else {
        _summits = [
          SummitEntry(
            id: 'peak-1',
            peakName: 'Zugspitze',
            mountainRange: 'Bavarian Alps',
            altitudeMeters: 2962,
            ascentDate: DateTime.now().subtract(const Duration(days: 45)),
            difficulty: 'Class 3 (Klettersteig)',
            notes: 'Via Reintal route, clear sky and icy morning summit crest.',
          ),
          SummitEntry(
            id: 'peak-2',
            peakName: 'Mount Hood (South Route)',
            mountainRange: 'Cascade Range',
            altitudeMeters: 3429,
            ascentDate: DateTime.now().subtract(const Duration(days: 120)),
            difficulty: 'Alpine Snow Climb',
            notes: 'Pearly Gates crossing before dawn, crampons and ice axe.',
          ),
          SummitEntry(
            id: 'peak-3',
            peakName: 'Scafell Pike',
            mountainRange: 'Lake District',
            altitudeMeters: 978,
            ascentDate: DateTime.now().subtract(const Duration(days: 200)),
            difficulty: 'Class 1 Trail',
            notes: 'Misty ascent via Wasdale Head, rocky plateau.',
          ),
        ];
      }

      final rawGear = prefs.getStringList(_keyGear);
      if (rawGear != null && rawGear.isNotEmpty) {
        _gearList = rawGear
            .map((str) => GearItem.fromJson(jsonDecode(str) as Map<String, dynamic>))
            .toList();
      } else {
        _gearList = [
          GearItem(id: 'g-1', name: 'Ultralight 2P Alpine Tent', category: 'Shelter', weightGrams: 1150, isPacked: true),
          GearItem(id: 'g-2', name: '850 FP Down Sleeping Bag (-7°C)', category: 'Shelter', weightGrams: 780, isPacked: true),
          GearItem(id: 'g-3', name: 'Canister Micro Stove & 650ml Pot', category: 'Cooking', weightGrams: 230, isPacked: false),
          GearItem(id: 'g-4', name: 'Gore-Tex Pro Hardshell Jacket', category: 'Apparel', weightGrams: 390, isPacked: true),
          GearItem(id: 'g-5', name: 'Aluminum 10-Point Crampons', category: 'Safety', weightGrams: 590, isPacked: false),
          GearItem(id: 'g-6', name: 'Satellite InReach SOS Communicator', category: 'Navigation', weightGrams: 100, isPacked: true),
          GearItem(id: 'g-7', name: 'Emergency Bivy & First Aid Kit', category: 'Safety', weightGrams: 290, isPacked: true),
        ];
      }
    } catch (e) {
      debugPrint('Error loading nordivex state: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> addSummit(SummitEntry summit) async {
    _summits.insert(0, summit);
    notifyListeners();
    await _persistSummits();
  }

  Future<void> deleteSummit(String id) async {
    _summits.removeWhere((s) => s.id == id);
    notifyListeners();
    await _persistSummits();
  }

  Future<void> toggleGear(String id) async {
    final item = _gearList.firstWhere((g) => g.id == id);
    item.isPacked = !item.isPacked;
    notifyListeners();
    await _persistGear();
  }

  Future<void> addGear(GearItem item) async {
    _gearList.add(item);
    notifyListeners();
    await _persistGear();
  }

  Future<void> deleteGear(String id) async {
    _gearList.removeWhere((g) => g.id == id);
    notifyListeners();
    await _persistGear();
  }

  void setElevationParams({double? start, double? peak, double? dist}) {
    if (start != null) _trailheadAlt = start.clamp(0, 8000);
    if (peak != null) _targetPeakAlt = peak.clamp(0, 8848);
    if (dist != null) _trailDistanceKm = dist.clamp(1.0, 100.0);
    notifyListeners();
    _persistElevationParams();
  }

  Future<void> _persistElevationParams() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTrailhead, _trailheadAlt);
    await prefs.setDouble(_keyTargetPeak, _targetPeakAlt);
    await prefs.setDouble(_keyDistance, _trailDistanceKm);
  }

  Future<void> _persistSummits() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _summits.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_keySummits, list);
  }

  Future<void> _persistGear() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _gearList.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_keyGear, list);
  }
}
