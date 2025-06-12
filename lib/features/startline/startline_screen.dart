import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/permissions/permissions_service.dart';
import '../../sensors/gps/gps_provider.dart';
import 'package:geolocator/geolocator.dart';

class StartLineScreen extends ConsumerStatefulWidget {
  const StartLineScreen({super.key});

  @override
  ConsumerState<StartLineScreen> createState() => _StartLineScreenState();
}

class _StartLineScreenState extends ConsumerState<StartLineScreen> {
  Position? pinEndPosition;
  Position? boatEndPosition;
  String error = '';

  Future<void> requestPermissions() async {
    final permissionService = PermissionsService();
    final granted = await permissionService.requestLocationPermissions();
    if (!granted) {
      setState(() {
        error = 'Location permission denied';
      });
    }
  }

  Future<void> capturePinEnd() async {
    try {
      final gps = ref.read(gpsServiceProvider);
      final position = await gps.getCurrentPosition();
      setState(() => pinEndPosition = position);
    } catch (e) {
      setState(() => error = 'Error: $e');
    }
  }

  Future<void> captureBoatEnd() async {
    try {
      final gps = ref.read(gpsServiceProvider);
      final position = await gps.getCurrentPosition();
      setState(() => boatEndPosition = position);
    } catch (e) {
      setState(() => error = 'Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Line Capture')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: capturePinEnd,
            child: const Text('Capture Pin End'),
          ),
          Text(pinEndPosition != null
              ? 'Pin: ${pinEndPosition!.latitude}, ${pinEndPosition!.longitude}'
              : 'Pin not set'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: captureBoatEnd,
            child: const Text('Capture Boat End'),
          ),
          Text(boatEndPosition != null
              ? 'Boat: ${boatEndPosition!.latitude}, ${boatEndPosition!.longitude}'
              : 'Boat not set'),
          if (error.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(error, style: const TextStyle(color: Colors.red)),
          ]
        ],
      ),
    );
  }
}