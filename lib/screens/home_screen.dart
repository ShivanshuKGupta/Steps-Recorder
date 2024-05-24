import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../services/notification_service.dart';
import '../services/watcher_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<String> events = [];
  final watcher = Watcher(outputFile: 'output.txt');
  late final Ticker ticker;

  @override
  void initState() {
    super.initState();
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
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Text(events[index]);
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
              events.addAll(await opFile.readAsLines());
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
        child: Icon(watcher.isRunning ? Icons.stop : Icons.play_arrow),
      ),
    );
  }

  void _listener(String data) {
    events.add(data);
  }
}
