import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import '../config.dart';
import '../models/events/event.dart';
import '../models/events/keyboard/keyboard_event.dart';
import '../models/script/script.dart';
import 'notification_service.dart';

part 'execute_service.g.dart';
part 'watch_service.g.dart';

enum ProcessStatus {
  /// The process is not running / or has stopped gracefully (exit code == 0)
  stopped,

  /// The process is running
  running,

  /// The process was aborted on itself (exit code != 0)
  aborted,

  /// The process was killed by the user/app
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

  /// The process instance
  Process? _process;

  /// A list of listeners used to notify when the process has output
  /// or changes its [_status]
  final List<void Function(ProcessStatus status, String? output)> _listeners =
      [];

  /// Logs a message
  void _log(dynamic msg);

  /// Get PID
  int? get getPid => _process?.pid;

  /// Starts the process
  Future<void> _start(String command, List<String> arguments) async {
    if (_status == ProcessStatus.running || _process != null) {
      throw 'This process is already running';
    }

    _log('Starting Process...');
    _process = await Process.start(command, arguments);
    _log('Process $getPid started');

    _status = ProcessStatus.running;
    try {
      _onStart?.call();
    } catch (e) {
      _log('Error in _onStart: $e');
    }
    notifyListeners(null);

    _process?.exitCode.then((exitCode) {
      if (_status == ProcessStatus.running) {
        if (exitCode != 0) {
          _status = ProcessStatus.aborted;
        } else {
          _status = ProcessStatus.stopped;
        }
      }

      _log('Process $getPid exited with code $exitCode');
      _process = null;
      try {
        _onExit?.call(_status);
      } catch (e) {
        _log('Error in _onExit: $e');
      }
      notifyListeners(null);
    });

    _process?.stdout.transform(utf8.decoder).listen(_stdout);
  }

  /// Stops the process
  Future<void> _stop() async {
    _log('Stopping Process $getPid');
    _status = ProcessStatus.stopped;
    _log('Flushing...');
    _process?.stdin.writeln('exit');
    await _process?.stdin.flush();
    _log('Flushed!');
  }

  /// Kills the process
  void kill() {
    _log('Killing Process $getPid');
    _status = ProcessStatus.killed;
    _process?.kill();
  }

  /// Handles the stdout of the process
  void _stdout(String data) => notifyListeners(data);

  /// Adds a listener to the process
  /// which is called when the process has output
  /// or changes its [_status]
  void addListener(void Function(ProcessStatus status, String? data) listener) {
    _listeners.add(listener);
  }

  /// Removes a listener from the process
  bool removeListener(
      void Function(ProcessStatus status, String? data) listener) {
    return _listeners.remove(listener);
  }

  /// Notifies all listeners about the process's output
  /// or [_status].
  /// If [data] is given as null then it will mean that only the
  /// [_status] has changed.
  void notifyListeners(String? data) {
    for (final listener in _listeners) {
      try {
        listener(_status, data);
      } catch (e) {
        _log('Error calling listener: $e');
      }
    }
  }
}
