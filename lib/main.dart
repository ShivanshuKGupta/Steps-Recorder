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

  runApp(const App());
}
