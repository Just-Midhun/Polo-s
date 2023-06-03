import 'package:flutter/material.dart';
import 'package:polo_s/Settings/settings.dart';

class HomeTabPage extends StatefulWidget{
  const HomeTabPage({Key? key}): super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

  Widget buildProfileImage()=> CircleAvatar(
    radius: 35,
    backgroundColor: Colors.grey.shade800,
      backgroundImage: const AssetImage("Resources/images/user.png")

  );

  Widget buildLogoImage()=> CircleAvatar(
    radius: 35,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: const AssetImage("Resources/images/polo1.png")

);


class _HomeTabPageState extends State<HomeTabPage>{
  @override
  Widget build(BuildContext context){

    return MaterialApp(

    home: Scaffold(
        body: Stack(
            children: [
              Positioned(
                  left:20,
                  top:40,
                  child:buildProfileImage()
              ),

              Positioned(
                  top:40,
                  left:170,

                child:buildLogoImage()
              ),

              Positioned(
                top: 40,
                right: 20,
                child:PopupMenuButton<String>(
                  icon: Image.asset(
                    'Resources/images/menu.png',
                    width: 50,
                    height: 50,
                  ),

                  onSelected: (value) {
                    // Handle menu item selection here
                    if (value == 'Option 1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    }
                  },

                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'Option 1',

                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          },

                          child: Image.asset(
                          'Resources/images/settings.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
        )
      ),
    );


  }
}


