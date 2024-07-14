import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'config.dart';
import 'utils/widgets/theme_mode_button.dart';

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
