import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../config.dart';
import '../../globals.dart';
import '../../models/events/event.dart';
import '../../models/events/keyboard/keyboard_event.dart';
import '../../services/notification_service.dart';
import '../../services/process_service.dart';

class RecordBar extends StatefulWidget {
  final ProcessService service;
  const RecordBar({required this.service, super.key});

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {
  final WatchService _keyboardWatcher = WatchService(
    outputScriptFilePath: null,
    keyboardOnlyMode: true,
  );
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    unawaited(init().onError(
      (e, s) => showError('Error initializing RecordBar: $e\n$s'),
    ));
  }

  Future<void> init() async {
    await shortenWindow();

    _keyboardWatcher.addListener(_onKeyboardEvent);
    widget.service.addListener(_serviceListener);

    if (widget.service.status != ProcessStatus.running) {
      await startService();
    }

    await _keyboardWatcher.record();
  }

  @override
  void dispose() {
    disposed = true;

    unawaited(restoreWindow());
    stopService();
    _keyboardWatcher.stopRecording();

    widget.service.removeListener(_serviceListener);
    _keyboardWatcher.removeListener(_onKeyboardEvent);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surface,
        ),
        icon: Icon(
          Icons.stop,
          color: colorScheme.error,
        ),
        label: const Text('Stop'),
        onPressed: stopService,
      ),
    );
  }

  void _onKeyboardEvent(ProcessStatus status, String? data) {
    log('Received keyboard event: $data', name: 'RecordBar');
    if (data == null) return;
    final List<Event?> events = data.split('\n').map((e) {
      if (e.isEmpty) return null;
      final Map<String, dynamic> data = json.decode(e.trim());
      return Event.parse(data);
    }).toList();

    for (final event in events) {
      if (event is KeyboardEvent &&
          event.specialKey == Config.endKey &&
          widget.service.status == ProcessStatus.running) {
        stopService();
      }
    }
  }

  late Size size;

  Future<void> shortenWindow() async {
    size = await windowManager.getSize();

    log('Shortening window', name: 'RecordBar');
    const minSize = Size(100, 40);
    await windowManager.setMinimumSize(minSize);
    await windowManager.setSize(minSize);
    await windowManager.setAlignment(Alignment.centerRight, animate: true);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.blur();
    await windowManager.setSkipTaskbar(true);
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  }

  Future<void> restoreWindow() async {
    log('Restoring window', name: 'RecordBar');
    await windowManager.setMinimumSize(Config.minWindowSize);
    await windowManager.setSize(size);
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setSkipTaskbar(false);
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setAlignment(Alignment.center, animate: true);
    await windowManager.show();
    await windowManager.focus();
  }

  void _serviceListener(ProcessStatus status, String? data) {
    if (status != ProcessStatus.running) {
      log('Service stopped', name: 'RecordBar');
      if (context.mounted && !disposed) {
        log('Popping RecordBar', name: 'RecordBar');
        Navigator.of(context).pop();
      }
    }
  }

  void stopService() {
    final service = widget.service;
    if (service is WatchService) {
      log('Stopping WatchService', name: 'RecordBar');
      service.stopRecording();
    } else if (service is ExecuteService) {
      log('Stopping ExecuteService', name: 'RecordBar');
      service.kill();
    } else {
      showError('Unknown service type');
    }
  }

  Future<void> startService() async {
    final service = widget.service;
    if (service is WatchService) {
      log('Starting WatchService', name: 'RecordBar');
      await service.record();
    } else if (service is ExecuteService) {
      log('Starting ExecuteService', name: 'RecordBar');
      await service.play();
    } else {
      showError('Unknown service type');
      return;
    }
  }
}
