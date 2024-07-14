import 'package:flutter/material.dart';

import 'app.dart';
import 'cleanup.dart';
import 'initialize.dart';
import 'set_error_widget.dart';

void main(List<String> arguments) async {
  /// Handle the arguments, if handled then the app won't run.
  // if (await handleArguments(arguments)) return;

  /// Initializes certain services and the app.
  await initialize();

  /// Stops all child processes when the app is closed.
  await setProcessSignalListeners();

  /// Set the error widget to show a custom error message.
  setErrorWidget();

  /// Run the app.
  runApp(const App());
}
