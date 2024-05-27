import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      size: Size(800, 600),
      minimumSize: Size(600, 400),
      center: true,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(const App());
}
