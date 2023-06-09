import 'package:flutter/material.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';

class ExampleMobile extends StatefulWidget {
  // final TextEditingController controller = TextEditingController(
  //     text:
  //         'The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines.');

  final TextEditingController controller = TextEditingController(text: 'test');

  ExampleMobile({super.key});

  @override
  State<ExampleMobile> createState() => _ExampleMobileState();
}

class _ExampleMobileState extends State<ExampleMobile>
    with AutomaticKeepAliveClientMixin<ExampleMobile> {
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
                    decoration:
                        const InputDecoration(hintText: 'Enter some text'),
                    autofocus: true,
                  )),
              const SizedBox(height: 16),
              Container(
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: TextWrapAutoSize(
                  Text(
                    text,
                    key: ValueKey(text),
                  ),
                  // doShowDebug: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
