import 'package:flutter/material.dart';
import 'package:hyphenatorx/hyphenatorx.dart';

class Challenge {
  final Text text;
  final Size sizeOuter;
  late TextStyle style;
  Hyphenator? hyphenator;
  TextPainter? painter;

  Challenge(this.text, this.sizeOuter, double fontSize,
      {this.hyphenator, this.painter}) {
    if (text.style == null) {
      style = TextStyle(fontSize: fontSize);
    } else {
      style = text.style!.copyWith(fontSize: fontSize);
    }

    painter ??= TextPainter(
      textDirection: text.textDirection ?? TextDirection.ltr,
      maxLines: text.maxLines,
      textScaleFactor: text.textScaleFactor ?? 1.0,
      locale: text.locale,
      textAlign: text.textAlign ?? TextAlign.start,
      textHeightBehavior: text.textHeightBehavior,
      textWidthBasis: text.textWidthBasis ?? TextWidthBasis.parent,
    );
  }

  Size paintText() {
    painter!.text = TextSpan(text: text.data, style: style);
    painter!.layout(minWidth: 0, maxWidth: sizeOuter.width);
    return painter!.size;
  }

  Challenge cloneWithFontSize(double fontSize) {
    if (style.fontSize == fontSize) {
      throw 'Setting same fontSize $fontSize will create an endless loop.';
    }
    return Challenge(text, sizeOuter, fontSize,
        hyphenator: hyphenator, painter: painter);
  }

  bool get isOneLine => RegExp(r'\s+').hasMatch(text.data!.trim()) == false;

  @override
  String toString() {
    return 'Challenge: $sizeOuter $style hasTokens: ${hyphenator != null}';
  }
}
