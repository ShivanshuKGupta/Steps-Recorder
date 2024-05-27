part of 'script.dart';

extension ScriptFunctions on Script {
  /// Create the script file at [scriptFilePath]
  Future<void> create() async {
    if (await file.exists()) {
      throw 'File already exists';
    }
    createdAt = DateTime.now();
    await file.writeAsString(json.encode(toJson()));
  }

  /// Save the script data to the file
  Future<void> save() async {
    if (!await file.exists()) {
      throw Exception('File does not exist');
    }
    updatedAt = DateTime.now();
    await file.writeAsString(json.encode(toJson()));
  }

  /// Deletes the script file
  Future<void> delete() async {
    await file.delete();
  }

  /// Executes the script
  /// Use [watchStatus] to check the status of the service
  Future<void> play() async {
    await _createTmpFile();
    await _executeService.play();
  }

  /// Stops the script execution
  void stop() {
    _executeService.kill();
  }

  /// Records the script
  Future<void> record() async {
    await _watchService.record();
  }

  /// Stops the script recording
  void stopRecording() {
    _watchService.stopRecording();
  }

  /// Adds a listener to the script
  ///
  /// These listeners are called whenever the status of the
  /// [watchStatus] or [executeStatus] changes
  void addListener(void Function(ProcessStatus status, String? data) listener) {
    _executeService.addListener(listener);
    _watchService.addListener(listener);
  }

  /// Removes a listener from the script
  ///
  /// This listener will no longer be called when the status of the
  /// [watchStatus] or [executeStatus] changes
  void removeListener(void Function(ProcessStatus, String?) listener) {
    _executeService.removeListener(listener);
    _watchService.removeListener(listener);
  }

  /// Creates a temporary file to store the events
  ///
  /// This file is in turn used to execute the script
  /// using the [_executeService]
  Future<void> _createTmpFile() async {
    final tmpFile = File('$scriptFilePath.tmp');
    if (await tmpFile.exists()) {
      await tmpFile.delete();
    }
    await tmpFile
        .writeAsString(events.map((e) => json.encode(e.toJson())).join('\n'));
  }
}

/// Loads all the scripts from the scripts folder
///
/// Returns a list of [Script] objects from the folder [scriptsFolder]
Future<List<Script>> loadAllScripts() async {
  final folder = Directory(scriptsFolder);
  if (!await folder.exists()) {
    await folder.create();
  }
  final files = await folder.list().toList();
  final scripts = <Script>[];
  for (final file in files) {
    if (!file.path.endsWith('.json')) continue;
    try {
      final script = await loadScript(file.absolute.path);
      scripts.add(script);
    } catch (e) {
      scripts.add(Script(
        title: file.path.split('/').last.split('\\').last.split('.').first,
        description: 'This script file is corrupted',
        events: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }
  return scripts;
}

/// Loads a script from the scripts folder
/// Just give the name of the file not the full path
Future<Script> loadScript(String scriptPath) async {
  final file = File(scriptPath);
  if (!await file.exists()) {
    throw Exception('File does not exist: $scriptPath');
  }
  final data = json.decode(await file.readAsString()) as Map<String, dynamic>;
  return Script.fromJson(data);
}
