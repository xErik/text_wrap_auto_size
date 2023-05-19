import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/src/strategy.dart';

import 'challenge.dart';

class StrategyNonHyphenate implements Strategy {
  @override
  Solution dimensions(Challenge task) {
    return Solution(task.text, task.style, task.paintText(), task.sizeOuter);
  }
}
