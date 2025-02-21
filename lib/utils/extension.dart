import 'package:flutter/material.dart';
extension ColorExt on Color {
  ColorFilter colorFilter() {
    return ColorFilter.mode(this, BlendMode.srcIn);
  }
}
