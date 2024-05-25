import 'package:flutter/material.dart';

import '../../models/events/script/script.dart';
import '../../utils/widgets/loading_icon_button.dart';

class ScriptEditScreen extends StatefulWidget {
  final Script script;
  const ScriptEditScreen({required this.script, super.key});

  @override
  State<ScriptEditScreen> createState() => _ScriptEditScreenState();
}

class _ScriptEditScreenState extends State<ScriptEditScreen> {
  late Script script;
  @override
  void initState() {
    super.initState();
    script = widget.script;
  }

  @override
  dispose() {
    script.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(script.title),
            Text(
              script.description ?? 'No description',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        actions: [
          /// Save Button
          LoadingIconButton(
            icon: const Icon(
              Icons.save_rounded,
              color: Colors.blue,
            ),
            onPressed: () async {
              await script.save();
            },
          ),

          /// Play Button
          LoadingIconButton(
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.green,
            ),
            onPressed: () async {
              await script.play();
            },
          ),
        ],
      ),
      body: const Row(
        children: [
          Column(
            children: [
              Text('All Types of Events go here'),
            ],
          ),
          VerticalDivider(),
          Expanded(child: Text('Actions go here'))
        ],
      ),
    );
  }
}
