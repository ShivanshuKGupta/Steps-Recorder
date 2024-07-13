import 'custom/custom_event.dart';
import 'keyboard/keyboard_event.dart';
import 'mouse/mouse_event.dart';

abstract class Event {
  final String type;

  Event({required this.type});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }

  Event.fromJson(Map<String, dynamic> json) : type = json['type'].toString();

  Event clone();

  static Event parse(Map<String, dynamic> json) {
    final type = json['type'].toString();
    switch (type) {
      case KeyboardEvent.eventType:
        return KeyboardEvent.fromJson(json);
      case MouseEvent.eventType:
        return MouseEvent.fromJson(json);
      case CustomEvent.eventType:
        return CustomEvent.fromJson(json);
      default:
        throw Exception('Unknown event type: $type');
    }
  }
}
