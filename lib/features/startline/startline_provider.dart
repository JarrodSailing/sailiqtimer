import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class StartLineState {
  final Position? pinEnd;
  final Position? boatEnd;

  StartLineState({this.pinEnd, this.boatEnd});

  StartLineState copyWith({Position? pinEnd, Position? boatEnd}) {
    return StartLineState(
      pinEnd: pinEnd ?? this.pinEnd,
      boatEnd: boatEnd ?? this.boatEnd,
    );
  }
}

class StartLineNotifier extends StateNotifier<StartLineState> {
  StartLineNotifier() : super(StartLineState());

  void setPinEnd(Position position) {
    state = state.copyWith(pinEnd: position);
  }

  void setBoatEnd(Position position) {
    state = state.copyWith(boatEnd: position);
  }
}

final startLineProvider =
    StateNotifierProvider<StartLineNotifier, StartLineState>((ref) {
  return StartLineNotifier();
});