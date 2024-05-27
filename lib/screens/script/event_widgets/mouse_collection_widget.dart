import 'package:flutter/material.dart';

import '../../../globals.dart';
import '../../../models/event_collections/mouse_move_collection.dart';
import '../../../models/events/mouse/mouse_event.dart';

class MouseCollectionWidget extends StatefulWidget {
  final MouseEventCollection collection;
  const MouseCollectionWidget({required this.collection, super.key});

  @override
  State<MouseCollectionWidget> createState() => _MouseCollectionWidgetState();
}

class _MouseCollectionWidgetState extends State<MouseCollectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0, right: 12),
            child: Icon(
              Icons.draw_rounded,
              color: Colors.purple,
            ),
          ),
          Text(
            'Move Mouse: ',
            style: textTheme.titleMedium,
          ),
          CustomPaint(
            size: const Size(100, 100),
            painter: MouseCollectionPainter(widget.collection),
          ),
        ],
      ),
    );
  }
}

class MouseCollectionPainter extends CustomPainter {
  final MouseEventCollection collection;
  MouseCollectionPainter(this.collection);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    num maxX = 0, maxY = 0;
    for (final event in collection.events) {
      if (event.x > maxX) {
        maxX = event.x;
      }
      if (event.y > maxY) {
        maxY = event.y;
      }
    }
    path.moveTo(collection.events.first.x * size.width / maxX,
        collection.events.first.y * size.height / maxY);
    for (final event in collection.events) {
      if (event.mouseEventType == MouseEventType.move) {
        path.lineTo(event.x * size.width / maxX, event.y * size.height / maxY);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
