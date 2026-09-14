import 'package:flutter/foundation.dart';

class NordivexStore extends ChangeNotifier {
  final List<String> _summits = [];
  List<String> get summits => _summits;

  Future<void> addSummit(String name) async {
    _summits.add(name);
    notifyListeners();
  }
}
