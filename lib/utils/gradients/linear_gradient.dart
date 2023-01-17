import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Gradients {
  static List<List<Color>> colors = [
    [
      const Color(0xff000046),
      const Color(0xff1CB5E0),
    ],
    [
      const Color(0xff2657eb),
      const Color(0xffde6161),
    ],
    [
      const Color(0xff333399),
      const Color(0xff9cb486),
    ],[
      const Color(0xff2c3e50),
      const Color(0xffcc5d79),
    ],[
      const Color(0xff43759d),
      const Color(0xff9a7a3d),
    ],
  ];

  static Gradient getGradient(int i) {
    var index = i % 5;
    return LinearGradient(
        colors: colors[index],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight);
  }
}
