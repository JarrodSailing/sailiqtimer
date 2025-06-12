import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'timer_service.dart';

final timerServiceProvider = Provider<TimerService>((ref) {
  final service = TimerService();
  ref.onDispose(() => service.dispose());
  return service;
});