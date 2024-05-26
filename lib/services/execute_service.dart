part of 'process_service.dart';

/// A service to execute scripts
/// Just give the path to the script file and make sure that a
/// file with the same name and a '.tmp' extension exists
/// with the events to be executed separated by new lines
class ExecuteService extends ProcessService {
  /// A map of all running services
  static final allServices = <String, ExecuteService>{};

  /// The path to the script file
  final String scriptFilePath;

  ExecuteService({required this.scriptFilePath}) : super();

  @override
  void _log(dynamic msg) => dev.log(msg.toString(), name: 'Execute Service');

  /// Starts the script
  Future<void> play() async {
    if (!await File(scriptFilePath).exists()) {
      throw 'Script file \'$scriptFilePath\' does not exist';
    }

    if (!await File('$scriptFilePath.tmp').exists()) {
      throw 'Script events file \'$scriptFilePath.tmp\' does not exist';
    }

    if (allServices[scriptFilePath]?.status == ProcessStatus.running) {
      throw 'Another instance of the same script is already running';
    }

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
  void stop() {
    _stop();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (status == ProcessStatus.running) {
        _kill();
      }
    });
  }
}
