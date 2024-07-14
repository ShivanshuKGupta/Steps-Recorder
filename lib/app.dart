import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

import 'cleanup.dart';
import 'globals.dart';
import 'screens/home/home_screen.dart';
import 'utils/widgets/theme_mode_button.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WindowListener {
  @override
  void onWindowClose() {
    super.onWindowClose();
    stopAllProcessServicesAndExit();
  }

  @override
  void onWindowFocus() {
    setState(() {});
    super.onWindowFocus();
  }

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

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
