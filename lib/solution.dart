import 'package:flutter/material.dart';

/// Class describes solution of fitting text into an outer box.
class Solution {
  /// For easy reference.
  String text;

  /// Font size has been adjusted, all other properties merged into it.
  TextStyle style;

  /// The size of this text within the outer box.
  Size sizeInner;

  /// The size of the outer box.
  Size sizeOuter;

  /// How many font size tests it took to find this solution.
  int fontSizeTests = -1;

  /// Constructor.
  Solution(this.text, this.style, this.sizeInner, this.sizeOuter);

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
    return '$sizeOuter $sizeInner $style';
  }
}
