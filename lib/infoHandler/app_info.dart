import 'package:flutter/cupertino.dart';
import 'package:polo_s/model/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions userPickUpLocation = Directions(
      locationName: "GG4X+FMC, Pathamuttam, Kerala 686532, India",
      locationLatitude: 9.5062312,
      locationLongitude: 76.5492156);
  Directions userDropOffLocation = Directions(
      locationName: "HGRC+JVC, Kottayam, Kerala 686001, India",
      locationLatitude: 9.591750,
      locationLongitude: 76.531914);
  int countTotalTrips = 0;

  // List<String> historyTripsKeysList = [];
  // List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
