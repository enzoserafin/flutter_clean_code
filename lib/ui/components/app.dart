import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Code',
      debugShowCheckedModeBanner: kDebugMode,
      home: LoginPage(),
    );
  }
}
