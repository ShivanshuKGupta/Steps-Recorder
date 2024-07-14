import 'dart:io';

import 'services/process_service.dart';

Future<void> setProcessSignalListeners() async {
  ProcessSignal.sigint.watch().listen((_) => stopAllProcessServices());
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) => stopAllProcessServices());
  }
}

void stopAllProcessServices() {
  WatchService.allServices.forEach((filePath, service) {
    service.kill();
  });
  ExecuteService.allServices.forEach((filePath, service) {
    service.kill();
  });
}
