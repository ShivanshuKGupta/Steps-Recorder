import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../config.dart';

class Watcher {
  final String outputFile;
  String get outputFilePath => '$outputFolder/$outputFile';
  Process? _process;
  final List<void Function(String)> _listeners = [];
  bool get isRunning => _process != null;

  Watcher({required this.outputFile});

  void _log(dynamic object) {
    log(object.toString(), name: 'Watcher Service');
  }

  Future<void> start() async {
    final outputFileObj = File(outputFilePath);
    _log('Output file path: $outputFilePath');
    if (outputFileObj.existsSync()) {
      _log('Warning: Output file already exists. Will be overwritten!');
    }

    _process = await Process.start(
      'python',
      [
        '$pythonScriptsFolderPath/src/watch.py',
        '"$outputFilePath"',
      ],
    );
    _log('Watcher started');

    _process?.stdout.transform(utf8.decoder).listen(_stdout);
    _process?.exitCode.then((exitCode) {
      _process = null;
      _log('Watcher exited with code $exitCode');
    });
  }

  void stop() => _process?.stdin.writeln('exit');

  void kill() => _process?.kill();

  void _stdout(String data) {
    _log(data);
    for (final listener in _listeners) {
      listener(data);
    }
  }

  void addStdoutListener(void Function(String data) listener) {
    _listeners.add(listener);
  }

  bool removeStdoutListener(void Function(String) listener) {
    return _listeners.remove(listener);
  }
}
