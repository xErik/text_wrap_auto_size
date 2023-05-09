import 'package:flutter/material.dart';

import 'solution.dart';
import 'src/overflowhelper.dart';

/// This widget auto sizes a Text with respect to the given bounds.
///
/// Throws, if unrestricted (infinite) bounds are given.
class TextWrapAutoSize extends StatelessWidget {
  final Text text;
  final bool isShowDebug;

  const TextWrapAutoSize(this.text, {super.key, this.isShowDebug = false});

  /// This method returns the calculated font size with respect to the given size.
  ///
  /// `Solution` has these fields: `String text`, `TextStyle style` and `Size size`.
  /// The field `size` describes the Size of the text, not the bounding, outer box.
  static Solution solution(Size size, Text text) =>
      OverflowHelper().solution(text, size);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints cts) {
      Size size = Size(cts.maxWidth, cts.maxHeight);
      if (size.width == double.infinity || size.height == double.infinity) {
        throw 'BoxContraints have infinite height: $size.\n\nTry wrapping TextAutoSize with Expanded: Expanded(child:TextAutoSize("text")).\n\nTry wrapping TextAutoSize with SizedBox: SizedBox(width:250, height:250, child:TextAutoSize("text"))).\n\n';
      }
      // Is this efficient compared to class field?
      return OverflowHelper().wrapDebug(text, size);
    });
  }
}
