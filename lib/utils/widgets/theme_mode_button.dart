import 'package:flutter/material.dart';

import '../../config.dart';

final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (themeMode.value == ThemeMode.light) {
          themeMode.value = ThemeMode.dark;
        } else if (themeMode.value == ThemeMode.dark) {
          themeMode.value = ThemeMode.system;
        } else {
          themeMode.value = ThemeMode.light;
        }
        Config.themeMode = themeMode.value;
      },
      icon: ValueListenableBuilder(
        valueListenable: themeMode,
        builder: (context, themeModeValue, _) {
          final icon = themeMode.value == ThemeMode.system
              ? Icons.brightness_auto_rounded
              : (themeMode.value == ThemeMode.light
                  ? Icons.wb_sunny_rounded
                  : Icons.nightlight_round);
          return Icon(icon);
        },
      ),
    );
  }
}
