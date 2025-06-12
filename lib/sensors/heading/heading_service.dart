import 'package:flutter_compass/flutter_compass.dart';

class HeadingService {
  HeadingService();

  Stream<double> get headingStream {
    return FlutterCompass.events!.map((event) {
      final rawHeading = event.heading ?? 0.0;
      return _normalizeHeading(rawHeading);
    });
  }

  double _normalizeHeading(double heading) {
    return heading < 0 ? 360 + heading : heading;
  }
}