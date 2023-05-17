import 'package:flutter/material.dart';

import 'example_hyphenation.dart';
import 'example_hyphenation_no.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Hyphenation'),
                Tab(text: 'Np Hyphenation'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ExampleHyphenation(),
              ExampleHyphenationNo(),
            ],
          ),
        ),
      ),
    );
  }
}
