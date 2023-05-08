import 'package:flutter/material.dart';

class Solution {
  String text;
  TextStyle style;
  Size size;
  Solution(this.text, this.style, this.size);

  @override
  String toString() {
    return '$size $style';
  }

  bool isSmaller(Size cts) {
    return size.height < cts.height;
  }

  bool isLarger(Size cts) {
    return (size.width > cts.width) || (size.height > cts.height);
  }
}
