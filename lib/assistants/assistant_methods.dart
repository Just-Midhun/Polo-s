import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polo_s/assistants/request_assistant.dart';
// import 'package:polo_s/global/map_key.dart';
import 'package:polo_s/infoHandler/app_info.dart';
import 'package:polo_s/model/directions.dart';
import 'package:polo_s/model/user_model.dart';
import 'package:provider/provider.dart';

import '../config_maps.dart';
//import '../global/global.dart';
import '../model/direction_details.dart';

class AssistantMethods {
  static Future<String?> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      placeAddress = "$st1, $st2, , $st3, $st4";

      Directions userPickupAddress = Directions(
          locationName: placeAddress,
          locationLatitude: position.latitude,
          locationLongitude: position.longitude);
      // userPickupAddress.longitude = position.longitude;
      // userPickupAddress.latitude = position.latitude;
      // userPickupAddress.placeName = placeAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    var directionUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$mapKey");
    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      if (kDebugMode) {
        print("failed");
      }
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(
        distanceValue: res["routes"][0]["legs"][0]["distance"]["value"],
        distanceText: res["routes"][0]["legs"][0]["distance"]["text"],
        encodedPoints: res["routes"][0]["overview_polyline"]["points"],
        durationText: res["routes"][0]["legs"][0]["duration"]["text"],
        durationValue: res["routes"][0]["legs"][0]["duration"]["value"]);

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    double timeTraveledFare = (directionDetails.durationValue / 60) * 12;
    double distancTraveledFare = (directionDetails.distanceValue / 1000) * 12;
    double totalFareAmount = timeTraveledFare + distancTraveledFare;

    return totalFareAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      String userId = firebaseUser.uid;
      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child("users").child(userId);

      reference.once().then((DatabaseEvent event) async {
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          userModelCurrentInfo = UserModel.fromSnapshot(dataSnapshot);
          // Use the 'users' object or perform any other operations here
        }
      });
    }
  }
}
