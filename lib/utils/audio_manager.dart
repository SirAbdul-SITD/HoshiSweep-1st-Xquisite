// lib/utils/audio_manager.dart
import 'package:audioplayers/audioplayers.dart';
import 'preferences.dart';

class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  final AudioPlayer _music = AudioPlayer();
  final AudioPlayer _sfx = AudioPlayer();
  final List<String> _tracks = [
    'music/ambient_1.wav',
    'music/ambient_2.wav',
    'music/ambient_3.wav',
  ];
  int _track = 0;
  bool _ready = false;

  Future<void> init() async {
    _ready = true;
    await _music.setReleaseMode(ReleaseMode.stop);
    _music.onPlayerComplete.listen((_) => _next());
    _startMusic();
  }

  Future<void> _startMusic() async {
    if (!_ready) return;
    if (!Preferences.instance.isSoundEnabled()) return;
    try {
      await _music.play(AssetSource(_tracks[_track]), volume: 0.5);
    } catch (_) {}
  }

  void _next() {
    _track = (_track + 1) % _tracks.length;
    _startMusic();
  }

  Future<void> _play(String asset) async {
    if (!Preferences.instance.isSoundEnabled()) return;
    try {
      await _sfx.play(AssetSource('sounds/$asset'), volume: 0.7);
    } catch (_) {}
  }

  void playShade() => _play('shade.wav');
  void playComplete() => _play('complete.wav');

  void onSoundSettingChanged() {
    if (Preferences.instance.isSoundEnabled()) {
      _startMusic();
    } else {
      _music.stop();
    }
  }
}
