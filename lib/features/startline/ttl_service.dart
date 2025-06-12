import 'dart:math';
import 'package:geolocator/geolocator.dart';

class TtlService {
  double? calculateTtl({
    required Position? currentPosition,
    required Position? pinEnd,
    required Position? boatEnd,
    required double? heading,
  }) {
    if (currentPosition == null || pinEnd == null || boatEnd == null || heading == null) {
      return null; // Insufficient data
    }

    final distanceToLine = _distanceToLine(
      currentPosition.latitude,
      currentPosition.longitude,
      pinEnd.latitude,
      pinEnd.longitude,
      boatEnd.latitude,
      boatEnd.longitude,
    );

    final lineAngle = _bearing(
      pinEnd.latitude, pinEnd.longitude,
      boatEnd.latitude, boatEnd.longitude,
    );

    final approachAngle = _deg2rad(heading) - (lineAngle + pi / 2);
    final projectedSpeed = cos(approachAngle) * currentPosition.speed;

    // Always calculate with absolute projected speed (heading always included)
    final safeProjectedSpeed = projectedSpeed.abs();

    if (safeProjectedSpeed <= 0.01) {
      return null; // Still safely avoid divide-by-zero if stationary
    }

    return distanceToLine / safeProjectedSpeed;
  }

  double _deg2rad(double deg) => deg * pi / 180.0;

  double _distanceToLine(
      double lat, double lon,
      double lat1, double lon1,
      double lat2, double lon2) {
    
    final phi = _deg2rad(lat);
    final lambda = _deg2rad(lon);
    final phi1 = _deg2rad(lat1);
    final lambda1 = _deg2rad(lon1);
    final phi2 = _deg2rad(lat2);
    final lambda2 = _deg2rad(lon2);

    final R = 6371000.0;

    final d13 = _haversine(phi1, lambda1, phi, lambda);
    final theta13 = _bearing(phi1, lambda1, phi, lambda);
    final theta12 = _bearing(phi1, lambda1, phi2, lambda2);

    final deltaTheta = theta13 - theta12;
    final dXt = asin(sin(d13 / R) * sin(deltaTheta)) * R;

    return dXt.abs();
  }

  double _haversine(double phi1, double lambda1, double phi2, double lambda2) {
    final dPhi = phi2 - phi1;
    final dLambda = lambda2 - lambda1;
    return 2 * asin(sqrt(pow(sin(dPhi / 2), 2) +
        cos(phi1) * cos(phi2) * pow(sin(dLambda / 2), 2))) * 6371000.0;
  }

  double _bearing(double phi1, double lambda1, double phi2, double lambda2) {
    final y = sin(lambda2 - lambda1) * cos(phi2);
    final x = cos(phi1) * sin(phi2) -
        sin(phi1) * cos(phi2) * cos(lambda2 - lambda1);
    return atan2(y, x);
  }
}