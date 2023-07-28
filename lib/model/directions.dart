class Directions {
  String? humanReadableAddress;
  String locationName;
  String? locationId;
  double locationLatitude;
  double locationLongitude;

  Directions({
    this.humanReadableAddress,
    required this.locationName,
    this.locationId,
    required this.locationLatitude,
    required this.locationLongitude,
  });
}
