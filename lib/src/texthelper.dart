import 'dart:math';

import 'package:flutter/widgets.dart';

class TextHelper {
  static Text cloneWithScalingFactorOne(Text t) {
    return Text(
      t.data!,
      style: t.style,
      strutStyle: t.strutStyle,
      textAlign: t.textAlign,
      textDirection: t.textDirection,
      locale: t.locale,
      softWrap: t.softWrap,
      overflow: t.overflow,
      textScaleFactor: 1.0,
      maxLines: t.maxLines,
      semanticsLabel: t.semanticsLabel,
      textWidthBasis: t.textWidthBasis,
      textHeightBehavior: t.textHeightBehavior,
      selectionColor: t.selectionColor,
    );
  }

  static final reNewline = RegExp(r'\r?\n');
  static double initialFontSize(
      Size sizeOuter, String text, double? minFontSize, double? maxFontSize) {
    final lines = text.split(reNewline);
    final double lineCount = lines.length.toDouble();

    if (sizeOuter.width > sizeOuter.height) {
      final fontSize = (sizeOuter.height ~/ lineCount).floorToDouble();
      return fontSizeClamp(fontSize, minFontSize, maxFontSize);
    }

    final maxChars =
        lines.fold(0, (myMax, element) => max(myMax, element.trim().length));

    final fontSize = (sizeOuter.width / (maxChars * 30)).floorToDouble();

    return fontSizeClamp(fontSize, minFontSize, maxFontSize);
  }

  /// Clamps the font size.
  static double fontSizeClamp(
      double fontSize, double? minFontSize, double? maxFontSize) {
    fontSize = minFontSize != null
        ? fontSize.clamp(minFontSize, double.infinity)
        : fontSize;

    fontSize = maxFontSize != null ? fontSize.clamp(1, maxFontSize) : fontSize;

    return fontSize;
  }
}
