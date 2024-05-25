import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/events/keyboard/keyboard_event.dart';
import '../../models/events/keyboard/special_keys.dart';
import '../../models/extensions/string_extension.dart';

class KeyboardEventWidget extends StatefulWidget {
  final KeyboardEvent event;
  const KeyboardEventWidget({
    required this.event,
    super.key,
  });

  @override
  State<KeyboardEventWidget> createState() => _KeyboardEventWidgetState();
}

class _KeyboardEventWidgetState extends State<KeyboardEventWidget> {
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
        title: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField(
                items: KeyboardButtonState.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name.toPascalCase()),
                      ),
                    )
                    .toList(),
                isDense: true,
                value: widget.event.state,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  floatingLabelStyle: textTheme.bodyLarge,
                ),
                onChanged: (KeyboardButtonState? value) {
                  widget.event.state = value ?? KeyboardButtonState.press;
                },
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                items: ['special', 'key']
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toPascalCase()),
                      ),
                    )
                    .toList(),
                value: widget.event.specialKey != null ? 'special' : 'key',
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (String? value) {
                  setState(() {
                    if (value == 'special') {
                      widget.event.specialKey ??= SpecialKey.values.first;
                    } else {
                      widget.event.specialKey = null;
                      widget.event.key ??= null;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        subtitle: widget.event.specialKey != null
            ? DropdownButtonFormField<SpecialKey>(
                items: SpecialKey.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name.toPascalCase()),
                      ),
                    )
                    .toList(),
                value: widget.event.specialKey,
                style: textTheme.bodySmall,
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    widget.event.specialKey = value ?? SpecialKey.values.first;
                  });
                },
              )
            : TextField(
                // widget.event.specialKey?.name ?? widget.event.key ?? '',
                maxLength: 1,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  counter: SizedBox(),
                  isDense: true,
                  enabledBorder: InputBorder.none,
                ),
                controller: TextEditingController(text: widget.event.key),
                onChanged: (value) {
                  widget.event.key = value.isEmpty ? 'a' : value[0];
                },
                onSubmitted: (value) {
                  setState(() {
                    widget.event.key = value.isEmpty ? 'a' : value[0];
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    widget.event.key = widget.event.key ?? 'a';
                  });
                },
              ),
        onFocusChange: (value) {
          if (!value) {
            setState(() {
              widget.event.key = widget.event.key ?? 'a';
            });
          }
        },
      ),
    );
  }
}
