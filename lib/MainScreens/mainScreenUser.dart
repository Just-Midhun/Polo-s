import 'package:flutter/material.dart';
import 'package:polo_s/tabPages/ride_tab.dart';
import 'package:polo_s/tabPages/home_tab.dart';
import 'package:polo_s/tabPages/friends_tab.dart';
import 'package:polo_s/tabPages/switchpage_tab.dart';
import 'dart:async' show Future;


class MainScreen extends StatefulWidget{
  static const String idscreen = "mainscreen";

  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index){
    setState(() {
      selectedIndex=index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState(){
    super.initState();

    tabController =TabController(length: 4, vsync:this);
  }


  bool _isStarIconEnabled = false;
  void toggleSettingsIcon() {
    setState(() {
      _isStarIconEnabled = !_isStarIconEnabled;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTabPage(),
          RideTabPage(),
          SwitchTabPage(),
          FriendsTabPage()
          ],
      ),
    bottomNavigationBar:  BottomNavigationBar(
      items: const [
      BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label:"Home",
      )
      ,

      BottomNavigationBarItem(
      icon: Icon(Icons.directions_car),
      label:"Ride",
      )
      ,

      BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label:"switch",
      )
      ,

      BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label:"Friends",
      )
    ],

    unselectedItemColor: Colors.white54,
    selectedItemColor: Colors.white,
    backgroundColor: Colors.black,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: const TextStyle(fontSize: 14),
    showUnselectedLabels:true,
    currentIndex: selectedIndex,
    onTap: onItemClicked,
    ),
    );
  }
}