import 'package:flutter/material.dart';

import '../../models/script/script.dart';

class RecordBar extends StatefulWidget {
  final Script script;
  const RecordBar({required this.script, super.key});

  @override
  State<RecordBar> createState() => _RecordBarState();
}

class _RecordBarState extends State<RecordBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
