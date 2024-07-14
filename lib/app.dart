import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

import 'cleanup.dart';
import 'globals.dart';
import 'screens/home/home_screen.dart';
import 'utils/widgets/theme_mode_button.dart';

class App extends StatelessWidget with WindowListener {
  @override
  void onWindowClose() {
    stopAllProcessServices();
    super.onWindowClose();
  }

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final Color grey = Colors.grey[300]!;

    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, themeModeValue, _) => MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Steps Recorder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          textTheme: GoogleFonts.quicksandTextTheme(),
        ),
        themeMode: themeModeValue,
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(onPrimary: grey),
          textTheme: GoogleFonts.quicksandTextTheme(
            TextTheme(
              titleLarge: TextStyle(color: grey),
              titleMedium: TextStyle(color: grey),
              bodyMedium: TextStyle(color: grey),
              bodySmall: TextStyle(color: grey),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
