import 'package:flutter/material.dart';

/// Class describes solution of fitting text into an outer box.
class Solution {
  /// For easy reference.
  final Text _text;

  /// Font size has been adjusted, all other properties merged into it.
  final TextStyle style;

  /// The size of this text within the outer box.
  final Size sizeInner;

  /// The size of the outer box.
  /// In case padding is set:
  /// sizeOuter = sizeOuter + padding
  final Size sizeOuter;

  /// How many font size tests it took to find this solution.
  int fontSizeTests = -1;

  /// Constructor.
  Solution(this._text, this.style, this.sizeInner, this.sizeOuter);

  /// Returns the text with the applied `TextStyle`.
  Text get text => Text(_text.data!,
      textAlign: _text.textAlign,
      locale: _text.locale,
      softWrap: _text.softWrap,
      // textScaleFactor has to be 1 for correct results.
      // Manager.solution() takes care of that.
      textScaleFactor: _text.textScaleFactor,
      // maxLines: isOneLine ? 1 : null,
      semanticsLabel: _text.semanticsLabel,
      strutStyle: _text.strutStyle,
      textWidthBasis: _text.textWidthBasis,
      textDirection: _text.textDirection,
      style: style);

  String get textString => _text.data!;

  /// Whether the inner box of the text is smaller than the outer box.
  bool get isValidSame =>
      sizeInner.width == sizeOuter.width &&
      sizeInner.height == sizeOuter.height;

  /// Whether the inner box of the text is smaller than the outer box.
  bool get isValid =>
      sizeInner.width <= sizeOuter.width &&
      sizeInner.height <= sizeOuter.height;

  @override
  String toString() {
    return 'Sol: in:${sizeInner.width}/${sizeInner.height} out:${sizeOuter.width}/${sizeOuter.height} font:${style.fontFamily} size:${style.fontSize} >$textString< isValid/Same:${isValid || isValidSame} ${fontSizeTests == -1 ? '' : "rounds:$fontSizeTests"}';
  }
}
