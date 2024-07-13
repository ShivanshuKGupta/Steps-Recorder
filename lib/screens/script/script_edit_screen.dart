import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../config.dart';
import '../../globals.dart';
import '../../models/event_collections/event_collection_functions.dart';
import '../../models/event_collections/keyboard_type_collection.dart';
import '../../models/event_collections/mouse_move_collection.dart';
import '../../models/events/custom/custom_event.dart';
import '../../models/events/keyboard/keyboard_event.dart';
import '../../models/events/mouse/mouse_event.dart';
import '../../models/script/script.dart';
import '../../services/notification_service.dart';
import '../../utils/widgets/loading_icon_button.dart';
import '../../widgets/play_script_button.dart';
import '../../widgets/record_script_button.dart';
import 'event_widgets/custom_event_widget.dart';
import 'event_widgets/keyboard_event_widget.dart';
import 'event_widgets/keyboard_type_collection_widget.dart';
import 'event_widgets/mouse_collection_widget.dart';
import 'event_widgets/mouse_event_widget.dart';

class ScriptEditScreen extends StatefulWidget {
  final Script script;
  const ScriptEditScreen({required this.script, super.key});

  @override
  State<ScriptEditScreen> createState() => _ScriptEditScreenState();
}

class _ScriptEditScreenState extends State<ScriptEditScreen> {
  late Script script;
  bool disposed = false;
  final folderChangedStream = Directory(scriptsFolder).watch();

  @override
  void initState() {
    super.initState();
    script = widget.script;
    script.events = reduceEvents(script.events);
    folderChangedStream.listen(_fileChangeHandler);
  }

  @override
  void dispose() {
    disposed = true;
    folderChangedStream.listen(null);
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
              controller: TextEditingController(text: script.displayTitle),
              decoration: InputDecoration(
                hintText: 'No Title',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: textTheme.titleLarge,
              ),
              style: textTheme.titleLarge,
              onChanged: (value) {
                script.displayTitle = value;
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayScriptButton(script: script),
                  LoadingIconButton(
                      tooltip: 'Save Script',
                      icon: const Icon(
                        Icons.save_rounded,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        await script.save();
                        setState(() {
                          script.events = reduceEvents(script.events);
                        });
                      }),
                  LoadingIconButton(
                    tooltip: 'Delete Script',
                    icon: Icon(Icons.delete_rounded, color: colorScheme.error),
                    onPressed: () async {
                      final bool? confirmation = await showConfirmDialog(
                        title: 'Delete Script?',
                        content:
                            'Are you sure you want to delete \'${script.displayTitle}\' script?',
                      );
                      if (confirmation == null || !confirmation) return;
                      Navigator.of(context).pop();
                      await Future.delayed(const Duration(milliseconds: 500),
                          () {
                        script.delete();
                      });
                    },
                  ),
                  RecordScriptButton(script: script),
                ],
              ),
              Text(
                'Press ${Config.endKey.name} to stop the recording  ',
                style: textTheme.bodySmall!.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
                      script.events.add(event);
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
                      script.events.add(event);
                    });
                  },
                  label: const Text('Add a Mouse Event'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.code_rounded),
                  onPressed: () {
                    final event = CustomEvent(
                      command: CustomCommand.restart,
                    );
                    setState(() {
                      script.events.add(event);
                    });
                  },
                  label: const Text('Add a Custom Event'),
                ),
              ],
            ),
          ),
        ),
        children: [
          for (final event in script.events)
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
                    const (CustomEvent) => CustomEventWidget(
                        event: event as CustomEvent,
                      ),
                    const (KeyboardTypeCollection) =>
                      KeyboardTypeCollectionWidget(
                          collection: event as KeyboardTypeCollection),
                    const (MouseEventCollection) => MouseCollectionWidget(
                        collection: event as MouseEventCollection),
                    _ => const Text('Unknown Event Type')
                  },
                ),
                IconButton(
                  tooltip: 'Delete Event',
                  icon: Icon(Icons.delete, color: colorScheme.error),
                  onPressed: () {
                    setState(() {
                      script.events.remove(event);
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Copy Event',
                  icon: const Icon(Icons.copy_rounded, color: Colors.blue),
                  onPressed: () {
                    setState(() {
                      script.events
                          .insert(script.events.indexOf(event), event.clone());
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
            final item = script.events.removeAt(oldIndex);
            script.events.insert(newIndex, item);
          });
        },
      ),
    );
  }

  Future<void> _fileChangeHandler(FileSystemEvent event) async {
    if (disposed) return;
    final eventPath = event.path.replaceAll('\\', '/');
    final scriptPath = script.scriptFile.path.replaceAll('\\', '/');
    if (eventPath == scriptPath) {
      script = await loadScript(script.scriptFile.absolute.path);
      setState(() {
        script.events = reduceEvents(script.events);
      });
    }
  }
}
