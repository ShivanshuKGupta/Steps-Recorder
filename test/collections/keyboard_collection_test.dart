import 'package:flutter_test/flutter_test.dart';
import 'package:steps_recorder/models/event_collections/event_collection_functions.dart';
import 'package:steps_recorder/models/event_collections/keyboard_type_collection.dart';
import 'package:steps_recorder/models/event_collections/mouse_move_collection.dart';
import 'package:steps_recorder/models/events/event.dart';
import 'package:steps_recorder/models/events/keyboard/keyboard_event.dart';
import 'package:steps_recorder/models/events/keyboard/special_keys.dart';
import 'package:steps_recorder/models/events/mouse/mouse_event.dart';

void main() {
  group('keyboard collection test', () {
    test('reduce keyboard events', () {
      final events = <Event>[
        KeyboardEvent(state: KeyboardButtonState.press, key: 'a'),
        KeyboardEvent(state: KeyboardButtonState.release, key: 'a'),
        KeyboardEvent(state: KeyboardButtonState.press, key: 'b'),
        KeyboardEvent(state: KeyboardButtonState.release, key: 'b'),
        KeyboardEvent(
            state: KeyboardButtonState.press, specialKey: SpecialKey.ctrl_l),
        KeyboardEvent(state: KeyboardButtonState.press, key: 'c'),
        KeyboardEvent(state: KeyboardButtonState.release, key: 'c'),
        KeyboardEvent(
            state: KeyboardButtonState.release, specialKey: SpecialKey.ctrl_l),
      ];

      final reducedEvents = reduceEvents(events);
      print(reducedEvents);

      expect(reducedEvents.length, 4);
      expect(reducedEvents[0].runtimeType, KeyboardTypeCollection);
      expect((reducedEvents[0] as KeyboardTypeCollection).keystrokes, 'ab');

      expect(reducedEvents[1].runtimeType, KeyboardEvent);

      expect(reducedEvents[2].runtimeType, KeyboardTypeCollection);
      expect((reducedEvents[2] as KeyboardTypeCollection).keystrokes, 'c');

      expect(reducedEvents[3].runtimeType, KeyboardEvent);
    });

    test('reduce mouse events', () {
      final events = <Event>[
        MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.move),
        MouseEvent(x: 1, y: 1, mouseEventType: MouseEventType.move),
        MouseEvent(x: 2, y: 2, mouseEventType: MouseEventType.move),
        MouseEvent(x: 3, y: 3, mouseEventType: MouseEventType.move),
        MouseEvent(x: 4, y: 4, mouseEventType: MouseEventType.move),
        MouseEvent(x: 5, y: 5, mouseEventType: MouseEventType.move),
        MouseEvent(x: 6, y: 6, mouseEventType: MouseEventType.move),
        MouseEvent(x: 7, y: 7, mouseEventType: MouseEventType.move),
        KeyboardEvent(state: KeyboardButtonState.press, key: 'a'),
        KeyboardEvent(state: KeyboardButtonState.release, key: 'a'),
        MouseEvent(x: 4, y: 4, mouseEventType: MouseEventType.move),
        MouseEvent(x: 5, y: 5, mouseEventType: MouseEventType.move),
        MouseEvent(x: 6, y: 6, mouseEventType: MouseEventType.move),
        MouseEvent(x: 7, y: 7, mouseEventType: MouseEventType.move),
      ];

      final reducedEvents = reduceEvents(events);
      print(reducedEvents);

      expect(reducedEvents.length, 3);
      expect(reducedEvents[0].runtimeType, MouseEventCollection);
      expect((reducedEvents[0] as MouseEventCollection).events.length, 8);

      expect(reducedEvents[1].runtimeType, KeyboardTypeCollection);

      expect(reducedEvents[2].runtimeType, MouseEventCollection);
      expect((reducedEvents[2] as MouseEventCollection).events.length, 4);
    });
  });
}
