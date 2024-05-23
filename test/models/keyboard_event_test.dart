import 'package:flutter_test/flutter_test.dart';
import 'package:steps_recorder/models/events/event.dart';
import 'package:steps_recorder/models/events/keyboard/keyboard_event.dart';
import 'package:steps_recorder/models/events/keyboard/special_keys.dart';

void main() {
  group('Keyboard Event', () {
    test('fromJson & toJson', () {
      Event event = Event.parse({
        'type': 'keyboard',
        'key': 'a',
        'state': 'press',
        'specialKey': 'enter',
      });
      if (event is! KeyboardEvent) {
        fail('Event is not a KeyboardEvent');
      }
      expect(event.key, 'a');
      expect(event.state, KeyboardButtonState.press);
      expect(event.specialKey, SpecialKey.enter);

      final json = event.toJson();
      expect(json['key'], 'a');
      expect(json['state'], 'press');
      expect(json['specialKey'], 'enter');
    });
  });
}
