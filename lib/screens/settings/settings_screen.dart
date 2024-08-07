import 'dart:async';

import 'package:flutter/material.dart';

import '../../config.dart';
import '../../globals.dart';
import '../../models/events/keyboard/special_keys.dart';
import '../../services/notification_service.dart';
import '../../utils/extensions/string_extension.dart';
import '../../utils/widgets/loading_elevated_button.dart';
import '../../utils/widgets/theme_mode_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // unawaited(launchAtStartup.isEnabled().then(
    //   (enabled) async {
    //     if (!enabled) {
    //       Config.startPlayingKeyShortcut = null;
    //       Config.startRecordingKeyShortcut = null;
    //       await Config.save();
    //       setState(() {});
    //     }
    //   },
    // ));
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
          const ThemeModeButton(),
          LoadingElevatedButton(
            icon: const Icon(
              Icons.save_rounded,
            ),
            label: const Text('Save'),
            onPressed: () async {
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
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  Config.endKey = value ?? SpecialKey.esc;
                });
              },
            ),
          ),
          if (false)
            TextField(
              controller:
                  TextEditingController(text: Config.startPlayingKeyShortcut),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ctrl + Alt + p',
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: textTheme.bodyLarge,
              ),
              style: textTheme.titleLarge,
              onChanged: (value) {
                Config.startPlayingKeyShortcut = value;
              },
              onEditingComplete: () async {
                setState(() {});
              },
            ),
          if (false)
            TextField(
              controller:
                  TextEditingController(text: Config.startRecordingKeyShortcut),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ctrl + Alt + r',
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: textTheme.bodyLarge,
              ),
              style: textTheme.titleLarge,
              onChanged: (value) {
                Config.startRecordingKeyShortcut = value;
              },
              onEditingComplete: () async {
                setState(() {});
              },
            ),
          if (false)
            TextField(
              controller: TextEditingController(text: Config.port.toString()),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '4040',
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: textTheme.bodyLarge,
              ),
              style: textTheme.titleLarge,
              onChanged: (value) {
                Config.port = int.tryParse(value) ?? Config.port;
                if (Config.port < 1024 || Config.port > 65535) {
                  Config.port = 4040;
                }
              },
              onEditingComplete: () async {
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}
