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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(init().onError(
        (e, s) => showError('Error initializing RecordBar: $e\n$s'),
      ));
    });
  }

  Future<void> init() async {
    await shortenWindow();

    _keyboardWatcher.addListener(_onKeyboardEvent);
    widget.service.addListener(_serviceListener);

    if (widget.service.status != ProcessStatus.running) {
      await startService();
    }

    await _keyboardWatcher.record();

    log('_keyboardWatcher.pid = ${_keyboardWatcher.getPid}');
    log('widget.service.pid = ${widget.service.getPid}');
  }

  @override
  void dispose() {
    if (!disposed) {
      unawaited(cleanUp());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: disposed
          ? const Center(child: Text('Saving Script...'))
          : ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(0),
                backgroundColor: colorScheme.surface,
              ),
              icon: Icon(
                Icons.stop,
                color: colorScheme.error,
              ),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Press ${Config.endKey.name} to stop'),
              ),
              onPressed: stopService,
            ),
    );
  }

  void _onKeyboardEvent(ProcessStatus status, String? data) {
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
        unawaited(stopService());
      }
    }
  }

  late Size size;

  Future<void> shortenWindow() async {
    size = await windowManager.getSize();

    log('Shortening window', name: 'RecordBar');
    const minSize = Size(150, 40);
    await windowManager.setMinimumSize(minSize);
    await windowManager.setSize(minSize);
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setAlignment(Alignment.centerRight);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setAsFrameless();
    await windowManager.blur();
  }

  Future<void> restoreWindow() async {
    log('Restoring window', name: 'RecordBar');
    await windowManager.setMinimumSize(Config.minWindowSize);
    await windowManager.setSize(size);
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setAlignment(Alignment.center);
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.show();
    // await windowManager.focus();
    log('Restored window', name: 'RecordBar');
  }

  void _serviceListener(ProcessStatus status, String? data) {
    if (status != ProcessStatus.running) {
      log('Service stopped', name: 'RecordBar');
      if (context.mounted && !disposed) {
        log('Popping RecordBar', name: 'RecordBar');
        unawaited(cleanUp().then((_) {
          Navigator.of(context).pop();
        }));
      }
    }
  }

  Future<void> stopService() async {
    final service = widget.service;
    if (service.status != ProcessStatus.running) return;
    if (service is WatchService) {
      log('Stopping WatchService', name: 'RecordBar');
      await service.stopRecording();
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

  Future<void> cleanUp() async {
    log('Cleaning up', name: 'RecordBar');
    setState(() {
      disposed = true;
    });

    await restoreWindow();
    await stopService();
    await _keyboardWatcher.stopRecording();

    widget.service.removeListener(_serviceListener);
    _keyboardWatcher.removeListener(_onKeyboardEvent);
  }
}
