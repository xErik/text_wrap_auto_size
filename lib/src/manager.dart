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
  Stack wrapDebug(Text text, Size size,
      {Hyphenator? hyphenator, double? minFontSize, double? maxFontSize}) {
    final sol = solution(text, size,
        hyphenator: hyphenator,
        minFontSize: minFontSize,
        maxFontSize: maxFontSize);
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
  Text wrap(Text text, Size size,
      {Hyphenator? hyphenator, double? minFontSize, double? maxFontSize}) {
    final Solution sol = solution(text, size,
        hyphenator: hyphenator,
        minFontSize: minFontSize,
        maxFontSize: maxFontSize);
    return sol.text;
  }

  // ------------------------------------------------------------------------------
  // SOLUTION
  // ------------------------------------------------------------------------------

  /// Returns solution object with the calculated results.
  /// The adjusted font size is stored in `style.fontSize`.
  Solution solution(Text text, Size sizeOuter,
      {Hyphenator? hyphenator, double? minFontSize, double? maxFontSize}) {
    if (minFontSize != null &&
        maxFontSize != null &&
        minFontSize > maxFontSize) {
      throw 'minFontSize must be equal to or smaller than maxFontSize';
    }

    // Reveives smetimes fractions when used inside an adjustable Widget.
    sizeOuter =
        Size(sizeOuter.width.floorToDouble(), sizeOuter.height.floorToDouble());
    // print("  -- sizeOuter: $sizeOuter");
    if (text.data!.isEmpty) {
      return Solution(text, const TextStyle(), const Size(0, 0), sizeOuter);
    }

    final textScalingOne = TextHelper.cloneWithScalingFactorOne(text);

    double initialFontSize = TextHelper.initialFontSize(
        sizeOuter, text.data!, minFontSize, maxFontSize);

    _candidatesFormer.add(initialFontSize.toInt());
    final task = Challenge(textScalingOne, sizeOuter, initialFontSize,
        hyphenator: hyphenator);

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
      const TextStyle();
      int? candidate = _candidate(isValid);
      // print(" -- candidate: $candidate");
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

    int numberOfTests = _candidatesFormer.length + 1;

    if (minFontSize != null && solIsValid.style.fontSize! < minFontSize) {
      final taskNew = Challenge(text, sizeOuter, minFontSize,
          hyphenator: hyphenator, painter: task.painter);

      final sol = strategy.dimensions(taskNew);
      if (sol.isValid == true) {
        solIsValid = sol;
        numberOfTests++;
      }
    }

    if (maxFontSize != null && solIsValid.style.fontSize! > maxFontSize) {
      final taskNew = Challenge(text, sizeOuter, maxFontSize,
          hyphenator: hyphenator, painter: task.painter);

      final sol = strategy.dimensions(taskNew);
      if (sol.isValid == true) {
        solIsValid = sol;
        numberOfTests++;
      }
    }

    solIsValid.fontSizeTests = numberOfTests;

    if (kDebugMode) {
      d.log(
          'font:${solIsValid.style.fontFamily}/${solIsValid.style.fontSize}pt initialFontSize:$initialFontSize | inner:${solIsValid.sizeInner.width}/${solIsValid.sizeInner.height} | outer:${solIsValid.sizeOuter.width}/${solIsValid.sizeOuter.height} | steps:${solIsValid.fontSizeTests} | ${strategy.runtimeType.toString()}');
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
