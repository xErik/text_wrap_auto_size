import 'dart:developer' as d;
import 'dart:math' as m;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:text_wrap_auto_size/solution.dart';

import 'challenge.dart';

class OverflowHelper {
  final List<int> _candidatesFormer = [];
  int _candidateStep = 150;

  /// Returns a Stack widget with the adjusted font size some debug output.
  Stack wrapDebug(Text text, Size size) {
    final sol = solution(text, size);
    final txt = sol.text;
    final label =
        "Inner box: ${sol.sizeInner.width} / ${sol.sizeInner.height}\nOuter box: ${sol.sizeOuter.width} / ${sol.sizeOuter.height}\nFont: ${sol.style.fontSize} / Steps: ${sol.fontSizeTests}";

    return Stack(
      children: [
        Positioned(
          child: Container(color: Colors.red, child: txt),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: Text(label,
                textAlign: TextAlign.end,
                style: TextStyle(
                  backgroundColor: Colors.white.withAlpha(220),
                ))),
      ],
    );
  }

  /// Returns a Text widget with the adjusted font size.
  Text wrap(Text text, Size size) {
    return solution(text, size).text;
  }

  /// Returns solution object with the calculated results.
  /// The adjusted font size is in `style.fontSize`.
  Solution solution(Text text, Size sizeOuter) {
    final task = Challenge(text, sizeOuter);

    Solution? solIsValid;
    Solution sol = _dimensions(task);

    while (true) {
      bool isValid = sol.isValid;
      bool isValidSame = sol.isValidSame;

      if (isValid) {
        solIsValid = sol;

        if (isValidSame) {
          break;
        }
      }

      // print(
      //     "SOL: ${sol.size} ${sol.style.fontSize} CTS: $cts isSmaller: $isSmaller isLarger: $isLarger");

      int? candidate = _candidate(isValid);

      if (candidate == null) {
        break;
      } else {
        final taskNew = task.cloneWithFontSize(candidate.toDouble());
        sol = _dimensions(taskNew);
      }
    }

    // Should never happen
    if (solIsValid == null) {
      throw 'Do not have a smaller Solution than $sol which is too large.';
    }

    solIsValid.fontSizeTests = _candidatesFormer.length;

    if (kDebugMode) {
      d.log(
          'Font ${solIsValid.style.fontFamily}/${solIsValid.style.fontSize}pt with inner size ${solIsValid.sizeInner} for outer size ${solIsValid.sizeOuter} in ${solIsValid.fontSizeTests} steps');
    }

    return solIsValid;
  }

  /// Returns the next font size candidate.
  /// Returns NULL if nor more candidates are available.
  int? _candidate(bool doUp) {
    int? candidate;

    if (_candidatesFormer.isEmpty) {
      candidate = _candidateStep;
    } else {
      int direction = doUp ? 1 : -1;
      candidate = _candidatesFormer.last + (_candidateStep * direction);
    }

    if (_candidatesFormer.contains(candidate)) {
      candidate = null;
    } else {
      _candidatesFormer.add(candidate);
      _candidateStep = m.max(1, _candidateStep ~/ 2);
    }

    return candidate;
  }

  Solution _dimensions(Challenge task) {
    //
    // Test for single word exceeding with
    //
    final maxWordWidth = _maxWordWidth(task);
    if (maxWordWidth > task.sizeOuter.width) {
      return Solution(task.text, task.style,
          Size(maxWordWidth, task.sizeOuter.height), task.sizeOuter);
    }

    //
    // Test whole text
    //
    final TextPainter painter = TextPainter(
      text: TextSpan(text: task.text.data, style: task.style),
      textDirection: task.text.textDirection ?? TextDirection.ltr,
      maxLines: task.text.maxLines,
      textScaleFactor: task.text.textScaleFactor ?? 1.0,
      locale: task.text.locale,
      textAlign: task.text.textAlign ?? TextAlign.start,
      textHeightBehavior: task.text.textHeightBehavior,
      textWidthBasis: task.text.textWidthBasis ?? TextWidthBasis.parent,
    )..layout(minWidth: 0, maxWidth: task.sizeOuter.width);
    return Solution(task.text, task.style, painter.size, task.sizeOuter);
  }

  /// Returns the width of the longest word with no line breaking.
  ///
  /// This is a heuristic approach for speed reasons.
  ///
  /// It sorts the words by letter-length, checks the word-width descendingly.
  /// It will only check words with 2 letters less than the longest word.
  final reWhitespace = RegExp('\\s+');
  double _maxWordWidth(Challenge task) {
    double? maxWidth;

    final words =
        task.text.data!.split(reWhitespace).toSet().toList(growable: false);

    words.sort((a, b) => b.length.compareTo(a.length));

    final maxChars = words.first.length;

    final TextPainter painter = TextPainter(
      textDirection: task.text.textDirection ?? TextDirection.ltr,
      maxLines: 1, // test ONLY one line here
      textScaleFactor: task.text.textScaleFactor ?? 1.0,
      locale: task.text.locale,
      textAlign: task.text.textAlign ?? TextAlign.start,
      textHeightBehavior: task.text.textHeightBehavior,
      textWidthBasis: task.text.textWidthBasis ?? TextWidthBasis.parent,
    );

    for (final word in words) {
      // Given a 10 letter word,a 8 letter word is processed, but not an 7 letter word.
      if (word.length + 3 < maxChars) {
        return maxWidth!;
      }

      painter.text = TextSpan(text: word, style: task.style);
      painter.layout(minWidth: 0, maxWidth: double.infinity);
      maxWidth = painter.width;
    }
    return maxWidth!;
  }
}
