import 'dart:io';

import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LaunchStartupHandler {
  /// Setup the launch at startup.
  static Future<void> setup() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      packageName: 'dev.shivanshukgupta.steps_recorder',
      args: ['--start-background-service'],
    );
  }

  /// Check if the app is enabled to launch at startup.
  static Future<bool> get isEnabled => launchAtStartup.isEnabled();

  /// Enable the app to launch at startup.
  static Future<void> enable() async {
    await launchAtStartup.enable();
  }

  /// Disable the app to launch at startup.
  static Future<void> disable() async {
    await launchAtStartup.disable();
  }
}
