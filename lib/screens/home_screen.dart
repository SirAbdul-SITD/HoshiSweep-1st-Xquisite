// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/preferences.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB0852E), Color(0xFFE0B24C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFFE0B24C).withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 4),
                ],
              ),
              child: const Icon(Icons.grid_4x4_rounded, color: kAccent, size: 80),
            ),
            const SizedBox(height: 28),
            Text('HOSHI SWEEP', style: techno(34, letterSpacing: 6)),
            const SizedBox(height: 8),
            Text('ONE OF EACH PER LINE',
                style: techno(12, color: kTextDim, letterSpacing: 3)),
            const Spacer(flex: 2),
            _menuButton(context, 'PLAY', Icons.play_arrow_rounded, true, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LevelSelectScreen()));
            }),
            const SizedBox(height: 14),
            _menuButton(context, 'SETTINGS', Icons.settings_rounded, false, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
            }),
            const Spacer(flex: 1),
            Text('${Preferences.instance.totalStars()} / 450 STARS',
                style: techno(12, color: kTextDim, letterSpacing: 2)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String label, IconData icon,
          bool primary, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 240,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: primary
                ? const LinearGradient(colors: [Color(0xFFB0852E), Color(0xFFE0B24C)])
                : null,
            color: primary ? null : kSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: primary ? kAccent.withOpacity(0.5) : kBorder),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: primary ? kBg : kTextPrimary, size: 22),
            const SizedBox(width: 10),
            Text(label,
                style: techno(16,
                    color: primary ? kBg : kTextPrimary, letterSpacing: 3)),
          ]),
        ),
      );
}
