import 'package:absen_kantor/widget/navbar.dart';
import 'package:flutter/material.dart';

class HomePageAuth extends StatelessWidget {
  const HomePageAuth({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
