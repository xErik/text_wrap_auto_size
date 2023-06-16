import 'package:flutter/material.dart';

import 'solution.dart';
import 'src/manager.dart';

/// This widget auto sizes a Text with respect to the given bounds.
///
/// Throws, if unrestricted (infinite) bounds are given.
class TextWrapAutoSize extends StatelessWidget {
  final Text text;
  final double? minFontSize;
  final double? maxFontSize;
  final bool doShowDebug;

  /// Constructor.
  const TextWrapAutoSize(this.text,
      {super.key,
      this.minFontSize,
      this.maxFontSize,
      this.doShowDebug = false});

  /// This method returns the calculated font size with respect to the given size.
  ///
  /// `Solution` has these fields: `String text`, `TextStyle style` and `Size size`.
  /// The field `size` describes the Size of the text, not the bounding, outer box.
  static Solution solution(Size size, Text text,
          {double? minFontSize, double? maxFontSize}) =>
      Manager().solution(text, size,
          minFontSize: minFontSize, maxFontSize: maxFontSize);

  @override
  Widget build(BuildContext context) {
    if (text.data!.isEmpty) {
      return const Text('');
    }

    return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints cts) {
      Size size = Size(cts.maxWidth, cts.maxHeight);
      if (size.width == double.infinity || size.height == double.infinity) {
        throw 'BoxContraints have infinite height: $size.\n\nTry wrapping TextAutoSize with Expanded: Expanded(child:TextAutoSize("text")).\n\nTry wrapping TextAutoSize with SizedBox: SizedBox(width:250, height:250, child:TextAutoSize("text"))).\n\n';
      }

      if (doShowDebug) {
        return Manager().wrapDebug(text, size,
            minFontSize: minFontSize, maxFontSize: maxFontSize);
      } else {
        return Manager().wrap(text, size,
            minFontSize: minFontSize, maxFontSize: maxFontSize);
      }
    });
  }
}
