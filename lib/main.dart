import 'package:flutter/material.dart';

import 'src/overflowhelper.dart';

class TextWrapAutoSize extends StatelessWidget {
  final Text text;

  const TextWrapAutoSize(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints cts) {
      Size size = Size(cts.maxWidth, cts.maxHeight);
      if (size.width == double.infinity || size.height == double.infinity) {
        throw 'BoxContraints have infinite height: $size.\n\nTry wrapping TextAutoSize with Expanded: Expanded(child:TextAutoSize("text")).\n\nTry wrapping TextAutoSize with SizedBox: SizedBox(width:250, height:250, child:TextAutoSize("text"))).\n\n';

        // size = MediaQuery.of(context).size;
      }
      // Is this efficient compared to class field?
      final helper = OverflowHelper(text);
      return helper.wrap(context, size);
    });
  }
}
