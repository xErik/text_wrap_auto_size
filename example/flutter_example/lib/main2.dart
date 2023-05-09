import 'package:flutter/material.dart';

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
  String _text = 'abc';

  @override
  Widget build(BuildContext context) {
    const style =
        TextStyle(color: Colors.red, fontFamily: 'Aclonica', fontSize: 102);
    final text = Text(_text, style: style);

    return SafeArea(
        child: Scaffold(
      // body: TextWrapAutoSize(text),
      body: Container(
        color: Colors.white,
        width: 360,
        height: 509.2,
        child: FittedBox(
          fit: BoxFit.contain,
          child: text,
        ),
      ),
      // body: text,
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
