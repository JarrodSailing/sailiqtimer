import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'heading_service.dart';

final headingServiceProvider = Provider<HeadingService>((ref) {
  return HeadingService();
});