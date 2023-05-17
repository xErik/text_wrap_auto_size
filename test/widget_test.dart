import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/text_wrap_auto_size_hyphend.dart';

const text =
    '''The arts are a vast subdivision of culture, composed of many creative endeavors and disciplines. It is a broader term than "art", which as a description of a field usually means only the visual arts. The arts encompass the visual arts, the literary arts and the performing arts – music, theatre, dance and film, among others. This list is by no means comprehensive, but only meant to introduce the concept of the arts. For all intents and purposes, the history of the arts begins with the history of art. The arts might have origins in early human evolutionary prehistory. According to a recent suggestion, several forms of audio and visual arts (rhythmic singing and drumming on external objects, dancing, body and face painting) were developed very early in hominid evolution by the forces of natural selection in order to reach an altered state of consciousness. In this state, which Jordania calls battle trance, hominids and early human were losing their individuality, and were acquiring a new collective identity, where they were not feeling fear or pain, and were religiously dedicated to the group interests, in total disregards of their individual safety and life. This state was needed to defend early hominids from predators, and also to help to obtain food by aggressive scavenging. Ritualistic actions involving heavy rhythmic music, rhythmic drill, coupled sometimes with dance and body painting had been universally used in traditional cultures before the hunting or military sessions in order to put them in a specific altered state of consciousness and raise the morale of participants.''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('text-empty', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(50, 50), const Text(''), 'en_us');

    // print(sol.textString); // String
    expect(sol.textString, '');
  });

// I/flutter (18312): SIZE Size(350.0, 720.0)
// I/flutter (18312): >hello<
// [log] font:null/163.0pt | inner:349.0/191.0 | outer:350.0/720.0 | steps:8 | StrategyNonHyphenate

  test('text-350-hello', () async {
    Solution sol = await TextWrapAutoSizeHyphend.solution(
        const Size(350, 720), const Text('hello'), 'en_us');
    expect(sol.textString, 'hello');
    expect(sol.sizeOuter, const Size(350, 720));
    expect(sol.sizeInner, const Size(350, 70));
    expect(sol.style.fontSize, 70);
    // expect(sol.style.fontSize, 8);
  });
}
