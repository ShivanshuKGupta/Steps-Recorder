import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../models/events/event.dart';
import '../models/events/keyboard/keyboard_event.dart';
import '../models/events/keyboard/special_keys.dart';
import '../models/events/script/script.dart';
import '../services/notification_service.dart';
import '../services/process_service.dart';
import '../utils/widgets/loading_elevated_button.dart';

class RecordScriptButton extends StatefulWidget {
  final Script script;
  const RecordScriptButton({required this.script, super.key});

  @override
  State<RecordScriptButton> createState() => _RecordScriptButtonState();
}

class _RecordScriptButtonState extends State<RecordScriptButton> {
  late ProcessStatus lastStatus = widget.script.watchStatus;
  final WatchService _keyboardWatcher = WatchService(
    scriptFilePath: null,
    keyboardOnlyMode: true,
  );

  @override
  void initState() {
    super.initState();
    widget.script.addListener(_onScriptEvent);
    _keyboardWatcher.addListener(_onKeyboardEvent);
    unawaited(_keyboardWatcher
        .record()
        .then(
          (_) => log('Keyboard watcher started', name: 'RecordScriptButton'),
        )
        .onError(
          (error, stackTrace) => log(
            'Error starting keyboard watcher: $error',
            name: 'RecordScriptButton',
            error: error,
            stackTrace: stackTrace,
          ),
        ));
  }

  @override
  void dispose() {
    widget.script.removeListener(_onScriptEvent);
    _keyboardWatcher.stopRecording();
    _keyboardWatcher.removeListener(_onKeyboardEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingElevatedButton(
      label: Text(
        widget.script.watchStatus == ProcessStatus.running
            ? 'Stop Recording'
            : 'Record',
      ),
      icon: Icon(
        widget.script.watchStatus == ProcessStatus.running
            ? Icons.stop
            : Icons.fiber_manual_record,
        color: widget.script.watchStatus == ProcessStatus.running
            ? Colors.red
            : Colors.blue,
      ),
      onPressed: () async {
        if (widget.script.watchStatus == ProcessStatus.running) {
          widget.script.stopRecording();
        } else {
          await widget.script.record();
        }
      },
    );
  }

  Future<void> _onScriptEvent(ProcessStatus _, String? data) async {
    setState(() {
      if (data != null) showMsg(data);
    });
    if (lastStatus == widget.script.watchStatus) return;
    if (widget.script.watchStatus == ProcessStatus.running) {
      showMsg('Script started executing...');
      if (kDebugMode) {
        await windowManager.minimize();
      }
    } else {
      showMsg('Recording saved: ${widget.script.scriptFilePath}');
      await windowManager.restore();
      await windowManager.show();
    }
    lastStatus = widget.script.watchStatus;
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
          event.specialKey == SpecialKey.esc &&
          widget.script.watchStatus == ProcessStatus.running) {
        log('Stopping recording', name: 'RecordScriptButton');
        widget.script.stopRecording();
      }
    }
  }
}
