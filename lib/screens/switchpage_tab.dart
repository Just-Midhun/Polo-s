import 'package:flutter/material.dart';

class SwitchTabPage extends StatefulWidget{
  const SwitchTabPage({Key? key}): super(key: key);

  @override
  State<SwitchTabPage> createState() => _SwitchTabPageState();
}



class _SwitchTabPageState extends State<SwitchTabPage>{
  @override
  Widget build(BuildContext context){
    return const Center(
        child: Text(
          "Switch"
      )
    );
  }
}