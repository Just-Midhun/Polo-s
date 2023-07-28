import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polo_s/allWidgets/progress_dialog.dart';
import 'package:polo_s/assistants/assistant_methods.dart';
import 'package:polo_s/infoHandler/app_info.dart';
import 'package:polo_s/model/direction_details.dart';
import 'package:polo_s/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../config_maps.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
String? destination;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  static const String idScreen = "mainscreen";

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylinejSet = {};

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late DirectionDetails tripDirectionDetails = DirectionDetails(
      distanceValue: 14580,
      durationValue: 1547,
      distanceText: '14.6 km',
      durationText: '26 mins',
      encodedPoints: encodedPoints);

  Position? currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingofmap = 0.0;
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight = 0;
  double searchContainerHeight = 300.0;
  double requestRideContainerHeight = 0;
  double bookedRiderContainerHeight = 0;
  double reachedDestinationContainerHeight = 0;

  bool drawerOpen = true;
  late DatabaseReference rideRequestRef, rideConfirmRef;
  LocationPermission? _locationPermission;
  String? address;
  bool isSearching = false;
  bool isLive = false;

  void startSearchingFriends() {
    setState(() {
      isSearching = true;
    });
  }

  void showFriends() {
    setState(() {
      isLive = true;
    });
  }

  void stopSearchingFriends() {
    setState(() {
      isSearching = false;
    });
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    AssistantMethods.getCurrentOnlineUserInfo();
  }

  void saveRideRequest() {
    rideRequestRef = FirebaseDatabase.instance.ref().child("Ride Requests");

    var pickup =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var dropOff =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickup.locationLatitude.toString(),
      "longitude": pickup.locationLongitude.toString(),
    };

    Map dropOffLocMap = {
      "latitude": dropOff.locationLatitude.toString(),
      "longitude": dropOff.locationLongitude.toString(),
    };

    Map rideinfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userModelCurrentInfo?.name,
      "pickup_address": pickup.locationName,
      "dropoff_address": dropOff.locationName,
      "distance": tripDirectionDetails.distanceValue,
    };

    rideRequestRef.push().set(rideinfoMap);
    if (kDebugMode) {
      print("hello");
    }
    if (kDebugMode) {
      print(userModelCurrentInfo?.name);
    }
    destination = dropOff.locationName;
  }

  void confirmRideRequest() {
    rideConfirmRef = FirebaseDatabase.instance.ref().child("Ride Confirmed");

    var pickup =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var dropOff =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickup.locationLatitude.toString(),
      "longitude": pickup.locationLongitude.toString(),
    };

    Map dropOffLocMap = {
      "latitude": dropOff.locationLatitude.toString(),
      "longitude": dropOff.locationLongitude.toString(),
    };

    Map rideinfoMap = {
      "driver_id": "driver123",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userModelCurrentInfo?.name,
      "pickup_address": pickup.locationName,
      "dropoff_address": dropOff.locationName,
      "distance": tripDirectionDetails.distanceValue,
    };

    rideConfirmRef.push().set(rideinfoMap);
    if (kDebugMode) {
      print("hello");
    }
    if (kDebugMode) {
      print(userModelCurrentInfo?.name);
    }
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 270.0;
      bottomPaddingofmap = 230.0;
      requestRideContainerHeight = 0.0;
      reachedDestinationContainerHeight = 0;
      drawerOpen = false;
    });
  }

  void cancelRideRequest() {
    rideRequestRef.remove();
  }

  void rideBookedContainer() {
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      bottomPaddingofmap = 230.0;
      requestRideContainerHeight = 0;
      reachedDestinationContainerHeight = 0;
      drawerOpen = true;
    });
  }

  void displayRequestRidecontainer() {
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      bottomPaddingofmap = 230.0;
      requestRideContainerHeight = 280.0;
      reachedDestinationContainerHeight = 0;
      drawerOpen = true;
    });

    saveRideRequest();
  }

  void reachedDestinationContainer() {
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      bottomPaddingofmap = 0;
      requestRideContainerHeight = 0;
      reachedDestinationContainerHeight = 350;
      drawerOpen = true;
    });
  }

  resetApp() {
    setState(() {
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0.0;
      bottomPaddingofmap = 230.0;
      requestRideContainerHeight = 0;
      reachedDestinationContainerHeight = 0;
      drawerOpen = true;

      polylinejSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
    });

    locatePosition();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = position;
    if (kDebugMode) {
      print(currentPosition);
    }
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLatPosition, zoom: 12);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //mapController.animateCamera(CameraUpdate.newCameraPosition(cameraposition));
    if (context.mounted) {
      address =
          await AssistantMethods.searchCoordinateAddress(position, context);
    }
    if (kDebugMode) {
      print("This is your Address :: ${address!}");
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(79.591750, 76.531910),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingofmap, top: 160),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            polylines: polylinejSet,
            markers: markersSet,
            circles: circlesSet,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingofmap = 265.0;
              });
              locatePosition();
            },
          ),

          // Hamburger button for drawer
          Positioned(
            left: -12.0,
            top: 120.0,
            child: Builder(
              builder: (context) => MaterialButton(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 1.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          )
                        ]),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20.0,
                      child: Icon(
                        (drawerOpen) ? Icons.menu : Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (drawerOpen) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      resetApp();
                    }
                  }),
            ),
          ),

          // for search widget
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: AnimatedSize(
              //vsync: this,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                  //height: searchContainerHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 6.0,),
                        // Text("Hi there,", style: TextStyle(fontSize: 12.0),),
                        // Text("Where to?,", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"), ),

                        const SizedBox(
                          height: 25.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchScreen()));
                            if (res == "ObtainDirection") {
                              displayRideDetailsContainer();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 5.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7))
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text("Search Drop Off")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),

          if (isSearching)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              'Searching Friends...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // ride details container
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              //vsync: this,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "Resources/images/taxi.png",
                                height: 70.0,
                                width: 80.0,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Distance",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand-Bold"),
                                  ),
                                  Text(
                                    // ignore: unnecessary_null_comparison
                                    ((tripDirectionDetails != null)
                                        ? tripDirectionDetails.distanceText
                                        : ''),
                                    style: const TextStyle(
                                        fontSize: 13.0, color: Colors.black),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                // ignore: unnecessary_null_comparison
                                ((tripDirectionDetails != null)
                                    ? '₹${AssistantMethods.calculateFares(tripDirectionDetails)}'
                                    : ''),
                                style: const TextStyle(
                                  fontFamily: "Brand-Bold",
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: riderNames.length,
                          itemBuilder: (context, index) {
                            String name = riderNames[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 5.0, // Add vertical spacing of 5
                              ),
                              child: InkWell(
                                child: Container(
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(name),
                                    subtitle: Text('Description of $name'),
                                  ),
                                ),
                                onTap: () async {
                                  // Get the token.
                                  String? registrationToken = await FirebaseMessaging.instance.getToken();

                                  // Define the notification.

                                  print(riderNames[index]);
                                },
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 0.0,
                            color: Colors
                                .transparent, // Set transparent color for the separator
                          ),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              findFanny();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              "Search Friends",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            displayRequestRidecontainer();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Request",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Icon(
                                  FontAwesomeIcons.taxi,
                                  color: Colors.white,
                                  size: 26.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //reusing ride
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: requestRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                            resetApp();
                          },
                          // child: const Icon(Icons.close)),
                          child: Center(
                            widthFactor: 300,
                            child: Text(
                              // ignore: unnecessary_null_comparison
                              (tripDirectionDetails != null)
                                  ? 'Pay ₹${AssistantMethods.calculateFares(
                                      tripDirectionDetails,
                                    )}'
                                  : '',
                              style: const TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 65.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  cancelRideRequest();
                                  resetApp();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  confirmRideRequest();
                                  cancelRideRequest();
                                  reachedDestinationContainer();
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // destination reached ui
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: reachedDestinationContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    Stack(
                      children: [
                        Center(
                          widthFactor: 300,
                          child: Text(
                            'Others going to $destination',
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 65.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  confirmRideRequest();
                                  cancelRideRequest();
                                },
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var finalPos =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var pickUpLatLng =
        LatLng(initialPos.locationLatitude, initialPos.locationLongitude);
    var dropOffLatLng =
        LatLng(finalPos.locationLatitude, finalPos.locationLongitude);
    if (kDebugMode) {
      print(initialPos.locationLatitude);
    }
    if (kDebugMode) {
      print(initialPos.locationLongitude);
    }
    if (kDebugMode) {
      print(finalPos.locationLatitude);
    }
    if (kDebugMode) {
      print(finalPos.locationLongitude);
    }

    showDialog(
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              "Please Wait...",
            ));
    var details = await AssistantMethods.obtainDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details!;
    });

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (kDebugMode) {
      print("This is Encoded Points");
    }
    if (kDebugMode) {
      print(details?.encodedPoints);
    }

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details!.encodedPoints);
    pLineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      for (var pointLatLng in decodedPolyLinePointsResult) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polylinejSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylinejSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > pickUpLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      markerId: const MarkerId("pickUpId"),
      infoWindow:
          InfoWindow(title: initialPos.locationName, snippet: "My location"),
      position: pickUpLatLng,
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: const MarkerId("dropOffId"),
      infoWindow:
          InfoWindow(title: finalPos.locationName, snippet: "DropOff location"),
      position: dropOffLatLng,
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.greenAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
      circleId: const CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.red,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: const CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const int earthRadius = 6371;

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = earthRadius * c * 1000;

    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  Timer? proximityTimer;

  @override
  void dispose() {
    proximityTimer?.cancel();
    super.dispose();
  }

  void displayUserOnMap(double latitude, double longitude) {
    LatLng userLocation = LatLng(latitude, longitude);

    // Create a marker for the user's location
    Marker userMarker = Marker(
      markerId: MarkerId(latitude.toString() + longitude.toString()),
      position: userLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'User'),
    );

    // Update the markers set with the user marker
    markersSet.add(userMarker);

    // Trigger a rebuild to update the map with the new marker
    setState(() {});
  }

  List<String> riderNames = []; // Declare a Set to store the markers

  void findFanny() async {
    var pickup =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var dropOff =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    DatabaseReference resp = FirebaseDatabase.instance.ref('Ride Confirmed');
    resp.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      List<String> updatedRiderNames = []; //extra line of code
      data.forEach((key, value) {
        if (value['rider_name'] != userModelCurrentInfo?.name) {
          if (value['dropoff']['latitude'] ==
                  dropOff.locationLatitude.toString() &&
              value['dropoff']['longitude'] ==
                  dropOff.locationLongitude.toString()) {
            String picklat = value['pickup']['latitude'].toString();
            String picklong = value['pickup']['longitude'].toString();
            String trimpicklat = picklat.substring(0, picklat.length - 5);
            String trimpicklong = picklong.substring(0, picklong.length - 5);

            String currentpicklat = pickup.locationLatitude.toString();
            String trimcurrentpicklat =
                currentpicklat.substring(0, picklat.length - 5);
            String currentpicklong = pickup.locationLongitude.toString();
            String trimcurrentpicklong =
                currentpicklong.substring(0, picklat.length - 4);

            if (trimpicklat == trimcurrentpicklat &&
                trimpicklong == trimcurrentpicklong) {
                print(value['rider_name']);
              updatedRiderNames.add(value['rider_name']);
            }
          }
        }
      });
      setState(() {
        riderNames = updatedRiderNames;
        //print(riderNames);
        rideDetailsContainerHeight = 350.0;
      });
    });
  }
}
