import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/events/mouse/mouse_event.dart';
import '../../models/extensions/string_extension.dart';

class MouseEventWidget extends StatefulWidget {
  final MouseEvent event;
  const MouseEventWidget({
    required this.event,
    super.key,
  });

  @override
  State<MouseEventWidget> createState() => _MouseEventWidgetState();
}

class _MouseEventWidgetState extends State<MouseEventWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      padding: const EdgeInsets.only(right: 10.0),
      child: ListTile(
        leading: const Icon(Icons.mouse_rounded),
        title: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField(
                items: MouseEventType.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name.toPascalCase()),
                      ),
                    )
                    .toList(),
                isDense: true,
                value: widget.event.mouseEventType,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  floatingLabelStyle: textTheme.bodyLarge,
                ),
                onChanged: (value) {
                  widget.event.mouseEventType = value ?? MouseEventType.press;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
