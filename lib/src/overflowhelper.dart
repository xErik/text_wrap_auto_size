import 'dart:developer';
import 'dart:math' as m;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:text_wrap_auto_size/solution.dart';

import 'measurementview.dart';

class OverflowHelper {
  final List<int> _candidatesFormer = [];
  int _candidateStep = 200;

  Stack wrapDebug(Text text, Size size) {
    final sol = solution(text, size);
    final txt = _cloneWithStyle(text, sol.style);
    final label =
        "Inner box: ${sol.sizeInner.width} / ${sol.sizeInner.height}\nOuter box: ${sol.sizeOuter.width} / ${sol.sizeOuter.height}";

    return Stack(
      children: [
        Positioned(
            right: 0,
            bottom: 0,
            child: Text(label,
                style: TextStyle(
                  backgroundColor: Colors.white.withAlpha(128),
                ))),
        Positioned(child: txt)
      ],
    );
  }

  Text wrap(Text text, Size size) {
    final sol = solution(text, size);
    return _cloneWithStyle(text, sol.style);
  }

  Solution solution(Text text, Size sizeOuter) {
    final double fontSize = text.style?.fontSize ?? 14.0;

    final TextStyle style = text.style != null
        ? text.style!.merge(TextStyle(fontSize: fontSize))
        : TextStyle(fontSize: fontSize);

    Solution? solIsValid;
    Solution sol = _dimensions(text, style, sizeOuter);

    while (true) {
      bool isValid = sol.isValid;
      bool isValidSame = sol.isValidSame;
      // bool isLarger = sol.isInvalid;

      if (isValid) {
        solIsValid = sol;

        if (isValidSame) {
          // print('EDGE CASE, BREAK');
          break;
        }
      }

      // print(
      //     "SOL: ${sol.size} ${sol.style.fontSize} CTS: $cts isSmaller: $isSmaller isLarger: $isLarger");

      int? candidate = _candidate(isValid);

      if (candidate == null) {
        // print('CANDIDATE IS NULL, BREAK');
        break;
      } else {
        final styleMerged =
            style.merge(TextStyle(fontSize: candidate.toDouble()));
        sol = _dimensions(text, styleMerged, sizeOuter);
      }
    }

    // Should never happen
    if (solIsValid == null) {
      throw 'Do not have a smaller Solution than $sol which is too large.';
    }

    if (kDebugMode) {
      log('Font ${solIsValid.style.fontFamily}/${solIsValid.style.fontSize}pt with inner size ${solIsValid.sizeInner} for outer size ${solIsValid.sizeOuter} in ${_candidatesFormer.length} steps');
    }
    return solIsValid;
  }

  int? _candidate(bool doUp) {
    int? candidate;

    if (_candidatesFormer.isEmpty) {
      candidate = _candidateStep;
      // print("candidate: $candidate");
    } else {
      int direction = doUp ? 1 : -1;
      candidate = _candidatesFormer.last + (_candidateStep * direction);
      // print(
      //     "candidate: $candidate dir: $direction former: ${_candidatesFormer.length}");
    }

    if (_candidatesFormer.contains(candidate)) {
      candidate = null;
    } else {
      _candidatesFormer.add(candidate);
      _candidateStep = m.max(1, _candidateStep ~/ 2);
    }

    return candidate;
  }

  Solution _dimensions(Text text, TextStyle style, Size sizeOuter) {
    bool isSoftWrap = (text.softWrap != null && text.softWrap! == false);
    // bool isMaxLines = text.maxLines != null;

    final w = SizedBox(
        width: isSoftWrap ? null : sizeOuter.width,
        // width: sizeOuter.width,
        child: Directionality(
            textDirection: text.textDirection ?? TextDirection.ltr,
            child: _cloneWithStyle(text, style)));

    final sizeInner = _measureWidget(w);

    return Solution(text.data!, style, sizeInner, sizeOuter);
  }

  Size _measureWidget(Widget widget) {
    final PipelineOwner pipelineOwner = PipelineOwner();
    final MeasurementView rootView = pipelineOwner.rootNode = MeasurementView();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    final RenderObjectToWidgetElement<RenderBox> element =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: rootView,
      debugShortDescription: '[root]',
      child: widget,
    ).attachToRenderTree(buildOwner);
    try {
      rootView.scheduleInitialLayout();
      pipelineOwner.flushLayout();
      return rootView.size;
    } finally {
      element
          .update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
      buildOwner.finalizeTree();
    }
  }

  Text _cloneWithStyle(Text text, TextStyle style) {
    return Text(text.data!,
        textAlign: text.textAlign,
        locale: text.locale,
        softWrap: text.softWrap,
        textScaleFactor: text.textScaleFactor,
        // maxLines: text.maxLines,
        semanticsLabel: text.semanticsLabel,
        strutStyle: text.strutStyle,
        textWidthBasis: text.textWidthBasis,
        textDirection: text.textDirection,
        style: style);
  }
}
