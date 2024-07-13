import '../events/keyboard/keyboard_event.dart';
import 'event_collection.dart';

/// A collection of keyboard events that simulates typing a string of characters.
class KeyboardTypeCollection extends EventCollection {
  static const String eventType = 'keyboard_type_collection';
  String keystrokes = '';

  KeyboardTypeCollection({this.keystrokes = ''}) : super(type: eventType);

  @override
  List<KeyboardEvent> buildEvents() {
    List<KeyboardEvent> events = [];
    for (int i = 0; i < keystrokes.length; i++) {
      events.add(KeyboardEvent(
        state: KeyboardButtonState.press,
        key: keystrokes[i],
      ));
      events.add(KeyboardEvent(
        state: KeyboardButtonState.release,
        key: keystrokes[i],
      ));
    }
    return events;
  }

  @override
  KeyboardTypeCollection clone() {
    return KeyboardTypeCollection(
      keystrokes: keystrokes,
    );
  }
}
