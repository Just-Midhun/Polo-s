import 'package:flutter/material.dart';
import 'package:polo_s/Settings/settings.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Widget buildProfileImage() => CircleAvatar(
    radius: 35,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: const AssetImage("Resources/images/user.png"),
  );

  List<String> rideTypeImages = [
    'Resources/images/carpool1.jpg',
    'Resources/images/carpool2.jpg',
    'Resources/images/carpool1.jpg',
    // Add more ride type images here
  ];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 40,
            child: buildProfileImage(),
          ),
          Positioned(
            top: 40,
            left: 170,
            child: Image.asset(
              'Resources/images/polo1.png',
              width: 70,
              height: 70,
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _openEndDrawer,
              child: Image.asset(
                'Resources/images/menu.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
          Positioned.fill(
            top: -280,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: 250,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 180,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: rideTypeImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: AspectRatio(
                            aspectRatio: 1.3,
                            child: Image.asset(
                              rideTypeImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 10,
            right: 10,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.blue.shade300,
                  width: 2.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Book a Ride',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: 360,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        // Handle button press
                      },
                      child: const Text('Select drop off'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: "Mukta"
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            ListTile(
              leading: Image.asset(
                'Resources/images/settings.png',
                width: 40,
                height: 40,
              ),
              title: const Text('Settings',style: TextStyle(fontSize: 30,fontFamily: "Mukta")),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: Image.asset(
                'Resources/images/offers.png',
                width: 40,
                height: 40,
              ),
              title: const Text('Offers',style: TextStyle(fontSize: 30,fontFamily: "Mukta")),
              onTap: () {
                // Handle "Offers" selection
              },
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: Image.asset(
                'Resources/images/history.png',
                width: 40,
                height: 40,
              ),
              title: const Text('History',style: TextStyle(fontSize: 30,fontFamily: "Mukta")),
              onTap: () {
                // Handle "History" selection
              },
            ),
          ],
        ),
      ),
    );
  }
}
