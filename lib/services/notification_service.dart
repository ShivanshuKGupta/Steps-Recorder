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
      backgroundColor: colorScheme.error,
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    ),
  );
}

Future<bool?> showConfirmDialog(
    {required String title, required String content}) async {
  return showDialog<bool>(
    context: appContext,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
