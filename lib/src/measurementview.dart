import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension StringExtension on Text {
  Size textHeight(double testWidth, TextStyle testStyle) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: data, style: testStyle),
      textDirection: textDirection ?? TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final countLines = (painter.size.width / testWidth).ceil();
    final height = countLines * painter.size.height;
    print(
        'countLines: $countLines fontSize: ${testStyle.fontSize} height: $height style: $testStyle');
    return Size(testWidth, height);
  }
}

class MeasurementView extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout() {
    assert(child != null);
    child!.layout(const BoxConstraints(), parentUsesSize: true);
    size = child!.size;
  }

  @override
  void debugAssertDoesMeetConstraints() => true;

  static Size measure(Widget widget) {
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
}
