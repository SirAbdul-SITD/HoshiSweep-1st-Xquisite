// lib/game/game_state.dart
import 'package:flutter/material.dart';
import 'hitori_level.dart';
import '../utils/preferences.dart';
import '../utils/audio_manager.dart';

/// Tap a cell to cycle: normal -> shaded -> circled(keep) -> normal.
/// Win when shaded set matches the solution.
class GameState extends ChangeNotifier {
  late HitoriLevel level;
  late List<int> marks; // 0 normal, 1 shaded, 2 circled
  int moves = 0;
  bool isComplete = false;
  int stars = 0;
  int currentLevelIndex = 0;
  bool initialized = false;

  int get n => level.n;

  void loadLevel(int index) {
    currentLevelIndex = index;
    level = LevelGenerator.generate(index);
    marks = List<int>.filled(n * n, 0);
    moves = 0;
    isComplete = false;
    stars = 0;
    initialized = true;
    notifyListeners();
  }

  void tapCell(int i) {
    if (isComplete) return;
    marks[i] = (marks[i] + 1) % 3;
    moves++;
    AudioManager.instance.playShade();
    _check();
    notifyListeners();
  }

  List<int> _nbrs(int i) {
    final r = i ~/ n, c = i % n;
    return [
      if (r > 0) i - n,
      if (r < n - 1) i + n,
      if (c > 0) i - 1,
      if (c < n - 1) i + 1,
    ];
  }

  bool shadedTouching(int i) {
    if (marks[i] != 1) return false;
    return _nbrs(i).any((x) => marks[x] == 1);
  }

  /// duplicate among unshaded cells in same row/col?
  bool duplicateError(int i) {
    if (marks[i] == 1) return false;
    final v = level.numbers[i];
    final r = i ~/ n, c = i % n;
    for (int cc = 0; cc < n; cc++) {
      final j = r * n + cc;
      if (j != i && marks[j] != 1 && level.numbers[j] == v) return true;
    }
    for (int rr = 0; rr < n; rr++) {
      final j = rr * n + c;
      if (j != i && marks[j] != 1 && level.numbers[j] == v) return true;
    }
    return false;
  }

  int get shadedCount => marks.where((m) => m == 1).length;

  void _check() {
    final shaded = <int>{};
    for (int i = 0; i < n * n; i++) {
      if (marks[i] == 1) shaded.add(i);
    }
    if (shaded.length != level.solution.length) return;
    for (final s in level.solution) {
      if (!shaded.contains(s)) return;
    }
    isComplete = true;
    stars = _calcStars();
    AudioManager.instance.playComplete();
    Preferences.instance.saveLevelResult(currentLevelIndex, stars);
  }

  int _calcStars() {
    final par = level.solution.length;
    if (moves <= (par * 1.6).round()) return 3;
    if (moves <= par * 3) return 2;
    return 1;
  }

  void restartLevel() {
    marks = List<int>.filled(n * n, 0);
    moves = 0;
    isComplete = false;
    stars = 0;
    notifyListeners();
  }

  void nextLevel() {
    if (currentLevelIndex < 149) loadLevel(currentLevelIndex + 1);
  }
}
