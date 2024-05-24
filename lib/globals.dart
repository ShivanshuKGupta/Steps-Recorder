import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
BuildContext get appContext => navigatorKey.currentContext!;

double get height => MediaQuery.of(appContext).size.height;
double get width => MediaQuery.of(appContext).size.width;

ColorScheme get colorScheme => Theme.of(appContext).colorScheme;
TextTheme get textTheme => Theme.of(appContext).textTheme;
