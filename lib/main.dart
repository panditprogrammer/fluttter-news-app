import 'package:flutter/material.dart';
import 'package:inn/screens/home_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      title: "IIN",
      home: Homepage(),
    );
  }
}
