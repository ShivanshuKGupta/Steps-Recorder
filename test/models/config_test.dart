import 'package:flutter_test/flutter_test.dart';
import 'package:steps_recorder/config.dart';
import 'package:steps_recorder/models/events/keyboard/special_keys.dart';

void main() {
  group('Config tests', () {
    test('Config.toJson', () {
      // Arrange
      Config.endKey = SpecialKey.alt_gr;
      Config.startRecordingKeyShortcut = 'ctrl+alt+shift+r';
      Config.startPlayingKeyShortcut = 'ctrl+alt+shift+p';

      final expected = {
        'endKey': 'alt_gr',
        'startRecordingKeyShortcut': 'ctrl+alt+shift+r',
        'startPlayingKeyShortcut': 'ctrl+alt+shift+p',
      };

      // Act
      final result = Config.toJson();

      // Assert
      expect(result, expected);
    });

    test('Config.loadFromJson', () {
      // Arrange
      final json = {
        'endKey': 'alt_gr',
        'startRecordingKeyShortcut': 'ctrl+alt+shift+r',
        'startPlayingKeyShortcut': 'ctrl+alt+shift+p',
      };

      // Act
      Config.loadFromJson(json);

      // Assert
      expect(Config.endKey, SpecialKey.alt_gr);
      expect(Config.startRecordingKeyShortcut, 'ctrl+alt+shift+r');
      expect(Config.startPlayingKeyShortcut, 'ctrl+alt+shift+p');
    });
  });
}
