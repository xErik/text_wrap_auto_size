import 'package:flutter/material.dart';
import 'package:hyphenatorx/texttokens.dart';

class Challenge {
  final Text text;
  final Size sizeOuter;
  late TextStyle style;
  TextTokens? tokens;

  Challenge(this.text, this.sizeOuter,
      {double fontSize = 14, TextTokens? tokens}) {
    if (text.style == null) {
      style = TextStyle(fontSize: fontSize);
    } else if (text.style!.fontSize == null) {
      style = text.style!.copyWith(fontSize: fontSize);
    }
  }

  Challenge cloneWithFontSize(double fontSize) =>
      Challenge(text, sizeOuter, fontSize: fontSize);

  bool get isOneLine => RegExp(r'\s+').hasMatch(text.data!.trim()) == false;

  // bool get isHyphenated => text.data!.contains('\u{00AD}');

  @override
  String toString() {
    return 'Challenge: $sizeOuter $style';
  }
}
