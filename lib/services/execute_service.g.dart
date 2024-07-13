part of 'process_service.dart';

/// A service to execute scripts
class ExecuteService extends ProcessService {
  /// A map of all running services
  static final allServices = <String, ExecuteService>{};

  /// The full path to the script file to execute
  final String scriptFilePath;

  ExecuteService({required this.scriptFilePath}) : super();

  @override
  void _log(dynamic msg) =>
      dev.log(msg.toString(), name: 'Execute Service ($getPid)');

  /// Starts executing the script.
  ///
  /// Make sure to save the script to [scriptFilePath] before calling this function
  Future<void> play() async {
    if (!await File(scriptFilePath).exists()) {
      throw 'Script file \'$scriptFilePath\' does not exist';
    }

    if (allServices[scriptFilePath]?.status == ProcessStatus.running) {
      throw 'Another instance of the same script is already running';
    }

    await _createTmpFile();

    _onStart = () {
      allServices[scriptFilePath] = this;
      _log('Script \'$scriptFilePath\' started');
    };

    _onExit = (status) {
      // allServices.remove(scriptFilePath);
      _log('Script \'$scriptFilePath\' exited with status $status');
    };

    await _start('python',
        ['$pythonScriptsFolderPath/src/execute.py', '"$scriptFilePath.tmp"']);
  }

  /// Stops the script
  ///
  /// If the script doesn't stops within 500 milliseconds then
  /// it will be killed
  // void stop() {
  //   _stop();
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     if (status == ProcessStatus.running) {
  //       _kill();
  //     }
  //   });
  // }

  void kill() => _kill();

  /// Reads all events from the [scriptFilePath] file,
  /// and then creates a .tmp file with all its events in it
  Future<void> _createTmpFile() async {
    final script = await loadScript(scriptFilePath);

    final tmpFile = File('$scriptFilePath.tmp');
    if (await tmpFile.exists()) {
      await tmpFile.delete();
    }

    await tmpFile.writeAsString(
      script.events.map((e) => json.encode(e.toJson())).join('\n'),
    );
  }
}
