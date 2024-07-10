import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        themeMode.value = themeMode.value == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
      },
      icon: ValueListenableBuilder(
        valueListenable: themeMode,
        builder: (context, themeModeValue, _) => Icon(
          themeModeValue == ThemeMode.light
              ? Icons.nightlight_round
              : Icons.wb_sunny,
        ),
      ),
    );
  }
}
