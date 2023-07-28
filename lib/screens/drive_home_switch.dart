import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DriverHomeSwitchPage extends StatefulWidget {
  const DriverHomeSwitchPage({Key? key}) : super(key: key);

  @override
  State<DriverHomeSwitchPage> createState() => _DriverHomeSwitchPageState();
}

class _DriverHomeSwitchPageState extends State<DriverHomeSwitchPage> {
  late GoogleMapController mapController;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void centerMapToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(currentLatLng));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: currentLocation != null
                ? CameraPosition(
                    target: currentLocation!,
                    zoom: 15,
                  )
                : const CameraPosition(
                    target: LatLng(100, 2000),
                    zoom: 15,
                  ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8),
              ),
              child: const CircleAvatar(
                radius: 33,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: centerMapToCurrentLocation,
              backgroundColor: Colors.white,
              // ignore: prefer_const_constructors
              child: Icon(
                Icons.location_searching,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
