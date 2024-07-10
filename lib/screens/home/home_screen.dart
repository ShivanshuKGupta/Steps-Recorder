import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../config.dart';
import '../../globals.dart';
import '../../models/script/script.dart';
import '../../services/notification_service.dart';
import '../../utils/widgets/loading_icon_button.dart';
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
    unawaited(Directory(scriptsFolder).exists().then((exists) async {
      if (!exists) {
        try {
          await Directory(scriptsFolder).create();
        } catch (e) {
          showError('Error creating scripts folder: $e');
        }
      }
      Directory(scriptsFolder).watch().listen(_fileChange);
    }));
    unawaited(_loadScripts());
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
              style: textTheme.bodySmall!.copyWith(color: colorScheme.primary),
            ),
          ],
        ),
        actions: [
          LoadingIconButton(
            tooltip: 'Refresh',
            style: IconButton.styleFrom(
              iconSize: 30,
              foregroundColor: Colors.blue,
            ),
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadScripts,
          ),
          LoadingIconButton(
            tooltip: 'Delete All Scripts',
            style: IconButton.styleFrom(
              iconSize: 30,
              foregroundColor: colorScheme.error,
            ),
            icon: const Icon(Icons.delete_forever_rounded),
            onPressed: _deleteAllScripts,
          ),
          IconButton(
            style: IconButton.styleFrom(iconSize: 30),
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_rounded),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
              setState(() {});
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
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox.shrink(),
                itemCount: scripts.length,
                itemBuilder: (context, index) =>
                    ScriptWidget(script: scripts[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Script',
        child: const Icon(Icons.add_rounded),
        onPressed: () async {
          await createNewScript();
        },
      ),
    );
  }

  void _fileChange(FileSystemEvent event) {
    unawaited(_loadScripts());
  }

  Future<void> _loadScripts() async {
    scripts = await loadAllScripts();
    setState(() {
      scripts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  Future<void> _deleteAllScripts() async {
    final bool? confirmation = await showConfirmDialog(
      title: 'Delete All Scripts',
      content: 'Are you sure you want to delete all scripts?',
    );

    final allScripts = scripts.map((e) => e).toList();
    if (confirmation == true) {
      for (final script in allScripts) {
        try {
          script.delete();
        } catch (e) {
          showError('Error deleting script: $e');
        }
      }
      showMsg('All scripts deleted');
    }
    _loadScripts();
  }
}
