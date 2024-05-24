import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/events/event.dart';
import '../models/events/keyboard/keyboard_event.dart';
import '../models/events/mouse/mouse_event.dart';
import '../services/execute_service.dart';
import '../services/notification_service.dart';
import '../services/watcher_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Event> events = [];
  final watcher = Watcher(outputFile: 'output.txt');
  final executer = ExecuteService(outputFile: 'output.txt');
  late final Ticker ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final opFile = File(executer.outputFilePath);
      events.clear();
      events.addAll(
          (await opFile.readAsLines()).map((e) => Event.parse(json.decode(e))));
    });
    watcher.addStdoutListener(_listener);
    ticker = createTicker((_) {
      setState(() {});
    });
    ticker.start();
  }

  @override
  void dispose() {
    watcher.removeStdoutListener(_listener);
    watcher.stop();
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                if (executer.isRunning) {
                  executer.stop();
                  showMsg('Execution stopped');
                } else {
                  await executer.start();
                  showMsg('Execution started');
                }
              } catch (e) {
                showMsg(e.toString());
              }
              setState(() {});
            },
            icon: Icon(
              executer.isRunning ? Icons.stop : Icons.play_arrow,
              color: executer.isRunning ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          if (event is KeyboardEvent) {
            return Text(event.specialKey?.name ??
                event.key ??
                'Keybord Event Not Found');
          } else if (event is MouseEvent) {
            return Text(event.mouseEventType.name);
          } else {
            return const Text('Error in event parsing');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            if (watcher.isRunning) {
              watcher.stop();
              showMsg('Stopped watching');
              final opFile = File(watcher.outputFilePath);
              events.clear();
              events.addAll((await opFile.readAsLines())
                  .map((e) => Event.parse(json.decode(e))));
              setState(() {});
            } else {
              await watcher.start();
              showMsg('Watching...');
            }
          } catch (e) {
            showMsg(e.toString());
          }
          setState(() {});
        },
        child: Icon(
          watcher.isRunning ? Icons.stop : Icons.fiber_manual_record_rounded,
          color: watcher.isRunning ? Colors.red : Colors.black,
        ),
      ),
    );
  }

  void _listener(String data) {
    showMsg(data);
  }
}
