import 'package:flutter/material.dart';

import '../globals.dart';

void showMsg(dynamic msg) {
  debugPrint(msg.toString());
  ScaffoldMessenger.of(appContext).showSnackBar(
    SnackBar(
      content: Text(msg.toString()),
      showCloseIcon: true,
    ),
  );
}

void showError(String msg) {
  debugPrint(msg);
  ScaffoldMessenger.of(appContext).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    ),
  );
}
