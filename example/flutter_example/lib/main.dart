import 'package:flutter/material.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String text = 'abcd';
  final controller = TextEditingController(text: 'test');

  @override
  Widget build(BuildContext context) {
    const style =
        TextStyle(fontFamily: 'Aclonica', fontWeight: FontWeight.bold);

    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Enter some text '),
              autofocus: true,
              onChanged: (val) {
                setState(() {
                  controller.text = val;
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length));
                });
              }),
          const SizedBox(height: 16),
          Container(
            width: 250,
            height: 250,
            color: Colors.grey,
            child: TextWrapAutoSize(Text(controller.text, style: style),
                isShowDebug: true),
          ),
        ],
      ),
    ));
  }

  // Size _measureWidget(Widget widget) {
  //   final PipelineOwner pipelineOwner = PipelineOwner();
  //   final MeasurementView rootView = pipelineOwner.rootNode = MeasurementView();
  //   final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  //   final RenderObjectToWidgetElement<RenderBox> element =
  //       RenderObjectToWidgetAdapter<RenderBox>(
  //     container: rootView,
  //     debugShortDescription: '[root]',
  //     child: widget,
  //   ).attachToRenderTree(buildOwner);
  //   try {
  //     rootView.scheduleInitialLayout();
  //     pipelineOwner.flushLayout();
  //     return rootView.size;
  //   } finally {
  //     element
  //         .update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
  //     buildOwner.finalizeTree();
  //   }
  // }
}

// class MeasurementView extends RenderBox
//     with RenderObjectWithChildMixin<RenderBox> {
//   @override
//   void performLayout() {
//     assert(child != null);
//     child!.layout(const BoxConstraints(), parentUsesSize: true);
//     size = child!.size;
//   }

//   @override
//   void debugAssertDoesMeetConstraints() => true;
// }
