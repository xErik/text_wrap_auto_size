import 'dart:developer' as d;
import 'dart:math' as m;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/src/strategy.dart';
import 'package:text_wrap_auto_size/src/strategyhyphenate.dart';
import 'package:text_wrap_auto_size/src/strategynonhyphenate.dart';
import 'package:text_wrap_auto_size/src/texthelper.dart';

import 'challenge.dart';

class Manager {
  final List<int> _candidatesFormer = [];
  int _candidateStep = 150;
  late final Strategy strategy;

  // ------------------------------------------------------------------------------
  // WRAP TEXT
  // ------------------------------------------------------------------------------

  /// Returns a Stack widget with the adjusted font size some debug output.
  Stack wrapDebug(Text text, Size size, Hyphenator? h) {
    final sol = solution(text, size, h);
    final txt = sol.text;
    final label =
        "Inner box: ${sol.sizeInner.width} / ${sol.sizeInner.height}\nOuter box: ${sol.sizeOuter.width} / ${sol.sizeOuter.height}\nFont: ${sol.style.fontSize} / Steps: ${sol.fontSizeTests}";

    return Stack(
      children: [
        Positioned(child: Container(child: txt)),
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
  Text wrap(Text text, Size size, Hyphenator? h) {
    final Solution sol = solution(text, size, h);
    return sol.text;
  }

  // ------------------------------------------------------------------------------
  // SOLUTION
  // ------------------------------------------------------------------------------

  /// Returns solution object with the calculated results.
  /// The adjusted font size is stored in `style.fontSize`.
  Solution solution(Text text, Size sizeOuter, Hyphenator? hyphenator) {
    if (text.data!.isEmpty) {
      return Solution(text, const TextStyle(), const Size(0, 0), sizeOuter);
    }

    final textScalingOne = TextHelper.cloneWithScalingFactorOne(text);

    final task =
        Challenge(textScalingOne, sizeOuter, 14, hyphenator: hyphenator);

    strategy =
        hyphenator != null ? StrategyHyphenate() : StrategyNonHyphenate();

    Solution? solIsValid;
    Solution sol = strategy.dimensions(task);

    while (true) {
      bool isValid = sol.isValid;
      bool isValidSame = sol.isValidSame;

      if (isValid) {
        // if (kDebugMode) {
        //   print(" ? $sol");
        // }

        solIsValid = sol;
        if (isValidSame) {
          break;
        }
      }

      int? candidate = _candidate(isValid);

      if (candidate == null) {
        break;
      } else {
        // bugfix, though this should never happen?
        if (candidate == task.style.fontSize) {
          continue;
        }

        final taskNew = task.cloneWithFontSize(candidate.toDouble());
        sol = strategy.dimensions(taskNew);
      }
    }

    // Should never happen
    if (solIsValid == null) {
      throw 'Do not have a smaller Solution than $sol which is too large.';
    }

    solIsValid.fontSizeTests = _candidatesFormer.length + 1;

    if (kDebugMode) {
      d.log(
          'font:${solIsValid.style.fontFamily}/${solIsValid.style.fontSize}pt | inner:${solIsValid.sizeInner.width}/${solIsValid.sizeInner.height} | outer:${solIsValid.sizeOuter.width}/${solIsValid.sizeOuter.height} | steps:${solIsValid.fontSizeTests} | ${strategy.runtimeType.toString()}');
    }

    return solIsValid;
  }

  // ------------------------------------------------------------------------------
  // FONT CANDIDATE
  // ------------------------------------------------------------------------------

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
}
