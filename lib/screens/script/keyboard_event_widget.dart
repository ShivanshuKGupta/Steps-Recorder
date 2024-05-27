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
  late final _keyController = TextEditingController(text: widget.event.key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16),
        leading: const Icon(
          Icons.keyboard_alt_rounded,
          color: Colors.blue,
        ),
        title: Row(
          children: [
            SizedBox(
              width: 100,
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
            SizedBox(
              width: 150,
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
                  prefixText: 'Type: ',
                ),
                onChanged: (String? value) {
                  setState(() {
                    if (value == 'special') {
                      widget.event.specialKey ??= SpecialKey.values.first;
                    } else {
                      widget.event.specialKey = null;
                      widget.event.key ??= 'a';
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: widget.event.specialKey != null
                  ? DropdownButtonFormField<SpecialKey>(
                      items: SpecialKey.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child:
                                  Text(e.name.removeUnderScore.toPascalCase()),
                            ),
                          )
                          .toList(),
                      value: widget.event.specialKey,
                      // style: textTheme.bodySmall,
                      decoration: const InputDecoration(
                        isDense: true,
                        enabledBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.event.specialKey =
                              value ?? SpecialKey.values.first;
                        });
                      },
                    )
                  : TextField(
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        counter: SizedBox(),
                        contentPadding: EdgeInsets.only(top: 8),
                        isDense: true,
                        enabledBorder: InputBorder.none,
                        prefixText: 'Key: ',
                      ),
                      style: textTheme.titleMedium,
                      controller: _keyController,
                      onChanged: (value) {
                        if (value.length > 1) {
                          value = value[1];
                        }
                        widget.event.key = value.isEmpty ? 'a' : value[0];
                        _keyController.text = value;
                      },
                      onSubmitted: (value) {
                        _keyController.text = value.isEmpty ? 'a' : value[0];
                      },
                      onEditingComplete: () {
                        _keyController.text = widget.event.key!;
                      },
                    ),
            ),
          ],
        ),
        onFocusChange: (value) {
          if (!value) {
            setState(
              () {
                widget.event.key ??= 'a';
                _keyController.text = widget.event.key!;
              },
            );
          }
        },
      ),
    );
  }
}
