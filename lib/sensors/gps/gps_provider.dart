import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'gps_service.dart';

final gpsServiceProvider = Provider<GpsService>((ref) {
  return GpsService();
});
