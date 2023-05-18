import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/src/manager.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size_hyphend.dart';

const text =
    '''The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines. It is a broader term than "art", which as a description of a field usually means only the visual arts. The arts encompass the visual arts, the literary arts and the performing arts – music, theatre, dance and film, among others. This list is by no means comprehensive, but only meant to introduce the concept of the arts. For all intents and purposes, the history of the arts begins with the history of art. The arts might have origins in early human evolutionary prehistory. According to a recent suggestion, several forms of audio and visual arts (rhythmic singing and drumming on external objects, dancing, body and face painting) were developed very early in hominid evolution by the forces of natural selection in order to reach an altered state of consciousness. In this state, which Jordania calls battle trance, hominids and early human were losing their individuality, and were acquiring a new collective identity, where they were not feeling fear or pain, and were religiously dedicated to the group interests, in total disregards of their individual safety and life. This state was needed to defend early hominids from predators, and also to help to obtain food by aggressive scavenging. Ritualistic actions involving heavy rhythmic music, rhythmic drill, coupled sometimes with dance and body painting had been universally used in traditional cultures before the hunting or military sessions in order to put them in a specific altered state of consciousness and raise the morale of participants.''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sRoboto = TextStyle(fontFamily: 'roboto');

  setUpAll(() async {
    final Future<ByteData> data = rootBundle.load('test/Roboto-Regular.ttf');
    final FontLoader fontLoader = FontLoader('roboto')..addFont(data);
    await fontLoader.load();
  });

  test('empty', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(50, 50), const Text('', style: sRoboto), 'en_us');
    expect(sol.textString, '');
  });

  test('350-hello', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(350, 720), const Text('hello', style: sRoboto), 'en_us');
    expect(sol.textString, 'hello');
    expect(sol.sizeOuter, const Size(350, 720));
    expect(sol.sizeInner, const Size(349, 196));
    expect(sol.style.fontSize, 163);
    expect(sol.text.style!.fontSize, 163);
    expect(sol.isValid, true);
  });

  test('360-509-test-static', () {
    Solution sol = TextWrapAutoSize.solution(
        const Size(360, 509), const Text('test', style: sRoboto));
    expect(sol.textString, 'test');
    expect(sol.style.fontSize, 211);
    expect(sol.text.style!.fontSize, 211);
    expect(sol.isValid, true);
  });

  test('360-509-test-manager', () {
    Solution sol = Manager().solution(
        const Text('test', style: sRoboto), const Size(360, 509), null);
    expect(sol.textString, 'test');
    // print(sol);
    expect(sol.style.fontSize, 211);
    expect(sol.text.style!.fontSize, 211);
    expect(sol.isValid, true);
  });

  test('360-509-test-wrap', () {
    Text sol = Manager()
        .wrap(const Text('test', style: sRoboto), const Size(360, 509), null);
    expect(sol.style!.fontSize, 211);
  });

  test('textpainter', () {
    const text = Text('test');

    final TextPainter painter = TextPainter(
      text: TextSpan(text: text.data!, style: sRoboto),
      textDirection: text.textDirection ?? TextDirection.ltr,
      maxLines: text.maxLines,
      textScaleFactor: text.textScaleFactor ?? 1.0,
      locale: text.locale,
      textAlign: text.textAlign ?? TextAlign.start,
      textHeightBehavior: text.textHeightBehavior,
      textWidthBasis: text.textWidthBasis ?? TextWidthBasis.parent,
    );

    painter.layout();
    // print(painter.size);

    expect(painter.size, const Size(24, 17));
  });

  //   test
// [log] font:null/211.0pt | inner:359.0/247.0 | outer:360.0/509.0 | steps:8 | StrategyNonHyphenate
}
