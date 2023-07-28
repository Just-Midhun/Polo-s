import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polo_s/config_maps.dart';
//import 'package:polo_s/global/global.dart';
import 'package:polo_s/screens/driver_verification.dart';
import 'package:polo_s/screens/friends_tab.dart';
import 'package:polo_s/screens/login_screen.dart';

import 'change_password_screen.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _userName;
  String? _phoneNumber;

  Future<void> fetchUserInfo() async {
    // Fetch the user information from Firebase
    // User? user = _firebaseAuth.currentUser;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Assuming the user model contains the name and phone properties
      // Modify the code to access the correct properties from your user model
      setState(() {
        _userName = userModelCurrentInfo?.name;
        _phoneNumber = userModelCurrentInfo?.phone;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Mukta",
              fontSize: 25,
            ),
          ),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Stack(
                children: [
                  const Positioned(
                    bottom: 15,
                    left: 20,
                    child: CircleAvatar(
                      radius: 50.0,
                      // backgroundImage: AssetImage('assets/avatar.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 45.0,
                    left: 150,
                    child: Column(
                      children: [
                        Text(
                          _userName ?? 'Nikkk',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _phoneNumber ?? '',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 75,
              child: buildSettingsContainer(
                title: 'Verify Driver',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverVerification(),
                    ),
                  );
                },
                icon: Icons.verified,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 75,
              child: buildSettingsContainer(
                title: 'Add Address',
                onPressed: () {
                  // Handle 'Add Address' button press here
                  if (kDebugMode) {
                    print('Add Address clicked');
                  }
                },
                icon: Icons.location_on,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 75,
              child: buildSettingsContainer(
                title: 'Change Password',
                onPressed: () {
                  // Handle 'Change Password' button press here
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen()));
                  if (kDebugMode) {
                    print('Change Password clicked');
                  }
                },
                icon: Icons.refresh,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 75,
              child: buildSettingsContainer(
                title: 'Manage Friends',
                onPressed: () {
                  // Handle 'Manage Friends' button press here
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FetchRecord()));
                  if (kDebugMode) {
                    print('Manage Friends clicked');
                  }
                },
                icon: Icons.edit,
              ),
            ),
            const SizedBox(height: 46.0),
            SizedBox(
              height: 75,
              child: buildSettingsContainer(
                title: 'Sign-out',
                onPressed: () {
                  // Handle 'Sign-out' button press here
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                  _firebaseAuth.signOut();
                  if (kDebugMode) {
                    print('Sign-out clicked');
                  }
                },
                icon: Icons.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsContainer({
    required String title,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(30.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(icon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
