import 'dart:convert';
import 'dart:io';

import '../../config.dart';
import '../../services/process_service.dart';
import '../event_collections/event_collection.dart';
import '../events/custom/custom_event.dart';
import '../events/event.dart';
import '../events/keyboard/keyboard_event.dart';
import '../events/mouse/mouse_event.dart';

part 'script_functions.g.dart';

class Script {
  /// The title of the script
  String title;

  /// The description of the script
  String? description;

  /// The list of events in the script
  List<Event> events;

  /// The date and time the script was created
  DateTime createdAt;

  /// The date and time the script was last updated
  DateTime updatedAt;

  /// The path of the script file
  late final String scriptFilePath = '$scriptsFolder/$title.json';

  /// The file object of the script
  late final File scriptFile = File(scriptFilePath);

  /// The service to execute the script
  late final executeService = (ExecuteService.allServices[scriptFilePath] ??=
      ExecuteService(scriptFilePath: scriptFilePath));

  /// The status of the execute service
  ProcessStatus get executeServiceStatus => executeService.status;

  /// The service to watch the script
  late final watchService = (WatchService.allServices[scriptFilePath] ??=
      WatchService(outputScriptFilePath: scriptFilePath));

  /// The status of the watch service
  ProcessStatus get watchServiceStatus => watchService.status;

  Script({
    required this.title,
    required this.events,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final List<Event> convertedEvents = [];
    for (final event in events) {
      if (event is KeyboardEvent ||
          event is MouseEvent ||
          event is CustomEvent) {
        convertedEvents.add(event);
      } else if (event is EventCollection) {
        convertedEvents.addAll(event.buildEvents());
      } else {
        throw 'Event type not supported to be converted in json: ${event.runtimeType}';
      }
    }
    return {
      'title': title,
      'description': description,
      'events': convertedEvents.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Script.fromJson(Map<String, dynamic> data)
      : title = data['title'],
        description = data['description'],
        events = (data['events'] as List<dynamic>)
            .map((e) => Event.parse(e as Map<String, dynamic>))
            .toList(),
        createdAt = DateTime.parse(data['createdAt']),
        updatedAt = DateTime.parse(data['updatedAt']);
}
