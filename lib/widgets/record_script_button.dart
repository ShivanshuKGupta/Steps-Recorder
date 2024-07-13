import 'dart:async';

import 'package:flutter/material.dart';

import '../globals.dart';
import '../models/script/script.dart';
import '../screens/record_bar/record_bar.dart';
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
  late ProcessStatus lastStatus = widget.script.watchServiceStatus;

  @override
  void initState() {
    super.initState();
    widget.script.addListener(_onScriptEvent);
  }

  @override
  void dispose() {
    widget.script.removeListener(_onScriptEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingElevatedButton(
      label: Text(
        widget.script.watchServiceStatus == ProcessStatus.running
            ? 'Stop Recording'
            : 'Record',
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor:
            widget.script.watchServiceStatus == ProcessStatus.running
                ? colorScheme.error
                : Colors.green,
      ),
      icon: Icon(
        widget.script.watchServiceStatus == ProcessStatus.running
            ? Icons.stop
            : Icons.fiber_manual_record,
        color: widget.script.watchServiceStatus == ProcessStatus.running
            ? colorScheme.error
            : Colors.green,
      ),
      onPressed: () async {
        if (widget.script.watchServiceStatus == ProcessStatus.running) {
          await widget.script.stopRecording();
        } else {
          // await widget.script.record();
          await Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  RecordBar(service: widget.script.watchService),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
    );
  }

  Future<void> _onScriptEvent(ProcessStatus _, String? data) async {
    setState(() {
      if (data != null) showMsg(data);
    });
  }
}
