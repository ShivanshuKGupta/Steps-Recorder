import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'models/events/keyboard/special_keys.dart';

final pythonScriptsFolderPath = kDebugMode
    ? 'F:/S_Data/Flutter_Projects/steps_recorder/python'
    : '${Directory.current.absolute.path}${Platform.pathSeparator}python';
final scriptsFolder = '$pythonScriptsFolderPath/scripts';

class Config {
  static SpecialKey endKey = SpecialKey.f12;

  Config._();

  static Map<String, dynamic> toJson() => {
        'endKey': endKey.toString(),
      };

  static void loadFromJson(Map<String, dynamic> json) {
    endKey = SpecialKey.values
            .where((e) => e.toString() == json['endKey'])
            .firstOrNull ??
        endKey;
  }

  static Future<void> save() async {
    final file = File('$pythonScriptsFolderPath/config.json');
    await file.writeAsString(json.encode(toJson()));
  }

  static Future<void> loadFromFile() async {
    final file = File('$pythonScriptsFolderPath/config.json');
    try {
      if (!await file.exists()) {
        await save();
      }
      final data = await file.readAsString();
      try {
        loadFromJson(json.decode(data));
      } catch (e) {
        try {
          log('LoadConfigError', error: 'Config file is correupted: $e');
          await file.delete();
        } catch (e) {
          log('LoadConfigError',
              error: 'Failed to delete corrupted config file: $e');
        }
      }
    } catch (e) {
      log('LoadConfigError', error: e);
    }
  }
}
