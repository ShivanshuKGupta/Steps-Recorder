import 'dart:async';

import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import '../../config.dart';
import '../../globals.dart';
import '../../models/events/keyboard/special_keys.dart';
import '../../models/extensions/string_extension.dart';
import '../../services/notification_service.dart';
import '../../utils/widgets/loading_elevated_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(launchAtStartup.isEnabled().then(
      (enabled) async {
        if (!enabled) {
          Config.startPlayingKeyShortcut = null;
          Config.startRecordingKeyShortcut = null;
          await Config.save();
          setState(() {});
        }
      },
    ));
  }

  @override
  void dispose() {
    unawaited(Config.save().then((value) {
      showMsg('Settings saved!');
    }));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          LoadingElevatedButton(
            icon: const Icon(
              Icons.save_rounded,
            ),
            label: const Text('Save'),
            onPressed: () async {
              await Config.save();
              showMsg('Settings saved!');
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField<SpecialKey>(
              items: SpecialKey.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name.removeUnderScore.toPascalCase()),
                    ),
                  )
                  .toList(),
              value: Config.endKey,
              // style: textTheme.bodySmall,
              decoration: const InputDecoration(
                prefixText: 'End Key: ',
              ),
              onChanged: (value) {
                setState(() {
                  Config.endKey = value ?? SpecialKey.values.first;
                });
              },
            ),
          ),
          TextField(
            controller:
                TextEditingController(text: Config.startPlayingKeyShortcut),
            decoration: InputDecoration(
              hintText: 'Ctrl + Alt + p',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintStyle: textTheme.bodyLarge,
            ),
            style: textTheme.titleLarge,
            onChanged: (value) {
              Config.startPlayingKeyShortcut = value;
            },
            onEditingComplete: () async {
              try {
                Config.startPlayingKeyShortcut = Config.startPlayingKeyShortcut;
              } catch (e) {
                showMsg('Error Saving Script Title: $e');
              }
            },
          ),
          TextField(
            controller:
                TextEditingController(text: Config.startRecordingKeyShortcut),
            decoration: InputDecoration(
              hintText: 'Ctrl + Alt + r',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintStyle: textTheme.bodyLarge,
            ),
            style: textTheme.titleLarge,
            onChanged: (value) {
              Config.startRecordingKeyShortcut = value;
            },
            onEditingComplete: () async {
              try {
                Config.startRecordingKeyShortcut =
                    Config.startRecordingKeyShortcut;
              } catch (e) {
                showMsg('Error Saving Script Title: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
