part of 'script.dart';

extension ScriptFunctions on Script {
  /// Create the script file at [scriptFilePath]
  Future<void> create() async {
    if (await scriptFile.exists()) {
      throw 'File already exists';
    }
    createdAt = DateTime.now();
    await scriptFile.writeAsString(json.encode(toJson()));
  }

  /// Save the script data to the file
  Future<void> save() async {
    if (!await scriptFile.exists()) {
      throw Exception('File does not exist');
    }
    updatedAt = DateTime.now();
    await scriptFile.writeAsString(json.encode(toJson()));
  }

  /// Deletes the script file
  void delete() {
    scriptFile.deleteSync();
  }

  /// Executes the script
  /// Use [watchServiceStatus] to check the status of the service
  Future<void> play() async {
    await save();
    await executeService.play();
  }

  /// Stops the script execution
  void stop() {
    executeService.kill();
  }

  /// Records the script
  Future<void> record() async {
    await watchService.record();
  }

  /// Stops the script recording
  Future<void> stopRecording() async {
    await watchService.stopRecording();
  }

  /// Adds a listener to the script
  ///
  /// These listeners are called whenever the status of the
  /// [watchServiceStatus] or [executeServiceStatus] changes
  void addListener(void Function(ProcessStatus status, String? data) listener) {
    executeService.addListener(listener);
    watchService.addListener(listener);
  }

  /// Removes a listener from the script
  ///
  /// This listener will no longer be called when the status of the
  /// [watchServiceStatus] or [executeServiceStatus] changes
  void removeListener(void Function(ProcessStatus, String?) listener) {
    executeService.removeListener(listener);
    watchService.removeListener(listener);
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

/// Creates a new script file in the scripts folder
///
/// The script file is named as 'Script $i.json' where i is the
/// smallest number such that the file 'Script $i.json' does not exist
/// in the scripts folder
Future<void> createNewScript() async {
  int i = 1;
  while (true) {
    if (await File('$scriptsFolder/Script $i.json').exists()) {
      i++;
    } else {
      break;
    }
  }
  String title = 'Script $i';
  await Script(
    title: title,
    events: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ).create();
}
