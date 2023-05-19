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
}
