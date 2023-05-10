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
  final controller = TextEditingController(
      text:
          'Unde est odit dolorum in fuga voluptatem. Consequatur odit nobis nihil labore. A aliquam at officia error.');

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
              decoration: const InputDecoration(hintText: 'Enter some text'),
              autofocus: true,
              onChanged: (val) {
                setState(() {
                  controller.text = val;
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length));
                });
              }),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    color: Colors.grey,
                    child: Text(controller.text,
                        style:
                            style.copyWith(fontSize: 30, fontFamily: 'Roboto')),
                  ),
                  const Text('Font: Roboto / fix: 30'),
                ],
              ),
              Column(children: [
                Container(
                  width: 250,
                  height: 250,
                  color: Colors.grey,
                  child: Text(controller.text,
                      style: style.copyWith(fontSize: 30)),
                ),
                const Text('Font: Aclonica / fix: 30'),
              ]),
              Column(
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    color: Colors.grey,
                    child: TextWrapAutoSize(Text(controller.text, style: style),
                        doShowDebug: true),
                  ),
                  const Text('Font: Aclonica / computed: 30'),
                ],
              )
            ],
          ),
        ],
      ),
    ));
  }
}
