import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:location/location.dart' as L;

// import 'package:location_platform_interface/location_platform_interface.dart';

import 'model.dart';

class constraints {
  double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Future<void> getUserLocation() async {
  //   L.Location location = L.Location();
  //   LocationData data;
  //   PermissionStatus status = await location.hasPermission();
  //   if (status != PermissionStatus.granted) {
  //     status = await location.requestPermission();
  //     if (status != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   bool? serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }
  //   data = await location.getLocation();
  //   print("location data");
  //   print(data);

  //   UserLocation.lat = data.latitude!;
  //   UserLocation.long = data.longitude!;
  // }

  // void geyLocationData() async {
  //   Future.delayed(const Duration(milliseconds: 1000), () async {
  //     List<Placemark>? userData =
  //         await placemarkFromCoordinates(UserLocation.lat, UserLocation.long);
  //     print(userData[0].name);
  //   });
  // }

  static Color primaryColor = Colors.indigo;
  static Color secondaryColor = Colors.white;
  static Color thirdColor = Colors.black;
  static RegExp nameRegExp = RegExp('[a-zA-Z]');
  static RegExp passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
}
