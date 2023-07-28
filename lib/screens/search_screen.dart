import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polo_s/allWidgets/divider.dart';
import 'package:polo_s/allWidgets/progress_dialog.dart';
import 'package:polo_s/assistants/request_assistant.dart';
import 'package:polo_s/config_maps.dart';
import 'package:polo_s/model/directions.dart';
import 'package:polo_s/model/place_prediction.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUptextEditingController = TextEditingController();
  TextEditingController dropOfftextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppInfo>(context).userPickUpLocation.locationName;
    pickUptextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back)),
                      const Center(
                        child: Text(
                          "Set Drop Off",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "Resources/images/pickicon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUptextEditingController,
                              decoration: InputDecoration(
                                hintText: "PickUp Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "Resources/images/desticon.png",
                        height: 16.0,
                        width: 16.0,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropOfftextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
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
          (placePredictionList.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return PredictionTile(
                        placePredictions: placePredictionList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const DividerWidget(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      var autocompleteurl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&location=9.506184%2C76.5493045&radius=50000&key=AIzaSyAIwBq6fp6TDzWMtHKfB9p2IlrT1ys27tM&components=country:IND");
      var res = await RequestAssistant.getRequest(autocompleteurl);
      if (res == 'failed') {
        if (kDebugMode) {
          print("failed");
        }
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
      if (kDebugMode) {
        print("Places Prediction Response :: ");
      }
      if (kDebugMode) {
        print(res);
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  const PredictionTile({Key? key, required this.placePredictions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceAddressDetails(placePredictions.placeId, context);
      },
      child: Column(
        children: [
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              const Icon(Icons.add_location),
              const SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placePredictions.mainText,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      placePredictions.secondaryText,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceAddressDetails(String placeID, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              "Setting DropOff, Please Wait",
            ));
    var placeDetailurl = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeID&key=$mapKey");
    var res = await RequestAssistant.getRequest(placeDetailurl);

    Navigator.pop(context);
    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Directions address = Directions(
          locationName: res["result"]["name"],
          locationId: placeID,
          locationLatitude: res["result"]["geometry"]["location"]["lat"],
          locationLongitude: res["result"]["geometry"]["location"]["lng"]);
      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(address);
      if (kDebugMode) {
        print("This is your drop off location ");
      }
      if (kDebugMode) {
        print(address.locationName);
      }
      //Navigator.pop(context,"ObtainDirection");
      Navigator.of(context).pop("ObtainDirection");
      //print(respon);
      //await getPlaceDirection();
    }
  }
}
