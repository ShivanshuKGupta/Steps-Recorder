import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/events/keyboard/special_keys.dart';

/// Folder Path where python scripts are stored.
final pythonScriptsFolderPath = kDebugMode
    ? 'F:/S_Data/Flutter_Projects/steps_recorder/python'
    : '${File(Platform.resolvedExecutable).parent.path}/python';

final scriptsFolder = '$pythonScriptsFolderPath/scripts';

class Config {
  /// The key that will stop the recording/playing.
  static SpecialKey endKey = SpecialKey.f12;

  /// The key that will start the recording.
  static String? startRecordingKeyShortcut;

  /// The key that will start playing the last script
  static String? startPlayingKeyShortcut;

  /// The port on which the background service will run.
  static int port = 4040;

  /// The theme mode of the app.
  static ThemeMode themeMode = ThemeMode.system;

  /// The minimum window size of the app.
  static Size minWindowSize = const Size(700, 400);

  /// The initial window size of the app.
  static Size initialWindowSize = const Size(800, 600);

  Config._();

  static Map<String, dynamic> toJson() => {
        'endKey': endKey.name,
        'startRecordingKeyShortcut': startRecordingKeyShortcut,
        'startPlayingKeyShortcut': startPlayingKeyShortcut,
        'port': port,
        'themeMode': themeMode.name,
      };

  static void loadFromJson(Map<String, dynamic> json) {
    endKey =
        SpecialKey.values.where((e) => e.name == json['endKey']).firstOrNull ??
            endKey;
    startRecordingKeyShortcut = json['startRecordingKeyShortcut'];
    startPlayingKeyShortcut = json['startPlayingKeyShortcut'];
    port = int.tryParse(json['port'].toString()) ?? port;
    themeMode = ThemeMode.values
            .where((e) => e.name == json['themeMode'])
            .firstOrNull ??
        themeMode;
  }

  /// Save the current config to the config.json file in the [pythonScriptsFolderPath]
  ///
  /// If the file is corrupted or does not exist,
  /// it will be re-created with default values.
  static Future<void> save() async {
    final file = File('$pythonScriptsFolderPath/config.json');
    await file.writeAsString(json.encode(toJson()));
  }

  static Future<void> loadFromFile() async {
    final file = File('$pythonScriptsFolderPath/config.json');
    try {
      if (!await file.exists()) await save();
      final data = await file.readAsString();

      try {
        loadFromJson(json.decode(data));
      } catch (e) {
        // If the config file is corrupted, delete it.
        log('LoadConfigError', error: 'Config file is corrupted: $e');
        await file.delete();
      }
    } catch (e) {
      log('LoadConfigError', error: e);
    }
  }
}
