import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.light,
      backgroundColor: Colors.white);
  static final dark = ThemeData(
      primaryColor: Colors.grey[600],
      brightness: Brightness.dark,
      backgroundColor: Colors.grey[600]);
}
