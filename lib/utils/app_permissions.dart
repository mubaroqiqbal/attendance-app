import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  AppPermissions._();

  static Future<bool> request(Permission permission) async {
    await permission.request();

    if (await permission.isGranted) return true;

    if (await permission.isDenied) {
      // Request the permission again
      await permission.request();
    }

    if (Platform.isAndroid) {
      if (await permission.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog.
        // The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        Future.delayed(Duration(seconds: 3), () => openAppSettings());
      }
    }

    return false;
  }
}
