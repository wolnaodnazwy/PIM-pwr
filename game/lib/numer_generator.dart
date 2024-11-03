import 'dart:math';

class NumberGenerator {
  int _targetNumber = 0;

  int get targetNumber => _targetNumber;

  void generate(int min, int max) {
    final random = Random();
    _targetNumber = min + random.nextInt(max - min + 1);
  }
}