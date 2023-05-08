import 'package:flutter/material.dart';
import 'package:text_wrap_auto_size/main.dart';

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
  String _text = 'text';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: TextWrapAutoSize(Text(_text)),
      //
      // Add or clear text
      //
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() => _text = ''),
            child: const Icon(Icons.clear),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => setState(() {
              _text = ('$_text text').trim();
            }),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    ));
  }
}
