import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  bool permissionAllowed = false;
  String? locationMessage;

  void getCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        this.latitude = position.latitude;
        this.longitude = position.longitude;
        this.permissionAllowed = true;
        this.locationMessage = "Latitude: $latitude, Longitude: $longitude";
        notifyListeners();
      } else {
        print("Location permission denied");
        this.permissionAllowed = false;
        this.locationMessage = "Location permission denied";
        notifyListeners();
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}
