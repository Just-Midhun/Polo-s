import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

num distanceTravelled = 0;

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  State<OffersPage> createState() => _OffersPageState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class _OffersPageState extends State<OffersPage> {
  final List<String> offers = [
    'Offer 1',
    'Offer 2',
    'Offer 3',
  ];


  late User? currentUser;

  @override
  void initState() {
    
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    //distanceTravelled = 0;
    totaldistance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.8),
              //     spreadRadius: 3,
              //     blurRadius: 3,
              //     offset: const Offset(0, 3), // Range of shadow effect
              //   ),
              // ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Your Travel Points',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${distanceTravelled / 1000000}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Travel More, Earn More',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Rewards',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1.5,
            width: 350,
            color: Colors.black,
          ),
          const SizedBox(height: 2),
          Expanded(
            
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                String offer = offers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 5.0, // Add vertical spacing of 5
                  ),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(offer),
                      subtitle: Text('Description of $offer'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void totaldistance() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('Ride Confirmed');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      num totalDistance = 0;
      data.forEach((key, value) {
        if (kDebugMode) {
          //print(value['distance']);
        }
        //distanceTravelled = distanceTravelled + value['distance'];
        totalDistance = totalDistance + (value['distance'] ?? 0);
      });
       setState(() {
    distanceTravelled = totalDistance;
  });
    });
   
     if (kDebugMode) {
       print(distanceTravelled);
     }
  }
}
