import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../config.dart';
import 'process_service.dart';

/// A service to execute scripts
class ExecuteService {
  /// A map of all running services
  static final allServices = <String, ExecuteService>{};

  /// The name of the script file without the path
  final String scriptName;

  /// The path to the script file
  String get scriptFilePath => '$scriptsFolder/$scriptName';

  /// The process running the script
  Process? _process;

  /// A list of listeners used to notify when the executer has output
  /// or changes its [status]
  final List<void Function(ProcessStatus status, String? output)> _listeners =
      [];

  /// The status of the execution service
  ProcessStatus status = ProcessStatus.stopped;

  ExecuteService({required this.scriptName});

  void _log(dynamic msg) => log(msg.toString(), name: 'Execute Service');

  /// Starts the script and adds it to the [allServices] map
  Future<void> play() async {
    if (!await File(scriptFilePath).exists()) {
      throw 'Output file :$scriptFilePath does not exist';
    }

    if (allServices[scriptName]?.status == ProcessStatus.running) {
      throw 'Another instance of the same script is already running';
    }

    if (status == ProcessStatus.running) {
      throw 'This script is already running';
    }

    _process = await Process.start(
      'python',
      ['$pythonScriptsFolderPath/src/execute.py', '"$scriptFilePath"'],
    );

    allServices[scriptName] = this;
    _log('Script \'$scriptName\' started');

    status = ProcessStatus.running;
    notifyListeners(null);

    _process?.exitCode.then((exitCode) {
      if (status == ProcessStatus.running) {
        status = ProcessStatus.aborted;
      }

      _log('Script $scriptName exited with code $exitCode');
      _process = null;
      allServices.remove(scriptName);
      notifyListeners(null);
    });

    _process?.stdout.transform(utf8.decoder).listen(_stdout);
  }

  /// Stops the script
  void stop() {
    status = ProcessStatus.stopped;
    _process?.stdin.writeln('exit');
  }

  /// Kills the script
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
