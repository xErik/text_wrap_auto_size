import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:text_wrap_auto_size/solution.dart';

import 'measurementview.dart';

class OverflowHelper {
  final List<int> _candidatesFormer = [];
  int _candidateStep = 200;

  Text wrap(Text text, Size size) {
    final sol = solution(text, size);
    return Text(sol.text, style: sol.style);
  }

  Solution solution(Text text, Size size) {
    final double fontSize = text.style?.fontSize ?? 14.0;

    final TextStyle style = text.style != null
        ? text.style!.merge(TextStyle(fontSize: fontSize))
        : TextStyle(fontSize: fontSize);

    Solution? solIsSmaller;
    Solution sol = _dimensions(text, style, size);

    while (true) {
      bool isSmaller = sol.isSmaller;
      bool isLarger = sol.isLarger;

      if (isSmaller) {
        solIsSmaller = sol;
      }

      // print(
      //     "SOL: ${sol.size} ${sol.style.fontSize} CTS: $cts isSmaller: $isSmaller isLarger: $isLarger");

      // Edge case
      if (isSmaller == false && isLarger == false) {
        // print('EDGE CASE, BREAK');
        break;
      }

      int? candidate = _candidate(isSmaller);

      if (candidate == null) {
        // print('CANDIDATE IS NULL, BREAK');
        break;
      } else {
        final styleMerged =
            style.merge(TextStyle(fontSize: candidate.toDouble()));
        sol = _dimensions(text, styleMerged, size);
      }
    }

    // print(
    //     'Calculate font size ${solIsSmaller!.style.fontSize} for size $cts in ${_candidatesFormer.length} steps');

    // Should never happen
    if (solIsSmaller == null) {
      throw 'Do not have a smaller Solution than $sol which is too large.';
    }

    return solIsSmaller;
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
      _candidateStep = max(1, _candidateStep ~/ 2);
    }

    return candidate;
  }

  Solution _dimensions(Text text, TextStyle style, Size sizeOuter) {
    final w = SizedBox(
        width: sizeOuter.width,
        child: Directionality(
            textDirection: text.textDirection ?? TextDirection.ltr,
            child: Text(text.data!, style: style)));
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
      // Clean up.
      element
          .update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
      buildOwner.finalizeTree();
    }
  }
}
