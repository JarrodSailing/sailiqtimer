import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerService {
  Timer? _timer;
  int _remainingSeconds = 0;
  final _timerStreamController = StreamController<int>.broadcast();

  Stream<int> get timerStream => _timerStreamController.stream;

  void start(int seconds) {
    _remainingSeconds = seconds;
    _timer?.cancel();

    _timerStreamController.add(_remainingSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _remainingSeconds--;
      _timerStreamController.add(_remainingSeconds);

      if (_remainingSeconds <= 0) {
        _timer?.cancel();
      }
    });
  }

  void reset() {
    _timer?.cancel();
    _timerStreamController.add(0);
  }

  void dispose() {
    _timer?.cancel();
    _timerStreamController.close();
  }
}