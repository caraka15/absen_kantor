import 'package:flutter/material.dart';

const MaterialColor greengood =
    MaterialColor(_greengoodPrimaryValue, <int, Color>{
  50: Color(0xFFE8F3F2),
  100: Color(0xFFC7E1DE),
  200: Color(0xFFA1CDC9),
  300: Color(0xFF7BB9B3),
  400: Color(0xFF5FAAA2),
  500: Color(_greengoodPrimaryValue),
  600: Color(0xFF3D938A),
  700: Color(0xFF34897F),
  800: Color(0xFF2C7F75),
  900: Color(0xFF1E6D63),
});
const int _greengoodPrimaryValue = 0xFF439B92;

const MaterialColor greengoodAccent =
    MaterialColor(_greengoodAccentValue, <int, Color>{
  100: Color(0xFFABFFF3),
  200: Color(_greengoodAccentValue),
  400: Color(0xFF45FFE4),
  700: Color(0xFF2BFFE1),
});
const int _greengoodAccentValue = 0xFF78FFEC;
