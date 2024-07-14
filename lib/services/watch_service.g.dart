part of 'process_service.dart';

/// Service to watch for keyboard and mouse events to create a list of events
/// in [outputScriptFilePath] file
class WatchService extends ProcessService {
  /// A map of all running watch services
  static final allServices = <String, WatchService>{};

  /// The path to the output script file in which the events will be written
  ///
  /// If null, the service will not write the events to a file
  /// instead it will just print them to the console,
  /// add a listener using [addListener] to get those events
  final String? outputScriptFilePath;

  /// If true, only keyboard events will be recorded
  final bool keyboardOnlyMode;

  /// If true, only mouse events will be recorded
  final bool mouseOnlyMode;

  /// The path to the tmp file
  /// containing only the events
  String? get tmpScriptFilePath =>
      outputScriptFilePath == null ? null : '$outputScriptFilePath.tmp';

  WatchService({
    required this.outputScriptFilePath,
    this.keyboardOnlyMode = false,
    this.mouseOnlyMode = false,
  });

  @override
  void _log(dynamic msg) =>
      dev.log(msg.toString(), name: 'Watch Service ($getPid)');

  /// Starts recording the events
  Future<void> record() async {
    if (outputScriptFilePath != null) {
      if (allServices[outputScriptFilePath]?.status == ProcessStatus.running) {
        throw 'Another instance of the same script is already recording';
      }

      _onStart = () {
        allServices[outputScriptFilePath!] = this;
        _log('Script \'$outputScriptFilePath\' started recording...');
      };

      _onExit = (ProcessStatus status) async {
        // allServices.remove(scriptFilePath);
        _log(
            'Script \'$outputScriptFilePath\' stopped recording with status $status');
        await _saveEvents();
      };
    }

    await _start('python', [
      '$pythonScriptsFolderPath/src/watch.py',
      if (keyboardOnlyMode) '--keyboard-only',
      if (mouseOnlyMode) '--mouse-only',
      if (outputScriptFilePath != null) tmpScriptFilePath!,
    ]);
  }

  /// Stops the watcher
  ///
  /// If the watcher doesn't stops within 500 milliseconds
  /// it will be killed
  Future<void> stopRecording() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (status == ProcessStatus.running) {
        kill();
        showError(
            "Watch service didn't exited within 500 ms, and so was killed!");
      }
    });
    await _stop();
  }

  Future<void> _saveEvents() async {
    try {
      if (outputScriptFilePath == null) {
        // The Watch Service was run without an output file!
        // So can\'t save events to any file!
        return;
      }
      Script script = await loadScript(outputScriptFilePath!);
      final tmpFile = File(tmpScriptFilePath!);

      script.events = (await tmpFile.readAsString())
          .split('\n')
          .map((e) {
            try {
              return Event.parse(json.decode(e));
            } catch (e) {
              return null;
            }
          })
          .whereType<Event>()
          .toList();

      // Removing the last keyboard events, if they were created due to
      // the end key being pressed
      Event? lastEvent = script.events.lastOrNull;
      while (
          lastEvent is KeyboardEvent && lastEvent.specialKey == Config.endKey) {
        script.events.removeLast();
        lastEvent = script.events.lastOrNull;
      }

      await script.save();
    } catch (e) {
      showMsg('Error Saving Script: $e');
    }
  }
}
