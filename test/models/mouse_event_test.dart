import 'package:flutter_test/flutter_test.dart';
import 'package:steps_recorder/models/events/event.dart';
import 'package:steps_recorder/models/events/mouse/mouse_event.dart';

void main() {
  group('Mouse Event', () {
    test('Move', () {
      Event event = Event.parse({
        'type': 'mouse',
        'mouseEventType': 'move',
        'x': 10,
        'y': 20.2,
      });
      if (event is! MouseEvent) {
        fail('Event is not a MouseEvent');
      }
      expect(event.x, 10);
      expect(event.y, 20.2);
      expect(event.mouseEventType, MouseEventType.move);

      final json = event.toJson();
      expect(json['x'], 10);
      expect(json['y'], 20.2);
      expect(json['mouseEventType'], 'move');
    });
    test('press', () {
      Event event = Event.parse({
        'type': 'mouse',
        'mouseEventType': 'press',
        'x': 10,
        'y': 20.2,
        'button': 'left',
      });
      if (event is! MouseEvent) {
        fail('Event is not a MouseEvent');
      }
      expect(event.x, 10);
      expect(event.y, 20.2);
      expect(event.mouseEventType, MouseEventType.press);
      expect(event.button, MouseBttn.left);

      final json = event.toJson();
      expect(json['x'], 10);
      expect(json['y'], 20.2);
      expect(json['mouseEventType'], 'press');
      expect(json['button'], 'left');
    });
    test('release', () {
      Event event = Event.parse({
        'type': 'mouse',
        'mouseEventType': 'release',
        'x': 10,
        'y': 20.2,
        'button': 'right',
      });
      if (event is! MouseEvent) {
        fail('Event is not a MouseEvent');
      }
      expect(event.x, 10);
      expect(event.y, 20.2);
      expect(event.mouseEventType, MouseEventType.release);
      expect(event.button, MouseBttn.right);

      final json = event.toJson();
      expect(json['x'], 10);
      expect(json['y'], 20.2);
      expect(json['mouseEventType'], 'release');
      expect(json['button'], 'right');
    });
    test('scroll', () {
      Event event = Event.parse({
        'type': 'mouse',
        'mouseEventType': 'scroll',
        'x': 10,
        'y': 20.2,
        'dx': 1,
        'dy': -2,
      });
      if (event is! MouseEvent) {
        fail('Event is not a MouseEvent');
      }
      expect(event.x, 10);
      expect(event.y, 20.2);
      expect(event.mouseEventType, MouseEventType.scroll);
      expect(event.dx, 1);
      expect(event.dy, -2);

      final json = event.toJson();
      expect(json['x'], 10);
      expect(json['y'], 20.2);
      expect(json['mouseEventType'], 'scroll');
      expect(json['dx'], 1);
      expect(json['dy'], -2);
    });
  });
}
