import 'package:flutter/widgets.dart';

class TextHelper {
  static Text clone(Text t, String str) {
    return Text(
      str,
      style: t.style,
      strutStyle: t.strutStyle,
      textAlign: t.textAlign,
      textDirection: t.textDirection,
      locale: t.locale,
      softWrap: t.softWrap,
      overflow: t.overflow,
      textScaleFactor: t.textScaleFactor,
      maxLines: t.maxLines,
      semanticsLabel: t.semanticsLabel,
      textWidthBasis: t.textWidthBasis,
      textHeightBehavior: t.textHeightBehavior,
      selectionColor: t.selectionColor,
    );
  }
}
