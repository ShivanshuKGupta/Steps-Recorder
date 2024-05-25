import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import '../config.dart';

part 'execute_service.dart';
part 'watcher_service.dart';

enum ProcessStatus {
  stopped,
  running,
  aborted,
  killed,
}

/// A service to manage processes
abstract class ProcessService {
  /// A function to call when the process starts
  void Function()? _onStart;

  /// A function to call when the process exits
  void Function(ProcessStatus status)? _onExit;

  ProcessService();

  /// The status of the process
  ProcessStatus _status = ProcessStatus.stopped;

  ProcessStatus get status => _status;

  /// The process
  Process? _process;

  /// A list of listeners used to notify when the process has output
  /// or changes its [_status]
  final List<void Function(ProcessStatus status, String? output)> _listeners =
      [];

  /// Logs a message
  void _log(dynamic msg);

  /// Starts the process
  Future<void> _start(String command, List<String> arguments) async {
    if (_status == ProcessStatus.running || _process != null) {
      throw 'This process is already running';
    }

    _process = await Process.start(command, arguments);

    _status = ProcessStatus.running;
    _onStart?.call();
    notifyListeners(null);

    _process?.exitCode.then((exitCode) {
      if (_status == ProcessStatus.running) {
        _status = ProcessStatus.aborted;
      }

      _log('Process exited with code $exitCode');
      _process = null;
      _onExit?.call(_status);
      notifyListeners(null);
    });

    _process?.stdout.transform(utf8.decoder).listen(_stdout);
  }

  /// Stops the process
  void _stop() {
    _status = ProcessStatus.stopped;
    _process?.stdin.writeln('exit');
  }

  /// Kills the process
  void _kill() {
    _status = ProcessStatus.killed;
    _process?.kill();
  }

  /// Handles the stdout of the process
  void _stdout(String data) => notifyListeners(data);

  /// Adds a listener to the process
  /// which is called when the process has output
  /// or changes its [_status]
  void addListener(
          void Function(ProcessStatus status, String? data) listener) =>
      _listeners.add(listener);

  /// Removes a listener from the process
  bool removeListener(
          void Function(ProcessStatus status, String? data) listener) =>
      _listeners.remove(listener);

  /// Notifies all listeners about the process's output
  /// or [_status]
  void notifyListeners(String? data) {
    for (final listener in _listeners) {
      listener(_status, data);
    }
  }
}
