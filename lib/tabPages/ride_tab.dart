import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;


Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/my_text.txt');
}


class RideTabPage extends StatefulWidget{
  const RideTabPage({Key? key}): super(key: key);

  @override
  _RideTabPageState createState() => _RideTabPageState();
}



class _RideTabPageState extends State<RideTabPage>{
  @override
  
  Widget build(BuildContext context){
    return MaterialApp(
        theme:ThemeData(scaffoldBackgroundColor: Colors.lightBlue),
      home: Scaffold(
        body:SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                  children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: const Positioned(
                    top:150,
                    left:50,
                    child: Text(
                    'To find your pickup\nlocation automatically,\nturn on location services',
                    style: TextStyle(fontFamily: 'Roboto',fontSize: 30,color: Colors.black),
                    ),
                  ),
                ),

                Positioned(
                  top:280,
                  left:50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: null,
                    child: const Text('Turn on Location',style: TextStyle(fontFamily: 'Roboto',fontSize: 18,color: Colors.white),),
                  )
                ),

                const Positioned(
                  child: Align(
                  alignment: Alignment(0, -0.05),
                  child: Text('Choose a Ride',
                    style: TextStyle(fontFamily: 'Roboto',fontSize: 30,color: Colors.black),)

              ),
            )
          ]
        )

      )
    )
      )
    );
  }
}