import 'package:flutter/material.dart';

import '../../../globals.dart';
import '../../../models/event_collections/keyboard_type_collection.dart';

class KeyboardTypeCollectionWidget extends StatefulWidget {
  final KeyboardTypeCollection collection;
  const KeyboardTypeCollectionWidget({
    required this.collection,
    super.key,
  });

  @override
  State<KeyboardTypeCollectionWidget> createState() =>
      _KeyboardEventWidgetState();
}

class _KeyboardEventWidgetState extends State<KeyboardTypeCollectionWidget> {
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
          Icons.short_text_rounded,
          color: Colors.blue,
        ),
        title: TextField(
          maxLines: 1,
          decoration: const InputDecoration(
            alignLabelWithHint: true,
            counter: SizedBox(),
            contentPadding: EdgeInsets.only(top: 8),
            isDense: true,
            enabledBorder: InputBorder.none,
            prefixText: 'Text: ',
          ),
          style: textTheme.titleMedium,
          controller: TextEditingController(text: widget.collection.keystrokes),
          onChanged: (value) {
            widget.collection.keystrokes = value;
          },
        ),
      ),
    );
  }
}
