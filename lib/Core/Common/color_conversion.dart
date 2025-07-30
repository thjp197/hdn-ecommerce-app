import 'package:flutter/material.dart';

Color getColorFromName(String colorName) {
  switch (colorName) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'pink':
      return Colors.pink;
    case 'bluegrey':
      return Colors.blueGrey;
    case 'blueAccent':
      return Colors.blueAccent;
    case 'blue':
      return Colors.blue;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    case 'brown':
      return Colors.brown;
    default:
       return Colors.blue[100]!; // Màu mặc định
  }
}