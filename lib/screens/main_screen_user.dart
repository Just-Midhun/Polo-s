import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'friends_tab.dart';
import 'home_tab.dart';
import 'map_screen.dart';
import 'package:polo_s/screens/drive_home_switch.dart';
import 'package:polo_s/screens/main_screen_driver.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainscreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  bool isRegistered = false;

  void checkDriverRegistrationStatus() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(currentUser.uid)
          .child('isRegistered');

      userRef.onValue.listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            isRegistered = event.snapshot.value as bool;
          });
        }
      }, onError: (error) {
        if (kDebugMode) {
          print('Error retrieving user registration status: $error');
        }
      });
    }
  }


  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    checkDriverRegistrationStatus();
  }

  void showDriverNotVerifiedToast() {
    Fluttertoast.showToast(
      msg: "Driver not verified",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTabPage(),
          MapScreen(),
          DriverHomeSwitchPage(),
          FetchRecord(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Ride",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Switch",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Friends",
          )
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 2 && !isRegistered) {
            showDriverNotVerifiedToast();
          }
          else if (index == 2 && isRegistered) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainDriverScreen(),
              ),
            );
          }
          else {
            onItemClicked(index);
          }
        },
      ),
    );
  }
}
