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

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final Future<ByteData> data = rootBundle.load('test/Roboto-Regular.ttf');
    final FontLoader fontLoader = FontLoader('Roboto')..addFont(data);
    await fontLoader.load();

    sRoboto = const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 100,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      decoration: TextDecoration.none,
      height: 1.17,
    );
  });

  test('empty', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(50, 50), Text('', style: sRoboto), 'en_us');
    expect(sol.textString, '');
  });

  test('widget-solution-hyphen-multiple-words', () async {
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

  test('widget-solution-hyphen-single-word', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(350, 720), Text('hello', style: sRoboto), 'en_us');
    expect(sol.textString, 'hello');
    expect(sol.sizeOuter, const Size(350, 720));
    expect(sol.sizeInner, const Size(349, 191));
    expect(sol.style.fontSize, 163);
    expect(sol.text.style!.fontSize, 163);
    expect(sol.isValid, true);
  });

  test('widget-solution-nohyphen-single-word', () {
    Solution sol = TextWrapAutoSize.solution(
        const Size(360, 509), Text('test', style: sRoboto));
    expect(sol.textString, 'test');
    expect(sol.style.fontSize, 217);
    expect(sol.text.style!.fontSize, 217);
    expect(sol.isValid, true);
    expect(sol.fontSizeTests, 9);
  });

  test('manager-wrap-single-word', () {
    Text sol = Manager()
        .wrap(Text('test', style: sRoboto), const Size(360, 509), null);
    expect(sol.data!, 'test');
    expect(sol.style!.fontSize, 217);
  });

  test('manager-wrap-multiple-words', () {
    const expected = text;

    Text sol =
        Manager().wrap(Text(text, style: sRoboto), const Size(100, 100), null);
    expect(sol.data!, expected);
    expect(sol.style!.fontSize, 12);
  });
}
