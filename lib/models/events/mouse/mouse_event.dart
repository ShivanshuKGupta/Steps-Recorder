import '../event.dart';

enum MouseBttn { left, right }

enum MouseEventType { move, press, release, scroll }

class MouseEvent extends Event {
  static const String eventType = 'mouse';
  final MouseEventType mouseEventType;
  num x;
  num y;

  MouseBttn? button;
  num? dx;
  num? dy;

  MouseEvent({
    required this.x,
    required this.y,
    required this.mouseEventType,
    this.dx,
    this.dy,
    this.button,
  }) : super(type: eventType);

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'x': x,
        'y': y,
        'dx': dx,
        'dy': dy,
        'mouseEventType': mouseEventType.name,
        'button': button?.name,
      });
  }

  @override
  MouseEvent.fromJson(super.json)
      : x = num.parse(json['x'].toString()),
        y = num.parse(json['y'].toString()),
        dx = num.tryParse(json['dx'].toString()),
        dy = num.tryParse(json['dy'].toString()),
        mouseEventType = MouseEventType.values
            .firstWhere((e) => e.name == json['mouseEventType'].toString()),
        button = MouseBttn.values
            .where((e) => e.name == json['button'].toString())
            .firstOrNull,
        super.fromJson();
}
