import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';

// const text =
//     '''The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines.''';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Future<ByteData> data = rootBundle.load('test/Roboto-Regular.ttf');
    FontLoader fontLoader = FontLoader('Roboto')..addFont(data);
    await fontLoader.load();

    data = rootBundle.load('test/jellee.roman.ttf');
    fontLoader = FontLoader('Jellee')..addFont(data);
    await fontLoader.load();
  });

  testWidgets('function-solution-nohyphen-one-word-specialfont',
      (tester) async {
    TextStyle sJellee = const TextStyle(
      fontFamily: 'Jellee',
      color: Colors.white,
    );

    const str = 'kass';
    const expected = """kass""";

    final text = Text(str, textAlign: TextAlign.right, style: sJellee);

    final app = MaterialApp(
      debugShowMaterialGrid: false,
      home: Scaffold(
          body: Container(
              alignment: Alignment.center,
              color: Colors.black,
              width: 720,
              height: 478,
              child: RepaintBoundary(child: TextWrapAutoSize(text)))),
    );

    await tester.pumpWidget(app);
    await expectLater(
        find.byType(TextWrapAutoSize),
        matchesGoldenFile(
            'function-solution-nohyphen-one-word-specialfont.png'));

    Solution sol = TextWrapAutoSize.solution(const Size(720, 478), text);
    // print(sol);
    expect(sol.textString, expected);
    expect(sol.isValid, true);
    expect(sol.sizeInner, const Size(720, 396));
    expect(sol.fontSizeTests, 12);
    expect(sol.style.fontSize, 330);
  });

  testWidgets('function-solution-nohyphen-one-word-specialfont2',
      (tester) async {
    TextStyle sJellee = const TextStyle(
      fontFamily: 'Jellee',
      color: Colors.white,
      height: 1.2,
    );

    const size = Size(720, 478);
    const str = 'HHH';
    const expected = """HHH""";

    final text = Text(str, textAlign: TextAlign.right, style: sJellee);

    final app = MaterialApp(
      debugShowMaterialGrid: false,
      home: Scaffold(
          body: Container(
              alignment: Alignment.center,
              color: Colors.black,
              width: size.width,
              height: size.height,
              child: RepaintBoundary(child: TextWrapAutoSize(text)))),
    );

    await tester.pumpWidget(app);
    await expectLater(
        find.byType(TextWrapAutoSize),
        matchesGoldenFile(
            'function-solution-nohyphen-one-word-specialfont2.png'));

    Solution sol = TextWrapAutoSize.solution(size, text);
    // print(sol);
    expect(sol.textString, expected);
    expect(sol.isValid, true);
    expect(sol.sizeInner, const Size(720, 367));
    expect(sol.fontSizeTests, 11);
    expect(sol.style.fontSize, 306);
  });

  // testWidgets('function-solution-nohyphen-one-word-specialfont2-padding',
  //     (tester) async {
  //   TextStyle sJellee = const TextStyle(
  //     fontFamily: 'Jellee',
  //     color: Colors.white,
  //     height: 1.2,
  //   );

  //   const padding = EdgeInsets.all(102);
  //   const size = Size(720, 478);
  //   const str = 'HHH';
  //   const expected = """HHH""";

  //   final text = Text(str, textAlign: TextAlign.right, style: sJellee);

  //   final app = MaterialApp(
  //     debugShowMaterialGrid: false,
  //     home: Scaffold(
  //         body: RepaintBoundary(
  //             child: Container(
  //                 alignment: Alignment.center,
  //                 color: Colors.black,
  //                 child: TextWrapAutoSize(
  //                   text,
  //                   paddingSoft: padding,
  //                 )))),
  //   );

  //   await tester.pumpWidget(app);
  //   await expectLater(
  //       find.byType(TextWrapAutoSize),
  //       matchesGoldenFile(
  //           'function-solution-nohyphen-one-word-specialfont2-padding.png'));

  //   Solution sol = TextWrapAutoSize.solution(size, text, padding: padding);
  //   // print(sol);
  //   expect(sol.textString, expected);
  //   expect(sol.isValid, true);
  //   expect(sol.sizeInner, const Size(516, 263));
  //   expect(sol.fontSizeTests, 11);
  //   expect(sol.style.fontSize, 219);
  // });
}
