import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../config.dart';
import '../models/events/event.dart';
import '../models/events/keyboard/keyboard_event.dart';
import '../models/script/script.dart';
import '../services/notification_service.dart';
import '../services/process_service.dart';
import '../utils/widgets/loading_icon_button.dart';

class PlayScriptButton extends StatefulWidget {
  final Script script;
  const PlayScriptButton({required this.script, super.key});

  @override
  State<PlayScriptButton> createState() => _PlayScriptButtonState();
}

class _PlayScriptButtonState extends State<PlayScriptButton> {
  late ProcessStatus lastStatus = widget.script.executeServiceStatus;
  final WatchService _keyboardWatcher = WatchService(
    outputScriptFilePath: null,
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
    return LoadingIconButton(
      tooltip: widget.script.executeServiceStatus == ProcessStatus.running
          ? 'Stop Script'
          : 'Play Script',
      icon: Icon(
        widget.script.executeServiceStatus == ProcessStatus.running
            ? Icons.stop
            : Icons.play_arrow,
        color: widget.script.executeServiceStatus == ProcessStatus.running
            ? Colors.red
            : Colors.green,
      ),
      onPressed: () async {
        if (widget.script.executeServiceStatus == ProcessStatus.running) {
          widget.script.stop();
        } else {
          await widget.script.play();
        }
      },
    );
  }

  Future<void> _onScriptEvent(ProcessStatus _, String? data) async {
    setState(() {
      if (data != null) showMsg(data);
    });
    if (lastStatus == widget.script.executeServiceStatus) return;
    if (widget.script.executeServiceStatus == ProcessStatus.running) {
      log('Minimizing', name: 'PlayScriptButton');
      await windowManager.minimize();
      // await windowManager.hide();
    } else {
      log('Restoring', name: 'PlayScriptButton');
      await windowManager.restore();
      await windowManager.show();
    }
    lastStatus = widget.script.executeServiceStatus;
  }

  void _onKeyboardEvent(ProcessStatus status, String? data) {
    log('Received keyboard event: $data', name: 'PlayScriptButton');
    if (data == null) return;
    final List<Event?> events = data.split('\n').map((e) {
      if (e.isEmpty) return null;
      final Map<String, dynamic> data = json.decode(e.trim());
      return Event.parse(data);
    }).toList();
    for (final event in events) {
      if (event is KeyboardEvent &&
          event.specialKey == Config.endKey &&
          widget.script.executeServiceStatus == ProcessStatus.running) {
        log('Stopping execution', name: 'RecordScriptButton');
        widget.script.stop();
      }
    }
  }
}
