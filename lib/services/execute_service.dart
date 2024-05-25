import 'dart:developer' as dev;
import 'dart:io';

import '../config.dart';
import 'process_service.dart';

/// A service to execute scripts
/// Just give the path to the script file and make sure that a
/// file with the same name and a '.tmp' extension exists
/// with the events to be executed separated by new lines
class ExecuteService extends ProcessService {
  /// A map of all running services
  static final allServices = <String, ExecuteService>{};

  /// The path to the script file
  String scriptFilePath;

  ExecuteService({required this.scriptFilePath}) : super();

  @override
  void log(dynamic msg) => dev.log(msg.toString(), name: 'Execute Service');

  /// Starts the script and adds it to the [allServices] map
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

    onStart = () {
      allServices[scriptFilePath] = this;
      log('Script \'$scriptFilePath\' started');
    };

    onExit = (status) {
      allServices.remove(scriptFilePath);
      log('Script \'$scriptFilePath\' exited with status $status');
    };

    await start('python',
        ['$pythonScriptsFolderPath/src/execute.py', '"$scriptFilePath.tmp"']);
  }
}
