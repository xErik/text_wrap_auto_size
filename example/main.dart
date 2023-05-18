import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: ((context) {
          const style = TextStyle(fontFamily: 'Roboto');
          const text = Text('test');

          final TextPainter painter = TextPainter(
            text: TextSpan(text: text.data!, style: style),
            textDirection: text.textDirection ?? TextDirection.ltr,
            maxLines: text.maxLines,
            textScaleFactor: text.textScaleFactor ?? 1.0,
            locale: text.locale,
            textAlign: text.textAlign ?? TextAlign.start,
            textHeightBehavior: text.textHeightBehavior,
            textWidthBasis: text.textWidthBasis ?? TextWidthBasis.parent,
          );

          painter.layout();

          // Unit test: (56, 14)
          // Web: (24, 16)
          // Android:

          print(painter.size);

          return Column(
            children: [text, Text(painter.size.toString())],
          );
        })),
      ),
    );
  }
}
