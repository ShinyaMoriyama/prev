import 'package:flutter/material.dart';

enum ColorSelect {
  Blue,
  Yellow,
  Brown,
  Red,
  Purple,
  Pink,
  Green,
  Black,
  Orange
}

extension ColorSelectNameExtension on ColorSelect {
  String get name {
    switch (this) {
      case ColorSelect.Blue:
        return 'Blue';
      case ColorSelect.Yellow:
        return 'Yellow';
      case ColorSelect.Brown:
        return 'Brown';
      case ColorSelect.Red:
        return 'Red';
      case ColorSelect.Purple:
        return 'Purple';
      case ColorSelect.Pink:
        return 'Pink';
      case ColorSelect.Green:
        return 'Green';
      case ColorSelect.Black:
        return 'Black';
      case ColorSelect.Orange:
        return 'Orange';
      default:
        return null;
    }
  }
}

extension ColorSelectColorExtension on ColorSelect {
  Color get object {
    switch (this) {
      case ColorSelect.Blue:
        return Colors.blue;
      case ColorSelect.Yellow:
        return Colors.yellow[600];
      case ColorSelect.Brown:
        return Colors.brown;
      case ColorSelect.Red:
        return Colors.red;
      case ColorSelect.Purple:
        return Colors.purple;
      case ColorSelect.Pink:
        return Colors.pink;
      case ColorSelect.Green:
        return Colors.green;
      case ColorSelect.Black:
        return Colors.black;
      case ColorSelect.Orange:
        return Colors.orange;
      default:
        return null;
    }
  }
}
