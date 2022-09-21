import 'dart:io';
import 'package:flutter/material.dart';
import '../localization/loc_app.dart';

class TryLater extends StatelessWidget {
  const TryLater({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocApp.translate(LKeys.errorOccurred)),
      content: Text(LocApp.translate(LKeys.pleaseTryLater)),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () => exit(0),
        ),
      ],
    );
  }
}
