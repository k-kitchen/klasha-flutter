import 'package:flutter/material.dart';

final appColors = const ThemeModel();

class ThemeModel {
  const ThemeModel({
    this.primary = const Color(0xFFE85243),
    this.primaryLight = const Color(0xFFFCE5E3),
    this.text = const Color(0xFF000000),
    this.subText = const Color(0xFF828282),
    this.lowerText = const Color(0xFFBDBDBD),
    this.grey = const Color(0xFFF0F0F0),
    this.white = const Color(0xFFFFFFFF),
    this.transparent = Colors.transparent,
  });

  final Color primary;
  final Color primaryLight;
  final Color text;
  final Color subText;
  final Color lowerText;
  final Color grey;
  final Color white;
  final Color transparent;
}
