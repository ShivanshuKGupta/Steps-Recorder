import 'dart:developer' as dev;
import 'dart:io';

import '../config.dart';
import 'process_service.dart';

/// Service to watch for keyboard and mouse events to create a list of events
/// in [scriptFilePath] file
class WatchService extends ProcessService {
  /// The path to the tmp output file
  /// in which the events will be written
  String scriptFilePath;

  WatchService({required this.scriptFilePath});

  @override
  void log(dynamic msg) => dev.log(msg.toString(), name: 'Watcher Service');

  /// Starts the watcher
  Future<void> record() async {
    if (File('$scriptFilePath.tmp').existsSync()) {
      log('Warning: Output file \'$scriptFilePath.tmp\' already exists. Will be overwritten!');
    }

    onStart = () {
      log('Watcher started');
    };

    onExit = (status) {
      log('Watcher exited with status $status');
    };

    await start('python',
        ['$pythonScriptsFolderPath/src/watch.py', '$scriptFilePath.tmp']);
  }
}
