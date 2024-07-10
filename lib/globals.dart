import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
BuildContext get appContext => navigatorKey.currentContext!;

double get height => MediaQuery.of(appContext).size.height;
double get width => MediaQuery.of(appContext).size.width;

ColorScheme get colorScheme => Theme.of(appContext).colorScheme;
TextTheme get textTheme => Theme.of(appContext).textTheme;

/// Bright & Light Colors for ScriptWidget
/// Since, they are bright, a black font color can be used
/// on top of them
const List<Color> colorsForScripts = [
  Colors.red,
  Colors.orange,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.cyan,
  Colors.amber,
];
