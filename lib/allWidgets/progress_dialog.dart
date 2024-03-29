import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget
{
  final String message;
  const ProgressDialog(this.message, {super.key,});

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),

        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child : Row(
        children: [
          const SizedBox(width: 6.0,),
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
          Text(
            message,
            style: const TextStyle(color: Colors.black) ,
          )
        ],
        ),
      ),
      )
    );
  }
}