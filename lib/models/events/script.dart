import 'event.dart';

class Script {
  String title;
  String? description;
  List<Event> events;

  Script({
    required this.title,
    required this.events,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  Script.fromJson(Map<String, dynamic> data)
      : title = data['title'],
        description = data['description'],
        events = (data['events'] as List<dynamic>)
            .map((e) => Event.parse(e as Map<String, dynamic>))
            .toList();
}
