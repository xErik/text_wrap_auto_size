import 'package:flutter/material.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size_hyphend.dart';

import 'edit_row.dart';

class ExampleHyphenation extends StatefulWidget {
  final TextEditingController controller = TextEditingController(
      text:
          'The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines.');

  ExampleHyphenation({super.key});

  @override
  State<ExampleHyphenation> createState() => _ExampleHyphenationState();
}

class _ExampleHyphenationState extends State<ExampleHyphenation>
    with AutomaticKeepAliveClientMixin<ExampleHyphenation> {
  String text = '';
  TextAlign align = TextAlign.right;
  Color color = Colors.red;
  FontWeight weight = FontWeight.w900;
  bool isHyphenation = false;

  @override
  void initState() {
    super.initState();
    text = widget.controller.text;
    widget.controller.addListener(
      () => setState(() {
        if (widget.controller.text != text) {
          text = widget.controller.text;
        }
      }),
    );
  }

  void setAlign(TextAlign value) {
    setState(() => align = value);
  }

  void setColor(Color value) {
    setState(() => color = value);
  }

  void setWeight(FontWeight value) {
    setState(() => weight = value);
  }

  void setHyphenation(bool value) {
    setState(() => isHyphenation = value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: EditRow(
              widget.controller,
              setAlign,
              setColor,
              setWeight,
              setHyphenation,
              align,
              color,
              weight,
              isHyphenation,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
              flex: 8,
              child: isHyphenation
                  ? TextWrapAutoSizeHyphend(
                      Text(text,
                          style: TextStyle(color: color, fontWeight: weight),
                          textAlign: align),
                      'en_us',
                      doShowDebug: true,
                    )
                  : TextWrapAutoSize(
                      Text(text,
                          style: TextStyle(color: color, fontWeight: weight),
                          textAlign: align),
                      doShowDebug: true,
                    )),
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
