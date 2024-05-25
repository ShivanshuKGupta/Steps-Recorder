import 'dart:io';

enum ProcessStatus {
  stopped,
  running,
  aborted,
  killed,
}

class ProcessService {
  ProcessStatus status = ProcessStatus.stopped;
  Process? _process;
}
