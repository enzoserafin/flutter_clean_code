import 'package:flutter/material.dart';
import '../helpers/helpers.dart';

Future<void> showLoading(BuildContext context) async {
  await Future.delayed(Duration.zero);
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SimpleDialog(
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            R.strings.wait,
            textAlign: TextAlign.center,
          ),
        ])
      ],
    ),
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
