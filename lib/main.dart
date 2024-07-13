import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'config.dart';
import 'utils/widgets/theme_mode_button.dart';

void main(List<String> arguments) async {
  /// Handle the arguments, if handled then the app won't run.
  // if (await handleArguments(arguments)) return;

  /// Initializes certain services and the app.
  await initialize();

  /// Set the error widget to show a custom error message.
  setErrorWidget();

  /// Run the app.
  runApp(const App());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.loadFromFile();
  await WindowManager.instance.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      minimumSize: Config.minWindowSize,
      size: Config.initialWindowSize,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  themeMode.value = Config.themeMode;
}

void setErrorWidget() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
        child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            ':-( Something went wrong!',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Contact shivanshukgupta on linkedin for support\n',
            textAlign: TextAlign.center,
          ),
          Text(
            '\n${details.exception}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ));
  };
}
