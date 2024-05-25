import 'dart:convert';
import 'dart:io';

import '../../../config.dart';
import '../../../services/process_service.dart';
import '../event.dart';

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
  late final File file = File(scriptFilePath);

  /// The service to execute the script
  late final _executeService = ExecuteService(scriptFilePath: scriptFilePath);

  /// The status of the execute service
  ProcessStatus get executeStatus => _executeService.status;

  /// The service to watch the script
  late final _watchService = WatchService(scriptFilePath: scriptFilePath);

  /// The status of the watch service
  ProcessStatus get watchStatus => _watchService.status;

  Script({
    required this.title,
    required this.events,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'events': events.map((e) => e.toJson()).toList(),
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

  /// Create the script file at [scriptFilePath]
  Future<void> create() async {
    if (await file.exists()) {
      throw 'File already exists';
    }
    createdAt = DateTime.now();
    await file.writeAsString(json.encode(toJson()));
  }

  /// Save the script data to the file
  Future<void> save() async {
    if (!await file.exists()) {
      throw Exception('File does not exist');
    }
    updatedAt = DateTime.now();
    await file.writeAsString(json.encode(toJson()));
  }

  /// Deletes the script file
  Future<void> delete() async {
    await file.delete();
  }

  /// Executes the script
  /// Use [watchStatus] to check the status of the service
  Future<void> play() async {
    await _createTmpFile();
    await _executeService.play();
  }

  /// Stops the script execution
  void stop() {
    _executeService.stop();
  }

  /// Records the script
  Future<void> record() async {
    await _watchService.record();
  }

  /// Stops the script recording
  void stopRecording() {
    _watchService.stopRecording();
  }

  /// Adds a listener to the script
  ///
  /// These listeners are called whenever the status of the
  /// [watchStatus] or [executeStatus] changes
  void addListener(void Function(ProcessStatus, String?) listener) {
    _executeService.addListener(listener);
    _watchService.addListener(listener);
  }

  /// Removes a listener from the script
  ///
  /// This listener will no longer be called when the status of the
  /// [watchStatus] or [executeStatus] changes
  void removeListener(void Function(ProcessStatus, String?) listener) {
    _executeService.removeListener(listener);
    _watchService.removeListener(listener);
  }

  /// Creates a temporary file to store the events
  ///
  /// This file is in turn used to execute the script
  /// using the [_executeService]
  Future<void> _createTmpFile() async {
    final tmpFile = File('$scriptFilePath.tmp');
    if (await tmpFile.exists()) {
      await tmpFile.delete();
    }
    await tmpFile.writeAsString(events.map((e) => e.toString()).join('\n'));
  }
}

/// Loads all the scripts from the scripts folder
///
/// Returns a list of [Script] objects from the folder [scriptsFolder]
Future<List<Script>> loadAllScripts() async {
  final folder = Directory(scriptsFolder);
  if (!await folder.exists()) {
    await folder.create();
  }
  final files = await folder.list().toList();
  final scripts = <Script>[];
  for (final file in files) {
    if (!file.path.endsWith('.json')) continue;
    try {
      final script = await loadScript(file.absolute.path);
      scripts.add(script);
    } catch (e) {
      scripts.add(Script(
        title: file.path.split('/').last.split('\\').last.split('.').first,
        description: "This script's file is corrupted",
        events: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }
  return scripts;
}

/// Loads a script from the scripts folder
/// Just give the name of the file not the full path
Future<Script> loadScript(String scriptPath) async {
  final file = File(scriptPath);
  if (!await file.exists()) {
    throw Exception('File does not exist: $scriptPath');
  }
  final data = json.decode(await file.readAsString()) as Map<String, dynamic>;
  return Script.fromJson(data);
}
