import 'package:absen_kantor/material/color.dart';
import 'package:flutter/material.dart';
import 'package:absen_kantor/ui/home.dart'; // Gantilah dengan file home yang sesuai

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: greengood,
      ),
    );
  }
}
