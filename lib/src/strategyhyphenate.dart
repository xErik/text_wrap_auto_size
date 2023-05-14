import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:hyphenatorx/texttokens.dart';

import '../solution.dart';
import 'challenge.dart';
import 'strategy.dart';
import 'texthelper.dart';

class StrategyHyphenate implements Strategy {
  // ------------------------------------------------------------------------------
  // CALCULATE DIMENSION OF CHALLENGE
  // ------------------------------------------------------------------------------

  @override
  Solution dimensions(Challenge task) {
    final builder =
        LineBuilder(task.tokens!, task.text, task.style, task.sizeOuter.width);

    //
    // Test for single word exceeding with
    //
    if (builder.maxSyllableWidth > task.sizeOuter.width) {
      return Solution(
          task.text,
          task.style,
          Size(builder.maxSyllableWidth, task.sizeOuter.height),
          task.sizeOuter);
    }

    final lines = builder.lines();
    final size = builder.size();

    return Solution(
        TextHelper.clone(task.text, lines), task.style, size, task.sizeOuter);
  }
}

class LineBuilder {
  final String _hyphen = '-\n';
  late final double _maxWidth;
  // final TextTokens _tokens;
  final List<List<TextPartToken>> _lines = [];
  late final TextPainter _painter;
  final TextStyle _style;
  double maxSyllableWidth = 0;
  late final TextTokenIterator _tokenIter;

  LineBuilder(TextTokens tokens, Text text, this._style, this._maxWidth) {
    final Map<String, Size> tokensWidthCache = {};
    _tokenIter = TextTokenIterator(tokens);

    _painter = TextPainter(
      textDirection: text.textDirection ?? TextDirection.ltr,
      maxLines: text.maxLines,
      textScaleFactor: text.textScaleFactor ?? 1.0,
      locale: text.locale,
      textAlign: text.textAlign ?? TextAlign.start,
      textHeightBehavior: text.textHeightBehavior,
      textWidthBasis: text.textWidthBasis ?? TextWidthBasis.parent,
    );

    for (final TextPartToken part in tokens.parts) {
      if (part is WordToken) {
        for (final WordPartToken p in part.parts) {
          _setWidths(p.text, tokensWidthCache, p);
        }
      } else if (part is TabsAndSpacesToken) {
        _setWidths(part.text, tokensWidthCache, part);
      } else if (part is NewlineToken) {
        part.sizeHyphen = const Size(0, 0);
        part.sizeNoHyphen = part.sizeHyphen;
        part.sizeCurrent = part.sizeHyphen;
      }
    }
  }

  void _setWidths(String syllable, Map<String, Size> tokensWidthCache,
      TextPartToken token) {
    final syllableHyphened = '$syllable$_hyphen';

    if (tokensWidthCache[syllable] == null) {
      _painter.text = TextSpan(text: syllable, style: _style);
      _painter.layout();
      tokensWidthCache[syllable] = _painter.size;

      _painter.text = TextSpan(text: syllableHyphened, style: _style);
      _painter.layout();
      tokensWidthCache[syllableHyphened] = _painter.size;
    }

    final Size sizeNoHyphen = tokensWidthCache[syllable]!;
    final Size sizeHyphen = tokensWidthCache[syllableHyphened]!;

    token.sizeHyphen = sizeHyphen;
    token.sizeNoHyphen = sizeNoHyphen;
    token.sizeCurrent = sizeNoHyphen;
    maxSyllableWidth = max(maxSyllableWidth, sizeNoHyphen.width);
  }

  String render() {
    if (_tokenIter.isEmpty()) {
      return '';
    }

    List<TextPartToken> line = [];

    while (true) {
      var currToken = _tokenIter.current();
      // ------------------------------------------------------------
      // NEWLINE
      // ------------------------------------------------------------
      if (currToken is NewlineToken) {
        line.add(currToken);
        _lines.add([...line]);
        line.clear();
      } else
      // ------------------------------------------------------------
      // TABS AND SPACES
      // ------------------------------------------------------------
      if (currToken is TabsAndSpacesToken) {
        if (_canAddNoHyphen([currToken])) {
          line.add(currToken);
        } else {
          _lines.add([...line]);
          line.clear();
          line.add(currToken);
        }
      } else
      // ------------------------------------------------------------
      // WORD
      // ------------------------------------------------------------
      if (currToken is WordToken) {
        final partLength = currToken.parts.length;
        List<WordPartToken> prelist = [];
        List<WordPartToken> postlist = [];

        // for (var i = 0; i < partLength; i++) {
        for (int i = partLength; i > 0; --i) {
          prelist = currToken.parts.sublist(0, i);
          postlist = currToken.parts.sublist(i, partLength);

          if (i == partLength && _canAddNoHyphen(prelist)) {
            line.addAll([...prelist]);
            prelist.clear();
            postlist.clear();
            break;
          } else if (_canAddHyphenlast(prelist)) {
            line.addAll(_doHyphenLast(prelist));
            _lines.add([...line]);
            line.clear();
            line.addAll(postlist);
            prelist.clear();
            postlist.clear();
            break;
          }
        }

        if (prelist.isNotEmpty || postlist.isNotEmpty) {
          throw 'Cannot fit: $currToken';
        }
      }

      // ------------------------------------------------------------
      // NEXT TOKEN
      // ------------------------------------------------------------

      if (_tokenIter.hasNext()) {
        currToken = _tokenIter.next();
      } else {
        break;
      }
    }

    return lines();
  }

  bool _canAddNoHyphen(final List<TextPartToken> tokens) {
    final double w =
        _lines.last.fold(0, (sum, item) => sum + item.sizeCurrent!.width);
    return w + tokens.fold(0, (sum, item) => item.sizeCurrent!.width) <=
        _maxWidth;
  }

  bool _canAddHyphenlast(final List<WordPartToken> tokens) {
    double w =
        _lines.last.fold(0, (sum, item) => sum + item.sizeCurrent!.width);

    w += _doHyphenLast(tokens)
        .fold<double>(0, (sum, item) => sum + item.sizeCurrent!.width);

    return w <= _maxWidth;
  }

  List<TextPartToken> _doHyphenLast(List<WordPartToken> tokens) {
    return tokens.sublist(0, tokens.length - 1)
      ..add(tokens.last.toHyphenAndSize(_hyphen));
  }

  Size size() {
    _painter.text = TextSpan(text: lines(), style: _style);
    _painter.layout();
    return _painter.size;
  }

  /// Returns render-ready result including newlines, spaces and syllables.
  String lines() {
    return _lines
        .map<String>((line) => line.map((e) => e.render()).join())
        .join();
  }
}
