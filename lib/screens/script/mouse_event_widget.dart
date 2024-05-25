import 'package:flutter/material.dart';

import '../../models/events/mouse/mouse_event.dart';

class MouseEventWidget extends StatelessWidget {
  final MouseEvent event;
  const MouseEventWidget({
    required this.event,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(event.toString()));
  }
}
