import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../config.dart';
import '../../globals.dart';
import '../../models/events/event.dart';
import '../../models/events/keyboard/keyboard_event.dart';
import '../../models/events/mouse/mouse_event.dart';
import '../../models/events/script/script.dart';
import '../../services/notification_service.dart';
import '../../services/process_service.dart';
import '../../widgets/play_script_button.dart';
import 'keyboard_event_widget.dart';
import 'mouse_event_widget.dart';

class ScriptEditScreen extends StatefulWidget {
  final Script script;
  const ScriptEditScreen({required this.script, super.key});

  @override
  State<ScriptEditScreen> createState() => _ScriptEditScreenState();
}

class _ScriptEditScreenState extends State<ScriptEditScreen> {
  late Script script;
  final events = <Event>[];
  bool disposed = false;

  final allTypeOfEvents = <Event>[
    KeyboardEvent(state: KeyboardButtonState.press, key: 'a'),
    KeyboardEvent(state: KeyboardButtonState.release, key: 'a'),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.move),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.press),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.release),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.scroll),
  ];

  final folderChangedStream = Directory(scriptsFolder).watch();

  @override
  void initState() {
    super.initState();
    script = widget.script;
    folderChangedStream.listen(_fileChangeHandler);
    script.addListener(_listener);
    events.addAll(script.events);
  }

  @override
  void dispose() {
    disposed = true;
    script.events = events;
    folderChangedStream.listen(null);
    script.removeListener(_listener);
    unawaited(script.save().onError(
          (error, stackTrace) => showMsg('Error Saving Script: $error'),
        ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: script.title),
              decoration: InputDecoration(
                hintText: 'No Title',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: textTheme.titleLarge,
              ),
              style: textTheme.titleLarge,
              onChanged: (value) {
                script.title = value;
              },
              onEditingComplete: () async {
                try {
                  await script.save();
                } catch (e) {
                  showMsg('Error Saving Script Title: $e');
                }
              },
            ),
            const SizedBox(height: 5),
            TextField(
              controller: TextEditingController(text: script.description),
              decoration: InputDecoration(
                hintText: 'No Description',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: textTheme.bodySmall,
              ),
              style: textTheme.bodySmall,
              onChanged: (value) {
                script.description = value;
              },
            ),
          ],
        ),
        actions: [
          PlayScriptButton(script: script),
          ElevatedButton.icon(
            onPressed: () async {
              if (script.watchStatus == ProcessStatus.running) {
                script.stopRecording();
              } else {
                await script.record();
              }
            },
            label: Text(script.watchStatus == ProcessStatus.running
                ? 'Stop'
                : 'Record'),
            icon: Icon(
              script.watchStatus == ProcessStatus.running
                  ? Icons.stop_rounded
                  : Icons.fiber_manual_record,
              color: script.watchStatus == ProcessStatus.running
                  ? Colors.red
                  : null,
            ),
          ),
        ],
      ),
      body: ReorderableListView(
        footer: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.keyboard_alt_rounded),
                  onPressed: () {
                    final event = KeyboardEvent(
                      state: KeyboardButtonState.press,
                      key: 'a',
                    );
                    setState(() {
                      events.add(event);
                    });
                  },
                  label: const Text('Add a Keyboard Event'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.mouse_rounded),
                  onPressed: () {
                    final event = MouseEvent(
                      x: 0,
                      y: 0,
                      mouseEventType: MouseEventType.press,
                    );
                    setState(() {
                      events.add(event);
                    });
                  },
                  label: const Text('Add a Mouse Event'),
                ),
              ],
            ),
          ),
        ),
        children: [
          for (final event in events)
            Row(
              key: ValueKey(event.toJson()),
              children: [
                Expanded(
                  child: switch (event.runtimeType) {
                    const (KeyboardEvent) => KeyboardEventWidget(
                        event: event as KeyboardEvent,
                      ),
                    const (MouseEvent) => MouseEventWidget(
                        event: event as MouseEvent,
                      ),
                    _ => const Text('Unknown Event Type')
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      events.remove(event);
                    });
                  },
                ),
                const SizedBox(width: 30),
              ],
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          log('Reorder: $oldIndex -> $newIndex');
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = events.removeAt(oldIndex);
            events.insert(newIndex, item);
          });
        },
      ),
    );
  }

  void _listener(ProcessStatus p1, String? p2) {
    setState(() {});
  }

  Future<void> _fileChangeHandler(FileSystemEvent event) async {
    if (disposed) return;
    final eventPath = event.path.replaceAll('\\', '/');
    final scriptPath = script.file.path.replaceAll('\\', '/');
    if (eventPath == scriptPath) {
      script = await loadScript(script.file.absolute.path);
      setState(() {
        events.clear();
        events.addAll(script.events);
      });
    }
  }
}
