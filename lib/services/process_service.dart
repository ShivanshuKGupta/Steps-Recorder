import 'dart:convert';
import 'dart:io';

enum ProcessStatus {
  stopped,
  running,
  aborted,
  killed,
}

/// A service to manage processes
abstract class ProcessService {
  /// A function to call when the process starts
  void Function()? onStart;

  /// A function to call when the process exits
  void Function(ProcessStatus status)? onExit;

  ProcessService();

  /// The status of the process
  ProcessStatus status = ProcessStatus.stopped;

  /// The process
  Process? _process;

  /// A list of listeners used to notify when the process has output
  /// or changes its [status]
  final List<void Function(ProcessStatus status, String? output)> _listeners =
      [];

  /// Logs a message
  void log(dynamic msg);

  /// Starts the process
  Future<void> start(String command, List<String> arguments) async {
    if (status == ProcessStatus.running || _process != null) {
      throw 'This process is already running';
    }

    _process = await Process.start(command, arguments);

    status = ProcessStatus.running;
    onStart?.call();
    notifyListeners(null);

    _process?.exitCode.then((exitCode) {
      if (status == ProcessStatus.running) {
        status = ProcessStatus.aborted;
      }

      log('Process exited with code $exitCode');
      _process = null;
      onExit?.call(status);
      notifyListeners(null);
    });

    _process?.stdout.transform(utf8.decoder).listen(_stdout);
  }

  /// Stops the process
  void stop() {
    status = ProcessStatus.stopped;
    _process?.stdin.writeln('exit');
  }

  /// Kills the process
  void kill() {
    status = ProcessStatus.killed;
    _process?.kill();
  }

  /// Handles the stdout of the process
  void _stdout(String data) => notifyListeners(data);

  /// Adds a listener to the process
  /// which is called when the process has output
  /// or changes its [status]
  void addListener(
          void Function(ProcessStatus status, String? data) listener) =>
      _listeners.add(listener);

  /// Removes a listener from the process
  bool removeListener(
          void Function(ProcessStatus status, String? data) listener) =>
      _listeners.remove(listener);

  /// Notifies all listeners about the process's output
  /// or [status]
  void notifyListeners(String? data) {
    for (final listener in _listeners) {
      listener(status, data);
    }
  }
}
