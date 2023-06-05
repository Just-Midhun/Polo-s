import 'package:flutter/material.dart';
import 'package:polo_s/Driver/driverVerification.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: AppBar(
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
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 15,
                    left: 20,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/avatar.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 45.0,
                    left: 150,
                    child: Column(
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '+1 123 456 7890',
                          style: TextStyle(
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
                  print('Add Address clicked');
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
                  print('Change Password clicked');
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
                  print('Manage Friends clicked');
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
                  print('Sign-out clicked');
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
