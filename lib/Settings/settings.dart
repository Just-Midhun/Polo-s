import 'package:flutter/material.dart';
import 'package:polo_s/Driver/driverVerification.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({Key? key}): super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 150.0, left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // Handle 'Verify Driver' button press here
                print('Verify Driver clicked');
              },
              child: const Text(
                'Verify Driver:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the driver verification screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverVerification(),
                  ),
                );
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
