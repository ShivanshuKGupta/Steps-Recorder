import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'config.dart';

void main(List<String> arguments) async {
  // if (await handleArguments(arguments)) return;

  WidgetsFlutterBinding.ensureInitialized();
  await Config.loadFromFile();
  await WindowManager.instance.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      minimumSize: Size(600, 400),
      size: Size(800, 600),
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  setErrorWidget();

  runApp(const App());
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
