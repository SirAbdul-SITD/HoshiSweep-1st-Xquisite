// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/preferences.dart';
import '../utils/audio_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              Text('SETTINGS', style: techno(20, letterSpacing: 3)),
            ]),
          ),
          const SizedBox(height: 20),
          _toggle('SOUND & MUSIC', Preferences.instance.isSoundEnabled(), (v) {
            setState(() {
              Preferences.instance.setSound(v);
              AudioManager.instance.onSoundSettingChanged();
            });
          }),
          _toggle('VIBRATION', Preferences.instance.isVibrationEnabled(), (v) {
            setState(() => Preferences.instance.setVibration(v));
          }),
          const Spacer(),
          Text('${Preferences.instance.totalStars()} ★ EARNED',
              style: techno(14, color: kAccent, letterSpacing: 2)),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: techno(13, letterSpacing: 1.5)),
            Switch(
                value: value,
                onChanged: onChanged,
                activeColor: kAccent),
          ],
        ),
      );
}
