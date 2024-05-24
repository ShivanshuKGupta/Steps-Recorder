import 'package:flutter/material.dart';

import '../globals.dart';

void showMsg(dynamic msg) {
  debugPrint(msg.toString());
  ScaffoldMessenger.of(globalContext).showSnackBar(
    SnackBar(
      content: Text(msg.toString()),
      showCloseIcon: true,
    ),
  );
}
