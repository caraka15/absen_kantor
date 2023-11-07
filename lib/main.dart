import 'package:absen_kantor/material/color.dart';
import 'package:absen_kantor/ui/home.dart';
import 'package:absen_kantor/ui/homeAuth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        primarySwatch: greengood,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final bool isLoggedIn =
      false; // Gantilah dengan logika login yang sesungguhnya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn ? HomePageAuth() : HomePage(),
    );
  }
}
