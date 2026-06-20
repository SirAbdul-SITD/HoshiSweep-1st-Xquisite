// lib/game/hitori_level.dart
import 'dart:math';

/// Hitori ("Hoshi Sweep"). Shade cells so that no number repeats among the
/// UNSHADED cells in any row or column, shaded cells never orthogonally touch,
/// and the unshaded cells stay connected.
///
/// Generation chooses a valid shaded set first (non-adjacent, leaving the rest
/// connected), fills the grid from a Latin base so unshaded cells are already
/// distinct per row/column, then sets each shaded cell's number to duplicate a
/// same-line value (so shading it is justified). The shading is a real solution.
class HitoriLevel {
  final int index;
  final int n;
  final String difficulty;
  final List<int> numbers;   // displayed number per cell
  final Set<int> solution;   // cells that must be shaded
  HitoriLevel({
    required this.index,
    required this.n,
    required this.difficulty,
    required this.numbers,
    required this.solution,
  });
}

class LevelGenerator {
  static HitoriLevel generate(int levelIndex) {
    int n;
    String difficulty;
    if (levelIndex < 50) {
      n = 5; difficulty = 'Easy';
    } else if (levelIndex < 100) {
      n = 7; difficulty = 'Medium';
    } else {
      n = 9; difficulty = 'Hard';
    }
    final rng = Random(levelIndex * 149 + levelIndex * 17 + 7);
    for (int t = 0; t < 60; t++) {
      final res = _build(levelIndex, n, difficulty, Random(rng.nextInt(1 << 31)));
      if (res != null) return res;
    }
    return _build(levelIndex, n, difficulty, Random(1))!;
  }

  static List<int> _nbrs(int i, int n) {
    final r = i ~/ n, c = i % n;
    return [
      if (r > 0) i - n,
      if (r < n - 1) i + n,
      if (c > 0) i - 1,
      if (c < n - 1) i + 1,
    ];
  }

  static HitoriLevel? _build(int index, int n, String diff, Random rng) {
    final shaded = <int>{};
    final cells = List.generate(n * n, (i) => i)..shuffle(rng);
    final cap = (n * n * 0.18).round();
    for (final i in cells) {
      if (shaded.length >= cap) break;
      if (_nbrs(i, n).any(shaded.contains)) continue;
      shaded.add(i);
    }
    final unshaded = [for (int i = 0; i < n * n; i++) if (!shaded.contains(i)) i];
    // connectivity
    final seen = <int>{unshaded.first};
    final st = [unshaded.first];
    while (st.isNotEmpty) {
      final cur = st.removeLast();
      for (final x in _nbrs(cur, n)) {
        if (!shaded.contains(x) && seen.add(x)) st.add(x);
      }
    }
    if (seen.length != unshaded.length) return null;

    // Latin base: value = ((r + c) % n) + 1 -> each row/col already a permutation
    final numbers = List<int>.generate(n * n, (i) => ((i ~/ n + i % n) % n) + 1);
    // each shaded cell duplicates a same-line unshaded value
    for (final s in shaded) {
      final r = s ~/ n, c = s % n;
      final sameLine = [
        for (final i in unshaded)
          if (i ~/ n == r || i % n == c) i
      ];
      if (sameLine.isNotEmpty) {
        numbers[s] = numbers[sameLine[rng.nextInt(sameLine.length)]];
      }
    }

    return HitoriLevel(
      index: index, n: n, difficulty: diff,
      numbers: numbers, solution: shaded,
    );
  }
}
