import 'package:flutter/widgets.dart';
import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/src/strategy.dart';

import 'challenge.dart';

class StrategyNonHyphenate implements Strategy {
  // ------------------------------------------------------------------------------
  // CALCULATE DIMENSION OF CHALLENGE
  // ------------------------------------------------------------------------------

  @override
  Solution dimensions(Challenge task) {
    //
    // Test for single word exceeding with
    //
    final doesExceedWidth = _doesWordExceedWidthX(task);

    if (doesExceedWidth) {
      // print(
      //     '   ! doesExceedWidth sizeOuter.width:${task.sizeOuter.width} fontSize:${task.style.fontSize}');
      return Solution(
          task.text,
          task.style,
          Size(task.sizeOuter.width + 1, task.sizeOuter.height),
          task.sizeOuter);
    }

    // final maxWidth = _maxWordWidth(task);
    // if (maxWidth > task.sizeOuter.width) {
    //   return Solution(task.text, task.style,
    //       Size(maxWidth, task.sizeOuter.height), task.sizeOuter);
    // }
    // print('TEST: ${task.style} maxWordWidth:$maxWidth');

    //
    // Test whole text
    //
    final TextPainter painter = TextPainter(
      // text: TextSpan(text: task.text.data, style: task.style),
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: task.text.data,
            style: task.style,
          ),
        ],
      ),
      textDirection: task.text.textDirection ?? TextDirection.ltr,
      maxLines: task.text.maxLines,
      // textScaleFactor: task.text.textScaleFactor ?? 1.0,
      locale: task.text.locale,
      textAlign: task.text.textAlign ?? TextAlign.start,
      textHeightBehavior: task.text.textHeightBehavior,
      // textWidthBasis: task.text.textWidthBasis ?? TextWidthBasis.parent,
      textWidthBasis: TextWidthBasis.longestLine,
    )..layout(minWidth: 0, maxWidth: task.sizeOuter.width);
    return Solution(task.text, task.style, painter.size, task.sizeOuter);
  }

  // ------------------------------------------------------------------------------
  // MAX WORD WIDTH
  // ------------------------------------------------------------------------------

  /// Returns the width of the longest word with no line breaking.
  ///
  /// This is a heuristic approach for speed reasons.
  ///
  /// It sorts the words by letter-length, checks the word-width descendingly.
  /// It will only check words with 2 letters less than the longest word.

  // bool _doesExceedWidth(Challenge task) {
  //   // double maxWidth = 0.0;

  //   final words =
  //       task.text.data!.split(reWhitespace).toSet().toList(growable: false);

  //   words.sort((a, b) => b.length.compareTo(a.length));

  //   // final maxChars = words.first.length;

  //   final TextPainter painter = TextPainter(
  //     textDirection: task.text.textDirection ?? TextDirection.ltr,
  //     maxLines: 1, // test ONLY one line here
  //     textScaleFactor: task.text.textScaleFactor ?? 1.0,
  //     locale: task.text.locale,
  //     textAlign: task.text.textAlign ?? TextAlign.start,
  //     textHeightBehavior: task.text.textHeightBehavior,
  //     textWidthBasis: task.text.textWidthBasis ?? TextWidthBasis.parent,
  //   );

  //   for (final word in words) {
  //     // Given a 10 letter word,a 8 letter word is processed, but not an 7 letter word.
  //     // if (word.length + 3 < maxChars) {
  //     //   return false;
  //     // }

  //     // painter.text =
  //     //     TextSpan(text: word.split('').join('\ufeff"'), style: task.style);
  //     painter.text = TextSpan(
  //       children: <InlineSpan>[
  //         TextSpan(
  //           text: word,
  //           style: task.style,
  //         ),
  //       ],
  //     );

  //     painter.layout(maxWidth: task.sizeOuter.width);

  //     if (painter.didExceedMaxLines) {
  //       return true;
  //     }

  //     // maxWidth = m.max(maxWidth, painter.size.width);
  //   }
  //   return false;
  // }

  // double _maxWordWidth(Challenge task) {
  //   double maxWidth = 0.0;

  //   final words =
  //       task.text.data!.split(reWhitespace).toSet().toList(growable: false);

  //   words.sort((a, b) => b.length.compareTo(a.length));

  //   final maxChars = words.first.length;

  //   final TextPainter painter = TextPainter(
  //     textDirection: task.text.textDirection ?? TextDirection.ltr,
  //     maxLines: 1, // test ONLY one line here
  //     textScaleFactor: task.text.textScaleFactor ?? 1.0,
  //     locale: task.text.locale,
  //     textAlign: task.text.textAlign ?? TextAlign.start,
  //     textHeightBehavior: task.text.textHeightBehavior,
  //     textWidthBasis: task.text.textWidthBasis ?? TextWidthBasis.parent,
  //   );

  //   for (final word in words) {
  //     // Given a 10 letter word,a 8 letter word is processed, but not an 7 letter word.
  //     if (word.length + 3 < maxChars) {
  //       return maxWidth!;
  //     }

  //     // painter.text =
  //     //     TextSpan(text: word.split('').join('\ufeff"'), style: task.style);
  //     painter.text = TextSpan(
  //       children: <InlineSpan>[
  //         TextSpan(
  //           text: word,
  //           style: task.style,
  //         ),
  //         // ),
  //       ],
  //     );

  //     painter.layout();
  //     // painter.didExceedMaxLines;

  //     maxWidth = m.max(maxWidth, painter.size.width);
  //   }
  //   return maxWidth!;
  // }

  final reWhitespace = RegExp(r'[\s\t\n\r ]+');
  bool _doesWordExceedWidthX(Challenge task) {
    // double maxWidth = 0.0;

    final words =
        task.text.data!.split(reWhitespace).toSet().toList(growable: false);

    words.sort((a, b) => b.length.compareTo(a.length));

    // final maxChars = words.first.length;

    final TextPainter painter = TextPainter(
      textDirection: task.text.textDirection ?? TextDirection.ltr,
      maxLines: 1, // test ONLY one line here
      // textScaleFactor: task.text.textScaleFactor ?? 1.0,
      locale: task.text.locale,
      textAlign: task.text.textAlign ?? TextAlign.start,
      textHeightBehavior: task.text.textHeightBehavior,
      // textWidthBasis: task.text.textWidthBasis ?? TextWidthBasis.parent,
      textWidthBasis: TextWidthBasis.longestLine,
    );

    for (final word in words) {
      // Given a 10 letter word,a 8 letter word is processed, but not an 7 letter word.
      // if (word.length + 3 < maxChars) {
      //   return maxWidth!;
      // }

      painter.text = TextSpan(
        // text: word,
        // style: task.style,
        children: <InlineSpan>[
          TextSpan(
            text: word,
            style: task.style,
          ),
        ],
      );
      painter.layout(maxWidth: task.sizeOuter.width);

      if (painter.didExceedMaxLines) {
        return true;
      }

      // maxWidth = m.max(maxWidth, painter.size.width);
    }
    return false;
  }
}
