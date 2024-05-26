import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../models/events/script/script.dart';
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
  late ProcessStatus lastStatus = widget.script.executeStatus;

  @override
  void initState() {
    super.initState();
    log('Init ${_onScriptEvent.hashCode}', name: 'PlayScriptButton');
    widget.script.addListener(_onScriptEvent);
  }

  @override
  void dispose() {
    log('Dispose ${_onScriptEvent.hashCode}', name: 'PlayScriptButton');
    widget.script.removeListener(_onScriptEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingIconButton(
      icon: Icon(
        widget.script.executeStatus == ProcessStatus.running
            ? Icons.stop
            : Icons.play_arrow,
        color: widget.script.executeStatus == ProcessStatus.running
            ? Colors.red
            : Colors.green,
      ),
      onPressed: () async {
        if (widget.script.executeStatus == ProcessStatus.running) {
          widget.script.stop();
        } else {
          await widget.script.play();
        }
      },
    );
  }

  Future<void> _onScriptEvent(ProcessStatus status, String? data) async {
    log('Script Event: $status, $data', name: 'PlayScriptButton');
    setState(() {
      if (data != null) showMsg(data);
    });
    log('lastStatus: $lastStatus, status: $status', name: 'PlayScriptButton');
    if (lastStatus == status) return;
    if (status == ProcessStatus.running) {
      log('Minimizing', name: 'PlayScriptButton');
      await windowManager.minimize();
    } else {
      log('Restoring', name: 'PlayScriptButton');
      await windowManager.restore();
    }
    lastStatus = status;
  }
}
