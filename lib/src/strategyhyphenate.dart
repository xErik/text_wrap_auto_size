import 'package:hyphenatorx/token/wrapresult.dart';

import '../solution.dart';
import 'challenge.dart';
import 'strategy.dart';
import 'texthelper.dart';

class StrategyHyphenate implements Strategy {
  // ------------------------------------------------------------------------------
  // CALCULATE DIMENSION OF CHALLENGE
  // ------------------------------------------------------------------------------

  @override
  Solution dimensions(Challenge task) {
    final WrapResult wrap =
        task.hyphenator!.wrap(task.text, task.style, task.sizeOuter.width);
    //
    // Test for single word exceeding with.
    //
    if (wrap.isSizeMatching == false) {
      return Solution(task.text, task.style, wrap.size, task.sizeOuter);
    }

    // if (kDebugMode) {
    //   d.log(
    //       'render: lines: ${wrap.tokens.length} inner: ${wrap.size} outer: ${task.sizeOuter} fontSize: ${wrap.style.fontSize}');
    // }

    return Solution(TextHelper.clone(wrap.text, wrap.textStr), wrap.style,
        wrap.size, task.sizeOuter);
  }
}
