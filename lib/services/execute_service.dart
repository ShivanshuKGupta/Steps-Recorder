import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../config.dart';

class ExecuteService {
  final String outputFile;
  String get outputFilePath => '$outputFolder/$outputFile';
  Process? _process;
  bool get isRunning => _process != null;

  ExecuteService({required this.outputFile});

  void _log(dynamic msg) {
    log(msg.toString(), name: 'Execute Service');
  }

  Future<void> start() async {
    final outputFileObj = File(outputFilePath);
    if (!outputFileObj.existsSync()) {
      throw 'Output file :$outputFilePath does not exist';
    }

    _process = await Process.start(
      'python',
      [
        '$pythonScriptsFolderPath/src/execute.py',
        '"$outputFilePath"',
      ],
    );
    _log('Execution started');

    _process?.stdout.transform(utf8.decoder).listen(_stdout);
    _process?.exitCode.then((exitCode) {
      _process = null;
      _log('Execute exited with code $exitCode');
    });
  }

  void stop() => _process?.stdin.writeln('exit');

  void kill() => _process?.kill();

  void _stdout(String data) {
    _log(data);
  }
}
