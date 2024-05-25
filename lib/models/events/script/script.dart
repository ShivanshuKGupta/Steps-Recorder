import 'dart:convert';
import 'dart:io';

import '../../../config.dart';
import '../../../services/execute_service.dart';
import '../event.dart';

class Script extends ExecuteService {
  String title;
  String? description;
  List<Event> events;
  DateTime createdAt;
  DateTime updatedAt;

  File get file => File(scriptFilePath);
  late final executeService = ExecuteService(scriptFilePath: scriptFilePath);

  Script({
    required this.title,
    required this.events,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  }) : super(scriptFilePath: '$scriptsFolder/$title.json');

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
        updatedAt = DateTime.parse(data['updatedAt']),
        super(scriptFilePath: '$scriptsFolder/${data['title']}.json');

  Future<void> create() async {
    if (await file.exists()) {
      throw 'File already exists';
    }
    createdAt = DateTime.now();
    await file.writeAsString(json.encode(toJson()));
  }

  Future<void> save() async {
    if (!await file.exists()) {
      throw Exception('File does not exist');
    }
    updatedAt = DateTime.now();
    await file.writeAsString(json.encode(toJson()));
  }

  Future<void> delete() async {
    await file.delete();
  }

  @override
  Future<void> play() async {
    await _createTmpFile();
    await super.play();
  }

  Future<void> _createTmpFile() async {
    final tmpFile = File('$scriptFilePath.tmp');
    if (await tmpFile.exists()) {
      await tmpFile.delete();
    }
    await tmpFile.writeAsString(events.map((e) => e.toString()).join('\n'));
  }
}

Future<List<Script>> loadScripts() async {
  final folder = Directory(scriptsFolder);
  if (!await folder.exists()) {
    await folder.create();
  }
  final files = await folder.list().map((e) => File(e.path)).toList();
  final scripts = <Script>[];
  for (final file in files) {
    try {
      final script = Script.fromJson(
          (json.decode(await file.readAsString()) as Map<String, dynamic>));
      scripts.add(script);
    } catch (e) {
      scripts.add(Script(
        title: file.path.split('/').last,
        description: "This script's file is corrupted",
        events: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }
  return scripts;
}
