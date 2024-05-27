import '../events/event.dart';
import '../events/keyboard/keyboard_event.dart';
import '../events/mouse/mouse_event.dart';
import 'keyboard_type_collection.dart';
import 'mouse_move_collection.dart';

/// Reduces raw events to a collection of events
///
/// Typically, this function is used to reduce raw mouse move events
/// to a single instance of mouse collection event.
///
/// Same goes for keyboard events for typing a bunch of characters.
List<Event> reduceEvents(List<Event> events) {
  if (events.isEmpty) return events;

  List<Event> reducedEvents = [];

  /// Reducing Keyboard Events

  // For every press down and consecutive press release event with the same key,
  // we reduce them to a single event of type [KeyboardTypeCollection] first.
  int n = events.length;
  for (int i = 0; i < n; i++) {
    final Event event = events[i];
    if (event is KeyboardEvent &&
        event.specialKey == null &&
        event.key != null &&
        i + 1 < n &&
        events[i + 1] is KeyboardEvent) {
      final nextEvent = events[i + 1] as KeyboardEvent;
      if (nextEvent.specialKey == null &&
          nextEvent.key != null &&
          nextEvent.key == event.key &&
          event.state == KeyboardButtonState.press &&
          nextEvent.state == KeyboardButtonState.release) {
        reducedEvents.add(KeyboardTypeCollection(keystrokes: event.key!));
        i++;
      } else {
        reducedEvents.add(event);
      }
    } else {
      reducedEvents.add(event);
    }
  }

  // Then all of these who come consecutively are reduced to a single event of type [KeyboardTypeCollection].
  final List<Event> reducedEvents2 = [reducedEvents.first];
  n = reducedEvents.length;
  for (int i = 1; i < n; i++) {
    final Event event = reducedEvents[i];
    if (event is KeyboardTypeCollection &&
        reducedEvents2.last is KeyboardTypeCollection) {
      (reducedEvents2.last as KeyboardTypeCollection).keystrokes +=
          event.keystrokes;
    } else {
      reducedEvents2.add(event);
    }
  }
  reducedEvents = reducedEvents2;

  /// Reducing Mouse Events
  ///
  /// For all consecutive mouse move events, we reduce them to a single event of type [MouseCollection].
  /// Only mouse move events are reduced. Click events are not reduced.
  final reducedEvents3 = <Event>[];
  n = reducedEvents.length;
  for (int i = 0; i < n; i++) {
    final Event event = reducedEvents[i];
    if (event is MouseEvent && event.mouseEventType == MouseEventType.move) {
      if (reducedEvents3.lastOrNull is MouseEventCollection) {
        (reducedEvents3.last as MouseEventCollection).events.add(event);
      } else {
        reducedEvents3.add(MouseEventCollection()..events.add(event));
      }
    } else {
      reducedEvents3.add(event);
    }
  }
  return reducedEvents = reducedEvents3;
}
