import 'package:flutter_test/flutter_test.dart';
import 'package:steps_recorder/models/events/keyboard/keyboard_event.dart';
import 'package:steps_recorder/services/key_combination_detector.dart';

void main() {
  group(
    'KeyCombinationDetector add event',
    () {
      test(
        'Detection',
        () {
          bool detected = false;
          KeyCombinationDetector detector = KeyCombinationDetector(
            keyCombination: 'ctrl_l+shift+a',
            onDetect: () {
              detected = true;
            },
          );

          detector.add(KeyboardEvent(
            key: 'ctrl_l',
            state: KeyboardButtonState.press,
          ));
          // print(detector.currentKeyCombination);
          expect(detected, false);

          detector.add(KeyboardEvent(
            key: 'shift',
            state: KeyboardButtonState.press,
          ));
          // print(detector.currentKeyCombination);
          expect(detected, false);

          detector.add(KeyboardEvent(
            key: 'a',
            state: KeyboardButtonState.press,
          ));
          // print(detector.currentKeyCombination);
          expect(detected, true);

          detected = false;

          detector.add(KeyboardEvent(
            key: 'ctrl_l',
            state: KeyboardButtonState.release,
          ));
          // print(detector.currentKeyCombination);
          expect(detected, false);

          detector.add(KeyboardEvent(
            key: 'shift',
            state: KeyboardButtonState.release,
          ));
          // print(detector.currentKeyCombination);
          expect(detected, false);

          detector.add(KeyboardEvent(
            key: 'a',
            state: KeyboardButtonState.release,
          ));
          // print(detector.currentKeyCombination);
          expect(detected, false);
        },
      );
    },
  );
}
