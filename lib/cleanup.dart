import 'dart:io';

import 'services/process_service.dart';

Future<void> setCleanup() async {
  ProcessSignal.sigint.watch().listen(_stopAllServices);
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen(_stopAllServices);
  }
}

void _stopAllServices(ProcessSignal signal) {
  WatchService.allServices.forEach((filePath, service) {
    service.kill();
  });
  ExecuteService.allServices.forEach((filePath, service) {
    service.kill();
  });
}
