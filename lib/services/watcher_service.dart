part of 'process_service.dart';

/// Service to watch for keyboard and mouse events to create a list of events
/// in [scriptFilePath] file
class WatchService extends ProcessService {
  /// The path to the tmp output file
  /// in which the events will be written
  final String scriptFilePath;

  /// The path to the tmp file
  /// containing only the events
  String get tmpScriptFilePath => '$scriptFilePath.tmp';

  WatchService({required this.scriptFilePath});

  @override
  void _log(dynamic msg) => dev.log(msg.toString(), name: 'Watcher Service');

  /// Starts the watcher
  Future<void> record() async {
    await _start(
        'python', ['$pythonScriptsFolderPath/src/watch.py', tmpScriptFilePath]);
  }

  /// Stops the watcher
  ///
  /// If the watcher doesn't stops within 500 milliseconds
  /// it will be killed
  void stopRecording() {
    _stop();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (status == ProcessStatus.running) {
        _kill();
      }
    });
  }
}
