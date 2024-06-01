import 'dart:io';

import '../services/background_service.dart';

/// If the arguments are handled, then the app will take a
/// different course of action, or else the app will run normally.
Future<bool> handleArguments(List<String> arguments) async {
  if (arguments.contains('--start-background-service')) {
    await BackgroundService.instance.start();
    return true;
  }
  if (arguments.contains('--record')) {
    throw UnimplementedError(
        'The app will start but recording is not implemented yet.');
    return false;
  }
  if (arguments.isNotEmpty) {
    print('Unknown arguments: $arguments');
    print(
        'Usage: ${Platform.executable} [--start-background-service] [--record]');
    exit(1);
  }
  return false;
}
