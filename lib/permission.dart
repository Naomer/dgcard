// permission.dart

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart'; // To check if it's iOS
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class PermissionService {
  // Request Notification Permission
  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }

  // Request Location Permission
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("Location permission granted");
    } else {
      print("Location permission denied");
    }
  }

  // Request Tracking Permission (for iOS only)
  Future<void> requestTrackingPermission() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      if (status == TrackingStatus.authorized) {
        print("Tracking permission granted");
      } else {
        print("Tracking permission denied");
      }
    } else {
      print("Tracking permission is only for iOS devices.");
    }
  }

  // Method to request all necessary permissions
  Future<void> requestAllPermissions() async {
    await requestNotificationPermission();
    await requestLocationPermission();
    await requestTrackingPermission(); // Only effective on iOS
  }
}
