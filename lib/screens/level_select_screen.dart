// lib/screens/level_select_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/preferences.dart';
import '../main.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});
  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) routeObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kBorder)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: kTextDim, size: 16),
                ),
              ),
              const SizedBox(width: 16),
              Text('SELECT LEVEL', style: techno(20, letterSpacing: 3)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _section('EASY', kEasyColor, 0, 49, '5×5'),
                _section('MEDIUM', kMediumColor, 50, 99, '7×7'),
                _section('HARD', kHardColor, 100, 149, '9×9'),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _section(String title, Color color, int start, int end, String size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8, left: 4),
          child: Row(children: [
            Text(title, style: techno(15, color: color, letterSpacing: 2)),
            const SizedBox(width: 8),
            Text(size, style: techno(11, color: kTextDim, letterSpacing: 1)),
          ]),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1),
          itemCount: end - start + 1,
          itemBuilder: (ctx, i) {
            final lvl = start + i;
            final stars = Preferences.instance.getStars(lvl);
            final unlocked = Preferences.instance.isUnlocked(lvl);
            return GestureDetector(
              onTap: unlocked
                  ? () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => GameScreen(levelIndex: lvl)))
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: unlocked ? kSurface : kSurface.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: stars > 0 ? color.withOpacity(0.6) : kBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!unlocked)
                      const Icon(Icons.lock_rounded, color: kTextDim, size: 16)
                    else ...[
                      Text('${lvl + 1}',
                          style: techno(15,
                              color: unlocked ? kTextPrimary : kTextDim)),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            3,
                            (s) => Icon(
                                  s < stars
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: s < stars ? kStarOn : kStarOff,
                                  size: 9,
                                )),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
