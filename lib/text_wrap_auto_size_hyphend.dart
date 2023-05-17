import 'package:flutter/material.dart';
import 'package:hyphenatorx/hyphenatorx.dart';

import 'solution.dart';
import 'src/manager.dart';

/// This widget auto sizes a Text with respect to the given bounds.
///
/// This widget hyphenates the given `Text`.
///
/// Throws, if unrestricted (infinite) bounds are given.
class TextWrapAutoSizeHyphend extends StatefulWidget {
  final Text text;
  final String language;
  final String symbol;
  final String hyphen;
  final bool doShowDebug;

  const TextWrapAutoSizeHyphend(this.text, this.language,
      {this.symbol = '\u{00AD}',
      this.hyphen = '-',
      this.doShowDebug = false,
      super.key});

  @override
  State<TextWrapAutoSizeHyphend> createState() =>
      _TextWrapAutoSizeHyphendState();
}

class _TextWrapAutoSizeHyphendState extends State<TextWrapAutoSizeHyphend> {
  late Future<Hyphenator> future;
  Widget? cache;
  String cacheKey = '';

  @override
  void initState() {
    super.initState();
    future = Hyphenator.loadAsyncByAbbr(widget.language,
        symbol: widget.symbol, hyphen: widget.hyphen);
  }

  /// This method returns the calculated font size with respect to the given size.
  ///
  /// `Solution` has these fields: `String text`, `TextStyle style` and `Size size`.
  /// The field `size` describes the Size of the text, not the bounding, outer box.
  // ignore: unused_element
  static Future<Solution> solution(Size size, Text text, String language,
      {String symbol = '\u{00AD}'}) async {
    final h = await Hyphenator.loadAsyncByAbbr(language, symbol: symbol);
    return Manager().solution(text, size, h);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.data!.isEmpty) {
      return const Text('');
    }

    return FutureBuilder<Hyphenator>(
      future: future,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snap.hasError) {
          throw snap.error!;
        }

        final Hyphenator h = snap.data!;
        // print('FUTURE');

        // @override
        return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints cts) {
          Size size = Size(cts.maxWidth, cts.maxHeight);
          if (size.width == double.infinity || size.height == double.infinity) {
            throw 'BoxContraints have infinite height: $size.\n\nTry wrapping: Expanded(child:TextWrapAutoSizeHyphend("text")).\n\nTry wrapping: SizedBox(width:250, height:250, child:TextWrapAutoSizeHyphend("text"))).\n\nTry wrapping: SizedBox(\n  width: MediaQuery.of(context).size.width,\n  height: MediaQuery.of(context).size.height,\n  child: TextWrapAutoSizeHyphend(Text(text)))';
          }

          final String cacheKeyCurrent =
              '${widget.text.toString()}|${widget.language}|${widget.symbol}|${widget.hyphen}|${widget.doShowDebug}|$size';

          if (cache == null || cacheKey != cacheKeyCurrent) {
            // print('WRAP FRESH');
            // print('    cacheKey        $cacheKey');
            // print('    cacheKeyCurrent $cacheKeyCurrent');
            cacheKey = cacheKeyCurrent;
            cache = (widget.doShowDebug)
                ? Manager().wrapDebug(widget.text, size, h)
                : Manager().wrap(widget.text, size, h);
          } else {
            // print('WRAP FROM CACHE');
          }

          return cache!;
        });
      },
    );
  }
}
