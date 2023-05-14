import 'package:flutter/material.dart';
import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:hyphenatorx/texttokens.dart';
import 'package:text_wrap_auto_size/src/texthelper.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';

import 'solution.dart';
import 'src/manager.dart';

/// This widget auto sizes a Text with respect to the given bounds.
///
/// This widget hyphenates the given `Test`.
///
/// Throws, if unrestricted (infinite) bounds are given.
class TextWrapAutoSizeHyphend extends StatefulWidget {
  final Text text;
  final String language;
  final String symbol;
  final bool doShowDebug;

  const TextWrapAutoSizeHyphend(this.text, this.language,
      {this.symbol = '\u{00AD}', this.doShowDebug = false, super.key});

  @override
  State<TextWrapAutoSizeHyphend> createState() =>
      _TextWrapAutoSizeHyphendState();
}

class _TextWrapAutoSizeHyphendState extends State<TextWrapAutoSizeHyphend> {
  late Future<Hyphenator> future;

  @override
  void initState() {
    super.initState();
    future = Hyphenator.loadAsyncByAbbr(widget.language, symbol: widget.symbol);
  }

  /// This method returns the calculated font size with respect to the given size.
  ///
  /// `Solution` has these fields: `String text`, `TextStyle style` and `Size size`.
  /// The field `size` describes the Size of the text, not the bounding, outer box.
  // ignore: unused_element
  static Future<Solution> solution(Size size, Text text, String language,
      {String symbol = '\u{00AD}'}) async {
    final h = await Hyphenator.loadAsyncByAbbr(language, symbol: symbol);
    final TextTokens tokens = h.hyphenateTextToTokens(text.data!);
    return Manager().solution(text, size, tokens);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Hyphenator>(
        future: future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          } else if (snap.hasError) {
            throw snap.error!;
          }

          final String hyphend = snap.data!.hyphenateText(widget.text.data!);

          return TextWrapAutoSize(TextHelper.clone(widget.text, hyphend),
              doShowDebug: widget.doShowDebug);
        });
  }
}
