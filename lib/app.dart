import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'globals.dart';
import 'screens/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Steps Recorder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blueAccent).copyWith(
                // brightness: Brightness.dark,
                // surface: Colors.black,
                ),
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme.apply(
              // bodyColor: Colors.white,
              // displayColor: Colors.white,
              // decorationColor: Colors.white,
              ),
        ),
      ),
      home: const HomeScreen(),
      // home: const MyHomePage(title: 'Draggable List View Try'),
    );
  }
}
