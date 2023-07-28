import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({Key? key}) : super(key: key);

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Ride Confirmed');
  late User? currentUser;
  int totaldistance = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Widget listItem({required Map trip}) {
    final String? pickupAddr = trip['pickup_address'];
    final String? dropoffAddr = trip['dropoff_address'];
    final String? bookedAt = trip['created_at'];
    final int distance = trip['distance'];

    if (pickupAddr == null || dropoffAddr == null) {
      // Handle the case where name or phone is null
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
        color: Colors.lightBlue.withOpacity(0.3),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pick up : $pickupAddr',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Drop off : $dropoffAddr',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            'Booked at : $bookedAt',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            'Distance : $distance',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print("tapped");
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print("hi");
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: const Text('Trip History'),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false, // Remove back arrow
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map trip = snapshot.value as Map;
            trip['key'] = snapshot.key;

            // Exclude current logged-in user
            if (trip['key'] == currentUser?.uid) {
              return Container(); // Skip rendering the item
            }

            return listItem(trip: trip);
          },
        ),
      ),
    );
  }
}
