import '../event.dart';
import 'special_keys.dart';

enum KeyboardButtonState { press, release }

class KeyboardEvent extends Event {
  static const String eventType = 'keyboard';
  String? key;
  SpecialKey? specialKey;
  KeyboardButtonState state;

  KeyboardEvent({required this.state, this.key, this.specialKey})
      : assert((key != null) ^ (specialKey != null)),
        super(type: eventType);

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'key': key,
        'specialKey': specialKey?.name,
        'state': state.name,
      });
  }

  @override
  KeyboardEvent.fromJson(super.json)
      : key = json['key'].toString(),
        specialKey = SpecialKey.values
            .where((e) => e.name == json['specialKey'].toString())
            .firstOrNull,
        state = KeyboardButtonState.values
            .firstWhere((e) => e.name == json['state']),
        super.fromJson();
}
