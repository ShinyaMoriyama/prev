import 'package:flutter/material.dart';

enum ColorSelect {
  blue,
  yellow,
  brown,
  red,
  purple,
  pink,
  green,
  black,
  orange
}

extension ColorSelectNameExtension on ColorSelect {
  String get name {
    switch (this) {
      case ColorSelect.blue:
        return 'Blue';
      case ColorSelect.yellow:
        return 'Yellow';
      case ColorSelect.brown:
        return 'Brown';
      case ColorSelect.red:
        return 'Red';
      case ColorSelect.purple:
        return 'Purple';
      case ColorSelect.pink:
        return 'Pink';
      case ColorSelect.green:
        return 'Green';
      case ColorSelect.black:
        return 'Black';
      case ColorSelect.orange:
        return 'Orange';
      default:
        return 'Green';
    }
  }
}

extension ColorSelectColorExtension on ColorSelect {
  Color get object {
    switch (this) {
      case ColorSelect.blue:
        return Colors.blue;
      case ColorSelect.yellow:
        return Colors.yellow.shade600;
      case ColorSelect.brown:
        return Colors.brown;
      case ColorSelect.red:
        return Colors.red;
      case ColorSelect.purple:
        return Colors.purple;
      case ColorSelect.pink:
        return Colors.pink;
      case ColorSelect.green:
        return Colors.green;
      case ColorSelect.black:
        return Colors.black;
      case ColorSelect.orange:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}
