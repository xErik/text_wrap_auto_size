import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/src/manager.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size_hyphend.dart';

const text =
    '''The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines.''';

void main() {
  late final TextStyle sRoboto;
  late final TextStyle sJellee;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Future<ByteData> data = rootBundle.load('test/Roboto-Regular.ttf');
    FontLoader fontLoader = FontLoader('Roboto')..addFont(data);
    await fontLoader.load();

    data = rootBundle.load('test/jellee.roman.ttf');
    fontLoader = FontLoader('Jellee')..addFont(data);
    await fontLoader.load();

    sRoboto = const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 100,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      decoration: TextDecoration.none,
      height: 1.17,
    );

    sJellee = const TextStyle(
      fontFamily: 'Jellee',
      color: Colors.white,
      height: 1.17,
    );
  });

  // -------------------------------------------------------------------
  // FUNCTION HYPHEN
  // -------------------------------------------------------------------

  test('function-empty-hyphen', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(50, 50), Text('', style: sRoboto), 'en_us');
    expect(sol.textString, '');
  });

  test('function-empty-nohyphen', () async {
    Solution sol =
        TextWrapAutoSize.solution(const Size(50, 50), Text('', style: sRoboto));
    expect(sol.textString, '');
  });

  test('function-solution-hyphen-multiple-words', () async {
    const expected = """
The arts are
a vast subdi-
vision of cul-
ture, com-
posed of
many cre-
ative
endeavors
and disci-
plines.""";

    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(350, 720), Text(text, style: sRoboto), 'en_us');
    // print(sol);
    expect(sol.textString, expected);
    expect(sol.sizeOuter, const Size(350, 720));
    expect(sol.sizeInner, const Size(343, 710));
    expect(sol.style.fontSize, 61);
    expect(sol.text.style!.fontSize, 61);
    expect(sol.isValid, true);
  });

  test('function-solution-hyphen-single-word', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(350, 720), Text('hello', style: sRoboto), 'en_us');
    expect(sol.textString, 'hello');
    expect(sol.sizeOuter, const Size(350, 720));
    expect(sol.sizeInner, const Size(349, 191));
    expect(sol.style.fontSize, 163);
    expect(sol.text.style!.fontSize, 163);
    expect(sol.isValid, true);
  });

  // -------------------------------------------------------------------
  // FUNCTION NO-HYPHEN
  // -------------------------------------------------------------------

  test('function-solution-nohyphen-one-word', () {
    Solution sol = TextWrapAutoSize.solution(
        const Size(360, 509), Text('test', style: sRoboto));
    expect(sol.textString, 'test');
    expect(sol.style.fontSize, 211);
    expect(sol.text.style!.fontSize, 211);
    expect(sol.isValid, true);
    expect(sol.fontSizeTests, 10);
    expect(sol.sizeInner, const Size(359, 247));
  });

  test('function-solution-nohyphen-one-word2', () {
    TextStyle sJellee = const TextStyle(
      fontFamily: 'Jellee',
      color: Colors.white,
      height: 1.17,
    );

    Solution sol = TextWrapAutoSize.solution(
        const Size(370, 744), Text('a', style: sJellee, textScaleFactor: 1.0));
    // print(sol);
    expect(sol.textString, 'a');
    expect(sol.style.fontSize, 636);
    expect(sol.text.style!.fontSize, 636);
    expect(sol.isValid, true);
    expect(sol.fontSizeTests, 339);
    expect(sol.sizeInner, const Size(367, 744));
  });

  test('function-solution-nohyphen-two-words', () {
    Solution sol = TextWrapAutoSize.solution(
        const Size(360, 509), Text('test test', style: sRoboto));
    expect(sol.textString, 'test\ntest');
  });

// [log] font:Jellee/33pt | inner:329/507 | outer:720/511 | steps:192 | StrategyNonHyphenate
  test('function-solution-nohyphen-many-lines-landscape', () {
    // final s0 = Stopwatch();
    // s0.start();
    const test = """as dasd ad adsa s sd
asd
asd asd a
sd adasd
d sad 
as
 sdad sa 

sd ds 
sd s 
 I will 

df sdfsdf

""";

    Solution sol = TextWrapAutoSize.solution(
        const Size(720, 511), Text(test, style: sJellee));
    // expect(sol.textString, 'test\ntest');

    // s0.stop();
    // print('Rounds: ${sol.fontSizeTests}');
    // print('Millis: ${s0.elapsedMilliseconds}');

    expect(sol.fontSizeTests, 10);
  });

  test('function-solution-nohyphen-many-lines-portrait', () {
    const test = """as dasd ad adsa s sd
asd
asd asd a
sd adasd
d sad 
as
 sdad sa 

sd ds 
sd s 
 I will 

df sdfsdf

""";

    Solution sol = TextWrapAutoSize.solution(
        const Size(511, 720), Text(test, style: sJellee));
    // print('p1 Rounds: ${sol.fontSizeTests}');

    expect(sol.fontSizeTests, 10);
  });

  test('function-solution-nohyphen-many-lines-portrait-oneline', () {
    const test = """Let me be your TEXTWRITINGTESTER!""";

    Solution sol = TextWrapAutoSize.solution(
        const Size(426.4, 800.0), Text(test, style: sJellee));
    // print('p2 Rounds: ${sol.fontSizeTests}');
    expect(sol.fontSizeTests, 11);
  });

  // -------------------------------------------------------------------
  // INTERNALS
  // -------------------------------------------------------------------

  test('manager-wrap-nohyphen-single-word', () {
    Text sol =
        Manager().wrap(Text('test', style: sRoboto), const Size(360, 509));
    expect(sol.data!, 'test');
    expect(sol.style!.fontSize, 211);
  });

  test('manager-wrap-nohyphen-multiple-words', () {
    const expected = """The arts are a
vast subdivision
of culture,
composed of
many creative
endeavors and
disciplines.""";

    Text sol = Manager().wrap(Text(text, style: sRoboto), const Size(100, 100));
    expect(sol.data!, expected);
    expect(sol.style!.fontSize, 12);
  });

  test('manager-min-max-font-size', () {
    Text sol = Manager().wrap(
        Text('test', style: sRoboto), const Size(360, 509),
        maxFontSize: 200);
    expect(sol.style!.fontSize, 200);

    sol = Manager().wrap(Text('test', style: sRoboto), const Size(360, 509),
        minFontSize: 211);
    expect(sol.style!.fontSize, 211);

    sol = Manager().wrap(Text('test', style: sRoboto), const Size(360, 509),
        minFontSize: 212);
    expect(sol.style!.fontSize, 211);

    sol = Manager().wrap(Text('test', style: sRoboto), const Size(360, 509),
        minFontSize: 212, maxFontSize: 212);
    expect(sol.style!.fontSize, 211);
  });
}
