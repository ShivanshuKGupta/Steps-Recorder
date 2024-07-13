import 'dart:async';

import 'package:flutter/material.dart';

import '../globals.dart';
import '../models/script/script.dart';
import '../screens/record_bar/record_bar.dart';
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
    return LoadingIconButton(
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surface,
      ),
      tooltip: widget.script.executeServiceStatus == ProcessStatus.running
          ? 'Stop Script'
          : 'Play Script',
      icon: Icon(
        widget.script.executeServiceStatus == ProcessStatus.running
            ? Icons.stop
            : Icons.play_arrow,
        color: widget.script.executeServiceStatus == ProcessStatus.running
            ? colorScheme.error
            : Colors.green,
      ),
      onPressed: () async {
        if (widget.script.executeServiceStatus == ProcessStatus.running) {
          widget.script.stop();
        } else {
          await widget.script.play();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  RecordBar(service: widget.script.executeService),
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
