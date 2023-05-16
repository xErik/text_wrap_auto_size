import 'package:flutter/material.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size_hyphend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo With Hyphenation',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final TextEditingController controller = TextEditingController(
      text:
          'The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines.');

  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            child: TextWrapAutoSizeHyphend(
              Text(
                text,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                key: ValueKey(text), // Uh, why is ValueKey needed?
              ),
              'en_us',
              doShowDebug: true,
            ),
          ),
        ],
      )),
    ));
  }
}
