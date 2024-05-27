part of 'process_service.dart';

/// Service to watch for keyboard and mouse events to create a list of events
/// in [scriptFilePath] file
class WatchService extends ProcessService {
  /// A map of all running services
  static final allServices = <String, WatchService>{};

  /// The path to the output script file in which the events will be written
  ///
  /// If null, the service will not write the events to a file
  /// instead it will just print them to the console
  ///
  /// add a listener using [addListener] to get those events
  final String? scriptFilePath;

  final bool keyboardOnlyMode;
  final bool mouseOnlyMode;

  /// The path to the tmp file
  /// containing only the events
  String? get tmpScriptFilePath =>
      scriptFilePath == null ? null : '$scriptFilePath.tmp';

  WatchService({
    required this.scriptFilePath,
    this.keyboardOnlyMode = false,
    this.mouseOnlyMode = false,
  });

  @override
  void _log(dynamic msg) => dev.log(msg.toString(), name: 'Watcher Service');

  /// Starts the watcher
  Future<void> record() async {
    if (scriptFilePath != null) {
      if (allServices[scriptFilePath]?.status == ProcessStatus.running) {
        throw 'Another instance of the same script is already recording';
      }

      _onStart = () {
        allServices[scriptFilePath!] = this;
        _log('Script \'$scriptFilePath\' started recording...');
      };

      _onExit = (ProcessStatus status) async {
        // allServices.remove(scriptFilePath);
        _log(
            'Script \'$scriptFilePath\' stopped recording with status $status');
        await _saveEvents();
      };
    }

    await _start('python', [
      '$pythonScriptsFolderPath/src/watch.py',
      if (keyboardOnlyMode) '--keyboard-only',
      if (mouseOnlyMode) '--mouse-only',
      if (scriptFilePath != null) tmpScriptFilePath!,
    ]);
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

  Future<void> _saveEvents() async {
    try {
      if (scriptFilePath == null || tmpScriptFilePath == null) {
        throw 'The Watch Service was run without an output file!';
      }
      Script script = await loadScript(scriptFilePath!);
      final tmpFile = File(tmpScriptFilePath!);
      final events = (await tmpFile.readAsString()).split('\n').map((e) {
        try {
          return Event.parse(json.decode(e));
        } catch (e) {
          return null;
        }
      });
      script.events.clear();
      for (var e in events) {
        if (e != null) script.events.add(e);
      }
      await script.save();
    } catch (e) {
      showMsg('Error Saving Script: $e');
    }
  }
}
