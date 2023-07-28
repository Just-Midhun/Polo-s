import 'package:flutter/material.dart';
import 'package:polo_s/screens/drive_home_switch.dart';
import 'package:polo_s/screens/main_screen_user.dart';

import 'home_tab.dart';

class MainDriverScreen extends StatefulWidget {
  static const String idScreen = "mainscreen";

  const MainDriverScreen({Key? key}) : super(key: key);

  @override
  State<MainDriverScreen> createState() => _MainDriverScreen();
}

class _MainDriverScreen extends State<MainDriverScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          DriverHomeSwitchPage(),
          HomeTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Switch",
          ),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            );
          } else {
            onItemClicked(index);
          }
        },
      ),
    );
  }
}
