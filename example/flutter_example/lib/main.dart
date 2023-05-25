import 'package:flutter/material.dart';

import 'example_hyphenation.dart';
import 'example_mobile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Hyphenation'),
                // Tab(text: 'Np Hyphenation'),
                Tab(text: 'Mobile'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ExampleHyphenation(),
              // ExampleHyphenationNo(),
              ExampleMobile(),
            ],
          ),
        ),
      ),
    );
  }
}
