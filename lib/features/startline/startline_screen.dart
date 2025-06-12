import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/permissions/permissions_service.dart';
import '../../sensors/gps/gps_provider.dart';
import '../../sensors/heading/heading_provider.dart';
import 'startline_provider.dart';
import 'ttl_service.dart';
import 'package:geolocator/geolocator.dart';

class StartLineScreen extends ConsumerStatefulWidget {
  const StartLineScreen({super.key});

  @override
  ConsumerState<StartLineScreen> createState() => _StartLineScreenState();
}

class _StartLineScreenState extends ConsumerState<StartLineScreen> {
  final ttlService = TtlService();
  int _selectedSeconds = 600; // default 10 min
  int _remainingSeconds = 600;
  bool _timerRunning = false;
  int _pinPressCount = 0;
  int _boatPressCount = 0;
  String error = '';
  late final gpsService = ref.read(gpsServiceProvider);
  late final headingService = ref.read(headingServiceProvider);

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    final permissionService = PermissionsService();
    final granted = await permissionService.requestLocationPermissions();
    if (!granted) {
      setState(() {
        error = 'Location permission denied';
      });
    }
  }

  void cycleTimer() {
    setState(() {
      if (_selectedSeconds == 600) {
        _selectedSeconds = 300;
      } else if (_selectedSeconds == 300) {
        _selectedSeconds = 60;
      } else {
        _selectedSeconds = 600;
      }
      _remainingSeconds = _selectedSeconds;
    });
  }

  void toggleStartReset() {
    if (_timerRunning) {
      setState(() {
        _timerRunning = false;
        _remainingSeconds = _selectedSeconds;
      });
    } else {
      setState(() {
        _timerRunning = true;
      });
      countdown();
    }
  }

  void countdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_timerRunning) return false;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        return true;
      } else {
        setState(() => _timerRunning = false);
        return false;
      }
    });
  }

  Future<void> capturePinEnd() async {
    _pinPressCount++;
    if (_pinPressCount >= 2) {
      try {
        final position = await gpsService.getCurrentPosition();
        ref.read(startLineProvider.notifier).setPinEnd(position);
        _pinPressCount = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pin End set")),
        );
      } catch (e) {
        setState(() => error = 'Error: $e');
      }
    }
  }

  Future<void> captureBoatEnd() async {
    _boatPressCount++;
    if (_boatPressCount >= 2) {
      try {
        final position = await gpsService.getCurrentPosition();
        ref.read(startLineProvider.notifier).setBoatEnd(position);
        _boatPressCount = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Boat End set")),
        );
      } catch (e) {
        setState(() => error = 'Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final startLineState = ref.watch(startLineProvider);
    final gpsStream = gpsService.positionStream;
    final headingStream = headingService.headingStream;

    return Scaffold(
      appBar: AppBar(title: const Text('SailIQ TTL Timer')),
      body: Column(
        children: [
          // Timer (top 50%)
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // TTL (middle 30%)
          Expanded(
            flex: 3,
            child: StreamBuilder<Position>(
              stream: gpsStream,
              builder: (context, gpsSnapshot) {
                return StreamBuilder<double>(
                  stream: headingStream,
                  builder: (context, headingSnapshot) {
                    final ttl = ttlService.calculateTtl(
                      currentPosition: gpsSnapshot.data,
                      pinEnd: startLineState.pinEnd,
                      boatEnd: startLineState.boatEnd,
                      heading: headingSnapshot.data,
                    );

                    return Center(
                      child: Text(
                        ttl != null ? 'TTL: ${ttl.toStringAsFixed(1)} sec' : 'TTL: ---',
                        style: const TextStyle(fontSize: 50),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Buttons (bottom 20%)
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: cycleTimer, child: const Text('Timer')),
                ElevatedButton(
                  onPressed: toggleStartReset,
                  child: Text(_timerRunning ? 'Reset' : 'Start'),
                ),
                ElevatedButton(onPressed: capturePinEnd, child: const Text('Pin End')),
                ElevatedButton(onPressed: captureBoatEnd, child: const Text('Boat End')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}