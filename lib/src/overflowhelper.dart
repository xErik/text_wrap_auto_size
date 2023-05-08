import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'measurementview.dart';
import 'solution.dart';

class OverflowHelper {
  final Text text;
  double? _fontSize;
  TextStyle? _style;
  final List<int> _candidatesFormer = [];
  int _candidateStep = 100;

  OverflowHelper(this.text);

  void initStyle(BuildContext context) {
    _fontSize = text.style?.fontSize ??
        Theme.of(context).textTheme.bodyMedium!.fontSize!;

    _style = text.style != null
        ? text.style!.merge(TextStyle(fontSize: _fontSize))
        : TextStyle(fontSize: _fontSize);
  }

  Text wrap(BuildContext ctx, Size cts) {
    if (_style == null) {
      initStyle(ctx);
    }

    _resetCandidates();

    Solution? solIsSmaller;
    Solution sol = _dimensions(_style!, cts.width);

    while (true) {
      bool isSmaller = sol.isSmaller(cts) ? true : false;
      bool isLarger = sol.isLarger(cts) ? true : false;

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
        TextStyle style =
            _style!.merge(TextStyle(fontSize: candidate.toDouble()));
        sol = _dimensions(style, cts.width);
      }
    }

    // print(
    //     'Calculate font size ${solIsSmaller!.style.fontSize} for size $cts in ${_candidatesFormer.length} steps');

    // Should never happen
    if (solIsSmaller == null) {
      throw 'Do not have a smaller Solution than $sol which is to large.';
    }

    return Text(text.data!,
        style: solIsSmaller.style
            .merge(TextStyle(backgroundColor: Colors.green.withAlpha(20))));
  }

  void _resetCandidates() {
    _candidatesFormer.clear();
    _candidateStep = 200;
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

  Solution _dimensions(TextStyle style, double wrapAt) {
    final w = SizedBox(
        width: wrapAt,
        child: Directionality(
            textDirection: text.textDirection ?? TextDirection.ltr,
            child: Text(text.data!, style: style)));
    final s = measureWidget(w);

    return Solution(text.data!, style, s);
  }

  Size measureWidget(Widget widget) {
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
