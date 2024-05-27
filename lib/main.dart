import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'config.dart';

void main() async {
  await Config.loadFromFile();
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    const WindowOptions(minimumSize: Size(600, 400)),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(const App());
}
