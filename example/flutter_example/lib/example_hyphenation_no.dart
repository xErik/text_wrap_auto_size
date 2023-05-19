import 'package:flutter/material.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';

class ExampleHyphenationNo extends StatefulWidget {
  final TextEditingController controller = TextEditingController(
      text:
          'The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines.');

  ExampleHyphenationNo({super.key});

  @override
  State<ExampleHyphenationNo> createState() => _ExampleHyphenationNoState();
}

class _ExampleHyphenationNoState extends State<ExampleHyphenationNo>
    with AutomaticKeepAliveClientMixin<ExampleHyphenationNo> {
  String text = '';

  @override
  void initState() {
    super.initState();
    text = widget.controller.text;
    widget.controller.addListener(
      () => setState(() {
        // if (widget.controller.text != text) {
        text = widget.controller.text;
        // }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: TextFormField(
                controller: widget.controller,
                decoration: const InputDecoration(hintText: 'Enter some text'),
                autofocus: true,
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: TextWrapAutoSize(
              Text(
                text,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                key: ValueKey(text), // Uh, why is ValueKey needed?
              ),
              doShowDebug: true,
            ),
          ),
        ],
      )),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
