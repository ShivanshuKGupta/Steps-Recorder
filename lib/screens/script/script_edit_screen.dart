import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/events/event.dart';
import '../../models/events/keyboard/keyboard_event.dart';
import '../../models/events/mouse/mouse_event.dart';
import '../../models/events/script/script.dart';
import '../../utils/widgets/loading_icon_button.dart';
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
  final events = <Event>[
    // if (kDebugMode) ...[
    //   KeyboardEvent(state: KeyboardButtonState.press, key: 'a'),
    //   KeyboardEvent(state: KeyboardButtonState.release, key: 'a'),
    //   MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.press),
    //   MouseEvent(x: 2, y: 2, mouseEventType: MouseEventType.move),
    //   MouseEvent(x: 2, y: 2, mouseEventType: MouseEventType.release),
    //   MouseEvent(
    //       x: 0, y: 0, dx: 0, dy: -1, mouseEventType: MouseEventType.scroll),
    // ]
  ];

  final allTypeOfEvents = <Event>[
    KeyboardEvent(state: KeyboardButtonState.press, key: 'a'),
    KeyboardEvent(state: KeyboardButtonState.release, key: 'a'),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.move),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.press),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.release),
    MouseEvent(x: 0, y: 0, mouseEventType: MouseEventType.scroll),
  ];

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    script = widget.script;
    events.addAll(script.events);
  }

  @override
  void dispose() {
    script.events = events;
    unawaited(script.save());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(script.title),
            Text(
              script.description ?? 'No description',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        actions: [
          /// Add a keyboard event button
          LoadingIconButton(
            icon: const Icon(
              Icons.keyboard_rounded,
              color: Colors.pink,
            ),
            onPressed: () async {
              final event = KeyboardEvent(
                state: KeyboardButtonState.press,
                key: 'a',
              );
              setState(() {
                events.add(event);
              });
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate,
              );
            },
          ),

          /// Add a mouse event button
          LoadingIconButton(
            icon: const Icon(
              Icons.mouse_rounded,
              color: Colors.purple,
            ),
            onPressed: () async {
              final event = MouseEvent(
                x: 0,
                y: 0,
                mouseEventType: MouseEventType.press,
              );
              setState(() {
                events.add(event);
              });
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate,
              );
            },
          ),
        ],
      ),
      body: ReorderableListView(
        scrollController: _controller,
        children: [
          for (final event in events)
            if (event is KeyboardEvent)
              KeyboardEventWidget(
                key: ValueKey(event.toJson()),
                event: event,
              )
            else if (event is MouseEvent)
              MouseEventWidget(
                key: ValueKey(event.toJson()),
                event: event,
              )
            else
              const Text('Unknown Event Type')
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
}
