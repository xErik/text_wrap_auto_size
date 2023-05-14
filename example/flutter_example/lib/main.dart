import 'package:flutter/material.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size_hyphend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Demo With Hyphenation',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String text = '';
  String symbol = '\u{00AD}';
  final controller = TextEditingController(
      text:
          'The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines.');

  @override
  void initState() {
    super.initState();
    text = controller.text;
    controller.addListener(() => setState(() => text = controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          _textfield(),
          const SizedBox(height: 16),
          _symbolMenu(),
          const SizedBox(height: 16),
          Container(
            width: 250,
            height: 250,
            color: Colors.grey,
            child:
                // ValueKey(symbol) causes call of
                // initState() in TextWrapAutoSizeHyphend, which is needed to
                // re-initialize its FutureBuilder.
                TextWrapAutoSizeHyphend(
              Text(text),
              'en_us',
              symbol: symbol,
              doShowDebug: true,
              key: ValueKey(symbol),
            ),
          ),
        ],
      )),
    ));
  }

  _textfield() {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(hintText: 'Enter some text'),
      autofocus: true,
    );
  }

  _symbolMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Hyphenation:'),
        const SizedBox(width: 8),
        DropdownMenu<String>(
            enableSearch: false,
            onSelected: (val) => setState(() => symbol = val!),
            initialSelection: symbol,
            dropdownMenuEntries: const [
              DropdownMenuEntry<String>(value: '', label: 'None'),
              DropdownMenuEntry<String>(value: '@', label: '@'),
              DropdownMenuEntry<String>(value: "\u{00AD}", label: 'Soft wrap')
            ]),
      ],
    );
  }
}
