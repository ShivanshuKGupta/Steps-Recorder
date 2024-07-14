import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/events/event.dart';
import '../models/events/keyboard/keyboard_event.dart';
import '../models/events/keyboard/special_keys.dart';
import 'process_service.dart';

/// Class which can be used to listen for keyboard events and detect a key combination.
/// When a key combination is detected, it calls the [onDetect] function.
///
/// This can be used to listen for a key combination and call a function when it is detected.
/// Ideally, you use a global instance of [WatchService] to listen for keyboard events.
/// Instead of creating a new instance of [WatchService] for each [KeyCombinationDetector].
class KeyCombinationDetector {
  late String _keyCombination;

  /// The key combination to detect.
  String get keyCombination => _keyCombination;

  /// Sets the key combination to detect,
  /// before setting it, it checks if the key combination is valid.
  set keyCombination(String value) {
    /// Check if the key combination is valid.
    final List<String> keys = value.split('+');
    final invalidKey = check(keys);
    if (invalidKey != null) {
      throw ArgumentError('Invalid key combination: $value');
    }

    /// Sort the keys to make sure the key combination is always the same.
    keys.sort();

    /// Set the key combination.
    _keyCombination = keys.join('+');
  }

  final List<String> _currentKeyCombination = [];

  /// The current key combination being pressed
  String get currentKeyCombination => _currentKeyCombination.join('+');

  /// The [WatchService] used to listen to keyboard events.
  late final WatchService watchService;

  /// The function to call when the key combination is detected.
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
          outputScriptFilePath: null,
          keyboardOnlyMode: true,
        );
  }

  /// Starts watching for keyboard events.
  ///
  /// Do not forget to call [stopWatching] when you are done.
  Future<void> startWatching() async {
    await watchService.record();
    watchService.addListener(_onKeyboardEvent);
  }

  /// Stops watching for keyboard events.
  Future<void> stopWatching() async {
    watchService.removeListener(_onKeyboardEvent);
    await watchService.stopRecording();
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
      debugPrint('Key combination detected: $keyCombination');
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
    debugPrint('Received keyboard event: $data');
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
