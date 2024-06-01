import 'package:flutter/material.dart';

import '../../../globals.dart';
import '../../../models/events/custom/custom_event.dart';
import '../../../utils/extensions/string_extension.dart';

class CustomEventWidget extends StatefulWidget {
  final CustomEvent event;
  const CustomEventWidget({required this.event, super.key});

  @override
  State<CustomEventWidget> createState() => _CustomEventWidgetState();
}

class _CustomEventWidgetState extends State<CustomEventWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16),
        leading: const Icon(
          Icons.code_rounded,
          color: Colors.deepOrangeAccent,
        ),
        title: Row(
          children: [
            SizedBox(
              width: 100,
              child: DropdownButtonFormField(
                items: CustomCommand.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name.toPascalCase()),
                      ),
                    )
                    .toList(),
                isDense: true,
                value: widget.event.command,
                decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  floatingLabelStyle: textTheme.bodyLarge,
                ),
                onChanged: (value) {
                  setState(() {
                    widget.event.command = value ?? CustomCommand.restart;
                    if (widget.event.command == CustomCommand.delay) {
                      widget.event.delay ??= 0.1;
                    }
                  });
                },
              ),
            ),
            if (widget.event.command == CustomCommand.delay)
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    counter: SizedBox(),
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 8),
                    enabledBorder: InputBorder.none,
                    prefixText: 'Delay(sec): ',
                  ),
                  style: textTheme.titleMedium,
                  controller: TextEditingController(
                      text: widget.event.delay?.toString()),
                  onChanged: (value) {
                    widget.event.delay = num.tryParse(value) ?? 0.1;
                  },
                  onSubmitted: (value) {
                    setState(() {
                      widget.event.delay = num.tryParse(value) ?? 0.1;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
        onFocusChange: (value) {
          if (!value) {
            setState(() {});
          }
        },
      ),
    );
  }
}
