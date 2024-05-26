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
        color: Colors.purple.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16),
        leading: const Icon(
          Icons.mouse_rounded,
          color: Colors.purple,
        ),
        title: Row(
          children: [
            SizedBox(
              width: 100,
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
                  setState(() {
                    widget.event.mouseEventType = value ?? MouseEventType.press;
                    if (widget.event.mouseEventType == MouseEventType.scroll) {
                      widget.event.dx ??= 0;
                      widget.event.dy ??= 0;
                    }
                  });
                },
              ),
            ),
            if (widget.event.mouseEventType != MouseEventType.scroll) ...[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: 'X: ',
                    alignLabelWithHint: true,
                    counter: SizedBox(),
                    isDense: true,
                    enabledBorder: InputBorder.none,
                  ),
                  controller:
                      TextEditingController(text: widget.event.x.toString()),
                  onChanged: (value) {
                    widget.event.x = num.tryParse(value) ?? 0;
                  },
                  onSubmitted: (value) {
                    setState(() {
                      widget.event.x = num.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: 'Y: ',
                    alignLabelWithHint: true,
                    counter: SizedBox(),
                    isDense: true,
                    enabledBorder: InputBorder.none,
                  ),
                  controller:
                      TextEditingController(text: widget.event.y.toString()),
                  onChanged: (value) {
                    widget.event.y = num.tryParse(value) ?? 0;
                  },
                  onSubmitted: (value) {
                    setState(() {
                      widget.event.y = num.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ] else ...[
              Expanded(
                child: DropdownButtonFormField(
                  items: <num>[-1, 0, 1]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ),
                      )
                      .toList(),
                  isDense: true,
                  value: widget.event.dx,
                  decoration: InputDecoration(
                    prefixText: 'DX: ',
                    isDense: true,
                    enabledBorder: InputBorder.none,
                    floatingLabelStyle: textTheme.bodyLarge,
                  ),
                  onChanged: (value) {
                    widget.event.dx = value ?? 0;
                  },
                ),
              ),
              Expanded(
                child: DropdownButtonFormField(
                  items: <num>[-1, 0, 1]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ),
                      )
                      .toList(),
                  isDense: true,
                  value: widget.event.dx,
                  decoration: InputDecoration(
                    prefixText: 'DY: ',
                    isDense: true,
                    enabledBorder: InputBorder.none,
                    floatingLabelStyle: textTheme.bodyLarge,
                  ),
                  onChanged: (value) {
                    widget.event.dy = value ?? 0;
                  },
                ),
              ),
            ],
          ],
        ),
        onFocusChange: (value) {
          if (!value) setState(() {});
        },
      ),
    );
  }
}
