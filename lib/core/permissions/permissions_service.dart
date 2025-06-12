import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<bool> requestLocationPermissions() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }
}