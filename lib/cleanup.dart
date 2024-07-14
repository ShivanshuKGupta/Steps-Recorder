import 'dart:io';

import 'services/process_service.dart';

Future<void> setProcessSignalListeners() async {
  ProcessSignal.sigint.watch().listen((_) => stopAllProcessServicesAndExit());
  if (!Platform.isWindows) {
    ProcessSignal.sigterm
        .watch()
        .listen((_) => stopAllProcessServicesAndExit());
  }
}

void stopAllProcessServicesAndExit() {
  WatchService.allServices.forEach((filePath, service) {
    service.kill();
  });
  ExecuteService.allServices.forEach((filePath, service) {
    service.kill();
  });
  exit(0);
}
