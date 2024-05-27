import '../events/event.dart';
import '../events/mouse/mouse_event.dart';
import 'event_collection.dart';

class MouseEventCollection extends EventCollection {
  static const String eventType = 'mouse_event_collection';
  final List<MouseEvent> events = [];

  MouseEventCollection() : super(type: eventType);

  @override
  List<Event> buildEvents() {
    return events;
  }
}
