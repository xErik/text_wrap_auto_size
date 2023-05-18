import 'package:flutter/material.dart';
import 'package:hyphenatorx/hyphenatorx.dart';

class Challenge {
  final Text text;
  final Size sizeOuter;
  late TextStyle style;
  Hyphenator? hyphenator;

  Challenge(this.text, this.sizeOuter,
      {double fontSize = 14, this.hyphenator}) {
    if (text.style == null) {
      style = TextStyle(fontSize: fontSize);
    } else {
      if (text.style!.fontSize == null) {
        style = text.style!.copyWith(fontSize: fontSize);
      } else {
        style = text.style!;
      }
    }
  }

  Challenge cloneWithFontSize(double fontSize) =>
      Challenge(text, sizeOuter, fontSize: fontSize, hyphenator: hyphenator);

  bool get isOneLine => RegExp(r'\s+').hasMatch(text.data!.trim()) == false;

  @override
  String toString() {
    return 'Challenge: $sizeOuter $style hasTokens: ${hyphenator != null}';
  }
}
