import 'package:launch_at_startup/launch_at_startup.dart';

import '../config.dart';
import 'key_combination_detector.dart';

class BackgroundService {
  static final instance = BackgroundService._();
  static late KeyCombinationDetector keyCombinationDetector;

  BackgroundService._() {
    keyCombinationDetector =
        KeyCombinationDetector(keyCombination: '', onDetect: () {});
  }

  Future<void> start() async {
    await Config.loadFromFile();
    if (Config.startRecordingKeyShortcut == null &&
        Config.startPlayingKeyShortcut == null) {
      await launchAtStartup.disable();
      return;
    }
    throw UnimplementedError('Start the background service.');
  }

  Future<void> restart() async {
    await Config.loadFromFile();
  }
}
