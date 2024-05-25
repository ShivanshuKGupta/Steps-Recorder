import 'package:window_manager/window_manager.dart';

class WindowService {
  Future<void> minimizeWindow() async {
    await WindowManager.instance.minimize();
  }
}
