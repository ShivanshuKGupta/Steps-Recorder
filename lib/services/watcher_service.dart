import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../config.dart';
import 'process_service.dart';

/// Service to watch for keyboard and mouse events to create a list of events
/// in [outputFileName] file
class WatchService {
  /// The name of the output script file without the path
  final String outputFileName;

  /// The path to the tmp output file
  String get outputFilePath => '$scriptsFolder/$outputFileName.tmp';

  /// The process running the watcher
  Process? _process;

  /// A list of listeners used to notify when the watcher has output
  /// or changes its [status]
  final List<void Function(ProcessStatus status, String? output)> _listeners =
      [];

  /// The status of the watcher
  ProcessStatus status = ProcessStatus.stopped;

  WatchService({required this.outputFileName});

  void _log(dynamic object) => log(object.toString(), name: 'Watcher Service');

  /// Starts the watcher
  Future<void> start() async {
    if (File(outputFilePath).existsSync()) {
      _log('Warning: Output file already exists. Will be overwritten!');
    }

    _process = await Process.start(
      'python',
      ['$pythonScriptsFolderPath/src/watch.py', '"$outputFilePath"'],
    );

    _log('Watcher started');
    status = ProcessStatus.running;
    notifyListeners(null);

    _process?.exitCode.then((exitCode) {
      if (status == ProcessStatus.running) {
        status = ProcessStatus.aborted;
      }

      _log('Watcher exited with code $exitCode');
      _process = null;
      notifyListeners(null);
    });

    _process?.stdout.transform(utf8.decoder).listen(_stdout);
  }

  void stop() {
    status = ProcessStatus.stopped;
    _process?.stdin.writeln('exit');
  }

  void kill() {
    status = ProcessStatus.killed;
    _process?.kill();
  }

  void _stdout(String data) => notifyListeners(data);

  void addStdoutListener(
          void Function(ProcessStatus status, String? data) listener) =>
      _listeners.add(listener);

  bool removeStdoutListener(
          void Function(ProcessStatus status, String? data) listener) =>
      _listeners.remove(listener);

  void notifyListeners(String? data) {
    for (final listener in _listeners) {
      listener(status, data);
    }
  }
}
