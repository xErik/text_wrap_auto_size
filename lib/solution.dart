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

  /// Constructor.
  Solution(this.text, this.style, this.sizeInner, this.sizeOuter);

  /// Whether the inner box of the text is smaller than the outer box.
  bool get isSmaller => sizeInner.height < sizeOuter.height ? true : false;

  /// Whether the inner box of the text is larger than the outer box.
  bool get isLarger => (sizeInner.width > sizeOuter.width) ||
          (sizeInner.height > sizeOuter.height)
      ? true
      : false;

  @override
  String toString() {
    return '$sizeOuter $sizeInner $style';
  }
}
