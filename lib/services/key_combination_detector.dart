import 'dart:convert';

import '../models/events/event.dart';
import '../models/events/keyboard/keyboard_event.dart';
import '../models/events/keyboard/special_keys.dart';
import 'process_service.dart';

class KeyCombinationDetector {
  late String _keyCombination;
  String get keyCombination => _keyCombination;
  set keyCombination(String value) {
    final List<String> keys = value.split('+');
    final invalidKey = check(keys);
    if (invalidKey != null) {
      throw ArgumentError('Invalid key combination: $value');
    }
    keys.sort();
    _keyCombination = keys.join('+');
  }

  final List<String> _currentKeyCombination = [];
  String get currentKeyCombination => _currentKeyCombination.join('+');

  late final WatchService watchService;

  final void Function() onDetect;

  /// Detects a key combination.
  ///
  /// If watchListener is provided, it will be used to listen to keyboard events.
  /// Or else a new [WatchService] will be created.
  KeyCombinationDetector({
    required String keyCombination,
    required this.onDetect,
    WatchService? watchService,
  }) {
    this.keyCombination = keyCombination;
    this.watchService = watchService ??
        WatchService(
          scriptFilePath: null,
          keyboardOnlyMode: true,
        );
  }

  /// Starts watching for keyboard events.
  Future<void> startWatching() async {
    await watchService.record();
    watchService.addListener(_onKeyboardEvent);
  }

  /// Stops watching for keyboard events.
  void stopWatching() {
    watchService.removeListener(_onKeyboardEvent);
    watchService.stopRecording();
  }

  /// Adds/Removes a keyboard event to the current key combination based
  /// on the [KeyboardButtonState]
  void add(KeyboardEvent event) {
    if (event.state == KeyboardButtonState.press) {
      _currentKeyCombination.add(event.specialKey?.name ?? event.key!);
    } else {
      _currentKeyCombination.remove(event.specialKey?.name ?? event.key!);
    }
    _currentKeyCombination.sort();
    if (currentKeyCombination == keyCombination) {
      print('Key combination detected: $keyCombination');
      onDetect();
    }
  }

  /// Checks if the key combination is valid.
  String? check(List<String> keys) {
    for (final key in keys) {
      if (key.length != 1 &&
          !SpecialKey.values.map((e) => e.name).contains(key)) {
        return key;
      }
    }
    return null;
  }

  void _onKeyboardEvent(ProcessStatus status, String? data) {
    print('Received keyboard event: $data');
    if (data == null) return;
    final List<Event?> events = data.split('\n').map((e) {
      if (e.isEmpty) return null;
      final Map<String, dynamic> data = json.decode(e.trim());
      return Event.parse(data);
    }).toList();
    for (final event in events) {
      if (event is KeyboardEvent) {
        add(event);
      }
    }
  }
}
