import 'package:flutter_test/flutter_test.dart';
import 'package:steps_recorder/models/events/keyboard/keyboard_event.dart';
import 'package:steps_recorder/models/events/mouse/mouse_event.dart';
import 'package:steps_recorder/models/script/script.dart';

void main() {
  group('Script Tests', () {
    test('fromJson & toJson', () {
      final script = Script(
        title: 'Test Script',
        description: 'This is a test script',
        events: [
          KeyboardEvent(
            state: KeyboardButtonState.press,
            key: 'a',
          ),
          MouseEvent(
            mouseEventType: MouseEventType.move,
            x: 100,
            y: 100,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final json = script.toJson();
      final newScript = Script.fromJson(json);

      expect(newScript.title, script.title);
      expect(newScript.description, script.description);
      expect(newScript.createdAt, script.createdAt);
      expect(newScript.updatedAt, script.updatedAt);
      expect(newScript.events.length, script.events.length);
      expect(script.events.length, newScript.events.length);
      for (var i = 0; i < newScript.events.length; i++) {
        expect(newScript.events[i].runtimeType, script.events[i].runtimeType);
        expect(newScript.events[i].toJson().toString(),
            script.events[i].toJson().toString());
      }
    });
  });
}
