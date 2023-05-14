import 'package:text_wrap_auto_size/solution.dart';
import 'package:text_wrap_auto_size/src/challenge.dart';

abstract class Strategy {
  Solution dimensions(Challenge task);
}
