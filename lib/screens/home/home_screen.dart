import 'dart:io';

import 'package:flutter/material.dart';

import '../../config.dart';
import '../../globals.dart';
import '../../models/events/script/script.dart';
import '../../services/notification_service.dart';
import '../script/script_widget.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Script> scripts = [];

  @override
  void initState() {
    super.initState();
    Directory(scriptsFolder).exists().then((value) async {
      if (!value) {
        await Directory(scriptsFolder).create();
      }
      Directory(scriptsFolder).watch().listen(_fileChange);
    });
    _loadScripts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Steps Recorder',
                style: textTheme.titleLarge,
              ),
              Text(
                'Scripts Directory: $scriptsFolder',
                style:
                    textTheme.bodySmall!.copyWith(color: colorScheme.primary),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_rounded),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: scripts.isEmpty
            ? Center(
                child: Text(
                  'Click on the + button to add a new script',
                  style: textTheme.bodyLarge,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.extent(
                  maxCrossAxisExtent: 300,
                  children:
                      scripts.map((e) => ScriptWidget(script: e)).toList(),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Script',
          child: const Icon(Icons.add_rounded),
          onPressed: () async {
            int i = 1;
            while (true) {
              if (await File('$scriptsFolder/Script $i.json').exists()) {
                i++;
              } else {
                break;
              }
            }
            try {
              String title = 'Script $i';
              await Script(
                title: title,
                events: [],
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ).create();
            } catch (e) {
              showMsg(e.toString());
            }
          },
        ));
  }

  void _fileChange(FileSystemEvent event) {
    _loadScripts();
  }

  void _loadScripts() {
    loadAllScripts().then((value) => setState(() {
          scripts = value;
          scripts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        }));
  }
}
