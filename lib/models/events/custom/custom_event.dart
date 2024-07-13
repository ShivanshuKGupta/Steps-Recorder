import '../event.dart';

enum CustomCommand { restart, delay }

class CustomEvent extends Event {
  static const String eventType = 'custom';

  CustomCommand command;
  num? delay;

  CustomEvent({required this.command, this.delay}) : super(type: eventType);

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'command': command.name,
        'delay': delay,
      });
  }

  @override
  CustomEvent.fromJson(super.json)
      : command =
            CustomCommand.values.firstWhere((e) => e.name == json['command']),
        delay = num.tryParse(json['delay'].toString()),
        super.fromJson();

  @override
  CustomEvent clone() {
    return CustomEvent(
      command: command,
      delay: delay,
    );
  }
}
