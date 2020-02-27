import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class FontStyles {
  static TextStyle headTextStyle =
      TextStyle(fontSize: 24.0, color: Colors.black);

  static TextStyle normalTextStyle =
      TextStyle(fontSize: 18.0, color: Colors.black);

  static TextStyle taskDeadLineStyle =
      normalTextStyle.copyWith(fontSize: 18.0, color: Colors.red);
}
