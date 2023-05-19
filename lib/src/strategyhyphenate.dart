import 'package:hyphenatorx/token/wrapresult.dart';

import '../solution.dart';
import 'challenge.dart';
import 'strategy.dart';

class StrategyHyphenate implements Strategy {
  @override
  Solution dimensions(Challenge task) {
    final WrapResult wrap =
        task.hyphenator!.wrap(task.text, task.style, task.sizeOuter.width);

    return Solution(wrap.text, wrap.style, wrap.size, task.sizeOuter);
  }
}
