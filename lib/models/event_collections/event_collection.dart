import '../events/event.dart';

/// Just a collection class to hold multiple events.
/// It is used to reduce the amount of events that are shown in the UI.
abstract class EventCollection extends Event {
  EventCollection({required super.type});

  List<Event> buildEvents();

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json;
  }

  @override
  EventCollection.fromJson(super.json) : super.fromJson() {
    throw 'Events if type KeyboardTypeCollection should not be converted from JSON. Use buildEvents() instead.';
  }
}
